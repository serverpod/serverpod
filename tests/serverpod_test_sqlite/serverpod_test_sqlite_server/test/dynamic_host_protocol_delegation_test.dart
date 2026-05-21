import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as shared;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as sqlite;
import 'package:test/test.dart';

void main() {
  group(
    'Given a module protocol holding an object from an unknown project,',
    () {
      late final moduleProtocol = module.Protocol()
        ..registerHostProtocol('serverpod_test_sqlite', sqlite.Protocol());
      // The `serverpod_test` is the owner of the class and is not registered.

      test(
        'when deserializing a qualified className unknown to the module, '
        'then a FormatException is thrown.',
        () {
          final sharedModel = shared.SharedModel(name: 'test', data: 42);
          final payload = {
            'className': 'serverpod_test_shared.SharedModel',
            'data': sharedModel.toJson(),
          };

          expect(
            () => moduleProtocol.deserializeDynamicFieldValue(payload),
            throwsA(isA<FormatException>()),
          );
        },
      );
    },
  );

  // NOTE: This test must come after the previous, since registering a host
  // protocol can not be undone. Otherwise, the test would not throw because
  // the previous registration would leak to the next test.
  group(
    'Given a module protocol with two registered host protocols,',
    () {
      late final moduleProtocol = module.Protocol()
        ..registerHostProtocol('serverpod_test_sqlite', sqlite.Protocol())
        ..registerHostProtocol('serverpod_test', server.Protocol());

      test(
        'when deserializing a qualified className only known to the second host, '
        'then the first host failure is caught and deserialization succeeds.',
        () {
          final sharedModel = shared.SharedModel(name: 'test', data: 42);
          final payload = {
            'className': 'serverpod_test_shared.SharedModel',
            'data': sharedModel.toJson(),
          };

          final decoded = moduleProtocol.deserializeDynamicFieldValue(payload);

          expect(decoded, isA<shared.SharedModel>());
          final model = decoded as shared.SharedModel;
          expect(model.name, 'test');
          expect(model.data, 42);
        },
      );
    },
  );
}
