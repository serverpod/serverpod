import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Serverpod server with a maximum request size of 10 bytes', () {
    late Serverpod server;
    late Session session;
    const int maxRequestSize = 10; // Maximum allowed request size in bytes

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
    group('when a request with a body larger than 10 bytes is sent', () {
      late http.Response response;

      setUp(() async {
        var uri = Uri.parse('http://localhost:8080/test');
        var body = {};
        for (var i = 0; i < 10; i++) {
          body[i.toString()] = 'Hello, Serverpod!';
        }
        var jsonBody = jsonEncode(body);

        response = await http.post(
          uri,
          body: jsonBody,
        );
      });

      test('then response has 413 status code.', () {
        expect(response.statusCode, equals(HttpStatus.requestEntityTooLarge));
      });

      test('then response contains an error message indicating the request size '
          'exceeded the maximum allowed size', () {
        var expectedMessage =
            'Request size exceeds the maximum allowed size of $maxRequestSize bytes.';
        expect(response.body, equals(expectedMessage));
      });
    });
  });
}
