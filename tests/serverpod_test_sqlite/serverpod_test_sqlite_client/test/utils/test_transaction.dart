import 'dart:async';

import 'package:serverpod_database/serverpod_database.dart';

/// Keeps a caller transaction open across a test's Given and when setup.
class TestTransaction {
  TestTransaction._();

  final _ready = Completer<void>();
  final _release = Completer<void>();
  late final Future<void> _completed;
  late final Transaction transaction;

  static Future<TestTransaction> start(Database database) async {
    final handle = TestTransaction._();
    handle._completed = database.transaction(handle._hold);
    // Also observe startup errors so a failed transaction cannot leave setup
    // waiting forever for the callback to be entered.
    await Future.any([handle._ready.future, handle._completed]);
    return handle;
  }

  Future<void> _hold(Transaction transaction) async {
    this.transaction = transaction;
    _ready.complete();
    await _release.future;
  }

  Future<void> commit() async {
    if (!_release.isCompleted) _release.complete();
    await _completed;
  }
}
