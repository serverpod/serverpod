import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  var protocol = _TestProtocol();

  group(
    'Given a map with dynamic keys,',
    () {
      final map = {'a': 1, 2: 'two'};

      test(
        'when converting to json, '
        'then the data is a list of key-value entries with className and data fields.',
        () {
          final encoded = protocol.dynamicFieldToJson(map);

          expect(encoded, {
            'className': 'Map',
            'data': [
              {
                'k': {'className': 'String', 'data': 'a'},
                'v': {'className': 'int', 'data': 1},
              },
              {
                'k': {'className': 'int', 'data': 2},
                'v': {'className': 'String', 'data': 'two'},
              },
            ],
          });
        },
      );

      group(
        'when round-tripping the JSON-converted data through jsonEncode and jsonDecode, ',
        () {
          late Map<String, dynamic> jsonDecoded;

          setUp(() {
            final encoded = protocol.dynamicFieldToJson(map);
            jsonDecoded = jsonDecode(jsonEncode(encoded));
          });

          test(
            'then the decoded data field is a List<dynamic>.',
            () {
              final data = jsonDecoded['data'];
              expect(data, isA<List>());
              data as List;
              expect(data[0], isA<Map<String, dynamic>>());
              expect(data[1], isA<Map<String, dynamic>>());
            },
          );
        },
      );
    },
  );

  group(
    'Given a map with dynamic keys round-tripped through jsonEncode and jsonDecode,',
    () {
      final map = {'a': 1, 2: 'two'};

      late Map<String, dynamic> jsonDecoded;

      setUp(() {
        final encoded = protocol.dynamicFieldToJson(map);
        jsonDecoded = jsonDecode(jsonEncode(encoded));
      });

      test(
        'when deserializing with deserializeByClassName, '
        'then the original map is restored.',
        () {
          final decoded = protocol.deserializeByClassName(jsonDecoded);

          expect(decoded, isA<Map>());
          decoded as Map<dynamic, dynamic>;
          expect(decoded['a'], 1);
          expect(decoded[2], 'two');
        },
      );

      test(
        'when deserializing with deserializeDynamicFieldValue, '
        'then the original map is restored.',
        () {
          final decoded = protocol.deserializeDynamicFieldValue(
            jsonDecoded,
          );

          expect(decoded, isA<Map>());
          decoded as Map<dynamic, dynamic>;
          expect(decoded['a'], 1);
          expect(decoded[2], 'two');
        },
      );
    },
  );

  group(
    'Given a dynamic field containing nested maps with dynamic keys, ',
    () {
      final value = [
        {'a': 1, 2: 'two'},
        {'b': true},
      ];

      test(
        'when round-tripping through jsonEncode and jsonDecode, '
        'then the nested maps are restored correctly.',
        () {
          final encoded = protocol.dynamicFieldToJson(value);
          final jsonDecoded = jsonDecode(jsonEncode(encoded));
          final decoded = protocol.deserializeDynamicFieldValue(jsonDecoded);

          expect(decoded, isA<List>());
          decoded as List;

          final first = decoded[0] as Map<dynamic, dynamic>;
          expect(first['a'], 1);
          expect(first[2], 'two');

          final second = decoded[1] as Map<dynamic, dynamic>;
          expect(second['b'], true);
        },
      );

      test(
        'when round-tripping through complete encode/decode cycle, '
        'then the nested maps are restored correctly.',
        () {
          final encoded = protocol.dynamicFieldToJson(value);
          final jsonDecoded = jsonDecode(jsonEncode(encoded));
          final decoded = protocol.deserializeDynamicFieldValue(jsonDecoded);

          expect(decoded, isA<List>());
          decoded as List;

          final first = decoded[0] as Map<dynamic, dynamic>;
          expect(first['a'], 1);
          expect(first[2], 'two');

          final second = decoded[1] as Map<dynamic, dynamic>;
          expect(second['b'], true);
        },
      );
    },
  );
}

class _TestProtocol extends SerializationManager {
  @override
  String get moduleName => 'test';
}
