import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/serverpod_internal.dart';

import '../serverpod_test.dart';

/// Helper singleton to close all open streams
/// Only used internally.
class GlobalStreamManager {
  // ignore: invalid_use_of_internal_member
  static List<MethodStreamManager> _streamManagers = [];

  /// Closes all open streams
  static Future<void> closeAllStreams() async {
    for (var streamManager in _streamManagers) {
      await streamManager.closeAllStreams();
    }
    _streamManagers = [];
  }

  /// Adds a stream manager to the list of tracked stream managers.
  // ignore: invalid_use_of_internal_member
  static void add(MethodStreamManager streamManager) {
    _streamManagers.add(streamManager);
  }
}

/// Manages streams in the generated endpoints.
/// Used by the generated code.
class TestStreamManager<OutputStreamType> {
  /// The stream controller for the output stream.
  StreamController<OutputStreamType> outputStreamController;

  // ignore: invalid_use_of_internal_member
  late final MethodStreamManager _streamManager;
  final UuidValue _methodStreamId = const Uuid().v4obj();

  /// Creates a new [TestStreamManager].
  TestStreamManager()
      : outputStreamController = StreamController<OutputStreamType>() {
    _streamManager = MethodStreamManager(
      onOutputStreamClosed: (
        UuidValue methodStreamId,
        CloseReason? closeReason,
        MethodStreamCallContext context,
      ) {
        if (closeReason == CloseReason.error) {
          outputStreamController.addError(const ConnectionClosedException());
        }

        outputStreamController.close();
      },
      onOutputStreamError: (
        UuidValue methodStreamId,
        Object error,
        StackTrace stackTrace,
        MethodStreamCallContext context,
      ) {
        outputStreamController.addError(error, stackTrace);
      },
      onOutputStreamValue: (
        UuidValue methodStreamId,
        Object? value,
        MethodStreamCallContext context,
      ) {
        outputStreamController.add(value as OutputStreamType);
      },
    );

    GlobalStreamManager.add(_streamManager);

    outputStreamController.onCancel = () async {
      await _streamManager.closeAllStreams();
    };
  }

  /// Inititates a stream method call which opens all needed streams.
  Future<void> callStreamMethod(
    MethodStreamCallContext callContext,
    Session session,
    Map<String, Stream<dynamic>> inputStreams,
  ) async {
    _streamManager.createStream(
      methodStreamCallContext: callContext,
      methodStreamId: _methodStreamId,
      session: session,
    );

    inputStreams.forEach((name, stream) {
      stream.listen(
        (value) {
          _streamManager.dispatchData(
            endpoint: callContext.endpoint.name,
            method: callContext.method.name,
            methodStreamId: _methodStreamId,
            parameter: name,
            value: value,
          );
        },
        onDone: () {
          _streamManager.closeStream(
            endpoint: callContext.endpoint.name,
            method: callContext.method.name,
            methodStreamId: _methodStreamId,
            parameter: name,
            reason: CloseReason.done,
          );
        },
        onError: (error) {
          _streamManager.dispatchError(
            endpoint: callContext.endpoint.name,
            method: callContext.method.name,
            methodStreamId: _methodStreamId,
            parameter: name,
            error: error,
          );
        },
      );
    });
  }
}
