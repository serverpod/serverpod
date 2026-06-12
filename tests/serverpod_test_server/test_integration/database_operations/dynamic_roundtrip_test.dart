import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  var object = ObjectWithDynamic(
    payload: 42,
    jsonbPayload: 10.23,
    payloadList: [1, 'b', SimpleData(num: 7)],
    payloadMap: {'a': 1, 'b': 2, 'c': SimpleData(num: 3)},
    payloadSet: {1, 2, 3, 'd'},
    payloadMapWithDynamicKeys: {'a': 1, 2: SimpleData(num: 1)},
  );

  /// Small abstraction to keep expectations close to the source model.
  void expectDynamicFields(ObjectWithDynamic retrieved) {
    expect(retrieved, isNotNull);
    expect(retrieved.payload, 42);
    expect(retrieved.jsonbPayload, 10.23);

    final payloadList = retrieved.payloadList;
    expect(payloadList.first, 1);
    expect(payloadList[1], 'b');
    expect(payloadList[2], isA<SimpleData>());
    expect((payloadList[2] as SimpleData).num, 7);

    final payloadMap = retrieved.payloadMap;
    expect(payloadMap['a'], 1);
    expect(payloadMap['b'], 2);
    expect(payloadMap['c'], isA<SimpleData>());
    expect((payloadMap['c'] as SimpleData).num, 3);

    final payloadSet = retrieved.payloadSet;
    expect(payloadSet, {1, 2, 3, 'd'});

    final mapWithDynamicKeys = retrieved.payloadMapWithDynamicKeys;
    expect(mapWithDynamicKeys['a'], 1);
    expect(mapWithDynamicKeys[2], isA<SimpleData>());
    expect((mapWithDynamicKeys[2] as SimpleData).num, 1);
  }

  withServerpod(
    'Given a table model with dynamic fields,',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      group('when inserting the model with all dynamic fields ', () {
        late Future<ObjectWithDynamic> insert;

        setUp(() async {
          insert = ObjectWithDynamic.db.insertRow(session, object);
        });

        test('then the operation succeeds.', () async {
          await expectLater(insert, completion(isA<ObjectWithDynamic>()));
        });

        test('then the value roundtrips correctly.', () async {
          final retrieved = await insert;
          expectDynamicFields(retrieved);
        });
      });
    },
  );

  withServerpod(
    'Given a table model with dynamic fields and an entry that has been inserted,',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await ObjectWithDynamic.db.insertRow(session, object);
      });

      test('when fetching the model, '
          'then the value roundtrips correctly.', () async {
        final retrieved = await ObjectWithDynamic.db.findFirstRow(session);

        expect(retrieved, isNotNull);
        expectDynamicFields(retrieved!);
      });
    },
  );

  withServerpod(
    'Given an endpoint that echoes an object with dynamic fields,',
    (sessionBuilder, endpoints) {
      test(
        'when round-tripping an object with dynamic fields, '
        'then the value is echoed correctly.',
        () async {
          final retrieved = await endpoints.testTools.echoObjectWithDynamic(
            sessionBuilder,
            object,
          );

          expectDynamicFields(retrieved);
        },
      );
    },
  );

  withServerpod(
    'Given an endpoint that echoes a dynamic value,',
    (sessionBuilder, endpoints) {
      test(
        'when round-tripping a dynamic value, '
        'then the value is echoed correctly.',
        () async {
          final retrieved = await endpoints.testTools.echoDynamic(
            sessionBuilder,
            object,
          );

          expectDynamicFields(retrieved);
        },
      );
    },
  );
}
