import 'package:serverpod_test_client/src/protocol/protocol.dart' as client;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as shared;
import 'package:test/test.dart';

void main() {
  final sharedProtocol = shared.Protocol();

  // Registers this project as a host on shared protocols for dynamic fields.
  // This will always be called for real projects, since the client protocol
  // is used on the generated `Client` class.
  client.Protocol();

  group(
    'Given a shared model with a dynamic field and a project model as data,',
    () {
      final simpleData = client.SimpleData(num: 1);
      final model = shared.DynamicOnShared(
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
              '__className__': 'DynamicOnShared',
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
          final wrapped = sharedProtocol.wrapWithClassName(model);

          expect(
            wrapped,
            {
              'className': 'DynamicOnShared',
              'data': model,
            },
          );
        },
      );
    },
  );

  group(
    'Given a serialized shared model with a dynamic field and a project model as data,',
    () {
      final simpleData = client.SimpleData(num: 1);

      final payload = {
        '__className__': 'DynamicOnShared',
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
          final decoded = shared.DynamicOnShared.fromJson(payload);

          expect(decoded, isA<shared.DynamicOnShared>());
          expect(
            decoded.data,
            isA<client.SimpleData>().having((data) => data.num, 'num', 1),
          );
        },
      );
    },
  );

  group(
    'Given a serialized shared model with a dynamic field and a project model as data wrapped with className,',
    () {
      final simpleData = client.SimpleData(num: 1);

      final payload = {
        'className': 'DynamicOnShared',
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
          final decoded = sharedProtocol.deserializeByClassName(payload);

          expect(decoded, isA<shared.DynamicOnShared>());
          expect(
            (decoded as shared.DynamicOnShared).data,
            isA<client.SimpleData>().having((data) => data.num, 'num', 1),
          );
        },
      );
    },
  );
}
