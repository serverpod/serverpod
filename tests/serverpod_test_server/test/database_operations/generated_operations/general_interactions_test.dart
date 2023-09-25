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
}
