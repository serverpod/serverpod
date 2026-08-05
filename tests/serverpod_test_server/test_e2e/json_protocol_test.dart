import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Given a Serverpod server when fetching an object, ", () {
    late http.Response response;

    setUpAll(() async {
      response = await http.post(
        Uri.parse("${serverUrl}serverOnlyScopedFieldModel"),
        body: jsonEncode({"method": "getScopeServerOnlyField"}),
      );
    });

    test('then it should return status code 200', () {
      expect(response.statusCode, 200);
    });

    test(
      'then the serialized response body should contain the "nested" key',
      () {
        Map jsonMap = jsonDecode(response.body);
        expect(jsonMap, contains('nested'));
      },
    );
  });

  group(
    "Given a Serverpod server when fetching an object with server only field, ",
    () {
      late http.Response response;

      setUpAll(() async {
        response = await http.post(
          Uri.parse("${serverUrl}serverOnlyScopedFieldModel"),
          body: jsonEncode({"method": "getScopeServerOnlyField"}),
        );
      });

      test('then the response body should not contain server-only field', () {
        Map jsonMap = jsonDecode(response.body);
        expect(jsonMap, isNot(contains('serverOnlyScope')));
      });

      test('then the "nested" object should not contain server-only field', () {
        Map jsonMap = jsonDecode(response.body);
        Map nestedMap = jsonMap['nested'];
        expect(nestedMap, isNot(contains('serverOnlyScope')));
      });
    },
  );

  group(
    "Given a Serverpod server when fetching an custom class object with server only field, ",
    () {
      late http.Response response;

      setUpAll(() async {
        response = await http.post(
          Uri.parse("${serverUrl}customClassProtocol"),
          body: jsonEncode({"method": "getProtocolField"}),
        );
      });

      test('then the response body should not contain server-only field', () {
        Map jsonMap = jsonDecode(response.body);
        expect(jsonMap, isNot(contains('serverOnlyValue')));
      });
    },
  );

  group(
    "Given a Serverpod server when fetching an custom class object that extends another custom class object and inherits a server only field",
    () {
      late http.Response response;

      setUpAll(() async {
        response = await http.post(
          Uri.parse("${serverUrl}serverOnlyScopedFieldChildModel"),
          body: jsonEncode({"method": "getProtocolField"}),
        );
      });

      test('then the response body should not contain server-only field', () {
        Map jsonMap = jsonDecode(response.body);
        expect(jsonMap, isNot(contains('serverOnlyScope')));
      });
    },
  );

  group(
    "Given a Serverpod server when calling an endpoint which throws a normal exception, ",
    () {
      late http.Response response;

      setUpAll(() async {
        response = await http.post(
          Uri.parse("${serverUrl}exceptionTest"),
          body: jsonEncode({"method": "throwNormalException"}),
        );
        print(response.body);
      });

      test('then it should return status code 500', () {
        expect(response.statusCode, 500);
      });
    },
  );

  group(
    "Given a Serverpod server when calling an endpoint which throws a exception with data, ",
    () {
      late http.Response response;

      setUpAll(() async {
        response = await http.post(
          Uri.parse("${serverUrl}exceptionTest"),
          body: jsonEncode({"method": "throwExceptionWithData"}),
        );
      });

      test('then it should return status code 400', () {
        expect(response.statusCode, 400);
      });

      test(
        'then the serialized response body should contain the "className" key',
        () {
          Map jsonMap = jsonDecode(response.body);
          expect(jsonMap, contains('className'));
        },
      );

      test(
        'then the serialized response body should contain the "data" key',
        () {
          Map jsonMap = jsonDecode(response.body);
          expect(jsonMap, contains('data'));
        },
      );

      test(
        'then the serialized "data" object inside response body contain all the fields',
        () {
          Map jsonMap = jsonDecode(response.body)["data"];
          expect(jsonMap, contains('message'));
          expect(jsonMap, contains('creationDate'));
          expect(jsonMap, contains('errorFields'));
          expect(jsonMap, contains('someNullableField'));
        },
      );
    },
  );
}
