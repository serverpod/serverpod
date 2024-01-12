import 'dart:async';
import 'dart:io';

import 'package:lsp_server/lsp_server.dart';
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

Future<void> runLanguageServer() async {
  var connection = Connection(stdin, stdout);

  ServerProject? serverProject;
  Exception? exception;

  connection.onInitialize((params) async {
    var rootUri = params.rootUri;
    if (rootUri != null) {
      try {
        serverProject = await _loadServerProject(rootUri, connection);
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

  connection.onInitialized((_) async {
    if (serverProject == null &&
        exception is ServerpodModulesNotFoundException) {
      _sendModulesNotFoundNotification(connection);
    } else if (serverProject == null) {
      _sendServerDisabledNotification(connection);
    } else {
      serverProject?.analyzer.validateAll();
    }
  });

  connection.onShutdown(() async {
    serverProject = null;
  });

  connection.onExit(() => connection.close());

  connection.onDidCloseTextDocument((params) async {
    var project = serverProject;
    if (project == null) return;
    if (!project.analyzer.isModelRegistered(params.textDocument.uri)) {
      return;
    }
    if (_isFileOnDisk(params.textDocument.uri)) return;

    project.analyzer.removeYamlModel(params.textDocument.uri);
    project.analyzer.validateAll();
  });

  connection.onDidOpenTextDocument((params) async {
    var project = serverProject;
    if (project == null) return;
    if (project.analyzer.isModelRegistered(params.textDocument.uri)) {
      return;
    }
    if (!_isModelInServerPath(params.textDocument.uri, project.serverRootUri)) {
      return;
    }

    project.analyzer.addYamlModel(
      ModelSource(
        defaultModuleAlias,
        params.textDocument.text,
        params.textDocument.uri,
        ModelHelper.extractPathFromConfig(
          project.config,
          params.textDocument.uri,
        ),
      ),
    );

    // We need to validate all protocols as the new protocol might reference or
    // be referenced by other protocols.
    project.analyzer.validateAll();
  });

  connection.onDidChangeTextDocument((params) async {
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

  await connection.listen();
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

void _sendServerDisabledNotification(Connection connection) {
  connection.sendNotification(
    'window/showMessage',
    ShowMessageParams(
      message: 'Serverpod model validation disabled, not a Serverpod project.',
      type: MessageType.Info,
    ).toJson(),
  );
}

Future<ServerProject?> _loadServerProject(
  Uri rootUri,
  Connection connection,
) async {
  var rootDir = Directory.fromUri(rootUri);

  var serverRootDir = _findServerDirectory(rootDir);
  if (serverRootDir == null) return null;

  var config = await GeneratorConfig.load(serverRootDir.path);

  var yamlSources = await ModelHelper.loadProjectYamlModelsFromDisk(
    config,
  );

  var analyzer = StatefulAnalyzer(
    yamlSources,
    (filePath, errors) => _reportDiagnosticErrors(connection, filePath, errors),
  );

  return ServerProject(
    serverRootUri: serverRootDir.uri,
    config: config,
    analyzer: analyzer,
  );
}

Directory? _findServerDirectory(Directory root) {
  if (isServerDirectory(root)) return root;

  var childDirs = root.listSync().where(
        (dir) => isServerDirectory(Directory.fromUri(dir.uri)),
      );

  if (childDirs.isNotEmpty) {
    return Directory.fromUri(childDirs.first.uri);
  }

  return null;
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
