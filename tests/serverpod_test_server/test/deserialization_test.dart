import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

class DeserializationTestClass {}

void main() {
  group(
    "Given an unknown type for protocol, ",
    () {
      test(
        'when trying to deserialize using server protocol, then a DeserializationTypeNotFoundException exception is thrown',
        () {
          expect(
            () => server.Protocol().deserialize<DeserializationTestClass>({}),
            throwsA(isA<DeserializationTypeNotFoundException>()),
          );
        },
      );
      test(
        'when trying to deserialize using client protocol, then a DeserializationTypeNotFoundException exception is thrown',
        () {
          expect(
            () => Protocol().deserialize<DeserializationTestClass>({}),
            throwsA(isA<DeserializationTypeNotFoundException>()),
          );
        },
      );
    },
  );

  group(
    "Given an known type for 'server' protocol but unknown type for 'auth' module, ",
    () {
      test(
        'when trying to deserialize with valid data, then no DeserializationTypeNotFoundException exception is thrown',
        () {
          expect(
            server.Protocol().deserialize<module.ModuleClass>({
              "name": "test",
              "data": 0,
            }),
            isA<module.ModuleClass>(),
          );
        },
      );

      test(
        'when trying to deserialize with invalid data, then TypeError exception is thrown and not DeserializationTypeNotFoundException',
        () {
          expect(
            () => server.Protocol().deserialize<module.ModuleClass>({
              "name": "test",
              "data": "test",
            }),
            throwsA(isA<TypeError>()),
          );
        },
      );
    },
  );
}
