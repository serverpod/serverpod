import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../../config.dart';

void main() {
  var client = Client(serverUrl);

  tearDown(() async => await client.databaseBatch.deleteAll());
  group('Given an empty database', () {
    test(
        'when batch inserting then all the entries are created in the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await client.databaseBatch.batchInsert(data);

      expect(inserted, hasLength(2));

      var simpleList = await client.databaseBatch.findAll();

      expect(inserted.first.id, equals(simpleList.first.id));
      expect(inserted.last.id, equals(simpleList.last.id));
    });

    test(
        'when batch inserting with one failing row then no entries are created in the database.',
        () async {
      var email1 = 'info@serverpod.dev';
      var email2 = 'dev@serverpod.dev';
      var data = <UniqueData>[
        UniqueData(number: 2, email: email1),
        UniqueData(number: 2, email: email2),
        UniqueData(number: 2, email: email2),
      ];

      expect(
        client.databaseBatch.batchInsert(data),
        throwsA(isA<ServerpodClientException>()),
      );

      var first = await client.databaseBatch.findByEmail(email1);
      expect(first, isNull);

      var second = await client.databaseBatch.findByEmail(email2);
      expect(second, isNull);
    });

    test('when batch inserting with an id defined then the id is ignored.',
        () async {
      const int max = 1 >>> 1;

      var data = <UniqueData>[
        UniqueData(id: max, number: 1, email: 'info@serverpod.dev'),
      ];

      var inserted = await client.databaseBatch.batchInsert(data);

      expect(inserted.first.id, isNot(max));
    });
  });

  group('Given two entries in the database when batch updating them.', () {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    late List<UniqueData> inserted;

    setUp(() async => inserted = await client.databaseBatch.batchInsert(data));

    test('then the returned values contains the updates', () async {
      var firstNumber = 5;
      var lastNumber = 6;

      inserted.first.number = firstNumber;
      inserted.last.number = lastNumber;

      var updated = await client.databaseBatch.batchUpdate(inserted);

      expect(updated.first.number, firstNumber);
      expect(updated.last.number, lastNumber);
    });

    test('then the database contains the updated values.', () async {
      var firstNumber = 5;
      var lastNumber = 6;

      inserted.first.number = firstNumber;
      inserted.last.number = lastNumber;

      await client.databaseBatch.batchUpdate(inserted);

      var first = await client.databaseBatch.findById(inserted.first.id!);
      var last = await client.databaseBatch.findById(inserted.last.id!);

      expect(first?.number, firstNumber);
      expect(last?.number, lastNumber);
    });
  });

  test(
      'Given a list of entries to update where one does not have an id then an error is thrown.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var toUpdate = [
      ...inserted,
      UniqueData(number: 3, email: 'extra@serverpod.dev'),
    ];

    expect(
      client.databaseBatch.batchUpdate(toUpdate),
      throwsA(isA<ServerpodClientException>()),
    );
  });

  test(
      'Given a list of entries trying to update a column that does not exist then an error is thrown.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    expect(
      client.databaseBatch.batchUpdateWithInvalidColumn(inserted),
      throwsA(isA<ServerpodClientException>()),
    );
  });

  test(
      'Given a list of entries when batch updating only a single column then no other data is updated.',
      () async {
    var expectedFirstEmail = 'info@serverpod.dev';
    var expectedLastEmail = 'dev@serverpod.dev';
    var expectedFirstNumber = 5;
    var expectedLastNumber = 6;

    var data = <UniqueData>[
      UniqueData(number: 1, email: expectedFirstEmail),
      UniqueData(number: 2, email: expectedLastEmail),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var toUpdate = <UniqueData>[
      UniqueData(
        id: inserted.first.id,
        number: expectedFirstNumber,
        email: 'new@serverpod.dev',
      ),
      UniqueData(
        id: inserted.last.id,
        number: expectedLastNumber,
        email: 'email@serverpod.dev',
      ),
    ];

    var updated = await client.databaseBatch.batchUpdateNumberOnly(toUpdate);

    expect(updated.first.number, expectedFirstNumber);
    expect(updated.last.number, expectedLastNumber);

    expect(updated.first.email, expectedFirstEmail);
    expect(updated.last.email, expectedLastEmail);
  });

  test(
      'Given two entires in the database when batch updating with one failing row then no entries are updated in the database',
      () async {
    var expectedFirstNumber = 1;
    var expectedLastNumber = 2;

    var data = <UniqueData>[
      UniqueData(number: expectedFirstNumber, email: 'info@serverpod.dev'),
      UniqueData(number: expectedLastNumber, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var toUpdate = <UniqueData>[
      UniqueData(
        id: inserted.first.id,
        number: 5,
        email: 'info@serverpod.dev',
      ),
      UniqueData(
        id: inserted.last.id,
        number: 6,
        email: 'info@serverpod.dev',
      ),
    ];

    expect(
      client.databaseBatch.batchUpdate(toUpdate),
      throwsA(isA<ServerpodClientException>()),
    );

    var first = await client.databaseBatch.findById(inserted.first.id!);
    var last = await client.databaseBatch.findById(inserted.last.id!);

    expect(first?.number, expectedFirstNumber);
    expect(last?.number, expectedLastNumber);
  });

  group('Given a typed entry in the database', () {
    var data = <Types>[
      Types(
        anInt: 1,
        aBool: true,
        aDouble: 1.0,
        aString: 'string',
        aDateTime: DateTime.now(),
        aByteData: ByteData.view(Uint8List(8).buffer),
        aDuration: Duration(milliseconds: 1000),
        aUuid: UuidValue(Uuid().v4()),
        anEnum: TestEnum.one,
      ),
    ];

    late Types type;

    setUp(() async {
      var inserted = await client.databaseBatch.batchInsertTypes(data);
      type = inserted.first;
    });

    test(
        'when updating anInt to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          anInt: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.anInt, isNull);
    });

    test(
        'when updating aBool to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aBool: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aBool, isNull);
    });

    test(
        'when updating aDouble to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDouble: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDouble, isNull);
    });

    test(
        'when updating aString to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aString: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aString, isNull);
    });

    test(
        'when updating aDateTime to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDateTime: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDateTime, isNull);
    });

    test(
        'when updating aByteData to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aByteData: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aByteData, isNull);
    });

    test(
        'when updating aDuration to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDuration: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDuration, isNull);
    });

    test(
        'when updating aUuid to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aUuid: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aUuid, isNull);
    });

    test(
        'when updating anEnum to null then the database is updated with null value.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          anEnum: null,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.anEnum, isNull);
    });
  });

  group('Given a typed entry in the database', () {
    var data = <Types>[
      Types(
        anInt: null,
        aBool: null,
        aDouble: null,
        aString: null,
        aDateTime: null,
        aByteData: null,
        aDuration: null,
        aUuid: null,
        anEnum: null,
      ),
    ];

    late Types type;

    setUp(() async {
      var inserted = await client.databaseBatch.batchInsertTypes(data);
      type = inserted.first;
    });

    test('when updating anInt to 1 then the database is updated with value 1.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          anInt: 1,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.anInt, equals(1));
    });

    test(
        'when updating aBool to true then the database is updated with value true.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aBool: true,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aBool, equals(true));
    });

    test(
        'when updating aDouble to 1.0 then the database is updated with value 1.0.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDouble: 1.0,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDouble, equals(1.0));
    });

    test(
        'when updating aString to "string" then the database is updated with value "string".',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aString: 'string',
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aString, equals('string'));
    });

    test(
        'when updating aDateTime to a real value then the database is updated with the real value.',
        () async {
      var now = DateTime.now().toUtc();
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDateTime: now,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDateTime, equals(now));
    });

    test(
        'when updating aByteData to a real value then the database is updated with the real value.',
        () async {
      var byteData = ByteData.view(Uint8List(8).buffer);
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aByteData: byteData,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(
        updated.first.aByteData?.buffer.asUint8List(),
        equals(byteData.buffer.asUint8List()),
      );
    });

    test(
        'when updating aDuration to a real value then the database is updated with the real value.',
        () async {
      var duration = Duration(milliseconds: 1000);
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aDuration: duration,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aDuration, equals(duration));
    });

    test(
        'when updating aUuid to a real value then the database is updated with the real value.',
        () async {
      var uuidValue = UuidValue(Uuid().v4());
      var toUpdate = <Types>[
        Types(
          id: type.id,
          aUuid: uuidValue,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.aUuid, equals(uuidValue));
    });

    test(
        'when updating anEnum to TestEnum.one then the database is updated with value TestEnum.one.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          anEnum: TestEnum.one,
        ),
      ];

      var updated = await client.databaseBatch.batchUpdateTypes(toUpdate);

      expect(updated.first.anEnum, equals(TestEnum.one));
    });
  });

  test(
      'Given two entries in the database when batch deleting the rows then the deleted ids are returned.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var deletedIds = await client.databaseBatch.batchDelete(inserted);

    expect(deletedIds.first, inserted.first.id);
    expect(deletedIds.last, inserted.last.id);
  });

  test(
      'Given two entries in the database when batch deleting the rows then the rows are deleted from the database.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    await client.databaseBatch.batchDelete(inserted);

    var first = await client.databaseBatch.findById(inserted.first.id!);
    var last = await client.databaseBatch.findById(inserted.last.id!);

    expect(first, isNull);
    expect(last, isNull);
  });

  test(
      'Given two entries in the database when batch deleting fails no rows are deleted from the database.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var relationalData =
        RelatedUniqueData(number: 1, uniqueDataId: inserted.last.id!);

    // This restricts the delete of the second entry
    await client.databaseBatch.insertRelatedUniqueData(relationalData);

    expect(
      client.databaseBatch.batchDelete(inserted),
      throwsA(isA<ServerpodClientException>()),
    );

    var first = await client.databaseBatch.findById(inserted.first.id!);
    var last = await client.databaseBatch.findById(inserted.last.id!);

    expect(first, isNotNull);
    expect(last, isNotNull);
  });

  test(
      'Given two entries in the database when batch deleting one the other entry is still in the database.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    await client.databaseBatch.batchDelete([inserted.first]);

    var first = await client.databaseBatch.findById(inserted.first.id!);
    var last = await client.databaseBatch.findById(inserted.last.id!);

    expect(first, isNull);
    expect(last, isNotNull);
  });

  test(
      'Given two entries in the database when batch deleting one only that id is returned.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await client.databaseBatch.batchInsert(data);

    var deletedIds = await client.databaseBatch.batchDelete([inserted.first]);

    expect(deletedIds, hasLength(1));
    expect(deletedIds.first, inserted.first.id);
  });
}
