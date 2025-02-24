import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' Uri fields",
    () {
      test(
        'when an object of the class is created, then the "uriDefaultModel" field should match the default value',
        () {
          var object = UriDefaultModel();
          var expectedUri = Uri.parse('https://serverpod.dev/defaultModel');
          expect(object.uriDefaultModel, equals(expectedUri));
        },
      );

      test(
        'when an object of the class is created, then the "uriDefaultModelNull" field should match the default value',
        () {
          var object = UriDefaultModel();
          var expected = Uri.parse('https://serverpod.dev/defaultModel');
          expect(object.uriDefaultModelNull, equals(expected));
        },
      );

      test(
        'when an object of the class is created with a specific value for "uriDefaultModel", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://serverpod.dev/overrideValue');
          var object = UriDefaultModel(uriDefaultModel: uri);
          expect(object.uriDefaultModel, equals(uri));
        },
      );

      test(
        'when an object of the class is created with a specific value for "uriDefaultModelNull", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://serverpod.dev/overrideValue');
          var object = UriDefaultModel(uriDefaultModelNull: uri);
          expect(object.uriDefaultModelNull, equals(uri));
        },
      );
    },
  );
}
