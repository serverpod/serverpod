import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;
import 'package:test/test.dart';

void main() {
  final moduleProtocol = module.Protocol();

  // Registers this project as a host on module protocols for dynamic fields.
  // This will always be called for real projects, since the server protocol
  // is passed to the `Serverpod` constructor.
  server.Protocol();

  group(
    'Given a model from a module with a dynamic field and a project model as data,',
    () {
      final simpleData = server.SimpleData(num: 1);
      final model = module.DynamicOnModule(
        name: 'test',
        data: simpleData,
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
                'className': 'serverpod_test.SimpleData',
                'data': simpleData.toJson(),
              },
            },
          );
        },
      );

      test(
        'when wrapping the model with className, '
        'then it returns the model with the correct class name and data.',
        () {
          final wrapped = moduleProtocol.wrapWithClassName(model);

          expect(
            wrapped,
            {
              'className': 'DynamicOnModule',
              'data': model,
            },
          );
        },
      );
    },
  );

  group(
    'Given a serialized model from a module with a dynamic field and a project model as data,',
    () {
      final simpleData = server.SimpleData(num: 1);

      final payload = {
        '__className__': 'serverpod_test_module.DynamicOnModule',
        'name': 'test',
        'data': {
          'className': 'serverpod_test.SimpleData',
          'data': simpleData.toJson(),
        },
      };

      test(
        'when deserializing the payload, '
        'then it returns the model with the correct class name and data.',
        () {
          final decoded = module.DynamicOnModule.fromJson(payload);

          expect(decoded, isA<module.DynamicOnModule>());
          expect(
            decoded.data,
            isA<server.SimpleData>().having((data) => data.num, 'num', 1),
          );
        },
      );
    },
  );

  group(
    'Given a serialized model from a module with a dynamic field and a project model as data wrapped with className,',
    () {
      final simpleData = server.SimpleData(num: 1);

      final payload = {
        'className': 'DynamicOnModule',
        'data': {
          'name': 'test',
          'data': {
            'className': 'serverpod_test.SimpleData',
            'data': simpleData.toJson(),
          },
        },
      };

      test(
        'when deserializing the payload, '
        'then it returns the model with the correct class name and data.',
        () {
          final decoded = moduleProtocol.deserializeByClassName(payload);

          expect(decoded, isA<module.DynamicOnModule>());
          expect(
            (decoded as module.DynamicOnModule).data,
            isA<server.SimpleData>().having((data) => data.num, 'num', 1),
          );
        },
      );
    },
  );
}
