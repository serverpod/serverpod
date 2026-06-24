import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given the main Serverpod library export', () {
    String describe(WebSocketEvent event) => switch (event) {
      TextDataReceived(text: var text) => text,
      BinaryDataReceived(data: var data) => '${data.length} bytes',
      CloseReceived(code: var code, reason: var reason) =>
        'closed: $code $reason',
    };

    test('when handling web socket events then event types are available.', () {
      expect(describe(TextDataReceived('hello')), 'hello');
      expect(
        describe(BinaryDataReceived(Uint8List.fromList([1, 2]))),
        '2 bytes',
      );
      expect(describe(CloseReceived(1000, 'done')), 'closed: 1000 done');
    });
  });
}
