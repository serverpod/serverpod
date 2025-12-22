import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import 'object_with_enum_enhanced_builder.dart';

void main() {
  var client = Client(serverUrl);

  group('Given an enhanced enum with custom properties', () {
    test(
      'when sending and writing it to the database then the returned value contains an ID',
      () async {
        var object = ObjectWithEnumEnhancedBuilder()
            .withTestEnumEnhanced(TestEnumEnhanced.two)
            .build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(result.id, isNotNull);
      },
    );

    test(
      'when sending and writing it to the database then the enum value is preserved',
      () async {
        var object = ObjectWithEnumEnhancedBuilder()
            .withTestEnumEnhanced(TestEnumEnhanced.two)
            .build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(result.testEnumEnhanced, equals(TestEnumEnhanced.two));
      },
    );

    test(
      'when roundtripping through database then enhanced enum properties are accessible',
      () async {
        var object = ObjectWithEnumEnhancedBuilder()
            .withTestEnumEnhanced(TestEnumEnhanced.one)
            .build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(result.testEnumEnhanced.shortName, equals('1'));
        expect(result.testEnumEnhanced.description, equals('The first value'));
        expect(result.testEnumEnhanced.priority, equals(10));
      },
    );

    test(
      'when roundtripping enum with default property value then default is preserved',
      () async {
        var object = ObjectWithEnumEnhancedBuilder()
            .withTestEnumEnhanced(TestEnumEnhanced.three)
            .build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(result.testEnumEnhanced.priority, equals(0)); // default value
      },
    );

    test(
      'when nullable enhanced enum is null then the returned value is null',
      () async {
        var object = ObjectWithEnumEnhancedBuilder().build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(result.nullableEnumEnhanced, isNull);
      },
    );

    test(
      'when enhanced enum list is roundtripped then all values are preserved',
      () async {
        var object = ObjectWithEnumEnhancedBuilder()
            .withEnumEnhancedList([
              TestEnumEnhanced.one,
              TestEnumEnhanced.two,
              TestEnumEnhanced.three,
            ])
            .build();

        var result =
            await client.basicDatabase.storeObjectWithEnumEnhanced(object);

        expect(
          result.enumEnhancedList,
          equals([
            TestEnumEnhanced.one,
            TestEnumEnhanced.two,
            TestEnumEnhanced.three,
          ]),
        );
        expect(result.enumEnhancedList[0].priority, equals(10));
        expect(result.enumEnhancedList[1].priority, equals(0));
      },
    );
  });
}
