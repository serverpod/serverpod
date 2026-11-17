import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  group('Given an active transaction', () {
    late List<String> calls;
    late _RecordingTransaction transaction;

    setUp(() {
      calls = [];
      transaction = _RecordingTransaction(calls);
    });

    test(
      'when the callback succeeds '
      'then the savepoint is released and not rolled back.',
      () async {
        var result = await DatabaseUtil.runInTransactionOrSavepoint(
          _UnusedDatabase(),
          transaction,
          (_) async => 42,
        );

        expect(result, 42);
        expect(calls, ['create', 'release']);
      },
    );

    test(
      'when the callback throws '
      'then the savepoint is rolled back and then released.',
      () async {
        await expectLater(
          DatabaseUtil.runInTransactionOrSavepoint(
            _UnusedDatabase(),
            transaction,
            (_) async => throw StateError('row failed'),
          ),
          throwsA(isA<StateError>()),
        );

        expect(calls, ['create', 'rollback', 'release']);
      },
    );

    test(
      'when the callback throws and releasing the savepoint fails '
      'then a RollbackToSavepointFailedException is thrown.',
      () async {
        transaction.failRelease = true;

        await expectLater(
          DatabaseUtil.runInTransactionOrSavepoint(
            _UnusedDatabase(),
            transaction,
            (_) async => throw StateError('row failed'),
          ),
          throwsA(isA<RollbackToSavepointFailedException>()),
        );

        expect(calls, ['create', 'rollback', 'release']);
      },
    );

    test(
      'when the callback throws and rolling back fails '
      'then the savepoint is not released and a '
      'RollbackToSavepointFailedException is thrown.',
      () async {
        transaction.failRollback = true;

        await expectLater(
          DatabaseUtil.runInTransactionOrSavepoint(
            _UnusedDatabase(),
            transaction,
            (_) async => throw StateError('row failed'),
          ),
          throwsA(isA<RollbackToSavepointFailedException>()),
        );

        expect(calls, ['create', 'rollback']);
      },
    );
  });
}

class _RecordingTransaction implements Transaction {
  _RecordingTransaction(this.calls);

  final List<String> calls;
  bool failRollback = false;
  bool failRelease = false;

  @override
  Future<Savepoint> createSavepoint() async {
    calls.add('create');
    return _RecordingSavepoint(this);
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<void> setRuntimeParameters(RuntimeParametersListBuilder builder) =>
      throw UnimplementedError();

  @override
  Map<String, dynamic> get runtimeParameters => const {};
}

class _RecordingSavepoint implements Savepoint {
  _RecordingSavepoint(this._transaction);

  final _RecordingTransaction _transaction;

  @override
  String get id => 'savepoint_test';

  @override
  Future<void> rollback() async {
    _transaction.calls.add('rollback');
    if (_transaction.failRollback) throw StateError('rollback failed');
  }

  @override
  Future<void> release() async {
    _transaction.calls.add('release');
    if (_transaction.failRelease) throw StateError('release failed');
  }
}

/// Only used when no transaction is passed, which these tests never do.
class _UnusedDatabase implements Database {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Database should not be used.');
}
