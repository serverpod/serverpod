import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'uriDefaultPersist' Uri fields",
    () {
      test(
        'when an object of the class is created, then the "uriDefaultPersist" field should be null',
        () {
          var object = UriDefaultPersist();
          expect(object.uriDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "uriDefaultPersist", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://serverpod.dev/overrideValue');
          var object = UriDefaultPersist(uriDefaultPersist: uri);
          expect(object.uriDefaultPersist, equals(uri));
        },
      );
    },
  );
}
