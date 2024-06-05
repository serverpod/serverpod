import 'dart:convert';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/serverpod_client_shared_private.dart';
import 'package:test/test.dart';

class TestSerialization extends SerializationManager {}

class TestSerializationImpl extends SerializationManager {
  @override
  Object? decodeWithType(String data) {
    var json = jsonDecode(data);

    if (json['className'] == 'TestException') {
      return TestException.fromJson(json['data']);
    }

    throw Exception('Unknown exception type');
  }
}

class TestException extends SerializableException {
  String message;

  TestException(this.message);

  factory TestException.fromJson(Map<String, dynamic> json) {
    return TestException(json['message']);
  }

  @override
  dynamic toJson() {
    return {
      'message': message,
    };
  }
}

void main() {
  group('Given a serializable exception when parsing the exception', () {
    var exception = getExceptionFrom(
      data:
          '{"className": "TestException", "data": {"message": "A custom exception"}}',
      serializationManager: TestSerializationImpl(),
      statusCode: 400,
    );

    test('then a base TestException is created', () {
      expect(exception, isA<TestException>());
    });

    test('then the message is parsed from the data', () {
      expect(exception.message, 'A custom exception');
    });
  });

  group(
      'Given malformed data with an unknown status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: 'malformed data',
      serializationManager: TestSerialization(),
      statusCode: 499,
    );

    test('then a base ServerpodClientException is created', () {
      expect(exception, isA<ServerpodClientException>());
      expect(exception.statusCode, 499);
    });

    test('then the message is an unknown error', () {
      expect(exception.message, 'Unknown error, data: malformed data');
    });
  });

  group(
      'Given malformed data with a bad request status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: 'malformed data',
      serializationManager: TestSerialization(),
      statusCode: 400,
    );

    test('then a bad request exception is created', () {
      expect(exception, isA<ServerpodClientBadRequest>());
    });

    test('then the message is a bad request', () {
      expect(exception.message, 'Bad request');
    });
  });

  group(
      'Given empty data with a bad request status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: '',
      serializationManager: TestSerialization(),
      statusCode: 400,
    );

    test('then a bad request exception is created', () {
      expect(exception, isA<ServerpodClientBadRequest>());
    });

    test('then the message is a bad request', () {
      expect(exception.message, 'Bad request');
    });
  });

  group(
      'Given empty data with a unauthorized status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: '',
      serializationManager: TestSerialization(),
      statusCode: 401,
    );

    test('then a unauthorized exception is created', () {
      expect(exception, isA<ServerpodClientUnauthorized>());
    });

    test('then the message is a unauthorized', () {
      expect(exception.message, 'Unauthorized');
    });
  });

  group(
      'Given empty data with a forbidden status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: '',
      serializationManager: TestSerialization(),
      statusCode: 403,
    );

    test('then a forbidden exception is created', () {
      expect(exception, isA<ServerpodClientForbidden>());
    });

    test('then the message is a forbidden', () {
      expect(exception.message, 'Forbidden');
    });
  });

  group(
      'Given empty data with a not found status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: '',
      serializationManager: TestSerialization(),
      statusCode: 404,
    );

    test('then a not found exception is created', () {
      expect(exception, isA<ServerpodClientNotFound>());
    });

    test('then the message is a not found', () {
      expect(exception.message, 'Not found');
    });
  });

  group(
      'Given empty data with a internal server error status code when parsing the exception',
      () {
    var exception = getExceptionFrom(
      data: '',
      serializationManager: TestSerialization(),
      statusCode: 500,
    );

    test('then a internal server error exception is created', () {
      expect(exception, isA<ServerpodClientInternalServerError>());
    });

    test('then the message is a internal server error', () {
      expect(exception.message, 'Internal server error');
    });
  });
}
