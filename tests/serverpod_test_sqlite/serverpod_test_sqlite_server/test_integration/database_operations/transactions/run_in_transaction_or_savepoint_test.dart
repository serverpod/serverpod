import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await SimpleData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
    'Given an outer transaction '
    'when the callback of `runInTransactionOrSavepoint` throws '
    'then the savepoint it created is no longer established.',
    () async {
      await session.db.transaction<void>((transaction) async {
        var spy = _SavepointCapturingTransaction(transaction);

        await expectLater(
          DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            spy,
            (_) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction,
              );
              throw _ForcedTestException();
            },
          ),
          throwsA(isA<_ForcedTestException>()),
        );

        // The failed write was undone.
        expect(await SimpleData.db.count(session, transaction: transaction), 0);

        // Releasing it again only succeeds while the savepoint is still
        // established in the database. Guard with an outer savepoint so the
        // expected error does not abort the whole transaction.
        var guard = await transaction.createSavepoint();
        await expectLater(
          spy.captured.single.release(),
          // SQLite: "no such savepoint".
          throwsA(isA<DatabaseQueryException>()),
        );
        await guard.rollback();
        await guard.release();

        // The transaction is still usable afterwards.
        await SimpleData.db.insertRow(
          session,
          SimpleData(num: 2),
          transaction: transaction,
        );
      });

      var rows = await SimpleData.db.find(session);
      expect(rows.map((r) => r.num), [2]);
    },
  );
}

/// Delegates to a real transaction and records the savepoints it creates.
class _SavepointCapturingTransaction implements Transaction {
  _SavepointCapturingTransaction(this._inner);

  final Transaction _inner;
  final List<Savepoint> captured = [];

  @override
  Future<Savepoint> createSavepoint() async {
    var savepoint = await _inner.createSavepoint();
    captured.add(savepoint);
    return savepoint;
  }

  @override
  Future<void> cancel() => _inner.cancel();

  @override
  Future<void> setRuntimeParameters(RuntimeParametersListBuilder builder) =>
      _inner.setRuntimeParameters(builder);

  @override
  Map<String, dynamic> get runtimeParameters => _inner.runtimeParameters;
}

class _ForcedTestException implements Exception {}
