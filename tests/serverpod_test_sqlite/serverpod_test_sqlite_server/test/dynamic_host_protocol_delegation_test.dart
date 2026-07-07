import 'package:serverpod_test_client/src/protocol/protocol.dart' as client;
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
      setUp(() {
        module.Protocol().registerHostProtocol(
          'serverpod_test_sqlite',
          sqlite.Protocol(),
        );
      });

      test(
        'when deserializing a qualified className unknown to the module, '
        'then a FormatException is thrown.',
        () {
          final sharedModel = shared.SharedModel(name: 'test', data: 42);
          final payload = {
            'className': 'unknown_project.SharedModel',
            'data': sharedModel.toJson(),
          };

          expect(
            () => module.Protocol().deserializeDynamicFieldValue(payload),
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
      setUp(() {
        module.Protocol().registerHostProtocol(
          'serverpod_test_sqlite',
          sqlite.Protocol(),
        );
        module.Protocol().registerHostProtocol(
          'serverpod_test',
          server.Protocol(),
        );
      });

      test(
        'when deserializing a qualified className only known to the second host, '
        'then the first host failure is caught and deserialization succeeds.',
        () {
          final serverModel = server.ExceptionWithData(
            message: 'test',
            creationDate: DateTime.utc(2026, 7, 7),
            errorFields: ['data'],
          );
          final payload = {
            'className': 'serverpod_test.ExceptionWithData',
            'data': serverModel.toJson(),
          };

          final decoded = module.Protocol().deserializeDynamicFieldValue(
            payload,
          );

          expect(decoded, isA<server.ExceptionWithData>());
          final model = decoded as server.ExceptionWithData;
          expect(model.message, 'test');
          expect(model.creationDate, DateTime.utc(2026, 7, 7));
          expect(model.errorFields, ['data']);
        },
      );
    },
  );

  group(
    'Given a shared model with a server-side model in its dynamic field and the client protocol registered after the server protocol,',
    () {
      late server.SimpleData serverModel;
      late shared.DynamicOnShared sharedModel;

      setUp(() {
        // Both the server and client protocols will register themselves on the
        // shared protocol for dynamic serialization/deserialization. This call
        // mocks the initialization only to ensure the tested order and that
        // previous tests do not affect this one.
        shared.Protocol().registerHostProtocol(
          'serverpod_test',
          server.Protocol(),
        );
        shared.Protocol().registerHostProtocol(
          'serverpod_test',
          client.Protocol(),
        );

        serverModel = server.SimpleData(num: 25);
        sharedModel = shared.DynamicOnShared(
          name: 'test',
          data: serverModel,
        );
      });

      test(
        'when deserializing round-tripping the shared model, '
        'then the deserialized stored model is a server model.',
        () {
          final serialized = sharedModel.toJson();
          final deserialized = shared.DynamicOnShared.fromJson(serialized);

          expect(deserialized, isA<shared.DynamicOnShared>());
          final model = deserialized;
          expect(model.name, 'test');
          expect(
            model.data,
            isA<server.SimpleData>().having((data) => data.num, 'num', 25),
          );
        },
      );
    },
  );
}
