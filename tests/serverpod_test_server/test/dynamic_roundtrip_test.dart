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
    'Given a model with a dynamic field having nested container objects, '
    'when serializing the model, '
    'then all nested container objects are encoded with their type.',
    () {
      var newObject = object.copyWith(
        payload: [
          1,
          2,
          3,
          {'a': 1, 'b': 2, 'c': SimpleData(num: 3)},
          {'a': 1, 2: SimpleData(num: 2)},
        ],
        payloadList: [
          1,
          'b',
          SimpleData(num: 7),
          [1, 2, 3],
          {'a': 1, 'b': 2},
          {'a': 1, 2: SimpleData(num: 2)},
        ],
        payloadMap: {
          'a': 1,
          'b': 2,
          'c': SimpleData(num: 3),
          'd': [1, 2, 3],
          'e': {'a': 1, 'b': 2},
          'f': {'a': 1, 2: SimpleData(num: 2)},
        },
      );

      final serialized = newObject.toJson();

      expect(serialized['payload'], {
        'className': 'List',
        'data': [
          {'className': 'int', 'data': 1},
          {'className': 'int', 'data': 2},
          {'className': 'int', 'data': 3},
          {
            'className': 'Map',
            'data': {
              'a': {'className': 'int', 'data': 1},
              'b': {'className': 'int', 'data': 2},
              'c': {
                'className': 'SimpleData',
                'data': {'__className__': 'SimpleData', 'num': 3},
              },
            },
          },
          {
            'className': 'Map',
            'data': [
              {
                'k': {'className': 'String', 'data': 'a'},
                'v': {'className': 'int', 'data': 1},
              },
              {
                'k': {'className': 'int', 'data': 2},
                'v': {
                  'className': 'SimpleData',
                  'data': {'__className__': 'SimpleData', 'num': 2},
                },
              },
            ],
          },
        ],
      });

      expect(serialized['payloadList'], [
        {'className': 'int', 'data': 1},
        {'className': 'String', 'data': 'b'},
        {
          'className': 'SimpleData',
          'data': {'__className__': 'SimpleData', 'num': 7},
        },
        {
          'className': 'List',
          'data': [
            {'className': 'int', 'data': 1},
            {'className': 'int', 'data': 2},
            {'className': 'int', 'data': 3},
          ],
        },
        {
          'className': 'Map',
          'data': {
            'a': {'className': 'int', 'data': 1},
            'b': {'className': 'int', 'data': 2},
          },
        },
        {
          'className': 'Map',
          'data': [
            {
              'k': {'className': 'String', 'data': 'a'},
              'v': {'className': 'int', 'data': 1},
            },
            {
              'k': {'className': 'int', 'data': 2},
              'v': {
                'className': 'SimpleData',
                'data': {'__className__': 'SimpleData', 'num': 2},
              },
            },
          ],
        },
      ]);

      expect(serialized['payloadMap'], {
        'a': {'className': 'int', 'data': 1},
        'b': {'className': 'int', 'data': 2},
        'c': {
          'className': 'SimpleData',
          'data': {'__className__': 'SimpleData', 'num': 3},
        },
        'd': {
          'className': 'List',
          'data': [
            {'className': 'int', 'data': 1},
            {'className': 'int', 'data': 2},
            {'className': 'int', 'data': 3},
          ],
        },
        'e': {
          'className': 'Map',
          'data': {
            'a': {'className': 'int', 'data': 1},
            'b': {'className': 'int', 'data': 2},
          },
        },
        'f': {
          'className': 'Map',
          'data': [
            {
              'k': {'className': 'String', 'data': 'a'},
              'v': {'className': 'int', 'data': 1},
            },
            {
              'k': {'className': 'int', 'data': 2},
              'v': {
                'className': 'SimpleData',
                'data': {'__className__': 'SimpleData', 'num': 2},
              },
            },
          ],
        },
      });
    },
  );

  test(
    'Given a model with a dynamic field, '
    'when round-tripping the model through toJson/fromJson, '
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

  test(
    'Given a model with a dynamic field, '
    'when round-tripping the model through complete encode/decode cycle, '
    'then the value roundtrips correctly.',
    () {
      final jsonDecoded = Protocol().encodeWithType(object);
      final deserialized = Protocol().decodeWithType(jsonDecoded);

      expect(deserialized, isA<ObjectWithDynamic>());
      deserialized as ObjectWithDynamic;
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
