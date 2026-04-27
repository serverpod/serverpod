import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:dds/dap.dart';
import 'package:serverpod_cli/src/dap/serverpod_debug_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ServerpodDebugAdapter wired to in-memory streams', () {
    late StreamController<List<int>> stdinPipe;
    late StreamController<List<int>> stdoutPipe;
    late ByteStreamServerChannel channel;
    late ServerpodDebugAdapter adapter;
    late StreamQueue<Map<String, dynamic>> outQueue;

    setUp(() {
      stdinPipe = StreamController<List<int>>();
      stdoutPipe = StreamController<List<int>>();
      channel = ByteStreamServerChannel(
        stdinPipe.stream,
        stdoutPipe.sink,
        null,
      );
      adapter = ServerpodDebugAdapter(channel);
      outQueue = StreamQueue<Map<String, dynamic>>(
        _frameStream(stdoutPipe.stream),
      );
      // Suppress unused_local warning while keeping `adapter` referenced so
      // the channel doesn't get garbage-collected mid-test.
      expect(adapter, isNotNull);
    });

    tearDown(() async {
      await outQueue.cancel(immediate: true);
      await stdinPipe.close();
      await stdoutPipe.close();
      await adapter.shutdown();
    });

    test(
      'when an initialize request is sent, '
      'then a successful initialize response is returned',
      () async {
        _send(stdinPipe, {
          'seq': 1,
          'type': 'request',
          'command': 'initialize',
          'arguments': {'adapterID': 'serverpod'},
        });

        final response = await _nextResponseFor(outQueue, 'initialize');
        expect(response['success'], isTrue);
        expect(response['body'], isA<Map>());
      },
    );

    test(
      'when a hotReload customRequest is sent before serverpod-cli.hotReload '
      'is registered, '
      'then the response is an unsuccessful response with a clear message',
      () async {
        _send(stdinPipe, {
          'seq': 1,
          'type': 'request',
          'command': 'initialize',
          'arguments': {'adapterID': 'serverpod'},
        });
        await _nextResponseFor(outQueue, 'initialize');

        _send(stdinPipe, {
          'seq': 2,
          'type': 'request',
          'command': 'hotReload',
          'arguments': {},
        });

        final response = await _nextResponseFor(outQueue, 'hotReload');
        expect(response['success'], isFalse);
        expect(response['message'], contains('serverpod-cli.hotReload'));
      },
    );

    test(
      'when a hotRestart customRequest is sent before '
      'serverpod-cli.hotRestart is registered, '
      'then the response references hotRestart, not hotReload',
      () async {
        _send(stdinPipe, {
          'seq': 1,
          'type': 'request',
          'command': 'initialize',
          'arguments': {'adapterID': 'serverpod'},
        });
        await _nextResponseFor(outQueue, 'initialize');

        _send(stdinPipe, {
          'seq': 2,
          'type': 'request',
          'command': 'hotRestart',
          'arguments': {},
        });

        final response = await _nextResponseFor(outQueue, 'hotRestart');
        expect(response['success'], isFalse);
        // The two paths are distinct services; the failure message must
        // identify hot restart, otherwise users will think reload is broken
        // when they pressed restart.
        expect(response['message'], contains('serverpod-cli.hotRestart'));
        expect(response['message'], isNot(contains('hotReload')));
      },
    );
  });
}

/// Pulls messages off [queue] (skipping events) until a response with the
/// matching command is found, then returns it.
Future<Map<String, dynamic>> _nextResponseFor(
  StreamQueue<Map<String, dynamic>> queue,
  String command,
) async {
  while (true) {
    final m = await queue.next.timeout(const Duration(seconds: 10));
    if (m['type'] == 'response' && m['command'] == command) return m;
  }
}

void _send(StreamController<List<int>> sink, Map<String, Object?> message) {
  final body = utf8.encode(jsonEncode(message));
  sink.add(utf8.encode('Content-Length: ${body.length}\r\n\r\n'));
  sink.add(body);
}

/// Decodes a stream of DAP-framed bytes into individual JSON messages.
Stream<Map<String, dynamic>> _frameStream(Stream<List<int>> source) async* {
  final buffer = BytesBuilder();
  await for (final chunk in source) {
    buffer.add(chunk);
    while (true) {
      final all = buffer.toBytes();
      final asText = utf8.decode(all, allowMalformed: true);
      final headerEnd = asText.indexOf('\r\n\r\n');
      if (headerEnd == -1) break;

      final lengthMatch = RegExp(
        r'Content-Length:\s*(\d+)',
        caseSensitive: false,
      ).firstMatch(asText.substring(0, headerEnd));
      if (lengthMatch == null) {
        throw StateError('Missing Content-Length in headers');
      }
      final contentLength = int.parse(lengthMatch.group(1)!);
      final bodyStart = headerEnd + 4;
      if (all.length - bodyStart < contentLength) break;

      final bodyBytes = all.sublist(bodyStart, bodyStart + contentLength);
      yield jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;

      // Keep only what's left after this message.
      final remainder = all.sublist(bodyStart + contentLength);
      buffer.clear();
      buffer.add(remainder);
    }
  }
}
