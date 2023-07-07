import 'dart:async';
import 'dart:io';

import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/diagnostics_source.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

import '../../analyzer.dart';
import '../generator/code_generation_collector.dart';

Future<void> runLanguageServer() async {
  var connection = Connection(stdin, stdout);

  bool parsingEnabled = true;
  Uri? serverRootUri;
  late GeneratorConfig config;
  StatefulAnalyzer statefulAnalyzer = StatefulAnalyzer();

  connection.onInitialize((params) async {
    serverRootUri = params.rootUri;
    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  connection.onInitialized((_) async {
    try {
      if (serverRootUri == null) throw Exception('No root URI set.');
      config = await _initializeAnalyzer(statefulAnalyzer, serverRootUri!);
    } catch (e) {
      statefulAnalyzer.unregisterOnErrorsChangedNotifier();
      statefulAnalyzer.clearState();
      parsingEnabled = false;

      connection.sendNotification(
        'window/showMessage',
        ShowMessageParams(
          message:
              'Serverpod protocol validation disabled, not a Serverpod project.',
          type: MessageType.Info,
        ).toJson(),
      );
    }
  });

  connection.onShutdown(() async {
    statefulAnalyzer.unregisterOnErrorsChangedNotifier();
    statefulAnalyzer.clearState();
    parsingEnabled = false;
  });

  connection.onExit(() => exit(0));

  connection.onDidCloseTextDocument((params) async {
    if (!parsingEnabled) return;
    if (!statefulAnalyzer.isProtocolRegistered(params.textDocument.uri)) return;
    if (_isFileOnDisk(params.textDocument.uri)) return;

    statefulAnalyzer.removeYamlProtocol(params.textDocument.uri);

    // This can be optimised to only validate the files we know have related errors.
    statefulAnalyzer.validateAll();
  });

  connection.onDidOpenTextDocument((params) async {
    if (!parsingEnabled) return;
    if (statefulAnalyzer.isProtocolRegistered(params.textDocument.uri)) return;
    if (!_isProtocolInServerPath(params.textDocument.uri, serverRootUri)) {
      return;
    }

    statefulAnalyzer.addYamlProtocol(
      ProtocolSource(
        params.textDocument.text,
        params.textDocument.uri,
        ProtocolHelper.extractPathFromProtocolRoot(
          config,
          params.textDocument.uri,
        ),
      ),
    );

    statefulAnalyzer.validateProtocol(
      params.textDocument.text,
      params.textDocument.uri,
    );

    // We need to validate all protocols as the new protocol might reference or
    // be referenced by other protocols.
    statefulAnalyzer.validateAll();
  });

  connection.onDidChangeTextDocument((params) async {
    var contentChanges = params.contentChanges.map((content) {
      return content.map(
        (document) => TextDocumentContentChangeEvent2(text: document.text),
        (document) => document,
      );
    });

    statefulAnalyzer.validateProtocol(
      contentChanges.first.text,
      params.textDocument.uri,
    );

    // This can be optimized to only validate the files we know have related errors.
    statefulAnalyzer.validateAll();
  });

  statefulAnalyzer.registerOnErrorsChangedNotifier((filePath, errors) {
    var diagnostics = _convertErrorsToDiagnostic(errors);
    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: filePath,
      ),
    );
  });

  await connection.listen();
}

Future<GeneratorConfig> _initializeAnalyzer(
  StatefulAnalyzer statefulAnalyzer,
  Uri rootUri,
) async {
  var rootDir = Directory.fromUri(rootUri);

  var serverDir = findServerDirectory(rootDir);
  if (serverDir == null) {
    throw Exception('No Serverpod server directory found.');
  }

  var config = await GeneratorConfig.load(serverDir.path);
  var yamlSources =
      await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config!);

  statefulAnalyzer.initialValidation(yamlSources);

  return config;
}

Directory? findServerDirectory(Directory rootDir) {
  if (isServerDirectory(rootDir)) return rootDir;

  var childDirs = rootDir.listSync().where(
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
