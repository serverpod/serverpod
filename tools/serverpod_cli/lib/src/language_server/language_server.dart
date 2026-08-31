import 'dart:async';
import 'dart:io';

import 'package:lsp_server/lsp_server.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/language_server/diagnostics_source.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

class ServerProject {
  Uri serverRootUri;
  GeneratorConfig config;
  StatefulAnalyzer analyzer;

  ServerProject({
    required this.serverRootUri,
    required this.config,
    required this.analyzer,
  });
}

Future<void> runLanguageServer({
  Connection? connection,
  Duration fileEventDebounce = const Duration(milliseconds: 300),
}) async {
  var conn = connection ?? Connection(stdin, stdout);

  ServerProject? serverProject;
  Exception? exception;
  var clientSupportsWatchedFilesRegistration = false;

  // The editor buffer is authoritative for open documents; rescans from disk
  // must not replace or remove them.
  var openDocumentKeys = <String>{};

  var rescanScheduler = _RescanScheduler(fileEventDebounce, () async {
    var project = serverProject;
    if (project == null) return;
    await _rescanModelsFromDisk(project, conn, openDocumentKeys);
  });

  conn.onInitialize((params) async {
    clientSupportsWatchedFilesRegistration =
        params
            .capabilities
            .workspace
            ?.didChangeWatchedFiles
            ?.dynamicRegistration ??
        false;

    var rootUri = params.rootUri;
    if (rootUri != null) {
      try {
        serverProject = await _loadServerProject(rootUri, conn);
      } catch (error) {
        if (error is Exception) {
          exception = error;
        }
      }
    }

    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  conn.onInitialized((_) async {
    if (exception is ServerpodModulesNotFoundException) {
      _sendModulesNotFoundNotification(conn);
    }

    if (serverProject != null && clientSupportsWatchedFilesRegistration) {
      // Fire-and-forget; a client that rejects the registration simply keeps
      // the previous behavior of only tracking open documents.
      unawaited(
        _registerFileWatchers(conn).catchError((_) {}),
      );
    }

    serverProject?.analyzer.validateAll();
  });

  conn.onNotification('workspace/didChangeWatchedFiles', (params) async {
    var project = serverProject;
    if (project == null) return;

    var changes = DidChangeWatchedFilesParams.fromJson(params.value).changes;
    if (changes.any((event) => _isRelevantFileEvent(event, project))) {
      rescanScheduler.schedule();
    }
  });

  conn.onShutdown(() async {
    serverProject = null;
  });

  conn.onExit(() => conn.close());

  conn.onDidCloseTextDocument((params) async {
    openDocumentKeys.remove(_documentKey(params.textDocument.uri));

    var project = serverProject;
    if (project == null) return;
    if (!project.analyzer.isModelRegistered(params.textDocument.uri)) {
      return;
    }
    if (_isFileOnDisk(params.textDocument.uri)) return;

    var registeredUri = _registeredUriFor(
      project.analyzer,
      params.textDocument.uri,
    );
    project.analyzer.removeYamlModel(params.textDocument.uri);
    if (registeredUri != null) {
      _clearDiagnostics(conn, registeredUri);
    }
    project.analyzer.validateAll();
  });

  conn.onDidOpenTextDocument((params) async {
    openDocumentKeys.add(_documentKey(params.textDocument.uri));

    var project = serverProject;
    if (project == null) return;
    if (project.analyzer.isModelRegistered(params.textDocument.uri)) {
      return;
    }

    var isSharedModel = _isModelInSharedPackagePath(
      params.textDocument.uri,
      project.serverRootUri,
      project.config,
    );
    if (!_isModelInServerPath(params.textDocument.uri, project.serverRootUri) &&
        !isSharedModel) {
      return;
    }

    // Resolves the correct module alias and sub directory for both server and
    // shared package models.
    project.analyzer.addYamlModel(
      ModelHelper.createModelSourceForPath(
        project.config,
        params.textDocument.uri.toFilePath(),
        params.textDocument.text,
      ),
    );

    // We need to validate all protocols as the new protocol might reference or
    // be referenced by other protocols.
    project.analyzer.validateAll();
  });

  conn.onDidChangeTextDocument((params) async {
    if (serverProject == null) return;

    var contentChanges = params.contentChanges.map((content) {
      return content.map(
        (document) => TextDocumentContentChangeEvent2(text: document.text),
        (document) => document,
      );
    });

    serverProject?.analyzer.validateModel(
      contentChanges.first.text,
      params.textDocument.uri,
    );
  });

  await conn.listen();
}

/// Asks the client to watch the file system, since disk changes (renames,
/// deletions, files created outside the editor) produce no text document
/// notifications.
Future<void> _registerFileWatchers(Connection connection) {
  var options = DidChangeWatchedFilesRegistrationOptions(
    watchers: [
      // Model files can live anywhere below a package's lib directory.
      FileSystemWatcher(
        globPattern: const Either2.t1('**/*.{spy,spy.yaml,spy.yml}'),
      ),
      // Directory renames and deletions only surface as events on the
      // directory itself, which the model file globs never match.
      FileSystemWatcher(
        globPattern: const Either2.t1('**/lib/**'),
        kind: const WatchKind(5), // WatchKind.Create | WatchKind.Delete
      ),
    ],
  );

  return connection.sendRequest(
    'client/registerCapability',
    RegistrationParams(
      registrations: [
        Registration(
          id: 'serverpod-model-file-watcher',
          method: 'workspace/didChangeWatchedFiles',
          registerOptions: options.toJson(),
        ),
      ],
    ).toJson(),
  );
}

/// Filters out watched file events that cannot affect any model, so unrelated
/// workspace activity does not trigger rescans.
bool _isRelevantFileEvent(FileEvent event, ServerProject project) {
  String path;
  try {
    path = event.uri.toFilePath();
  } on UnsupportedError {
    return false;
  }

  if (ModelHelper.isModelFile(path)) return true;

  // Deleted or renamed-away directories no longer exist on disk; they can
  // only be recognized as a parent of a previously registered model.
  var canonicalPath = p.canonicalize(path);
  if (project.analyzer.registeredModelUris.any(
    (uri) => p.isWithin(canonicalPath, _documentKey(uri)),
  )) {
    return true;
  }

  // Created (or renamed-to) directories may contain model files.
  return event.type == FileChangeType.Created && Directory(path).existsSync();
}

/// Reconciles the analyzer state with the model files on disk. Models whose
/// document is open in the editor are left untouched.
Future<void> _rescanModelsFromDisk(
  ServerProject project,
  Connection connection,
  Set<String> openDocumentKeys,
) async {
  var diskSources = await ModelHelper.loadProjectYamlModelsFromDisk(
    project.config,
  );
  var diskKeys = diskSources
      .map((source) => _documentKey(source.yamlSourceUri))
      .toSet();

  for (var uri in project.analyzer.registeredModelUris) {
    var key = _documentKey(uri);
    if (!diskKeys.contains(key) && !openDocumentKeys.contains(key)) {
      project.analyzer.removeYamlModel(uri);
      _clearDiagnostics(connection, uri);
    }
  }

  for (var source in diskSources) {
    if (openDocumentKeys.contains(_documentKey(source.yamlSourceUri))) {
      continue;
    }
    project.analyzer.addYamlModel(source);
  }

  project.analyzer.validateAll();
}

/// LSP document URIs and disk URIs for the same file can differ (e.g. drive
/// letter casing on Windows); the canonicalized file path identifies both.
String _documentKey(Uri uri) => p.canonicalize(uri.toFilePath());

/// Returns the URI the model for [uri] is registered under. Diagnostics must
/// be cleared with the exact URI they were published with.
Uri? _registeredUriFor(StatefulAnalyzer analyzer, Uri uri) {
  var key = _documentKey(uri);
  for (var registeredUri in analyzer.registeredModelUris) {
    if (_documentKey(registeredUri) == key) return registeredUri;
  }
  return null;
}

void _clearDiagnostics(Connection connection, Uri uri) {
  connection.sendDiagnostics(
    PublishDiagnosticsParams(diagnostics: [], uri: uri),
  );
}

/// Coalesces bursts of file events into a single rescan and prevents
/// overlapping rescans from interleaving.
class _RescanScheduler {
  _RescanScheduler(this._debounce, this._rescan);

  final Duration _debounce;
  final Future<void> Function() _rescan;

  Timer? _timer;
  bool _running = false;
  bool _rerunRequested = false;

  void schedule() {
    _timer?.cancel();
    _timer = Timer(_debounce, () => unawaited(_run()));
  }

  Future<void> _run() async {
    if (_running) {
      _rerunRequested = true;
      return;
    }
    _running = true;
    try {
      do {
        _rerunRequested = false;
        await _rescan();
      } while (_rerunRequested);
    } finally {
      _running = false;
    }
  }
}

void _sendModulesNotFoundNotification(Connection connection) {
  connection.sendNotification(
    'window/showMessage',
    ShowMessageParams(
      message:
          'Serverpod model validation disabled. Unable to locate necessary modules, have you run "dart pub get"?',
      type: MessageType.Warning,
    ).toJson(),
  );
}

Future<ServerProject?> _loadServerProject(
  Uri rootUri,
  Connection connection,
) async {
  var rootDir = Directory.fromUri(rootUri);

  var serverRootDir = findServerDirectory(rootDir);
  if (serverRootDir == null) return null;

  var config = await GeneratorConfig.load(
    serverRootDir: serverRootDir.path,
    interactive: false, // Language server should never be interactive
  );

  var yamlSources = await ModelHelper.loadProjectYamlModelsFromDisk(
    config,
  );

  var analyzer = StatefulAnalyzer(
    config,
    yamlSources,
    (filePath, errors) => _reportDiagnosticErrors(connection, filePath, errors),
  );

  return ServerProject(
    serverRootUri: serverRootDir.uri,
    config: config,
    analyzer: analyzer,
  );
}

void _reportDiagnosticErrors(
  Connection connection,
  Uri filePath,
  CodeGenerationCollector errors,
) {
  var diagnostics = _convertErrorsToDiagnostic(errors);
  connection.sendDiagnostics(
    PublishDiagnosticsParams(
      diagnostics: diagnostics,
      uri: filePath,
    ),
  );
}

List<Diagnostic> _convertErrorsToDiagnostic(
  CodeGenerationCollector errors,
) {
  return errors.errors.where((e) => e.span != null).map((error) {
    var span = error.span;
    if (span == null) throw Error();

    var severity = DiagnosticSeverity.Error;
    List<DiagnosticTag>? tags;
    if (error is SourceSpanSeverityException) {
      severity = _convertToDiagnosticSeverity(error.severity);
      tags = _convertToDiagnosticTags(error.tags);
    }

    return Diagnostic(
      severity: severity,
      source: DiagnosticsSource.serverpod,
      message: error.message,
      range: Range(
        start: Position(
          line: span.start.line,
          character: span.start.column,
        ),
        end: Position(
          line: span.end.line,
          character: span.end.column,
        ),
      ),
      tags: tags,
    );
  }).toList();
}

DiagnosticSeverity _convertToDiagnosticSeverity(
  SourceSpanSeverity severity,
) {
  switch (severity) {
    case SourceSpanSeverity.error:
      return DiagnosticSeverity.Error;
    case SourceSpanSeverity.warning:
      return DiagnosticSeverity.Warning;
    case SourceSpanSeverity.info:
      return DiagnosticSeverity.Information;
    case SourceSpanSeverity.hint:
      return DiagnosticSeverity.Hint;
  }
}

List<DiagnosticTag>? _convertToDiagnosticTags(List<SourceSpanTag>? tags) {
  if (tags == null) return null;

  return tags.map((tag) {
    switch (tag) {
      case SourceSpanTag.unnecessary:
        return DiagnosticTag.Unnecessary;
      case SourceSpanTag.deprecated:
        return DiagnosticTag.Deprecated;
    }
  }).toList();
}

bool _isModelInSharedPackagePath(
  Uri uri,
  Uri serverUri,
  GeneratorConfig config,
) {
  var path = uri.path;
  for (var e in config.sharedModelsSourcePathsParts.entries) {
    if (path.contains(e.value.join('/'))) {
      return true;
    }
  }
  return false;
}

bool _isModelInServerPath(Uri uri, Uri serverUri) {
  var path = uri.path;
  if (path.contains(serverUri.path)) {
    return true;
  }
  return false;
}

bool _isFileOnDisk(Uri uri) {
  var file = File.fromUri(uri);
  return file.existsSync();
}
