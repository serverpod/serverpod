import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Given an HTTP client invoking a serverpod endpoint method', () {
    setUpAll(() async {});

    tearDownAll(() async {});

    test(
        'when calling an endpoint method with correct parameters '
        'then it should respond with 200 ok', () async {
      var response = await http.post(
        Uri.parse('${serverUrl}simple'),
        body: jsonEncode({
          'method': 'hello',
          'name': 'Starbase Alpha',
        }),
      );

      expect(response.statusCode, 200);
      expect(response.body, contains('Hello Starbase Alpha'));
    });

    test(
        'when calling an endpoint method with missing parameters '
        'then it should respond with 400 bad request', () async {
      var response = await http.post(
        Uri.parse('${serverUrl}simple'),
        body: jsonEncode({
          'method': 'hello',
        }),
      );

      expect(response.statusCode, 400);
      expect(response.body, contains('Missing required query parameter: name'));
    });

    test(
        'when calling an endpoint method with too many parameters '
        'then it should respond with 400 bad request', () async {
      var response = await http.post(
        Uri.parse('${serverUrl}simple'),
        body: jsonEncode({
          'method': 'hello',
          'name': 'Starbase Alpha',
          'extra': 'spurious value',
        }),
      );

      expect(response.statusCode, 400);
    }, skip: 'desired behavior unclear');

    test(
        'when calling an endpoint method with misspelled method name '
        'then it should respond with 400 bad request', () async {
      var response = await http.post(
        Uri.parse('${serverUrl}simpleMistake'),
        body: jsonEncode({
          'method': 'hello',
          'name': 'Starbase Alpha',
        }),
      );

      expect(response.statusCode, 400);
      expect(response.body, contains('Endpoint simpleMistake not found'));
    });
  });
}
