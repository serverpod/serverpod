import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod('Record return types', (sessionBuilder, endpoints) {
    test(
      'Given an endpoint returning a record with a non-empty model list, '
      'when calling it through the test tools, '
      'then the models and count are deserialized.',
      () async {
        final rows = [SimpleData(num: 42), SimpleData(num: 7)];

        final result = await endpoints.recordParameters
            .returnRecordOfSimpleDataList(sessionBuilder, rows);

        expect(result.$1.map((row) => row.num), [42, 7]);
        expect(result.$2, 2);
      },
    );

    test(
      'Given an endpoint returning a record with an empty model list, '
      'when calling it through the test tools, '
      'then the empty list and count are preserved.',
      () async {
        final result = await endpoints.recordParameters
            .returnRecordOfSimpleDataList(sessionBuilder, []);

        expect(result.$1, isEmpty);
        expect(result.$2, 0);
      },
    );

    test(
      'Given an endpoint returning a nullable named record with a model list, '
      'when calling it through the test tools, '
      'then the models and named fields are deserialized.',
      () async {
        final record = (rows: [SimpleData(num: 42)], count: 1);

        final result = await endpoints.recordParameters
            .returnNullableNamedRecordOfSimpleDataList(sessionBuilder, record);

        expect(result!.rows!.single.num, 42);
        expect(result.count, 1);
      },
    );

    test(
      'Given an endpoint returning a named record with a null model list, '
      'when calling it through the test tools, '
      'then the null list is preserved.',
      () async {
        final result = await endpoints.recordParameters
            .returnNullableNamedRecordOfSimpleDataList(
              sessionBuilder,
              (rows: null, count: 0),
            );

        expect(result!.rows, isNull);
        expect(result.count, 0);
      },
    );

    test(
      'Given an endpoint returning a null record, '
      'when calling it through the test tools, '
      'then null is returned.',
      () async {
        final result = await endpoints.recordParameters
            .returnNullableNamedRecordOfSimpleDataList(sessionBuilder, null);

        expect(result, isNull);
      },
    );

    test(
      'Given an endpoint returning a list of records containing model lists, '
      'when calling it through the test tools, '
      'then the nested models and null records are deserialized.',
      () async {
        final records = <(List<SimpleData>, int)?>[
          ([SimpleData(num: 42)], 1),
          null,
          ([SimpleData(num: 7), SimpleData(num: 9)], 2),
        ];

        final result = await endpoints.recordParameters
            .returnNullableListOfRecordOfSimpleDataList(
              sessionBuilder,
              records,
            );

        expect(result, hasLength(3));
        expect(result![0]!.$1.single.num, 42);
        expect(result[0]!.$2, 1);
        expect(result[1], isNull);
        expect(result[2]!.$1.map((row) => row.num), [7, 9]);
        expect(result[2]!.$2, 2);
      },
    );

    test(
      'Given an endpoint returning an empty list of records, '
      'when calling it through the test tools, '
      'then the empty list is returned.',
      () async {
        final result = await endpoints.recordParameters
            .returnNullableListOfRecordOfSimpleDataList(sessionBuilder, []);

        expect(result, isEmpty);
      },
    );

    test(
      'Given an endpoint returning a null list of records, '
      'when calling it through the test tools, '
      'then null is returned.',
      () async {
        final result = await endpoints.recordParameters
            .returnNullableListOfRecordOfSimpleDataList(sessionBuilder, null);

        expect(result, isNull);
      },
    );
  });
}
