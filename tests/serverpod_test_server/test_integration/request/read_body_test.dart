import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

const int maxRequestSize = 10; // Maximum allowed request size in bytes

void main() {
  late Serverpod server;
  late Session session;

  setUp(() async {
    server = IntegrationTestServer.create(
      config: ServerpodConfig(
        maxRequestSize: maxRequestSize,
        database: null,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
      ),
    );
    await server.start();

    session = await server.createSession(enableLogging: false);
  });

  tearDown(() async {
    await session.close();
    await server.shutdown(exitProcess: false);
  });

  group('Serverpod request size validation', () {
    test('should return appropriate error for oversized request body',
        () async {
      // Arrange
      var uri = Uri.parse('http://localhost:8080/test');
      var largeBody = <String, String>{};
      for (var i = 0; i < 10000; i++) {
        largeBody[i.toString()] = 'Hello, Serverpod!';
      }
      var jsonBody = jsonEncode(largeBody);
      var requestBodyLength = utf8.encode(jsonBody).length;

      // Act
      var response = await http.post(
        uri,
        body: jsonBody,
      );

      // Assert
      // Check the status code
      expect(response.statusCode, equals(HttpStatus.requestEntityTooLarge));

      // Check the error message
      var expectedMessage =
          'Request size exceeds the maximum allowed size of $maxRequestSize bytes.';
      expect(response.body, equals(expectedMessage));
    });
  });
}
