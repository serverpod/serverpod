import 'dart:async';

import 'package:serverpod/server.dart';

import 'function_call_wrappers.dart';

/// Package private extension to set the output stream.
extension SetOutputStreamExtension on TestStreamManager {
  /// Sets the output stream and starts listening to it.
  void setOutputStream(Stream stream) {
    var subscription = stream.listen((data) {
      outputStreamController.add(data);
    }, onError: (e) {
      outputStreamController.addError(getException(e));
    }, onDone: () {
      outputStreamController.close();
    });

    outputStreamController.onCancel = () {
      subscription.cancel();
    };
  }
}

/// Manages streams in the generated endpoints.
/// Should only be used in generated code.
class TestStreamManager<OutputStreamType> {
  final Map<String, StreamController> _inputStreamControllers = {};
  StreamController<OutputStreamType>? _outputStreamController;

  /// Gets the output stream controller and creates it lazily.
  StreamController<OutputStreamType> get outputStreamController {
    _outputStreamController ??= StreamController<OutputStreamType>();

    return _outputStreamController!;
  }

  /// Creates a new [TestStreamManager].
  TestStreamManager();

  /// Wraps all input streams in a [StreamController] to allow the test tools to close them when needed.
  Map<String, Stream> createManagedInputStreams(
    Map<String, Stream> inputStreams,
  ) {
    return inputStreams.map((key, stream) {
      var streamController = StreamController();
      stream.listen(
        streamController.add,
        onDone: streamController.close,
      );
      _inputStreamControllers[key] = streamController;

      return MapEntry(key, streamController.stream);
    });
  }

  /// Gets the input stream with the given [name].
  Stream getInputStream(String name) {
    var maybeStream = _inputStreamControllers[name]?.stream;
    if (maybeStream == null) {
      throw StateError('Stream $name not found');
    }

    return maybeStream;
  }

  /// Closes all input streams and the output stream with the appropriate error.
  void onRevokedAuthentication(AuthenticationFailureReason reason) {
    _inputStreamControllers.forEach((key, controller) {
      controller.close();
    });

    _outputStreamController?.addError(getTestAuthorizationException(reason));
    _outputStreamController?.close();
  }
}
