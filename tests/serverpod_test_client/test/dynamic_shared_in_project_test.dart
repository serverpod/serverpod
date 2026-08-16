import 'package:serverpod_test_client/src/protocol/object_with_dynamic.dart';
import 'package:serverpod_test_client/src/protocol/protocol.dart' as client;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as shared;
import 'package:test/test.dart';

void main() {
  // Registers this project as a host on shared protocols for dynamic fields.
  // This will always be called for real projects, since the client protocol
  // is used on the generated `Client` class.
  client.Protocol();

  group('Given a project model with a shared model in payload,', () {
    final sharedModel = shared.SharedModel(name: 'test', data: 42);
    final object = client.ObjectWithDynamic(
      payload: sharedModel,
      jsonbPayload: null,
      payloadList: [sharedModel],
      payloadMap: {sharedModel.name: sharedModel},
      payloadSet: {},
      payloadMapWithDynamicKeys: {},
    );

    test(
      'when serializing the model, '
      'then the dynamic field uses the shared package class name.',
      () {
        final serialized = object.toJson();

        final expectedModelPayload = {
          'className': 'serverpod_test_shared.SharedModel',
          'data': sharedModel.toJson(),
        };

        expect(serialized['payload'], expectedModelPayload);
        expect(serialized['payloadList'], [expectedModelPayload]);
        expect(serialized['payloadMap'], {
          sharedModel.name: expectedModelPayload,
        });
      },
    );

    test(
      'when deserializing the payload, '
      'then it returns the shared model.',
      () {
        final decoded = ObjectWithDynamic.fromJson(object.toJson());

        expect(decoded.payload, isA<shared.SharedModel>());
        final payload = decoded.payload as shared.SharedModel;
        expect(payload.name, 'test');
        expect(payload.data, 42);
      },
    );
  });
}
