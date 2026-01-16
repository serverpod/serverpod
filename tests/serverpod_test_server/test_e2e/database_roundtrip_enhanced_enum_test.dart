import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import 'object_with_enum_enhanced_builder.dart';

void main() {
  final client = Client(serverUrl);

  group(
    'Given an object stored in the database containing an enhanced enum serialized byIndex',
    () {
      test(
        'when roundtripping then value and properties are preserved',
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
    },
  );

  group(
    'Given an object stored in the database containing an enhanced enum serialized byName',
    () {
      test(
        'when roundtripping then value and properties are preserved',
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
    },
  );

  group(
    'Given an object stored in the database containing a list of enhanced enums',
    () {
      test(
        'when roundtripping then all values and properties are preserved',
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
          expect(result.byIndexList[1].priority, equals(0));
        },
      );
    },
  );

  group('Given a nullable enhanced enum field set to null', () {
    test(
      'when storing then null is preserved after roundtrip',
      () async {
        final object = ObjectWithEnumEnhancedBuilder().build();

        final result = await client.basicDatabase.storeObjectWithEnumEnhanced(
          object,
        );

        expect(result.nullableByIndex, isNull);
        expect(result.nullableByName, isNull);
      },
    );
  });
}
