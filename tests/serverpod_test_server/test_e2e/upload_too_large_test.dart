import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  test('Given the test server '
      'when request is too large '
      'then the server should respond with an error.', () {
    expectLater(
      client.upload.uploadByteData('path', ByteData(1 << 20)),
      throwsA(
        isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 413)
            .having(
              (e) => e.message,
              'message',
              'Unknown error, data: Request size exceeds the maximum allowed size of 524288 bytes.',
            ),
      ),
    );
  });
}
