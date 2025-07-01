import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = UriDefaultMix();
          expect(
            object.uriDefaultAndDefaultModel,
            equals(Uri.parse('https://serverpod.dev/defaultModel')),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = UriDefaultMix();
          expect(
            object.uriDefaultAndDefaultPersist,
            equals(Uri.parse('https://serverpod.dev/default')),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = UriDefaultMix();
          expect(
            object.uriDefaultModelAndDefaultPersist,
            equals(Uri.parse('https://serverpod.dev/defaultModel')),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uriDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://example.com');
          var object = UriDefaultMix(
            uriDefaultAndDefaultModel: uri,
          );
          expect(
            object.uriDefaultAndDefaultModel,
            equals(uri),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uriDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://example.com');
          var object = UriDefaultMix(
            uriDefaultAndDefaultPersist: uri,
          );
          expect(
            object.uriDefaultAndDefaultPersist,
            equals(uri),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uriDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var uri = Uri.parse('https://example.com');
          var object = UriDefaultMix(
            uriDefaultModelAndDefaultPersist: uri,
          );
          expect(
            object.uriDefaultModelAndDefaultPersist,
            equals(uri),
          );
        },
      );
    },
  );
}
