import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as shared;
import 'package:test/test.dart';

void main() {
  // Registers this project as a host on both shared and module protocols for
  // dynamic fields. This will always be called for real projects, since the
  // server protocol is passed to the `Serverpod` constructor.
  server.Protocol();

  group(
    'Given a module model with a dynamic field and a shared model as data,',
    () {
      final sharedModel = shared.SharedModel(name: 'test', data: 42);
      final model = module.DynamicOnModule(
        name: 'test',
        data: sharedModel,
      );

      test(
        'when serializing the model, '
        'then it returns the payload with the correct class name and data.',
        () {
          final serialized = model.toJson();

          expect(
            serialized,
            {
              '__className__': 'serverpod_test_module.DynamicOnModule',
              'name': 'test',
              'data': {
                'className': 'serverpod_test_shared.SharedModel',
                'data': sharedModel.toJson(),
              },
            },
          );
        },
      );

      test(
        'when deserializing the payload, '
        'then it returns the shared model.',
        () {
          final decoded = module.DynamicOnModule.fromJson(model.toJson());

          expect(decoded.data, isA<shared.SharedModel>());
          final data = decoded.data as shared.SharedModel;
          expect(data.name, 'test');
          expect(data.data, 42);
        },
      );
    },
  );
}
