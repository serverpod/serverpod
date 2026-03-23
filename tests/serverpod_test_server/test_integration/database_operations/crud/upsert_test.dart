import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  });

  group('Given an empty database', () {
    test(
      'when upserting rows then all rows are inserted and returned.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 1, email: 'a@serverpod.dev'),
          UniqueData(number: 2, email: 'b@serverpod.dev'),
        ];

        var result = await UniqueData.db.upsert(
          session,
          data,
          uniqueColumns: (t) => [t.email],
        );

        expect(result, hasLength(2));
        expect(result[0].id, isNotNull);
        expect(result[1].id, isNotNull);
        expect(result[0].email, 'a@serverpod.dev');
        expect(result[1].email, 'b@serverpod.dev');

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when upserting a single row with upsertRow then the row is inserted.',
      () async {
        var result = await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 1, email: 'single@serverpod.dev'),
          uniqueColumns: (t) => [t.email],
        );

        expect(result.id, isNotNull);
        expect(result.email, 'single@serverpod.dev');
        expect(result.number, 1);

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(1));
      },
    );
  });

  group('Given a row with a unique constraint already exists', () {
    late UniqueData existingRow;

    setUp(() async {
      existingRow = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: 'existing@serverpod.dev'),
      );
    });

    test(
      'when upserting a row with the same unique value then the existing row is updated.',
      () async {
        var result = await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 42, email: 'existing@serverpod.dev'),
          uniqueColumns: (t) => [t.email],
        );

        expect(result.id, existingRow.id);
        expect(result.email, 'existing@serverpod.dev');
        expect(result.number, 42);

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(1));
        expect(allRows.first.number, 42);
      },
    );

    test(
      'when upserting a row with a new unique value then a new row is inserted.',
      () async {
        var result = await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 2, email: 'new@serverpod.dev'),
          uniqueColumns: (t) => [t.email],
        );

        expect(result.id, isNotNull);
        expect(result.id, isNot(existingRow.id));
        expect(result.email, 'new@serverpod.dev');

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when batch upserting a mix of new and conflicting rows then both inserts and updates happen.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 99, email: 'existing@serverpod.dev'),
          UniqueData(number: 3, email: 'new@serverpod.dev'),
        ];

        var result = await UniqueData.db.upsert(
          session,
          data,
          uniqueColumns: (t) => [t.email],
        );

        expect(result, hasLength(2));

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));

        var updatedExisting = allRows.firstWhere(
          (r) => r.email == 'existing@serverpod.dev',
        );
        expect(updatedExisting.number, 99);
        expect(updatedExisting.id, existingRow.id);

        var newRow = allRows.firstWhere(
          (r) => r.email == 'new@serverpod.dev',
        );
        expect(newRow.number, 3);
      },
    );

    test(
      'when upserting within a transaction then the upsert is atomic.',
      () async {
        await session.db.transaction((transaction) async {
          var result = await UniqueData.db.upsertRow(
            session,
            UniqueData(number: 77, email: 'existing@serverpod.dev'),
            uniqueColumns: (t) => [t.email],
            transaction: transaction,
          );

          expect(result.id, existingRow.id);
          expect(result.number, 77);
        });

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(1));
        expect(allRows.first.number, 77);
      },
    );
  });
}
