import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uuid/uuid.dart';

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
        'when calling an endpoint method with non-existing endpoint path '
        'then it should respond with 404 not found', () async {
      final nonExistingPath =
          'path_${Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var response = await http.post(
        Uri.parse('$serverUrl$nonExistingPath'),
        body: jsonEncode({
          'method': 'hello',
          'name': 'Starbase Alpha',
        }),
      );

      expect(response.statusCode, 404);
      expect(response.body, contains('Endpoint $nonExistingPath not found'));
    });

    test(
        'when calling an endpoint method with non-existing method name '
        'then it should respond with 400 bad request', () async {
      final nonExistingName =
          'path_${Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var response = await http.post(
        Uri.parse('${serverUrl}simple'),
        body: jsonEncode({
          'method': nonExistingName,
          'name': 'Starbase Alpha',
        }),
      );

      expect(response.statusCode, 400);
      expect(response.body, contains('Method "$nonExistingName" not found'));
    });

    test(
        'when calling an endpoint method with missing method name attribute '
        'then it should respond with 400 bad request', () async {
      var response = await http.post(
        Uri.parse('${serverUrl}simple'),
        body: jsonEncode({
          'name': 'Starbase Alpha',
        }),
      );

      expect(response.statusCode, 400);
      expect(response.body, contains('No method name specified'));
    });
  });
}
