import 'dart:async';
import 'dart:io';

import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/diagnostics_source.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

import '../../analyzer.dart';
import '../generator/code_generation_collector.dart';

class ServerDirectory {
  Uri serverRootUri;
  GeneratorConfig config;
  StatefulAnalyzer analyzer;

  ServerDirectory({
    required this.serverRootUri,
    required this.config,
    required this.analyzer,
  });
}

Future<void> runLanguageServer() async {
  var connection = Connection(stdin, stdout);

  ServerDirectory? serverDirectory;

  connection.onInitialize((params) async {
    var rootUri = params.rootUri;
    if (rootUri != null) {
      serverDirectory = await _loadServerDirectory(rootUri, connection);
    }

    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  connection.onInitialized((_) async {
    if (serverDirectory == null) {
      _sendServerDisabledNotification(connection);
    } else {
      serverDirectory?.analyzer.validateAll();
    }
  });

  connection.onShutdown(() async {
    serverDirectory?.analyzer.unregisterOnErrorsChangedNotifier();
    serverDirectory = null;
  });

  connection.onExit(() => exit(0));

  connection.onDidCloseTextDocument((params) async {
    var serverDir = serverDirectory;
    if (serverDir == null) return;
    if (!serverDir.analyzer.isProtocolRegistered(params.textDocument.uri)) {
      return;
    }
    if (_isFileOnDisk(params.textDocument.uri)) return;

    serverDir.analyzer.removeYamlProtocol(params.textDocument.uri);

    serverDir.analyzer.validateAll();
  });

  connection.onDidOpenTextDocument((params) async {
    var serverDir = serverDirectory;
    if (serverDir == null) return;
    if (serverDir.analyzer.isProtocolRegistered(params.textDocument.uri)) {
      return;
    }
    if (!_isProtocolInServerPath(
        params.textDocument.uri, serverDir.serverRootUri)) {
      return;
    }

    serverDir.analyzer.addYamlProtocol(
      ProtocolSource(
        params.textDocument.text,
        params.textDocument.uri,
        ProtocolHelper.extractPathFromProtocolRoot(
          serverDir.config,
          params.textDocument.uri,
        ),
      ),
    );

    // We need to validate all protocols as the new protocol might reference or
    // be referenced by other protocols.
    serverDir.analyzer.validateAll();
  });

  connection.onDidChangeTextDocument((params) async {
    if (serverDirectory == null) return;

    var contentChanges = params.contentChanges.map((content) {
      return content.map(
        (document) => TextDocumentContentChangeEvent2(text: document.text),
        (document) => document,
      );
    });

    serverDirectory?.analyzer.validateProtocol(
      contentChanges.first.text,
      params.textDocument.uri,
    );

    // This can be optimized to only validate the files we know have related errors.
    serverDirectory?.analyzer.validateAll();
  });

  await connection.listen();
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

void _sendServerDisabledNotification(Connection connection) {
  connection.sendNotification(
    'window/showMessage',
    ShowMessageParams(
      message:
          'Serverpod protocol validation disabled, not a Serverpod project.',
      type: MessageType.Info,
    ).toJson(),
  );
}

Future<ServerDirectory?> _loadServerDirectory(
  Uri rootUri,
  Connection connection,
) async {
  var rootDir = Directory.fromUri(rootUri);

  var serverRootDir = findServerDirectory(rootDir);
  if (serverRootDir == null) return null;

  var config = await GeneratorConfig.load(serverRootDir.path);
  if (config == null) return null;

  var yamlSources = await ProtocolHelper.loadProjectYamlProtocolsFromDisk(
    config,
  );

  var analyzer = StatefulAnalyzer(
    yamlSources,
    (filePath, errors) => _reportDiagnosticErrors(connection, filePath, errors),
  );

  return ServerDirectory(
    serverRootUri: serverRootDir.uri,
    config: config,
    analyzer: analyzer,
  );
}

Directory? findServerDirectory(Directory root) {
  if (isServerDirectory(root)) return root;

  var childDirs = root.listSync().where(
        (dir) => isServerDirectory(Directory.fromUri(dir.uri)),
      );

  if (childDirs.isNotEmpty) {
    return Directory.fromUri(childDirs.first.uri);
  }

  return null;
}

List<Diagnostic> _convertErrorsToDiagnostic(
  CodeGenerationCollector errors,
) {
  return errors.errors.where((e) => e.span != null).map((error) {
    var span = error.span;
    if (span == null) throw Error();

    return Diagnostic(
      severity: DiagnosticSeverity.Error,
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
    );
  }).toList();
}

bool _isProtocolInServerPath(Uri uri, Uri? serverUri) {
  if (serverUri == null) return false;

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
