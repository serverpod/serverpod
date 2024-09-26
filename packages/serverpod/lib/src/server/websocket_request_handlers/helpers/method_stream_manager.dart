import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class _RevokedAuthenticationHandler {
  MessageCentralListenerCallback? _revokedAuthenticationCallback;

  _RevokedAuthenticationHandler();

  /// Call when the stream call is cancelled to do proper cleanup.
  Future<void> destroy(Session session) async {
    var localRevokedAuthenticationCallback = _revokedAuthenticationCallback;
    var authenticationInfo = await session.authenticated;

    if (localRevokedAuthenticationCallback != null &&
        authenticationInfo != null) {
      session.messages.removeListener(
        MessageCentralServerpodChannels.revokedAuthentication(
          authenticationInfo.userId,
        ),
        localRevokedAuthenticationCallback,
      );
    }

    _revokedAuthenticationCallback = null;
  }

  Future<void> createOnRevokedAuthenticationListener(
    Endpoint endpoint,
    Session session,
    void Function() onRevokedAuthenticationCallback,
  ) async {
    var authenticationIsRequired =
        endpoint.requireLogin || endpoint.requiredScopes.isNotEmpty;

    if (authenticationIsRequired) {
      var authenticationInfo = await session.authenticated;
      if (authenticationInfo == null) {
        throw StateError(
          'Authentication was required but no authentication info could be retrieved.',
        );
      }

      void localRevokedAuthenticationCallback(event) async {
        var authenticationRevokedReason = switch (event) {
          RevokedAuthenticationUser _ =>
            AuthenticationFailureReason.unauthenticated,
          RevokedAuthenticationAuthId revokedAuthId =>
            revokedAuthId.authId == authenticationInfo.authId
                ? AuthenticationFailureReason.unauthenticated
                : null,
          RevokedAuthenticationScope revokedScopes => revokedScopes.scopes.any(
              (s) => endpoint.requiredScopes.map((s) => s.name).contains(s),
            )
                ? AuthenticationFailureReason.insufficientAccess
                : null,
          _ => null,
        };

        if (authenticationRevokedReason != null) {
          onRevokedAuthenticationCallback();
        }
      }

      session.messages.addListener(
        MessageCentralServerpodChannels.revokedAuthentication(
          authenticationInfo.userId,
        ),
        localRevokedAuthenticationCallback,
      );

      _revokedAuthenticationCallback = localRevokedAuthenticationCallback;
    }
  }
}

class _InputStreamContext implements _StreamContext {
  @override
  final StreamController controller;

  _InputStreamContext(this.controller);
}

class _OutputStreamContext implements _StreamContext {
  @override
  final StreamController controller;

  final StreamSubscription subscription;

  CloseReason? closeReason;

  _OutputStreamContext(this.controller, this.subscription);
}

abstract interface class _StreamContext {
  StreamController get controller;
}

/// Manages the streams for an endpoint method call.
/// Should only be used by Serverpod packages.
@internal
class MethodStreamManager {
  static const Duration _closeTimeout = Duration(seconds: 6);
  final Map<String, _InputStreamContext> _inputStreamContexts = {};
  final Map<String, _OutputStreamContext> _outputStreamContexts = {};

  MethodStreamManager({
    this.onInputStreamClosed,
    this.onOutputStreamClosed,
    this.onOutputStreamError,
    this.onOutputStreamValue,
    this.onAllStreamsClosed,
  });

  void Function(
    UuidValue methodStreamId,
    Object? value,
    MethodStreamCallContext methodStreamCallContext,
  )? onOutputStreamValue;
  void Function(
    UuidValue methodStreamId,
    Object error,
    StackTrace stackTrace,
    MethodStreamCallContext methodStreamCallContext,
  )? onOutputStreamError;
  void Function(
    UuidValue methodStreamId,
    CloseReason? closeReason,
    MethodStreamCallContext callContext,
  )? onOutputStreamClosed;
  void Function(
    UuidValue methodStreamId,
    String parameterName,
    CloseReason? closeReason,
    MethodStreamCallContext callContext,
  )? onInputStreamClosed;

  void Function()? onAllStreamsClosed;

  Future<void> closeAllStreams() async {
    var inputControllers =
        _inputStreamContexts.values.map((c) => c.controller).toList();
    _inputStreamContexts.clear();

    var outboundStreamContexts = _outputStreamContexts.values.toList();
    _outputStreamContexts.clear();

    var closeSubscriptionFutures = outboundStreamContexts.map(
      (c) => c.subscription.cancel().timeout(
            _closeTimeout,
            onTimeout: () => c.controller.onCancel?.call(),
          ),
    );

    await Future.wait([
      ...closeSubscriptionFutures,
      _closeControllers(inputControllers),
    ]);
  }

  Future<void> closeStream({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue methodStreamId,
    required CloseReason reason,
  }) async {
    var streamKey = _buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      methodStreamId: methodStreamId,
    );
    if (parameter == null) {
      var context = _outputStreamContexts[streamKey];

      if (context == null) {
        return;
      }

      // Immediate close of the stream
      _updateCloseReason(streamKey, reason);
      await context.controller.onCancel?.call();
      unawaited(context.subscription.cancel());
    } else {
      var context = _inputStreamContexts.remove(streamKey);

      if (context == null) {
        return;
      }

      if (reason == CloseReason.error) {
        context.controller.addError(
          const StreamClosedWithErrorException(),
        );
      }

      return _closeControllers([context.controller]);
    }
  }

  void createStream({
    required MethodStreamCallContext methodStreamCallContext,
    required UuidValue methodStreamId,
    required Session session,
  }) {
    var outputStreamContext = _createOutputController(
      methodStreamCallContext,
      session,
      methodStreamId,
    );

    var inputStreams =
        _createInputStreams(methodStreamCallContext, methodStreamId);
    var streamParams = inputStreams.map(
      (key, value) => MapEntry(key, value.stream),
    );

    switch (methodStreamCallContext.method.returnType) {
      case MethodStreamReturnType.streamType:
        _handleMethodWithStreamReturn(
          methodStreamCallContext: methodStreamCallContext,
          session: session,
          streamParams: streamParams,
          outputController: outputStreamContext.controller,
          subscription: outputStreamContext.subscription,
          methodStreamId: methodStreamId,
        );
        break;
      case MethodStreamReturnType.futureType:
      case MethodStreamReturnType.voidType:
        _handleMethodWithFutureReturn(
          methodStreamCallContext: methodStreamCallContext,
          session: session,
          streamParams: streamParams,
          outputController: outputStreamContext.controller,
          methodStreamId: methodStreamId,
        );
        break;
    }
  }

  _OutputStreamContext _createOutputController(
    MethodStreamCallContext methodStreamCallContext,
    Session session,
    UuidValue methodStreamId,
  ) {
    bool isCancelled = false;
    var revokedAuthenticationHandler = _RevokedAuthenticationHandler();
    var outputController = StreamController(onCancel: () async {
      /// Guard against multiple calls to onCancel
      /// This is required because we invoke the onCancel
      /// method manually if the stream is closed by a timeout
      /// or a request from the client.
      if (isCancelled) return;
      isCancelled = true;
      await revokedAuthenticationHandler.destroy(session);
      await _closeOutboundStream(methodStreamCallContext, methodStreamId);
      await session.close();
    });

    revokedAuthenticationHandler.createOnRevokedAuthenticationListener(
      methodStreamCallContext.endpoint,
      session,
      () => closeStream(
        endpoint: methodStreamCallContext.endpoint.name,
        method: methodStreamCallContext.method.name,
        methodStreamId: methodStreamId,
        reason: CloseReason.error,
      ),
    );

    late StreamSubscription subscription;
    subscription = outputController.stream.listen(
      (value) {
        onOutputStreamValue?.call(
            methodStreamId, value, methodStreamCallContext);
      },
      onError: (e, s) async {
        onOutputStreamError?.call(
            methodStreamId, e, s, methodStreamCallContext);

        var streamKey = _buildStreamKey(
          endpoint: methodStreamCallContext.endpoint.name,
          method: methodStreamCallContext.method.name,
          methodStreamId: methodStreamId,
        );
        _updateCloseReason(streamKey, CloseReason.error);

        /// Required to close stream when error occurs.
        /// This will also close the input streams.
        /// We can't use the "cancelOnError" option
        /// for the listen method because this cancels
        /// the stream before the onError callback has
        /// been called.
        await subscription.cancel();
      },
    );

    var outputStreamContext =
        _OutputStreamContext(outputController, subscription);
    _outputStreamContexts[_buildStreamKey(
      endpoint: methodStreamCallContext.endpoint.name,
      method: methodStreamCallContext.method.name,
      methodStreamId: methodStreamId,
    )] = outputStreamContext;

    return outputStreamContext;
  }

  void _updateCloseReason(
    String streamKey,
    CloseReason reason,
  ) {
    if (_outputStreamContexts.containsKey(streamKey)) {
      _outputStreamContexts.update(
        streamKey,
        (value) => value..closeReason = reason,
      );
    }
  }

  /// Dispatches a message to the correct stream controller.
  bool dispatchData({
    required String endpoint,
    required String method,
    required UuidValue methodStreamId,
    String? parameter,
    required Object? value,
  }) {
    var streamContext = _inputStreamContexts[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      methodStreamId: methodStreamId,
    )];

    if (streamContext == null) {
      return false;
    }

    streamContext.controller.add(value);
    return true;
  }

  /// Dispatches an error to the correct stream controller.
  bool dispatchError({
    required String endpoint,
    required String method,
    required UuidValue methodStreamId,
    String? parameter,
    required Object error,
  }) {
    var streamContext = _inputStreamContexts[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      methodStreamId: methodStreamId,
    )];

    if (streamContext == null) {
      return false;
    }

    streamContext.controller.addError(error);
    return true;
  }

  String _buildStreamKey({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue methodStreamId,
  }) =>
      '$methodStreamId:$endpoint:$method${parameter != null ? ':$parameter' : ''}';

  Future<void> _closeControllers(Iterable<StreamController> controllers) async {
    List<Future<void>> futures = [];
    // Close all controllers that have listeners.
    // If close is called on a controller that has no listeners, it will
    // return a future that never completes.
    var controllersToClose =
        controllers.where((c) => c.hasListener && !c.isClosed);

    for (var controller in controllersToClose) {
      // Paused streams will never process the close event and
      // will never complete. Therefore we need add a timeout to complete the
      // future.
      futures.add(controller.close().timeout(
            _closeTimeout,
            onTimeout: () async => await controller.onCancel?.call(),
          ));
    }

    await Future.wait(futures);
  }

  Map<String, StreamController> _createInputStreams(
    MethodStreamCallContext callContext,
    UuidValue methodStreamId,
  ) {
    var inputStreams = <String, StreamController>{};

    for (var streamParam in callContext.inputStreams) {
      var parameterName = streamParam.name;
      var controller = StreamController(onCancel: () async {
        var context = _inputStreamContexts.remove(_buildStreamKey(
          endpoint: callContext.endpoint.name,
          method: callContext.method.name,
          parameter: parameterName,
          methodStreamId: methodStreamId,
        ));

        if (context == null) {
          return;
        }

        onInputStreamClosed?.call(
          methodStreamId,
          parameterName,
          CloseReason.done,
          callContext,
        );
      });

      inputStreams[parameterName] = controller;
      _inputStreamContexts[_buildStreamKey(
        endpoint: callContext.endpoint.name,
        method: callContext.method.name,
        parameter: parameterName,
        methodStreamId: methodStreamId,
      )] = _InputStreamContext(controller);
    }

    return inputStreams;
  }

  Future<void> _handleMethodWithFutureReturn({
    required MethodStreamCallContext methodStreamCallContext,
    required Session session,
    required Map<String, Stream<dynamic>> streamParams,
    required StreamController outputController,
    required UuidValue methodStreamId,
  }) async {
    var streamKey = _buildStreamKey(
      endpoint: methodStreamCallContext.endpoint.name,
      method: methodStreamCallContext.method.name,
      methodStreamId: methodStreamId,
    );
    try {
      var result = await methodStreamCallContext.method
          .call(session, methodStreamCallContext.arguments, streamParams);

      _updateCloseReason(streamKey, CloseReason.done);
      if (methodStreamCallContext.method.returnType !=
          MethodStreamReturnType.voidType) {
        outputController.add(result);
      }
    } catch (e, stackTrace) {
      _updateCloseReason(streamKey, CloseReason.error);
      outputController.addError(e, stackTrace);
    }

    await outputController.close();
  }

  Future<void> _closeOutboundStream(
      MethodStreamCallContext callContext, UuidValue methodStreamId) async {
    var context = _outputStreamContexts.remove(
      _buildStreamKey(
        endpoint: callContext.endpoint.name,
        method: callContext.method.name,
        methodStreamId: methodStreamId,
      ),
    );

    if (context == null) return;

    onOutputStreamClosed?.call(
        methodStreamId, context.closeReason, callContext);

    var inputStreamControllers = <StreamController>[];
    for (var streamParam in callContext.inputStreams) {
      var paramStreamContext = _inputStreamContexts.remove(_buildStreamKey(
        endpoint: callContext.endpoint.name,
        method: callContext.method.name,
        parameter: streamParam.name,
        methodStreamId: methodStreamId,
      ));

      if (paramStreamContext == null) {
        continue;
      }

      onInputStreamClosed?.call(
        methodStreamId,
        streamParam.name,
        context.closeReason ?? CloseReason.done,
        callContext,
      );

      inputStreamControllers.add(paramStreamContext.controller);
    }

    await _closeControllers(inputStreamControllers);

    if (_outputStreamContexts.isEmpty && _inputStreamContexts.isEmpty) {
      onAllStreamsClosed?.call();
    }
  }

  void _handleMethodWithStreamReturn({
    required MethodStreamCallContext methodStreamCallContext,
    required UuidValue methodStreamId,
    required Session session,
    required Map<String, Stream<dynamic>> streamParams,
    required StreamController outputController,
    required StreamSubscription subscription,
  }) {
    outputController
        .addStream(
      methodStreamCallContext.method
          .call(session, methodStreamCallContext.arguments, streamParams),
    )
        .whenComplete(
      () async {
        var streamKey = _buildStreamKey(
          endpoint: methodStreamCallContext.endpoint.name,
          method: methodStreamCallContext.method.name,
          methodStreamId: methodStreamId,
        );

        var closeReasonIsNotAlreadySetToError =
            _outputStreamContexts[streamKey]?.closeReason != CloseReason.error;
        if (closeReasonIsNotAlreadySetToError) {
          _updateCloseReason(streamKey, CloseReason.done);
        }

        await subscription.cancel();
      },
    );
  }
}
