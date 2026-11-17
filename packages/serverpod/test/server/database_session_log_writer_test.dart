import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as protocol;
import 'package:serverpod/src/server/log_manager/log_writers/database_session_log_writer.dart';
import 'package:serverpod/src/server/log_manager/session_log.dart';
import 'package:test/test.dart';

void main() {
  group('Given a database session log writer with pending inserts,', () {
    for (final fails in [false, true]) {
      test(
        'when an insert ${fails ? 'fails' : 'succeeds'} during disposal, '
        'then disposal waits for all inserts and completes without error.',
        () async {
          final database = _PendingInsertDatabase();
          final writer = DatabaseSessionLogWriter()
            ..attach(_FakeSession(database));
          final firstOpen = writer.open(_openEvent('first'));
          final secondOpen = writer.open(_openEvent('second'));
          expect(database.inserts, hasLength(2));

          var disposed = false;
          final disposal = writer.dispose().then((_) => disposed = true);
          final disposalExpectation = expectLater(disposal, completes);

          if (fails) {
            database.inserts.first.completeError(
              StateError('Database connection closed'),
            );
          } else {
            database.inserts.first.complete();
          }
          await firstOpen;
          await Future<void>.delayed(Duration.zero);
          expect(disposed, isFalse);

          database.inserts.last.complete();
          await secondOpen;
          await disposalExpectation;
          expect(disposed, isTrue);

          await writer.open(_openEvent('after-disposal'));
          expect(database.inserts, hasLength(2));
          await writer.dispose();
        },
      );
    }
  });
}

SessionOpen _openEvent(String sessionId) => SessionOpen(
  sessionId: sessionId,
  kind: SessionKind.internal,
  label: 'test',
  startTime: DateTime.utc(2026),
  serverId: 'test-server',
);

class _FakeSession implements Session {
  @override
  final Database db;

  _FakeSession(this.db);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _PendingInsertDatabase implements Database {
  final inserts = <Completer<void>>[];

  @override
  Future<T> insertRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) async {
    final completer = Completer<void>();
    inserts.add(completer);
    (row as protocol.SessionLogEntry).id = inserts.length;
    await completer.future;
    return row;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
