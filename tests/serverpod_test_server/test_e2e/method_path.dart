import 'package:http/http.dart' as http;

import 'config.dart';

import 'package:test/test.dart';

// These tests check that the server support both calling methods through
// parameters and through the new path format (e.g. /simple/hello), which is
// required by OpenAPI.

void main() {
  group('Calling simple endpoint method through parameter', () {
    test('succeed if method and parameters are correct', () async {
      var result = await http.post(
        Uri.parse('${serverUrl}simple?method=hello&name=Bob'),
      );

      expect(result.body, equals('"Hello Bob"'));
      expect(result.statusCode, equals(200));
    });

    test('fail if method name is incorrect', () async {
      var result = await http.post(
        Uri.parse('${serverUrl}simple?method=helloNonExistant&name=Bob'),
      );

      expect(result.statusCode, equals(400));
    });
  });

  group('Calling simple endpoint method through path', () {
    test('succeed if method and path are correct', () async {
      var result = await http.post(
        Uri.parse('${serverUrl}simple/hello?name=Andy'),
      );

      expect(result.body, equals('"Hello Andy"'));
      expect(result.statusCode, equals(200));
    });

    test('fail if method name is incorrect', () async {
      var result = await http.post(
        Uri.parse('${serverUrl}simple/helloNonExistant?name=Andy'),
      );

      expect(result.statusCode, equals(400));
    });
  });

  group('Calling simple endpoint method in a module through parameter', () {
    test('succeed if method and parameters are correct', () async {
      var result = await http.post(
        Uri.parse(
            '${serverUrl}serverpod_test_module.module?method=hello&name=Bob'),
      );

      expect(result.body, equals('"Hello Bob"'));
      expect(result.statusCode, equals(200));
    });

    test('fail if method name is incorrect', () async {
      var result = await http.post(
        Uri.parse(
            '${serverUrl}serverpod_test_module.module?method=helloNonExistant&name=Bob'),
      );

      expect(result.statusCode, equals(400));
    });
  });

  group('Calling simple endpoint method in a module through path', () {
    test('succeed if method and path are correct', () async {
      var result = await http.post(
        Uri.parse('${serverUrl}serverpod_test_module.module/hello?name=Andy'),
      );

      expect(result.body, equals('"Hello Andy"'));
      expect(result.statusCode, equals(200));
    });

    test('fail if method name is incorrect', () async {
      var result = await http.post(
        Uri.parse(
            '${serverUrl}serverpod_test_module.module/helloNonExistant?name=Andy'),
      );

      expect(result.statusCode, equals(400));
    });
  });
}
