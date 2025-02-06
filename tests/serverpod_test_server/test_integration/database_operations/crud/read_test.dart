import 'dart:typed_data';

import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid_value.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
    await SimpleData.db.deleteWhere(session, where: (_) => Constant.bool(true));
    await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
      'Given a list of entries when finding the first row by ordering and offsetting the query then the correct row is returned.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
      UniqueData(number: 3, email: 'career@serverpod.dev'),
    ];

    await UniqueData.db.insert(session, data);

    var dev = await UniqueData.db.findFirstRow(
      session,
      orderBy: (t) => t.number,
      orderDescending: true,
      offset: 1,
    );

    expect(dev?.email, 'dev@serverpod.dev');
  });

  group('Given an empty database', () {
    test('when trying to find an object by id then null is returned.',
        () async {
      var retrieved = await SimpleData.db.findById(
        session,
        1,
      );

      expect(retrieved, isNull);
    });

    test('when trying to find a row then null is returned.', () async {
      var retrieved = await SimpleData.db.findFirstRow(
        session,
        where: (t) => t.num.equals(1),
      );

      expect(retrieved, isNull);
    });

    test('when trying to find all then an empty list is returned.', () async {
      var retrieved = await SimpleData.db.find(
        session,
        orderBy: (t) => t.id,
        limit: 10,
        offset: 0,
      );

      expect(retrieved, []);
    });
  });

  test(
      'Given an object that is inserted when retrieving it by id then the same object is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await SimpleData.db.insertRow(
      session,
      simpleData,
    );

    var retrieved = await SimpleData.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved, isNotNull);
    expect(inserted.id, retrieved!.id);
    expect(inserted.num, retrieved.num);
  });

  test(
      'Given two inserted objects when finding by row then the filtered row is returned',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    await SimpleData.db.insertRow(session, simpleData1);
    var expected = await SimpleData.db.insertRow(session, simpleData2);

    var retrieved = await SimpleData.db.findFirstRow(
      session,
      where: (t) => t.num.equals(2),
    );

    expect(retrieved, isNotNull);
    expect(retrieved?.id, expected.id);
  });

  test(
      'Given two inserted objects when retrieving all then a list with the two objects is returned.',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    var inserted1 = await SimpleData.db.insertRow(session, simpleData1);
    var inserted2 = await SimpleData.db.insertRow(session, simpleData2);

    var retrieved = await SimpleData.db.find(
      session,
      orderBy: (t) => t.id,
      limit: 10,
      offset: 0,
    );

    expect(retrieved, hasLength(2));
    expect(retrieved.first.id, inserted1.id);
    expect(retrieved.last.id, inserted2.id);
  });

  test(
      'Given an inserted empty model when retrieving it then the model is returned.',
      () async {
    var emptyModel = EmptyModelWithTable();
    var inserted = await EmptyModelWithTable.db.insertRow(
      session,
      emptyModel,
    );

    var retrieved = await EmptyModelWithTable.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved, isNotNull);
    expect(inserted.id, retrieved!.id);
  });

  test(
      'Given an object with a `bool` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(aBool: true);
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved!.aBool, true);
  });

  test(
      'Given an object with an `int` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      anInt: 99,
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved!.anInt, 99);
  });

  test(
      'Given an object with a `double` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aDouble: 1.23,
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved!.aDouble, 1.23);
  });

  test(
      'Given an object with a `DateTime` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aDateTime: DateTime.utc(2024, 12, 24, 23, 30),
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved!.aDateTime, DateTime.utc(2024, 12, 24, 23, 30));
  });

  test(
      'Given an object with a `String` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(aString: 'Lorem ipsum');
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved!.aString, 'Lorem ipsum');
  });

  test(
      'Given an object with a `ByteData` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aByteData: ByteData.view(Uint8List.fromList([1, 2, 3]).buffer),
    );

    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(
      Uint8List.view(
        retrieved!.aByteData!.buffer,
        retrieved.aByteData!.offsetInBytes,
        retrieved.aByteData!.lengthInBytes,
      ).toList(),
      [1, 2, 3],
    );
  });

  test(
      'Given an object with a `Duration` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aDuration: Duration(hours: 1, minutes: 2, seconds: 3),
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved?.aDuration, Duration(hours: 1, minutes: 2, seconds: 3));
  });

  test(
      'Given an object with a `UUID` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aUuid: UuidValue.fromString('b1e66000-1cc3-4ead-a4ab-a548e2047d3a'),
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(
      retrieved?.aUuid,
      UuidValue.fromString('b1e66000-1cc3-4ead-a4ab-a548e2047d3a'),
    );
  });

  test(
      'Given an object with a `BigInt` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aBigInt: BigInt.two,
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(
      retrieved?.aBigInt,
      BigInt.two,
    );
  });

  test(
      'Given an object with an `enum` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      anEnum: TestEnum.two,
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(
      retrieved?.anEnum,
      TestEnum.two,
    );
  });

  test(
      'Given an object with a stringified `enum` field, when it\'s stored in the database, then it can be read out again',
      () async {
    var object = Types(
      aStringifiedEnum: TestEnumStringified.three,
    );
    var inserted = await Types.db.insertRow(
      session,
      object,
    );

    var retrieved = await Types.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved?.aStringifiedEnum, TestEnumStringified.three);
  });
}
