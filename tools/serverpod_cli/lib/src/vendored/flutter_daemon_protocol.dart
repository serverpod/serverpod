/*
 * This file is adapted from `flutter_tools`' own DAP adapter:
 *   <flutter>/packages/flutter_tools/lib/src/debug_adapters/flutter_adapter.dart
 * which is the canonical client for the `flutter run --machine`
 * daemon protocol. Flutter team maintains it; the protocol itself
 * has no public stable API of its own.
 *
 * Vendored against Flutter 3.41.9 (frameworkRevision 00b0c91f06).
 * When re-syncing, diff `flutter_adapter.dart` at the matching tag
 * and update the wire format / request shape if anything changed.
 * The shape is otherwise stable across recent stable releases.
 *
 * The scope of the below license ("Software") is limited to this
 * file only, which is a derivative work of the original. The license
 * does not apply to any other part of the codebase.
 *
 * Modifications: takes a [Process] from our [FlutterProcess] caller
 * rather than owning its own spawn; the response router is exposed
 * for our [FlutterProcess.handleMachineLine] to dispatch into.
 *
 * Copyright 2014 The Flutter Authors. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Google Inc. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Request/response correlator for `flutter run --machine`. Feed
/// stdout envelopes through [tryHandleResponse] to resolve requests.
class FlutterDaemonProtocol {
  FlutterDaemonProtocol(this._process);

  final Process _process;
  int _requestId = 0;
  final Map<int, Completer<Object?>> _requestCompleters = {};

  /// Resolves to the response's `result`, or throws
  /// [FlutterDaemonException] / [StateError].
  Future<Object?> sendRequest(
    String method, [
    Map<String, Object?>? params,
  ]) {
    final completer = Completer<Object?>();
    final id = _requestId++;
    _requestCompleters[id] = completer;
    try {
      _sendMessage({'id': id, 'method': method, 'params': params});
    } catch (e) {
      _requestCompleters.remove(id);
      completer.completeError(
        StateError('Failed to send to Flutter daemon: $e'),
      );
    }
    return completer.future;
  }

  /// Wire format: one JSON array per line. Throws if stdin is closed.
  void _sendMessage(Map<String, Object?> message) {
    _process.stdin.writeln('[${jsonEncode(message)}]');
  }

  /// Resolves the matching completer if [envelope] is a response we
  /// issued; returns `false` otherwise so the caller can event-dispatch.
  bool tryHandleResponse(Map<String, Object?> envelope) {
    final id = envelope['id'];
    if (id is! int) return false;
    // Reject ids we never issued, in case stray output JSON-decoded.
    if (id < 0 || id >= _requestId) return false;
    final completer = _requestCompleters.remove(id);
    if (completer == null) return false;
    final error = envelope['error'];
    if (error != null) {
      completer.completeError(FlutterDaemonException(error));
    } else {
      completer.complete(envelope['result']);
    }
    return true;
  }

  /// Abort in-flight requests. Call from the process-exit listener.
  void abort([String reason = 'Flutter daemon process exited']) {
    for (final completer in _requestCompleters.values) {
      if (!completer.isCompleted) {
        completer.completeError(StateError(reason));
      }
    }
    _requestCompleters.clear();
  }
}

class FlutterDaemonException implements Exception {
  FlutterDaemonException(this.error);
  final Object? error;
  @override
  String toString() => 'FlutterDaemonException: $error';
}
