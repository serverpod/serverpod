import 'dart:typed_data';

import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_value.dart';

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
  });

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
  });

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
  });

  test(
      'Given an model when updatingRow with a specific column only that column and no other data is updated.',
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
  });

  test('Given an model without an id when updatingRow then an error is thrown.',
      () async {
    expect(
      UniqueData.db.updateRow(
        session,
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        columns: (t) => [t.number],
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

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
  });

  group('Given a typed entry in the database', () {
    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

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
        anEnum: TestEnum.one,
      ),
    ];

    late Types type;

    setUp(() async {
      var inserted = await Types.db.insert(session, data);
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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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
      var inserted = await Types.db.insert(session, data);
      type = inserted.first;
    });

    tearDown(() async {
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('when updating anInt to 1 then the database is updated with value 1.',
        () async {
      var toUpdate = <Types>[
        Types(
          id: type.id,
          anInt: 1,
        ),
      ];

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

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

      var updated = await Types.db.update(session, toUpdate);

      expect(updated.first.aDuration, equals(duration));
    });

    test(
        'when updating aUuid to a real value then the database is updated with the real value.',
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

      var updated = await Types.db.update(session, toUpdate);

      expect(updated.first.anEnum, equals(TestEnum.one));
    });
  });
}
