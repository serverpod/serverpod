import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' Uri fields",
    () {
      test(
        'when an object of the class is created, then the "uriDefault" field should match the default value',
        () {
          var object = UriDefault();
          var expectedUri = Uri.parse('https://serverpod.dev/default');
          expect(object.uriDefault, equals(expectedUri));
        },
      );

      test(
        'when an object of the class is created, then the "uriDefaultNull" field should match the default value',
        () {
          var object = UriDefault();
          var expectedUri = Uri.parse('https://serverpod.dev/default');
          expect(object.uriDefaultNull, equals(expectedUri));
        },
      );

      test(
        'when an object of the class is created with a specific value for "uriDefault", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://serverpod.dev/default');
          var object = UriDefault(uriDefault: uri);
          expect(object.uriDefault, equals(uri));
        },
      );

      test(
        'when an object of the class is created with a specific value for "uriDefaultNull", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://serverpod.dev/default');
          var object = UriDefault(uriDefaultNull: uri);
          expect(object.uriDefaultNull, equals(uri));
        },
      );
    },
  );
}
