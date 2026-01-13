import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import 'object_with_enum_enhanced_builder.dart';

void main() {
  final client = Client(serverUrl);

  group('Given an enhanced enum serialized by index', () {
    test(
      'when roundtripping through database then enum value is preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder()
            .withByIndex(TestEnumEnhanced.two)
            .build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.byIndex, equals(TestEnumEnhanced.two));
        expect(result.byIndex.shortName, equals('2'));
      },
    );

    test(
      'when roundtripping nullable enum as null then null is preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder().build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.nullableByIndex, isNull);
      },
    );

    test(
      'when roundtripping enum list then all values are preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder().withByIndexList([
          TestEnumEnhanced.one,
          TestEnumEnhanced.two,
          TestEnumEnhanced.three,
        ]).build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.byIndexList.length, equals(3));
        expect(result.byIndexList[0].priority, equals(10));
        expect(result.byIndexList[1].priority, equals(0)); // default
      },
    );
  });

  group('Given an enhanced enum serialized by name', () {
    test(
      'when roundtripping through database then enum value is preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder()
            .withByName(TestEnumEnhancedByName.two)
            .build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.byName, equals(TestEnumEnhancedByName.two));
        expect(result.byName.shortName, equals('2'));
      },
    );

    test(
      'when roundtripping nullable enum as null then null is preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder().build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.nullableByName, isNull);
      },
    );

    test(
      'when roundtripping enum list then all values are preserved',
      () async {
        final object = ObjectWithEnumEnhancedBuilder().withByNameList([
          TestEnumEnhancedByName.one,
          TestEnumEnhancedByName.two,
          TestEnumEnhancedByName.three,
        ]).build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.byNameList.length, equals(3));
        expect(result.byNameList[0].priority, equals(10));
        expect(result.byNameList[1].priority, equals(0)); // default
      },
    );
  });
}
