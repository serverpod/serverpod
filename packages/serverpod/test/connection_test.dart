import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  Client client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Basic types', () {
    var dateTime = DateTime(1976, 9, 10, 2, 10);

    test('Simple calls', () async {
      await client.simple.setGlobalInt(10);
      await client.simple.addToGlobalInt();
      int? value = await client.simple.getGlobalInt();
      expect(value, equals(11));
    });

    test('Type int', () async {
      int? result = await client.basicTypes.testInt(10);
      expect(result, equals(10));
    });

    test('Type null int', () async {
      int? result = await client.basicTypes.testInt(null);
      expect(result, isNull);
    });

    test('Type double', () async {
      double? result = await client.basicTypes.testDouble(10.0);
      expect(result, equals(10.0));
    });

    test('Type null double', () async {
      double? result = await client.basicTypes.testDouble(null);
      expect(result, isNull);
    });

    test('Type bool', () async {
      bool? result = await client.basicTypes.testBool(true);
      expect(result, equals(true));
    });

    test('Type null bool', () async {
      bool? result = await client.basicTypes.testBool(null);
      expect(result, isNull);
    });

    test('Type String', () async {
      String? result = await client.basicTypes.testString('test');
      expect(result, 'test');
    });

    test('Type String with value \'null\'', () async {
      String? result = await client.basicTypes.testString('null');
      expect(result, 'null');
    });

    test('Type null String', () async {
      String? result = await client.basicTypes.testString(null);
      expect(result, isNull);
    });

    test('Type DateTime', () async {
      DateTime? result = await client.basicTypes.testDateTime(dateTime);
      expect(result!.toLocal(), equals(dateTime));
    });

    test('Type null DateTime', () async {
      DateTime? result = await client.basicTypes.testDateTime(null);
      expect(result, isNull);
    });
  });

  group('Database', () {
    test('Write and read', () async {
      var dateTime = DateTime(1976, 9, 10, 2, 10);

      var types = Types(
        aBool: true,
        aDouble: 1.5,
        anInt: 42,
        aDateTime: dateTime,
        aString: 'Foo',
      );

      int? count = await client.basicDatabase.countRows();
      expect(count, isNotNull);

      int? id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      int? newCount = await client.basicDatabase.countRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      Types? storedTypes = await client.basicDatabase.getTypes(id);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(id));

        expect(storedTypes.aBool, equals(true));
        expect(storedTypes.anInt, equals(42));
        expect(storedTypes.aDouble, equals(1.5));
        expect(storedTypes.aString, equals('Foo'));
        expect(storedTypes.aDateTime?.toLocal(), equals(dateTime));
      }
    });

    test('Write and read null values', () async {
      var types = Types();

      int? count = await client.basicDatabase.countRows();
      expect(count, isNotNull);

      int? id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      int? newCount = await client.basicDatabase.countRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      Types? storedTypes = await client.basicDatabase.getTypes(id);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(id));

        expect(storedTypes.aBool, isNull);
        expect(storedTypes.anInt, isNull);
        expect(storedTypes.aDouble, isNull);
        expect(storedTypes.aString, isNull);
        expect(storedTypes.aDateTime, isNull);
      }
    });

    test('Raw query', () async {
      var types = Types();

      int? id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      int? storedId = await client.basicDatabase.getTypesRawQuery(id);
      expect(storedId, equals(id));
    });
  });

//  test('Type List<int>', () async {
//    List<int> result = await client.basicTypes.testIntList([1, 2, 3]);
//    expect(result, equals([1, 2, 3]));
//  });
}