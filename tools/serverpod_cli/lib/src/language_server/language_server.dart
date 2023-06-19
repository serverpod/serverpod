import 'dart:async';
import 'dart:io';
import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/language_server/diagnostics_source.dart';

import '../../analyzer.dart';
import '../generator/code_generation_collector.dart';

Future<void> runLanguageServer() async {
  var connection = Connection(stdin, stdout);

  connection.onInitialize((params) async {
    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
      ),
    );
  });

  connection.onDidOpenTextDocument((params) async {
    var diagnostics = _validateYamlProtocol(
      params.textDocument.text,
      params.textDocument.uri.toString(),
    );

    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: params.textDocument.uri,
      ),
    );
  });

  connection.onDidChangeTextDocument((params) async {
    var contentChanges = params.contentChanges.map((content) {
      return content.map(
        (document) => TextDocumentContentChangeEvent2(text: document.text),
        (document) => document,
      );
    });

    var diagnostics = _validateYamlProtocol(
      contentChanges.last.text,
      params.textDocument.uri.toString(),
    );

    connection.sendDiagnostics(
      PublishDiagnosticsParams(
        diagnostics: diagnostics,
        uri: params.textDocument.uri,
      ),
    );
  });

  await connection.listen();
}

List<Diagnostic> _validateYamlProtocol(String yaml, String sourcePath) {
  var collector = CodeGenerationCollector();

  var analyzer = SerializableEntityAnalyzer(
    yaml: yaml,
    sourceFileName: sourcePath,
    outFileName: '', // Only needed for real codegen
    subDirectoryParts: [], // Only needed for real codegen
    collector: collector,
  );

  analyzer.analyze();

  var diagnostics = collector.errors.where((e) => e.span != null).map((error) {
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

  return diagnostics;
}
