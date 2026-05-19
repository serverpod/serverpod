import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  var object = ObjectWithDynamic(
    payload: 42,
    jsonbPayload: 10.23,
    payloadList: [1, 'b', SimpleData(num: 7)],
    payloadMap: {'a': 1, 'b': 2, 'c': SimpleData(num: 3)},
    payloadSet: {1, 2, 3, 'd'},
    payloadMapWithDynamicKeys: {'a': 1, 2: SimpleData(num: 1)},
  );

  group(
    'Given a model with a dynamic field, '
    'when serializing the model,',
    () {
      final serialized = object.toJson();

      test(
        'then the basic fields are encoded with their type.',
        () {
          expect(
            serialized['payload'],
            {'className': 'int', 'data': 42},
          );
          expect(
            serialized['jsonbPayload'],
            {'className': 'double', 'data': 10.23},
          );
        },
      );

      test(
        'then the list and set fields are encoded with their type.',
        () {
          expect(serialized['payloadList'], [
            {'className': 'int', 'data': 1},
            {'className': 'String', 'data': 'b'},
            {
              'className': 'SimpleData',
              'data': {'__className__': 'SimpleData', 'num': 7},
            },
          ]);

          expect(serialized['payloadSet'], {
            {'className': 'int', 'data': 1},
            {'className': 'int', 'data': 2},
            {'className': 'int', 'data': 3},
            {'className': 'String', 'data': 'd'},
          });
        },
      );

      test(
        'then the map dynamic keys has the keys and values encoded with their type.',
        () {
          expect(serialized['payloadMapWithDynamicKeys'], [
            {
              'k': {'className': 'String', 'data': 'a'},
              'v': {'className': 'int', 'data': 1},
            },
            {
              'k': {'className': 'int', 'data': 2},
              'v': {
                'className': 'SimpleData',
                'data': {'__className__': 'SimpleData', 'num': 1},
              },
            },
          ]);
        },
      );
    },
  );

  test(
    'Given a model with a dynamic field, '
    'when round-tripping the model, '
    'then the value roundtrips correctly.',
    () {
      final serialized = object.toJson();
      final deserialized = ObjectWithDynamic.fromJson(serialized);

      expect(deserialized, isA<ObjectWithDynamic>());
      expect(deserialized.payload, object.payload);
      expect(deserialized.jsonbPayload, object.jsonbPayload);
      expect(deserialized.payloadList.first, 1);
      expect(deserialized.payloadList[1], 'b');
      expect(deserialized.payloadList.last, isA<SimpleData>());
      expect(deserialized.payloadMap['a'], 1);
      expect(deserialized.payloadMap['b'], 2);
      expect(deserialized.payloadMap['c'], isA<SimpleData>());
      expect((deserialized.payloadMap['c'] as SimpleData).num, 3);
      expect(deserialized.payloadSet, object.payloadSet);
      expect(deserialized.payloadMapWithDynamicKeys['a'], 1);
      expect(deserialized.payloadMapWithDynamicKeys[2], isA<SimpleData>());
      expect((deserialized.payloadMapWithDynamicKeys[2] as SimpleData).num, 1);
    },
  );
}
