import 'package:serverpod_test_client/src/protocol/object_with_dynamic.dart';
import 'package:test/test.dart';

void main() {
  group('Given a model with dynamic fields', () {
    final model = ObjectWithDynamic(
      id: 1,
      payload: 'test',
      jsonbPayload: 1,
      payloadList: [1, 2, 3],
      payloadMap: {'a': 1, 'b': 2},
      payloadSet: {1, 2, 3},
      payloadMapWithDynamicKeys: {},
    );

    test(
      'when calling copyWith changing a non-dynamic field, '
      'then dynamic fields remain unchanged.',
      () {
        final updated = model.copyWith(id: 2);

        expect(updated.id, 2);
        expect(updated.payload, model.payload);
        expect(updated.jsonbPayload, model.jsonbPayload);
        expect(updated.payloadList, model.payloadList);
        expect(updated.payloadMap, model.payloadMap);
        expect(updated.payloadSet, model.payloadSet);
      },
    );

    test(
      'when calling copyWith changing a dynamic field to null, '
      'then only the changed dynamic field is nulled.',
      () {
        final cleared = model.copyWith(payload: null);

        expect(cleared.payload, isNull);
        expect(cleared.jsonbPayload, model.jsonbPayload);
        expect(cleared.payloadList, model.payloadList);
        expect(cleared.payloadMap, model.payloadMap);
        expect(cleared.payloadSet, model.payloadSet);
      },
    );

    test(
      'when calling copyWith changing a dynamic field to a new value, '
      'then only the changed dynamic field is updated.',
      () {
        final updated = model.copyWith(payload: 2);

        expect(updated.payload, 2);
        expect(updated.jsonbPayload, model.jsonbPayload);
        expect(updated.payloadList, model.payloadList);
        expect(updated.payloadMap, model.payloadMap);
        expect(updated.payloadSet, model.payloadSet);
      },
    );
  });
}
