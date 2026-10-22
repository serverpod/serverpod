import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod('Map return types', (sessionBuilder, endpoints) {
    test(
      'Given an endpoint returning an integer-keyed map of models, '
      'when calling it through the test tools, '
      'then the keys and models are deserialized.',
      () async {
        final map = {1: SimpleData(num: 42), 2: SimpleData(num: 7)};

        final result = await endpoints.mapParameters.returnIntSimpleDataMap(
          sessionBuilder,
          map,
        );

        expect(result.map((key, value) => MapEntry(key, value.num)), {
          1: 42,
          2: 7,
        });
      },
    );

    test(
      'Given an endpoint returning an empty integer-keyed map of models, '
      'when calling it through the test tools, '
      'then the empty map is preserved.',
      () async {
        final result = await endpoints.mapParameters.returnIntSimpleDataMap(
          sessionBuilder,
          {},
        );

        expect(result, isEmpty);
      },
    );

    test(
      'Given an endpoint returning a nullable integer-keyed map with models and null values, '
      'when calling it through the test tools, '
      'then the keys, models, and null values are deserialized.',
      () async {
        final map = {1: SimpleData(num: 42), 2: null};

        final result = await endpoints.mapParameters
            .returnNullableIntSimpleDataMapNullableSimpleData(
              sessionBuilder,
              map,
            );

        expect(result!.map((key, value) => MapEntry(key, value?.num)), {
          1: 42,
          2: null,
        });
      },
    );

    test(
      'Given an endpoint returning a null integer-keyed map of models, '
      'when calling it through the test tools, '
      'then null is returned.',
      () async {
        final result = await endpoints.mapParameters
            .returnNullableIntSimpleDataMapNullableSimpleData(
              sessionBuilder,
              null,
            );

        expect(result, isNull);
      },
    );
  });
}
