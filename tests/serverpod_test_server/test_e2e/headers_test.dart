import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'config.dart';

void main() {
  group('Calling the endpoint should return the expected default headers', () {
    var uri = Uri.parse('${serverUrl}simple/hello');

    test('When http method is POST', () async {
      var result = await http.post(uri,
          headers: {
            'content-type': 'application/json',
          },
          body: jsonEncode({'name': 'mike'}));

      expect(
        result.headers['access-control-allow-origin'],
        equals('*'),
      );
      expect(
          result.headers.containsKey('access-control-allow-headers'), isFalse);
      expect(
        result.headers['access-control-allow-methods'],
        equals('POST'),
      );
    });

    test('When http method is OPTIONS', () async {
      final client = http.Client();
      final method = 'OPTIONS';

      final request = http.Request(method, uri);
      request.headers.addAll({
        'content-type': 'application/json',
      });
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);

      expect(
        response.headers['access-control-allow-origin'],
        equals('*'),
      );
      expect(
        response.headers['content-length'],
        equals('0'),
      );
      expect(
          response.headers.containsKey('access-control-allow-headers'), isTrue);
      expect(
        response.headers['access-control-allow-methods'],
        equals('POST'),
      );
    });
  });
}
