import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
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

      var inserted = await UniqueData.db.insert(session, data);

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

      var updated = await UniqueData.db.update(
        session,
        toUpdate,
        columns: (t) => [t.number],
      );

      expect(updated.first.number, expectedFirstNumber);
      expect(updated.last.number, expectedLastNumber);

      expect(updated.first.email, expectedFirstEmail);
      expect(updated.last.email, expectedLastEmail);
    },
  );

  test(
    'Given a list of entries to update where one does not have an id then an error is thrown.',
    () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      var toUpdate = [
        ...inserted,
        UniqueData(number: 3, email: 'extra@serverpod.dev'),
      ];

      expect(
        UniqueData.db.update(
          session,
          toUpdate,
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a list of entries trying to update a column that does not exist then an error is thrown.',
    () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      expect(
        UniqueData.db.update(
          session,
          inserted,
          columns: (_) => [SimpleData.t.num],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given an model when batch updatingRow with a specific column only that column and no other data is updated.',
    () async {
      var expectedEmail = 'info@serverpod.dev';
      var expectedNumber = 5;

      var inserted = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: expectedEmail),
      );

      var toUpdate = UniqueData(
        id: inserted.id,
        number: expectedNumber,
        email: 'new@serverpod.dev',
      );

      var updated = await UniqueData.db.updateRow(
        session,
        toUpdate,
        columns: (t) => [t.number],
      );

      expect(updated.number, expectedNumber);

      expect(updated.email, expectedEmail);
    },
  );

  test(
    'Given an model without an id when batch updatingRow then an error is thrown.',
    () async {
      expect(
        UniqueData.db.updateRow(
          session,
          UniqueData(number: 1, email: 'info@serverpod.dev'),
          columns: (t) => [t.number],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given an model trying to updateRow with a column that does not exist then an error is thrown.',
    () async {
      var inserted = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: 'info@serverpod.dev'),
      );

      expect(
        UniqueData.db.updateRow(
          session,
          inserted,
          columns: (_) => [SimpleData.t.num],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  group('Given a typed entry in the database', () {
    var data = Types(
      anInt: 1,
      aBool: true,
      aDouble: 1.0,
      aString: 'string',
      aDateTime: DateTime.now(),
      aByteData: ByteData.view(Uint8List(8).buffer),
      aDuration: Duration(milliseconds: 1000),
      aUuid: UuidValue.fromString(Uuid().v4()),
      aUri: Uri.parse('https://example.com'),
      aBigInt: BigInt.from(123456789),
      aVector: Vector([1.0, 2.0, 3.0]),
      aHalfVector: HalfVector([1.0, 2.0, 3.0]),
      aSparseVector: SparseVector([1.0, 0.0, 2.0]),
      aBit: Bit([true, false, true]),
      anEnum: TestEnum.one,
      aStringifiedEnum: TestEnumStringified.one,
      aList: [1, 2, 3],
      aMap: {1: 10, 2: 20},
      aSet: {1, 2, 3},
      aRecord: ('test', optionalUri: Uri.parse('https://serverpod.dev')),
    );

    late Types type;

    setUp(() async {
      type = await Types.db.insertRow(session, data);
    });

    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test(
      'when updating anInt to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          anInt: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.anInt, isNull);
      },
    );

    test(
      'when updating aBool to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aBool: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBool, isNull);
      },
    );

    test(
      'when updating aDouble to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aDouble: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDouble, isNull);
      },
    );

    test(
      'when updating aString to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aString: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aString, isNull);
      },
    );

    test(
      'when updating aDateTime to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aDateTime: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDateTime, isNull);
      },
    );

    test(
      'when updating aByteData to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aByteData: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aByteData, isNull);
      },
    );

    test(
      'when updating aDuration to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aDuration: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDuration, isNull);
      },
    );

    test(
      'when updating aUuid to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aUuid: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aUuid, isNull);
      },
    );

    test(
      'when updating aUri to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aUri: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aUri, isNull);
      },
    );

    test(
      'when updating aBigInt to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aBigInt: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBigInt, isNull);
      },
    );

    test(
      'when updating aVector to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aVector: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aVector, isNull);
      },
    );

    test(
      'when updating aHalfVector to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aHalfVector: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aHalfVector, isNull);
      },
    );

    test(
      'when updating aSparseVector to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aSparseVector: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aSparseVector, isNull);
      },
    );

    test(
      'when updating aBit to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aBit: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBit, isNull);
      },
    );

    test(
      'when updating anEnum to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          anEnum: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.anEnum, isNull);
      },
    );

    test(
      'when updating aStringifiedEnum to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aStringifiedEnum: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aStringifiedEnum, isNull);
      },
    );

    test(
      'when updating aList to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aList: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aList, isNull);
      },
    );

    test(
      'when updating aMap to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aMap: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aMap, isNull);
      },
    );

    test(
      'when updating aSet to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aSet: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aSet, isNull);
      },
    );

    test(
      'when updating aRecord to null then the database is updated with null value.',
      () async {
        var value = Types(
          id: type.id,
          aRecord: null,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aRecord, isNull);
      },
    );
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
      aUri: null,
      aBigInt: null,
      aVector: null,
      aHalfVector: null,
      aSparseVector: null,
      aBit: null,
      anEnum: null,
      aStringifiedEnum: null,
      aList: null,
      aMap: null,
      aSet: null,
      aRecord: null,
    );

    late Types type;

    setUp(() async {
      type = await Types.db.insertRow(session, data);
    });

    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test(
      'when updating anInt to 1 then the database is updated with value 1.',
      () async {
        var value = Types(
          id: type.id,
          anInt: 1,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.anInt, equals(1));
      },
    );

    test(
      'when updating aBool to true then the database is updated with value true.',
      () async {
        var value = Types(
          id: type.id,
          aBool: true,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBool, equals(true));
      },
    );

    test(
      'when updating aDouble to 1.0 then the database is updated with value 1.0.',
      () async {
        var value = Types(
          id: type.id,
          aDouble: 1.0,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDouble, equals(1.0));
      },
    );

    test(
      'when updating aString to "string" then the database is updated with value "string".',
      () async {
        var value = Types(
          id: type.id,
          aString: 'string',
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aString, equals('string'));
      },
    );

    test(
      'when updating aDateTime to a real value then the database is updated with the real value.',
      () async {
        var now = DateTime.now().toUtc();
        var value = Types(
          id: type.id,
          aDateTime: now,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDateTime, equals(now));
      },
    );

    test(
      'when updating aByteData to a real value then the database is updated with the real value.',
      () async {
        var byteData = ByteData.view(Uint8List(8).buffer);
        var value = Types(
          id: type.id,
          aByteData: byteData,
        );

        var updated = await Types.db.updateRow(session, value);

        var byteDataResult = updated.aByteData;

        expect(
          byteDataResult?.buffer.asUint8List(
            byteDataResult.offsetInBytes,
            byteDataResult.lengthInBytes,
          ),
          equals(byteData.buffer.asUint8List()),
        );
      },
    );

    test(
      'when updating aDuration to a real value then the database is updated with the real value.',
      () async {
        var duration = Duration(milliseconds: 1000);
        var value = Types(
          id: type.id,
          aDuration: duration,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aDuration, equals(duration));
      },
    );

    test(
      'when updating aUuid to a real value then the database is updated with the real value.',
      () async {
        var uuidValue = UuidValue.fromString(Uuid().v4());
        var value = Types(
          id: type.id,
          aUuid: uuidValue,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aUuid, equals(uuidValue));
      },
    );

    test(
      'when updating aUri to a real value then the database is updated with the real value.',
      () async {
        var uri = Uri.parse('https://example.com');
        var value = Types(
          id: type.id,
          aUri: uri,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aUri, equals(uri));
      },
    );

    test(
      'when updating aBigInt to a real value then the database is updated with the real value.',
      () async {
        var bigInt = BigInt.from(987654321);
        var value = Types(
          id: type.id,
          aBigInt: bigInt,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBigInt, equals(bigInt));
      },
    );

    test(
      'when updating aVector to a real value then the database is updated with the real value.',
      () async {
        var vector = Vector([4.0, 5.0, 6.0]);
        var value = Types(
          id: type.id,
          aVector: vector,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aVector, equals(vector));
      },
    );

    test(
      'when updating aHalfVector to a real value then the database is updated with the real value.',
      () async {
        var halfVector = HalfVector([4.0, 5.0, 6.0]);
        var value = Types(
          id: type.id,
          aHalfVector: halfVector,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aHalfVector, equals(halfVector));
      },
    );

    test(
      'when updating aSparseVector to a real value then the database is updated with the real value.',
      () async {
        var sparseVector = SparseVector([0.0, 4.0, 5.0]);
        var value = Types(
          id: type.id,
          aSparseVector: sparseVector,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aSparseVector, equals(sparseVector));
      },
    );

    test(
      'when updating aBit to a real value then the database is updated with the real value.',
      () async {
        var value = Types(
          id: type.id,
          aBit: Bit([true, false, true]),
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aBit, equals(Bit([true, false, true])));
      },
    );

    test(
      'when updating anEnum to TestEnum.one then the database is updated with value TestEnum.one.',
      () async {
        var value = Types(
          id: type.id,
          anEnum: TestEnum.one,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.anEnum, equals(TestEnum.one));
      },
    );

    test(
      'when updating aStringifiedEnum to TestEnumStringified.two then the database is updated with value TestEnumStringified.two.',
      () async {
        var value = Types(
          id: type.id,
          aStringifiedEnum: TestEnumStringified.two,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aStringifiedEnum, equals(TestEnumStringified.two));
      },
    );

    test(
      'when updating aList to a real value then the database is updated with the real value.',
      () async {
        var list = [4, 5, 6];
        var value = Types(
          id: type.id,
          aList: list,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aList, equals(list));
      },
    );

    test(
      'when updating aMap to a real value then the database is updated with the real value.',
      () async {
        var map = {3: 30, 4: 40};
        var value = Types(
          id: type.id,
          aMap: map,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aMap, equals(map));
      },
    );

    test(
      'when updating aSet to a real value then the database is updated with the real value.',
      () async {
        var set = {4, 5, 6};
        var value = Types(
          id: type.id,
          aSet: set,
        );

        var updated = await Types.db.updateRow(session, value);

        expect(updated.aSet, equals(set));
      },
    );

    test(
      'when updating aRecord to a new value then the database is updated with the value.',
      () async {
        var value = Types(
          id: type.id,
          aRecord: ('test', optionalUri: Uri.parse('https://serverpod.dev')),
        );

        var updated = await Types.db.updateRow(session, value);

        expect(
          updated.aRecord,
          equals(('test', optionalUri: Uri.parse('https://serverpod.dev'))),
        );
      },
    );
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
        aUuid: UuidValue.fromString(Uuid().v4()),
        aUri: Uri.parse('https://example.com'),
        aBigInt: BigInt.from(123456789),
        aVector: Vector([1.0, 2.0, 3.0]),
        aHalfVector: HalfVector([1.0, 2.0, 3.0]),
        aSparseVector: SparseVector([0.0, 4.0, 5.0]),
        aBit: Bit([true, false, true]),
        anEnum: TestEnum.one,
        aStringifiedEnum: TestEnumStringified.one,
        aList: [1, 2, 3],
        aMap: {1: 10, 2: 20},
        aSet: {1, 2, 3},
        aRecord: ('test', optionalUri: Uri.parse('https://serverpod.dev')),
      ),
    ];

    late Types type;

    setUp(() async {
      var inserted = await Types.db.insert(session, data);
      type = inserted.first;
    });

    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test(
      'when batch updating anInt to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            anInt: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.anInt, isNull);
      },
    );

    test(
      'when batch updating aBool to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBool: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBool, isNull);
      },
    );

    test(
      'when batch updating aDouble to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDouble: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDouble, isNull);
      },
    );

    test(
      'when batch updating aString to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aString: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aString, isNull);
      },
    );

    test(
      'when batch updating aDateTime to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDateTime: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDateTime, isNull);
      },
    );

    test(
      'when batch updating aByteData to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aByteData: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aByteData, isNull);
      },
    );

    test(
      'when batch updating aDuration to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDuration: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDuration, isNull);
      },
    );

    test(
      'when batch updating aUuid to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aUuid: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aUuid, isNull);
      },
    );

    test(
      'when batch updating aUri to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aUri: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aUri, isNull);
      },
    );

    test(
      'when batch updating aBigInt to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBigInt: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBigInt, isNull);
      },
    );

    test(
      'when batch updating aVector to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aVector: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aVector, isNull);
      },
    );

    test(
      'when batch updating aHalfVector to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aHalfVector: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aHalfVector, isNull);
      },
    );

    test(
      'when batch updating aSparseVector to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aSparseVector: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aSparseVector, isNull);
      },
    );

    test(
      'when batch updating aBit to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBit: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBit, isNull);
      },
    );

    test(
      'when batch updating anEnum to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            anEnum: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.anEnum, isNull);
      },
    );

    test(
      'when batch updating aStringifiedEnum to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aStringifiedEnum: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aStringifiedEnum, isNull);
      },
    );

    test(
      'when batch updating aList to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aList: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aList, isNull);
      },
    );

    test(
      'when batch updating aMap to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aMap: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aMap, isNull);
      },
    );

    test(
      'when batch updating aSet to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aSet: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aSet, isNull);
      },
    );

    test(
      'when batch updating aRecord to null then the database is updated with null value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aRecord: null,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aRecord, isNull);
      },
    );
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
        aUri: null,
        aBigInt: null,
        aVector: null,
        aHalfVector: null,
        aSparseVector: null,
        aBit: null,
        anEnum: null,
        aStringifiedEnum: null,
        aList: null,
        aMap: null,
        aSet: null,
        aRecord: null,
      ),
    ];

    late Types type;

    setUp(() async {
      var inserted = await Types.db.insert(session, data);
      type = inserted.first;
    });

    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test(
      'when batch updating anInt to 1 then the database is updated with value 1.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            anInt: 1,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.anInt, equals(1));
      },
    );

    test(
      'when batch updating aBool to true then the database is updated with value true.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBool: true,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBool, equals(true));
      },
    );

    test(
      'when batch updating aDouble to 1.0 then the database is updated with value 1.0.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDouble: 1.0,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDouble, equals(1.0));
      },
    );

    test(
      'when batch updating aString to "string" then the database is updated with value "string".',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aString: 'string',
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aString, equals('string'));
      },
    );

    test(
      'when batch updating aDateTime to a real value then the database is updated with the real value.',
      () async {
        var now = DateTime.now().toUtc();
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDateTime: now,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDateTime, equals(now));
      },
    );

    test(
      'when batch updating aByteData to a real value then the database is updated with the real value.',
      () async {
        var byteData = ByteData.view(Uint8List(8).buffer);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aByteData: byteData,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        var byteDataResult = updated.first.aByteData;

        expect(
          byteDataResult?.buffer.asUint8List(
            byteDataResult.offsetInBytes,
            byteDataResult.lengthInBytes,
          ),
          equals(byteData.buffer.asUint8List()),
        );
      },
    );

    test(
      'when batch updating aDuration to a real value then the database is updated with the real value.',
      () async {
        var duration = Duration(milliseconds: 1000);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aDuration: duration,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aDuration, equals(duration));
      },
    );

    test(
      'when batch updating aUuid to a real value then the database is updated with the real value.',
      () async {
        var uuidValue = UuidValue.fromString(Uuid().v4());
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aUuid: uuidValue,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aUuid, equals(uuidValue));
      },
    );

    test(
      'when batch updating aUri to a real value then the database is updated with the real value.',
      () async {
        var uri = Uri.parse('https://example.com');
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aUri: uri,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aUri, equals(uri));
      },
    );

    test(
      'when batch updating aBigInt to a real value then the database is updated with the real value.',
      () async {
        var bigInt = BigInt.from(987654321);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBigInt: bigInt,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBigInt, equals(bigInt));
      },
    );

    test(
      'when batch updating aVector to a real value then the database is updated with the real value.',
      () async {
        var vector = Vector([4.0, 5.0, 6.0]);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aVector: vector,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aVector, equals(vector));
      },
    );

    test(
      'when batch updating aHalfVector to a real value then the database is updated with the real value.',
      () async {
        var halfVector = HalfVector([4.0, 5.0, 6.0]);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aHalfVector: halfVector,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aHalfVector, equals(halfVector));
      },
    );

    test(
      'when batch updating aSparseVector to a real value then the database is updated with the real value.',
      () async {
        var sparseVector = SparseVector([0.0, 4.0, 5.0]);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aSparseVector: sparseVector,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aSparseVector, equals(sparseVector));
      },
    );

    test(
      'when batch updating aBit to a real value then the database is updated with the real value.',
      () async {
        var bit = Bit([true, false, true]);
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aBit: bit,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aBit, equals(bit));
      },
    );

    test(
      'when batch updating anEnum to TestEnum.one then the database is updated with value TestEnum.one.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            anEnum: TestEnum.one,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.anEnum, equals(TestEnum.one));
      },
    );

    test(
      'when batch updating aStringifiedEnum to TestEnumStringified.two then the database is updated with value TestEnumStringified.two.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aStringifiedEnum: TestEnumStringified.two,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aStringifiedEnum, equals(TestEnumStringified.two));
      },
    );

    test(
      'when batch updating aList to a real value then the database is updated with the real value.',
      () async {
        var list = [4, 5, 6];
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aList: list,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aList, equals(list));
      },
    );

    test(
      'when batch updating aMap to a real value then the database is updated with the real value.',
      () async {
        var map = {3: 30, 4: 40};
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aMap: map,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aMap, equals(map));
      },
    );

    test(
      'when batch updating aSet to a real value then the database is updated with the real value.',
      () async {
        var set = {4, 5, 6};
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aSet: set,
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(updated.first.aSet, equals(set));
      },
    );

    test(
      'when batch updating aRecord then the database is updated with the given value.',
      () async {
        var toUpdate = <Types>[
          Types(
            id: type.id,
            aRecord: ('test', optionalUri: Uri.parse('https://serverpod.dev')),
          ),
        ];

        var updated = await Types.db.update(session, toUpdate);

        expect(
          updated.first.aRecord,
          equals(
            ('test', optionalUri: Uri.parse('https://serverpod.dev')),
          ),
        );
      },
    );

    test(
      'when listing id column in an update query of a row then update completes successfully.',
      () async {
        expect(
          Types.db.updateRow(session, type, columns: (t) => [t.id]),
          completes,
        );
      },
    );
  });

  group('Given empty model in database', () {
    late EmptyModelWithTable model;
    setUp(() async {
      model = await EmptyModelWithTable.db.insertRow(
        session,
        EmptyModelWithTable(),
      );
    });

    tearDown(() async {
      await EmptyModelWithTable.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    test('when model is updated then update completes', () async {
      expect(
        EmptyModelWithTable.db.updateRow(session, model),
        completes,
      );
    });

    test(
      'when with columns from different model then error is thrown',
      () async {
        var invalidColumns = [SimpleData.t.num, Types.t.anInt];
        expect(
          EmptyModelWithTable.db.updateRow(
            session,
            model,
            columns: (t) => invalidColumns,
          ),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Columns do not exist in table'),
                )
                .having((e) => e.name, 'name', 'columns')
                .having(
                  (e) => e.invalidValue,
                  'invalidValue',
                  invalidColumns.toString(),
                ),
          ),
        );
      },
    );
  });
}
