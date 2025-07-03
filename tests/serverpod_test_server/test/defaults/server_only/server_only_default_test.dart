import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with serverOnly scoped fields with default values",
    () {
      test(
        'when an instance is created on server, then serverOnly fields have default values.',
        () {
          var serverObject = ServerOnlyDefault(
            normalField: 'test value',
          );

          expect(serverObject.normalField, 'test value');
          expect(serverObject.serverOnlyField, -1);
          expect(serverObject.serverOnlyStringField, 'Server only message');
        },
      );

      test(
        'when serverOnly field values are explicitly provided, then those values are used.',
        () {
          var serverObject = ServerOnlyDefault(
            normalField: 'test value',
            serverOnlyField: 42,
            serverOnlyStringField: 'Custom message',
          );

          expect(serverObject.normalField, 'test value');
          expect(serverObject.serverOnlyField, 42);
          expect(serverObject.serverOnlyStringField, 'Custom message');
        },
      );

      test(
        'when creating a new object with copyWith, then serverOnly defaults are preserved.',
        () {
          var original = ServerOnlyDefault(
            normalField: 'original',
          );

          var copied = original.copyWith(
            normalField: 'updated',
          );

          expect(copied.normalField, 'updated');
          expect(copied.serverOnlyField, -1);
          expect(copied.serverOnlyStringField, 'Server only message');
        },
      );
    },
  );
}
