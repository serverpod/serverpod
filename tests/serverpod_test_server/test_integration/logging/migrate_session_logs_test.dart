import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

/// Use a server id for all entries in the test to ensure they are isolated
/// from other logging.
const serverId = 'migrate_tests';

void main() {
  withServerpod('Given session log entries with only authenticatedUserId set', (
    sessionBuilder,
    _,
  ) {
    late Session session;
    late List<SessionLogEntry> entries;
    setUp(() async {
      entries = <SessionLogEntry>[];
      var time = DateTime.now();
      for (var i = 1; i <= 5; i++) {
        entries.add(
          SessionLogEntry(
            authenticatedUserId: i,
            userId: null,
            serverId: serverId,
            time: time,
            touched: time,
          ),
        );
      }

      session = sessionBuilder.build();
      await SessionLogEntry.db.insert(
        session,
        entries,
      );
    });
    group('when migrating user id field ', () {
      late int migratedCount;
      setUp(() async {
        migratedCount = await SessionLogUtils.migrateSessionLogUserIds(
          session: session,
        );
      });

      test('then migratedCount matches session log entries', () {
        expect(migratedCount, entries.length);
      });

      test('then authenticatedUserId is moved to userId', () async {
        var rows = await SessionLogEntry.db.find(
          session,
          orderBy: (t) => t.id,
          where: (t) => t.serverId.equals(serverId),
        );

        expect(rows.length, entries.length);
        var expectedUserIds = entries
            .map((e) => e.authenticatedUserId.toString())
            .toList();
        var actualUserIds = rows.map((e) => e.userId).toList();

        expect(actualUserIds, orderedEquals(expectedUserIds));
      });

      test('then authenticatedUserId is nulled', () async {
        var rows = await SessionLogEntry.db.find(
          session,
          orderBy: (t) => t.id,
          where: (t) => t.serverId.equals(serverId),
        );

        for (var entry in rows) {
          expect(entry.authenticatedUserId, isNull);
        }
      });
    });

    test(
      'when migrated in a transaction that is rolled back then no entries are migrated',
      () async {
        await session.db.transaction((transaction) async {
          var savepoint = await transaction.createSavepoint();
          await SessionLogUtils.migrateSessionLogUserIds(
            session: session,
            transaction: transaction,
          );

          await savepoint.rollback();
        });

        var migratedRows = await SessionLogEntry.db.find(
          session,
          where: (t) => t.userId.notEquals(null) & t.serverId.equals(serverId),
        );

        expect(
          migratedRows,
          hasLength(0),
          reason: 'Should not have any migrated rows',
        );
      },
    );
  });

  withServerpod(
    'Given session log entries with both userId and authenticatedUserId',
    (sessionBuilder, _) {
      late Session session;
      late SessionLogEntry entry;

      setUp(() async {
        session = sessionBuilder.build();
        entry = await SessionLogEntry.db.insertRow(
          session,
          SessionLogEntry(
            authenticatedUserId: 43,
            userId: 'already',
            serverId: serverId,
            time: DateTime.now(),
            touched: DateTime.now(),
          ),
        );
      });

      test(
        'when migrating user id field then entry with non-null user id is not migrated',
        () async {
          await SessionLogUtils.migrateSessionLogUserIds(session: session);
          var actualEntry = await SessionLogEntry.db.findById(
            session,
            entry.id!,
          );

          expect(actualEntry?.userId, entry.userId);
        },
      );
    },
  );

  withServerpod('Given more entries than maxMigratedEntries', (
    sessionBuilder,
    _,
  ) {
    late Session session;
    const maxMigratedEntries = 3;

    setUp(() async {
      session = sessionBuilder.build();
      final entries = List.generate(
        maxMigratedEntries + 4,
        (i) => SessionLogEntry(
          authenticatedUserId: i + 100,
          userId: null,
          serverId: serverId,
          time: DateTime.now(),
          touched: DateTime.now(),
        ),
      );
      await SessionLogEntry.db.insert(session, entries);
    });

    test(
      'when migrating user id then only maxMigratedEntries number of entries are migrated',
      () async {
        final migrated = await SessionLogUtils.migrateSessionLogUserIds(
          session: session,
          maxMigratedEntries: maxMigratedEntries,
        );

        final actuallyMigratedEntries = await SessionLogEntry.db.count(
          session,
          where: (t) => t.userId.notEquals(null) & t.serverId.equals(serverId),
        );
        expect(migrated, maxMigratedEntries);
        expect(actuallyMigratedEntries, maxMigratedEntries);
      },
    );
  });

  withServerpod('Given more entries than batchSize', (sessionBuilder, _) {
    late Session session;
    const batchSize = 3;
    late List<SessionLogEntry> entries;

    setUp(() async {
      session = sessionBuilder.build();
      entries = List.generate(
        batchSize + 4,
        (i) => SessionLogEntry(
          authenticatedUserId: i + 100,
          userId: null,
          serverId: serverId,
          time: DateTime.now(),
          touched: DateTime.now(),
        ),
      );
      await SessionLogEntry.db.insert(session, entries);
    });

    test('when migrating user id then all entries are migrated', () async {
      final migrated = await SessionLogUtils.migrateSessionLogUserIds(
        session: session,
        batchSize: batchSize,
      );

      final migratedEntries = await SessionLogEntry.db.find(
        session,
        where: (t) => t.userId.equals(null) & t.serverId.equals(serverId),
      );
      expect(migrated, entries.length, reason: 'Migration count mismatch');
      expect(
        migratedEntries,
        hasLength(0),
        reason: 'Should not have any non-migrated entries',
      );
    });
  });
}
