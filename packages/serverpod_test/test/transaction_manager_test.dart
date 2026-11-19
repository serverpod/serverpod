import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/src/test_serverpod.dart';
import 'package:serverpod_test/src/transaction_manager.dart';
import 'package:test/test.dart';

void main() {
  late List<String> calls;
  late TransactionManager transactionManager;

  setUp(() {
    calls = [];
    transactionManager = TransactionManager(_UnusedSession())
      ..currentTransaction = _RecordingTransaction(calls);
  });

  test(
    'Given a savepoint in the current transaction '
    'when rolling back to the previous savepoint '
    'then the savepoint is rolled back and then released.',
    () async {
      await transactionManager.addSavepoint();

      await transactionManager.rollbackToPreviousSavepoint();

      expect(calls, ['create', 'rollback', 'release']);
    },
  );

  test(
    'Given a locked transaction stack with a savepoint '
    'when ensuring the transaction is unlocked '
    'then the savepoint is rolled back and then released.',
    () async {
      await transactionManager.addSavepoint(lock: true);

      await transactionManager.ensureTransactionIsUnlocked();

      expect(calls, ['create', 'rollback', 'release']);
    },
  );

  test(
    'Given a savepoint in the current transaction '
    'when releasing the previous savepoint '
    'then the savepoint is only released.',
    () async {
      await transactionManager.addSavepoint();

      await transactionManager.releasePreviousSavepoint();

      expect(calls, ['create', 'release']);
    },
  );
}

class _RecordingTransaction implements Transaction {
  _RecordingTransaction(this.calls);

  final List<String> calls;

  @override
  Future<Savepoint> createSavepoint() async {
    calls.add('create');
    return _RecordingSavepoint(calls);
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
  _RecordingSavepoint(this.calls);

  final List<String> calls;

  @override
  String get id => 'savepoint_test';

  @override
  Future<void> rollback() async => calls.add('rollback');

  @override
  Future<void> release() async => calls.add('release');
}

/// Savepoint handling never touches the session.
class _UnusedSession implements InternalServerpodSession {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Session should not be used.');
}
