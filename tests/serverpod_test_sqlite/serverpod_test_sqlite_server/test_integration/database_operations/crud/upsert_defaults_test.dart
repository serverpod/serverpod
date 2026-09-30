import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  final session = await IntegrationTestServer().session();

  tearDown(() async {
    await IntDefaultPersist.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ServerOnlyChangedIdFieldClass.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  test(
    'Given existing values and inputs mixing supplied and omitted defaults, '
    'when upserting with all update columns, '
    'then both inserted and updated rows receive their database defaults.',
    () async {
      await IntDefaultPersist.db.insert(session, [
        IntDefaultPersist(id: 1, intDefaultPersist: 99),
        IntDefaultPersist(id: 3, intDefaultPersist: 99),
      ]);

      final returned = await IntDefaultPersist.db.upsert(
        session,
        [
          IntDefaultPersist(id: 1),
          IntDefaultPersist(id: 2, intDefaultPersist: 20),
          IntDefaultPersist(id: 3, intDefaultPersist: 30),
          IntDefaultPersist(id: 4),
        ],
        conflictColumns: (table) => [table.id],
      );

      expect(returned.map((row) => (row.id, row.intDefaultPersist)), [
        (1, 10),
        (2, 20),
        (3, 30),
        (4, 10),
      ]);
    },
  );

  test(
    'Given an omitted default selected explicitly for conflict updates, '
    'when upserting without returning rows, '
    'then the existing value is replaced with the database default.',
    () async {
      await IntDefaultPersist.db.insertRow(
        session,
        IntDefaultPersist(id: 1, intDefaultPersist: 99),
      );

      final returned = await IntDefaultPersist.db.upsert(
        session,
        [IntDefaultPersist(id: 1), IntDefaultPersist(id: 2)],
        conflictColumns: (table) => [table.id],
        updateColumns: (table) => [table.intDefaultPersist],
        noReturn: true,
      );
      final stored = await IntDefaultPersist.db.find(
        session,
        orderBy: (table) => table.id,
      );

      expect(returned, isEmpty);
      expect(stored.map((row) => (row.id, row.intDefaultPersist)), [
        (1, 10),
        (2, 10),
      ]);
    },
  );

  test(
    'Given inputs omitting every defaulted field and generated integer id, '
    'when upserting with returned rows, '
    'then defaults apply independently to each input.',
    () async {
      final inputs = [IntDefaultPersist(), IntDefaultPersist()];

      final returned = await IntDefaultPersist.db.upsert(
        session,
        inputs,
        conflictColumns: (table) => [table.id],
      );

      expect(returned.map((row) => row.intDefaultPersist), [10, 10]);
      expect(returned.map((row) => row.id).toSet(), hasLength(2));
      expect(returned.every((row) => row.id != null), isTrue);
    },
  );

  test(
    'Given a model containing only a UUID id with a random database default, '
    'when upserting multiple inputs with returned rows, '
    'then the database generates a separate UUID for every input.',
    () async {
      final inputs = [
        ServerOnlyChangedIdFieldClass(),
        ServerOnlyChangedIdFieldClass(),
      ];
      expect(inputs.map((row) => row.id), [null, null]);

      final returned = await ServerOnlyChangedIdFieldClass.db.upsert(
        session,
        inputs,
        conflictColumns: (table) => [table.id],
      );
      final stored = await ServerOnlyChangedIdFieldClass.db.find(session);

      expect(returned, hasLength(2));
      expect(returned.every((row) => row.id != null), isTrue);
      expect(returned.map((row) => row.id).toSet(), hasLength(2));
      expect(
        stored.map((row) => row.id),
        unorderedEquals(returned.map((r) => r.id)),
      );
    },
  );

  test(
    'Given a model containing only a UUID id with a random database default, '
    'when inserting with ignored conflicts, '
    'then generated UUIDs are preserved in the returned models.',
    () async {
      final returned = await ServerOnlyChangedIdFieldClass.db.insert(
        session,
        [ServerOnlyChangedIdFieldClass(), ServerOnlyChangedIdFieldClass()],
        ignoreConflicts: true,
      );

      expect(returned, hasLength(2));
      expect(returned.every((row) => row.id != null), isTrue);
      expect(returned.map((row) => row.id).toSet(), hasLength(2));
    },
  );

  test(
    'Given one input containing only an omitted UUID id, '
    'when upserting without returning rows, '
    'then its database default is persisted.',
    () async {
      final returned = await ServerOnlyChangedIdFieldClass.db.upsert(
        session,
        [ServerOnlyChangedIdFieldClass()],
        conflictColumns: (table) => [table.id],
        noReturn: true,
      );
      final stored = await ServerOnlyChangedIdFieldClass.db.find(session);

      expect(returned, isEmpty);
      expect(stored, hasLength(1));
      expect(stored.single.id, isNotNull);
    },
  );
}
