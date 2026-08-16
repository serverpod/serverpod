// https://github.com/tekartik/synchronized.dart Licenced under MIT License.

// Copyright (c) 2016, Alexandre Roux Tekartik.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

import 'dart:async';

/// This simulates the synchronized feature of Java in an async way
///
/// Create a shared [Lock] object and use it using the [Lock.synchronized]
/// method to prevent concurrent access to a shared resource.
///
/// ```dart
/// class MyClass {
///  final _lock = new Lock();
//
///  Future<void> myMethod() async {
///    await _lock.synchronized(() async {
///      step1();
///      step2();
///      step3();
///    });
///  }
/// ```
//}

/// Object providing the implicit lock.
///
/// A [Lock] can be reentrant (in this case it will use a [Zone]).
///
/// if [timeout] is not null, it will timeout after the specified duration.
abstract class Lock {
  /// Creates a [Lock] object.
  ///
  /// if [reentrant], it uses [Zone] to allow inner [synchronized] calls.
  factory Lock() {
    return BasicLock();
  }

  /// Executes [computation] when lock is available.
  ///
  /// Only one asynchronous block can run while the lock is retained.
  ///
  /// If [timeout] is specified, it will try to grab the lock and will not
  /// call the computation callback and throw a [TimeoutExpection] if the lock
  /// cannot be grabbed in the given duration.
  Future<T> synchronized<T>(
    FutureOr<T> Function() computation, {
    Duration? timeout,
  });

  /// returns true if the lock is currently locked.
  bool get locked;

  /// for reentrant, test whether we are currently in the synchronized section.
  /// for non reentrant, it returns the [locked] status.
  bool get inLock;
}

/// Basic (non-reentrant) lock
class BasicLock implements Lock {
  /// The last running block
  Future<dynamic>? last;

  @override
  bool get locked => last != null;

  @override
  Future<T> synchronized<T>(
    FutureOr<T> Function() func, {
    Duration? timeout,
  }) async {
    var prev = last;
    var completer = Completer<void>.sync();
    last = completer.future;
    try {
      // If there is a previous running block, wait for it
      if (prev != null) {
        if (timeout != null) {
          // This could throw a timeout error
          await prev.timeout(timeout);
        } else {
          await prev;
        }
      }

      // Run the function and return the result
      var result = func();
      if (result is Future) {
        return await result;
      } else {
        return result;
      }
    } finally {
      // Cleanup
      // waiting for the previous task to be done in case of timeout
      void complete() {
        // Only mark it unlocked when the last one complete
        if (identical(last, completer.future)) {
          last = null;
        }
        completer.complete();
      }

      // In case of timeout, wait for the previous one to complete too
      // before marking this task as complete

      if (prev != null && timeout != null) {
        // But we still returns immediately
        // ignore: unawaited_futures
        prev.then((_) {
          complete();
        });
      } else {
        complete();
      }
    }
  }

  @override
  String toString() {
    return 'Lock[${identityHashCode(this)}]';
  }

  @override
  bool get inLock => locked;
}
