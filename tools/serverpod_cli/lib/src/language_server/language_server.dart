import 'dart:async';
import 'dart:io';
import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/language_server/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/diagnostics_source.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

import '../../analyzer.dart';
import '../generator/code_generation_collector.dart';

Future<void> runLanguageServer() async {
  var connection = Connection(stdin, stdout);

  StatefulAnalyzer statefulAnalyzer = StatefulAnalyzer();

  // TODO fix this variable and clean it up!
  Uri? serverUri;

  statefulAnalyzer.regsiterOnErrorsChangedNotifier((filePath, errors) {
    var diagnostics = _convertErrorsToDiagnostic(errors);
    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: filePath,
      ),
    );
  });

  connection.onInitialize((params) async {
    serverUri = params.rootUri;
    try {
      await _initializeAnalyzer(statefulAnalyzer, params.rootUri);
    } catch (e) {
      connection.sendNotification(
        'window/showMessage',
        ShowMessageParams(
          message:
              'Serverpod protocol validation disabled, not a Serverpod project.',
          type: MessageType.Warning,
        ).toJson(),
      );

      statefulAnalyzer.unregisterOnErrorsChangedNotifier();
    }

    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  connection.onDidCloseTextDocument((params) async {
    if (statefulAnalyzer.isProtocolRegistered(params.textDocument.uri) &&
        !isFileOnDisk(params.textDocument.uri)) {
      statefulAnalyzer.removeYamlProtocol(params.textDocument.uri);

      // This can be optimised to only validate the files we know have related errors.
      statefulAnalyzer.validateAll();
    }
  });

  connection.onDidOpenTextDocument((params) async {
    if (!statefulAnalyzer.isProtocolRegistered(params.textDocument.uri) &&
        /*isProtocolInServerPath(params.textDocument.uri, serverUri)*/ true) {
      statefulAnalyzer.addYamlProtocol(ProtocolSource(
        params.textDocument.text,
        params.textDocument.uri,
      ));
    }

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

    // This can be optimised to only validate the files we know have related errors.
    statefulAnalyzer.validateAll();
  });

  await connection.listen();
}

Future<void> _initializeAnalyzer(
  StatefulAnalyzer statefulAnalyzer,
  Uri? rootUri,
) async {
  if (rootUri != null) {
    var serverDir = Directory.fromUri(rootUri);

    // TODO extract and handle if serverdir is not what we expect
    if (!isServerDirectory(serverDir)) {
      var childDirs = serverDir.listSync().where(
          (element) => isServerDirectory(Directory.fromUri(element.uri)));
      serverDir = Directory.fromUri(childDirs.first.uri);
    }

    var config = await GeneratorConfig.load(serverDir.path);
    var yamlSources =
        await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config!);

    statefulAnalyzer.initialValidation(yamlSources);
  }
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

//TODO fix these helpers and clean them up!
bool isProtocolInServerPath(Uri uri, Uri? serverUri) {
  if (serverUri == null) return false;

  var path = uri.path;
  if (path.contains(serverUri.path)) {
    return true;
  }
  return false;
}

bool isFileOnDisk(Uri uri) {
  var file = File.fromUri(uri);
  return file.existsSync();
}
