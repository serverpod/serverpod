import 'dart:async';

/// A mutex implementation that allows for synchronized execution of code.
///
/// This class provides a synchronized block that ensures that only one
/// operation can execute at a time. It uses a list of waiting operations
/// to manage the order of execution.
class Mutex {
  bool _locked = false;

  /// The list of waiting operations.
  final List<Completer<void>> _waiting = [];

  /// Runs the given function inside a synchronized block.
  Future<T> synchronized<T>(Future<T> Function() callback) async {
    await _acquire();

    try {
      return await callback();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() async {
    if (!_locked) {
      _locked = true;
      return;
    }
    // If already locked, wait until the lock is available.
    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
  }

  void _release() {
    if (_waiting.isEmpty) {
      _locked = false;
      return;
    }
    // Let the next waiting operation acquire the lock.
    final next = _waiting.removeAt(0);
    next.complete();
  }
}
