import 'dart:async';

import 'package:lsp_server/lsp_server.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/language_server/language_server.dart';

/// Runs the language server in-process over in-memory streams and acts as the
/// LSP client driving it.
///
/// Expectations on server-initiated messages ([nextDiagnosticsFor],
/// [nextRegistration]) must be created before sending the message that
/// triggers them, or the response may be missed.
class LanguageServerTestSession {
  LanguageServerTestSession() {
    var server = Connection(_clientToServer.stream, _serverToClient.sink);
    client = Connection(_serverToClient.stream, _clientToServer.sink);

    client.onNotification('textDocument/publishDiagnostics', (params) async {
      _diagnostics.add(PublishDiagnosticsParams.fromJson(params.value));
    });
    client.onRequest('client/registerCapability', (params) async {
      var received = RegistrationParams.fromJson(params.value).registrations;
      registrations.addAll(received);
      received.forEach(_registrations.add);
      return null;
    });

    _serverDone = runLanguageServer(
      connection: server,
      fileEventDebounce: Duration.zero,
    );
    _clientDone = client.listen();
  }

  final _clientToServer = StreamController<List<int>>();
  final _serverToClient = StreamController<List<int>>();
  final _diagnostics = StreamController<PublishDiagnosticsParams>.broadcast();
  final _registrations = StreamController<Registration>.broadcast();

  late final Connection client;
  late final Future<void> _serverDone;
  late final Future<dynamic> _clientDone;

  /// All capability registrations requested by the server so far.
  final registrations = <Registration>[];

  Future<void> initialize(
    Uri rootUri, {
    bool supportsWatchedFilesRegistration = true,
    bool linkSupport = false,
  }) async {
    await client.sendRequest('initialize', {
      'processId': null,
      'rootUri': rootUri.toString(),
      'capabilities': {
        if (supportsWatchedFilesRegistration)
          'workspace': {
            'didChangeWatchedFiles': {'dynamicRegistration': true},
          },
        if (linkSupport)
          'textDocument': {
            'definition': {'linkSupport': true},
          },
      },
    });
  }

  void sendInitialized() {
    client.sendNotification('initialized', <String, Object?>{});
  }

  void openDocument(String filePath, String text) {
    client.sendNotification('textDocument/didOpen', {
      'textDocument': {
        'uri': Uri.file(filePath).toString(),
        'languageId': 'yaml',
        'version': 1,
        'text': text,
      },
    });
  }

  void closeDocument(String filePath) {
    client.sendNotification('textDocument/didClose', {
      'textDocument': {'uri': Uri.file(filePath).toString()},
    });
  }

  void sendWatchedFileEvents(List<(String, FileChangeType)> events) {
    client.sendNotification('workspace/didChangeWatchedFiles', {
      'changes': [
        for (var (path, type) in events)
          {'uri': Uri.file(path).toString(), 'type': type.toJson()},
      ],
    });
  }

  /// Completes with the next diagnostics published for [filePath] that match
  /// [where].
  Future<PublishDiagnosticsParams> nextDiagnosticsFor(
    String filePath, {
    bool Function(PublishDiagnosticsParams params)? where,
  }) {
    return _diagnostics.stream
        .firstWhere(
          (params) =>
              p.equals(params.uri.toFilePath(), filePath) &&
              (where == null || where(params)),
        )
        .timeout(const Duration(seconds: 10));
  }

  /// Completes with the next capability registration requested by the server.
  Future<Registration> nextRegistration() {
    return _registrations.stream.first.timeout(const Duration(seconds: 10));
  }

  Future<dynamic> requestDefinition(
    String filePath, {
    required int line,
    required int character,
  }) {
    return client.sendRequest('textDocument/definition', {
      'textDocument': {'uri': Uri.file(filePath).toString()},
      'position': {'line': line, 'character': character},
    });
  }

  Future<dynamic> requestReferences(
    String filePath, {
    required int line,
    required int character,
    bool includeDeclaration = true,
  }) {
    return client.sendRequest('textDocument/references', {
      'textDocument': {'uri': Uri.file(filePath).toString()},
      'position': {'line': line, 'character': character},
      'context': {'includeDeclaration': includeDeclaration},
    });
  }

  Future<void> dispose() async {
    await _clientToServer.close();
    await _serverToClient.close();
    try {
      await Future.wait([
        _serverDone,
        _clientDone,
      ]).timeout(const Duration(seconds: 5));
    } catch (_) {
      // Channel teardown errors are irrelevant to the tests.
    }
    await _diagnostics.close();
    await _registrations.close();
  }
}
