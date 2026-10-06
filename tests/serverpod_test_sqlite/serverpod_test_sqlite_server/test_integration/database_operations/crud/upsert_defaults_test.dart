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

  group(
    'Given existing values and inputs mixing supplied and omitted defaults, ',
    () {
      late List<IntDefaultPersist> inputs;

      setUp(() async {
        await IntDefaultPersist.db.insert(session, [
          IntDefaultPersist(id: 1, intDefaultPersist: 99),
          IntDefaultPersist(id: 3, intDefaultPersist: 99),
        ]);
        inputs = [
          IntDefaultPersist(id: 1),
          IntDefaultPersist(id: 2, intDefaultPersist: 20),
          IntDefaultPersist(id: 3, intDefaultPersist: 30),
          IntDefaultPersist(id: 4),
        ];
      });

      group('when upserting with all update columns, ', () {
        late List<IntDefaultPersist> returned;

        setUp(() async {
          returned = await IntDefaultPersist.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.id],
          );
        });

        test(
          'then both inserted and updated rows receive their database defaults.',
          () {
            expect(returned.map((row) => (row.id, row.intDefaultPersist)), [
              (1, 10),
              (2, 20),
              (3, 30),
              (4, 10),
            ]);
          },
        );
      });
    },
  );

  group(
    'Given an omitted default selected explicitly for conflict updates, ',
    () {
      late List<IntDefaultPersist> inputs;

      setUp(() async {
        await IntDefaultPersist.db.insertRow(
          session,
          IntDefaultPersist(id: 1, intDefaultPersist: 99),
        );
        inputs = [IntDefaultPersist(id: 1), IntDefaultPersist(id: 2)];
      });

      group('when upserting without returning rows, ', () {
        late List<IntDefaultPersist> returned;
        late List<IntDefaultPersist> stored;

        setUp(() async {
          returned = await IntDefaultPersist.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.id],
            updateColumns: (table) => [table.intDefaultPersist],
            noReturn: true,
          );
          stored = await IntDefaultPersist.db.find(
            session,
            orderBy: (table) => table.id,
          );
        });

        test('then no models are returned.', () {
          expect(returned, isEmpty);
        });

        test(
          'then the existing value is replaced with the database default.',
          () {
            expect(stored.map((row) => (row.id, row.intDefaultPersist)), [
              (1, 10),
              (2, 10),
            ]);
          },
        );
      });
    },
  );

  group(
    'Given inputs omitting every defaulted field and generated integer id, ',
    () {
      late List<IntDefaultPersist> inputs;

      setUp(() {
        inputs = [IntDefaultPersist(), IntDefaultPersist()];
      });

      group('when upserting with returned rows, ', () {
        late List<IntDefaultPersist> returned;

        setUp(() async {
          returned = await IntDefaultPersist.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.id],
          );
        });

        test('then defaults apply independently to each input.', () {
          expect(returned.map((row) => row.intDefaultPersist), [10, 10]);
          expect(returned.map((row) => row.id).toSet(), hasLength(2));
          expect(returned.every((row) => row.id != null), isTrue);
        });
      });
    },
  );

  group(
    'Given a model containing only a UUID id with a random database default, ',
    () {
      late List<ServerOnlyChangedIdFieldClass> inputs;
      late List<UuidValue?> initialIds;

      setUp(() {
        inputs = [
          ServerOnlyChangedIdFieldClass(),
          ServerOnlyChangedIdFieldClass(),
        ];
        initialIds = inputs.map((row) => row.id).toList();
      });

      group('when upserting multiple inputs with returned rows, ', () {
        late List<ServerOnlyChangedIdFieldClass> returned;
        late List<ServerOnlyChangedIdFieldClass> stored;

        setUp(() async {
          returned = await ServerOnlyChangedIdFieldClass.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.id],
          );
          stored = await ServerOnlyChangedIdFieldClass.db.find(session);
        });

        test(
          'then the database generates a separate UUID for every input.',
          () {
            expect(initialIds, [null, null]);
            expect(returned, hasLength(2));
            expect(returned.every((row) => row.id != null), isTrue);
            expect(returned.map((row) => row.id).toSet(), hasLength(2));
          },
        );

        test('then the generated UUIDs are persisted.', () {
          expect(
            stored.map((row) => row.id),
            unorderedEquals(returned.map((r) => r.id)),
          );
        });
      });

      group('when inserting with ignored conflicts, ', () {
        late List<ServerOnlyChangedIdFieldClass> returned;

        setUp(() async {
          returned = await ServerOnlyChangedIdFieldClass.db.insert(
            session,
            inputs,
            ignoreConflicts: true,
          );
        });

        test('then generated UUIDs are preserved in the returned models.', () {
          expect(returned, hasLength(2));
          expect(returned.every((row) => row.id != null), isTrue);
          expect(returned.map((row) => row.id).toSet(), hasLength(2));
        });
      });
    },
  );

  group('Given one input containing only an omitted UUID id, ', () {
    late List<ServerOnlyChangedIdFieldClass> inputs;

    setUp(() {
      inputs = [ServerOnlyChangedIdFieldClass()];
    });

    group('when upserting without returning rows, ', () {
      late List<ServerOnlyChangedIdFieldClass> returned;
      late List<ServerOnlyChangedIdFieldClass> stored;

      setUp(() async {
        returned = await ServerOnlyChangedIdFieldClass.db.upsert(
          session,
          inputs,
          conflictColumns: (table) => [table.id],
          noReturn: true,
        );
        stored = await ServerOnlyChangedIdFieldClass.db.find(session);
      });

      test('then no models are returned.', () {
        expect(returned, isEmpty);
      });

      test('then its database default is persisted.', () {
        expect(stored, hasLength(1));
        expect(stored.single.id, isNotNull);
      });
    });
  });
}
