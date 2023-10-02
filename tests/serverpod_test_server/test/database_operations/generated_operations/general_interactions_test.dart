import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../../config.dart';

void main() {
  var client = Client(serverUrl);

  tearDown(() async => await client.basicDatabase.deleteAll());

  group('Given an empty database', () {
    test('when trying to find an object by id then null is returned.',
        () async {
      var retrieved = await client.basicDatabase.findByIdSimpleData(1);
      expect(retrieved, isNull);
    });

    test('when trying to find a row then null is returned.', () async {
      var retrieved = await client.basicDatabase.findRowSimpleData(1);
      expect(retrieved, isNull);
    });

    test('when trying to find all then an empty list is returned.', () async {
      var retrieved = await client.basicDatabase.findSimpleData(
        limit: 10,
        offset: 0,
      );
      expect(retrieved, []);
    });

    test(
        'when trying to delete a row that doesn\'t exist then an error is thrown.',
        () {
      expect(
        client.basicDatabase.deleteRowSimpleData(SimpleData(id: 1, num: 1)),
        throwsA(isA<ServerpodClientException>()),
      );
    });
    test(
        'when trying to delete a row that doesn\'t exist then an error is thrown.',
        () {
      expect(
        client.basicDatabase.deleteRowSimpleData(SimpleData(id: 1, num: 1)),
        throwsA(isA<ServerpodClientException>()),
      );
    });
    test('when trying to delete where (all) then an empty list is returned.',
        () async {
      var result = await client.basicDatabase.deleteWhereSimpleData();
      expect(result, []);
    });

    test('when trying to update a row than an error is thrown.', () {
      expect(
        client.basicDatabase.updateRowSimpleData(SimpleData(id: 1, num: 1)),
        throwsA(isA<ServerpodClientException>()),
      );
    });
  });

  test(
      'Given an object data without an id when calling insertRow then the created object is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await client.basicDatabase.insertRowSimpleData(simpleData);

    expect(inserted.id, isNotNull);
    expect(inserted.num, 1);
  });

  test(
      'Given an object that is inserted when retrieving it by id then the same object is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await client.basicDatabase.insertRowSimpleData(simpleData);

    var retrieved = await client.basicDatabase.findByIdSimpleData(inserted.id!);

    expect(retrieved, isNotNull);
    expect(inserted.id, retrieved!.id);
    expect(inserted.num, retrieved.num);
  });

  test(
      'Given two inserted objects when finding by row then the filtered row is returned',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    await client.basicDatabase.insertRowSimpleData(simpleData1);
    var expected = await client.basicDatabase.insertRowSimpleData(simpleData2);

    var retrieved = await client.basicDatabase.findRowSimpleData(2);

    expect(retrieved, isNotNull);
    expect(retrieved?.id, expected.id);
  });

  test(
      'Given two inserted objects when retrieving all then a list with the two objects is returned.',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    var inserted1 = await client.basicDatabase.insertRowSimpleData(simpleData1);
    var inserted2 = await client.basicDatabase.insertRowSimpleData(simpleData2);

    var retrieved =
        await client.basicDatabase.findSimpleData(limit: 10, offset: 0);

    expect(retrieved, hasLength(2));
    expect(retrieved.first.id, inserted1.id);
    expect(retrieved.last.id, inserted2.id);
  });

  test(
      'Given an inserted object when deleting that row then the id of the row is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await client.basicDatabase.insertRowSimpleData(simpleData);

    var id = await client.basicDatabase.deleteRowSimpleData(inserted);
    expect(id, inserted.id);
  });

  test(
      'Given an inserted object when deleting that row then it cannot be retrieved from the db.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await client.basicDatabase.insertRowSimpleData(simpleData);
    var id = await client.basicDatabase.deleteRowSimpleData(inserted);

    var retrieved = await client.basicDatabase.findByIdSimpleData(id);

    expect(retrieved, isNull);
  });

  test(
      'Given two inserted objects when deleting all then the ids of the rows are returned.',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    var inserted1 = await client.basicDatabase.insertRowSimpleData(simpleData1);
    var inserted2 = await client.basicDatabase.insertRowSimpleData(simpleData2);

    var ids = await client.basicDatabase.deleteWhereSimpleData();

    expect(ids, hasLength(2));
    expect(ids, contains(inserted1.id));
    expect(ids, contains(inserted2.id));
  });

  group('Given a typed entry in the database', () {
    var data = Types(
      anInt: 1,
      aBool: true,
      aDouble: 1.0,
      aString: 'string',
      aDateTime: DateTime.now(),
      aByteData: ByteData.view(Uint8List(8).buffer),
      aDuration: Duration(milliseconds: 1000),
      aUuid: UuidValue(Uuid().v4()),
      anEnum: TestEnum.one,
    );

    late Types type;

    setUp(() async {
      type = await client.basicDatabase.insertTypes(data);
    });

    test(
        'when updating anInt to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        anInt: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.anInt, isNull);
    });

    test(
        'when updating aBool to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aBool: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aBool, isNull);
    });

    test(
        'when updating aDouble to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aDouble: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDouble, isNull);
    });

    test(
        'when updating aString to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aString: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aString, isNull);
    });

    test(
        'when updating aDateTime to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aDateTime: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDateTime, isNull);
    });

    test(
        'when updating aByteData to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aByteData: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aByteData, isNull);
    });

    test(
        'when updating aDuration to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aDuration: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDuration, isNull);
    });

    test(
        'when updating aUuid to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        aUuid: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aUuid, isNull);
    });

    test(
        'when updating anEnum to null then the database is updated with null value.',
        () async {
      var value = Types(
        id: type.id,
        anEnum: null,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.anEnum, isNull);
    });
  });

  group('Given a typed entry in the database', () {
    var data = Types(
      anInt: null,
      aBool: null,
      aDouble: null,
      aString: null,
      aDateTime: null,
      aByteData: null,
      aDuration: null,
      aUuid: null,
      anEnum: null,
    );

    late Types type;

    setUp(() async {
      type = await client.basicDatabase.insertTypes(data);
    });

    test('when updating anInt to 1 then the database is updated with value 1.',
        () async {
      var value = Types(
        id: type.id,
        anInt: 1,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.anInt, equals(1));
    });

    test(
        'when updating aBool to true then the database is updated with value true.',
        () async {
      var value = Types(
        id: type.id,
        aBool: true,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aBool, equals(true));
    });

    test(
        'when updating aDouble to 1.0 then the database is updated with value 1.0.',
        () async {
      var value = Types(
        id: type.id,
        aDouble: 1.0,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDouble, equals(1.0));
    });

    test(
        'when updating aString to "string" then the database is updated with value "string".',
        () async {
      var value = Types(
        id: type.id,
        aString: 'string',
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aString, equals('string'));
    });

    test(
        'when updating aDateTime to a real value then the database is updated with the real value.',
        () async {
      var now = DateTime.now().toUtc();
      var value = Types(
        id: type.id,
        aDateTime: now,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDateTime, equals(now));
    });

    test(
        'when updating aByteData to a real value then the database is updated with the real value.',
        () async {
      var byteData = ByteData.view(Uint8List(8).buffer);
      var value = Types(
        id: type.id,
        aByteData: byteData,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(
        updated.aByteData?.buffer.asUint8List(),
        equals(byteData.buffer.asUint8List()),
      );
    });

    test(
        'when updating aDuration to a real value then the database is updated with the real value.',
        () async {
      var duration = Duration(milliseconds: 1000);
      var value = Types(
        id: type.id,
        aDuration: duration,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aDuration, equals(duration));
    });

    test(
        'when updating aUuid to a real value then the database is updated with the real value.',
        () async {
      var uuidValue = UuidValue(Uuid().v4());
      var value = Types(
        id: type.id,
        aUuid: uuidValue,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.aUuid, equals(uuidValue));
    });

    test(
        'when updating anEnum to TestEnum.one then the database is updated with value TestEnum.one.',
        () async {
      var value = Types(
        id: type.id,
        anEnum: TestEnum.one,
      );

      var updated = await client.basicDatabase.updateTypes(value);

      expect(updated.anEnum, equals(TestEnum.one));
    });
  });
}
