import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the "Type" database-roundtrip/echo endpoint', () {
    test(
        'When sending a new to be stored, then the count of stored objects is increased by one',
        () async {
      var types = Types();

      var count = await client.basicDatabase.countTypesRows();
      expect(count, isNotNull);

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var newCount = await client.basicDatabase.countTypesRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));
    });

    test(
        'When sending an object with a `bool` field, then it\'s written to the database and can be read later',
        () async {
      var types = Types(
        aBool: true,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aBool, equals(true));
    });

    test(
        'When sending an object with a `ByteData` field, then it\'s written to the database and can be read later',
        () async {
      var types = Types(
        aByteData: ByteData.view(Uint8List.fromList([1, 2, 3]).buffer),
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aByteData?.buffer.asUint8List().toList(), [1, 2, 3]);
    });

    test(
        'When sending an object with a `double` field, then it\'s written to the database and can be read later',
        () async {
      var types = Types(
        aDouble: 1.5,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aDouble, equals(1.5));
    });

    test(
        'When sending an object with a `int` field, then it\'s written to the database and can be read later',
        () async {
      var types = Types(
        anInt: 42,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.anInt, equals(42));
    });

    test(
        'When sending an object with a `DateTime` field, then it\'s written to the database and can be read later',
        () async {
      var dateTime = DateTime.utc(1976, 9, 10, 2, 10);

      var types = Types(
        aDateTime: dateTime,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aDateTime, equals(dateTime));
    });

    test(
        'When sending an object with a `Duration` field, then it\'s written to the database and can be read later',
        () async {
      var duration = const Duration(seconds: 1);

      var types = Types(
        aDuration: duration,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);
      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aDuration, equals(duration));
    });

    test(
        'When sending an object with a `String` field, then it\'s written to the database and can be read later',
        () async {
      var types = Types(
        aString: 'Foo',
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aString, equals('Foo'));
    });

    test(
        'When sending an object with a `UUID` field, then it\'s written to the database and can be read later',
        () async {
      var uuid = UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');

      var types = Types(
        aUuid: uuid,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aUuid, equals(uuid));
    });

    test(
        'When sending an object with a `BigInt` field, then it\'s written to the database and can be read later',
        () async {
      var bigInt = BigInt.parse('18446744073709551615999');

      var types = Types(
        aBigInt: bigInt,
      );

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));
      expect(storedTypes.aBigInt, equals(bigInt));
    });

    test(
        'When writing an object with fields set to `null` (by default), then an object with `null` fields is returned',
        () async {
      var types = Types();

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      expect(storedTypes!.id, equals(types.id));

      expect(storedTypes.aBool, isNull);
      expect(storedTypes.anInt, isNull);
      expect(storedTypes.aDouble, isNull);
      expect(storedTypes.aString, isNull);
      expect(storedTypes.aDateTime, isNull);
      expect(storedTypes.aDuration, isNull);
      expect(storedTypes.aUuid, isNull);
      expect(storedTypes.aBigInt, isNull);
    });
  });
}
