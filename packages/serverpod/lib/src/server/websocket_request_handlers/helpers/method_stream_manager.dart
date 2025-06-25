import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class _RevokedAuthenticationHandler {
  final MessageCentralListenerCallback? _revokedAuthenticationCallback;
  final AuthenticationInfo? _authenticationInfo;

  _RevokedAuthenticationHandler._(
    AuthenticationInfo authenticationInfo,
    void Function(dynamic event) revokedAuthenticationCallback,
  )   : _authenticationInfo = authenticationInfo,
        _revokedAuthenticationCallback = revokedAuthenticationCallback;

  /// Call when the stream call is cancelled to do proper cleanup.
  Future<void> destroy(Session session) async {
    var localRevokedAuthenticationCallback = _revokedAuthenticationCallback;
    var localAuthenticationInfo = _authenticationInfo;

    if (localRevokedAuthenticationCallback != null &&
        localAuthenticationInfo != null) {
      session.messages.removeListener(
        MessageCentralServerpodChannels.revokedAuthentication(
          localAuthenticationInfo.userIdentifier,
        ),
        localRevokedAuthenticationCallback,
      );
    }
  }

  static Future<_RevokedAuthenticationHandler?>
      createIfAuthenticationIsRequired(
    Endpoint endpoint,
    Session session, {
    required void Function() onRevokedAuthentication,
  }) async {
    var authenticationIsRequired =
        endpoint.requireLogin || endpoint.requiredScopes.isNotEmpty;
    if (!authenticationIsRequired) {
      return null;
    }

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
        onRevokedAuthentication();
      }
    }

    session.messages.addListener(
      MessageCentralServerpodChannels.revokedAuthentication(
        authenticationInfo.userIdentifier,
      ),
      localRevokedAuthenticationCallback,
    );

    return _RevokedAuthenticationHandler._(
      authenticationInfo,
      localRevokedAuthenticationCallback,
    );
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

typedef _OnOutputStreamValue = void Function(
  UuidValue methodStreamId,
  Object? value,
  MethodStreamCallContext methodStreamCallContext,
);
typedef _OnOutputStreamError = void Function(
  UuidValue methodStreamId,
  Object error,
  StackTrace stackTrace,
  MethodStreamCallContext methodStreamCallContext,
);
typedef _OnOutputStreamClosed = void Function(
  UuidValue methodStreamId,
  CloseReason? closeReason,
  MethodStreamCallContext callContext,
);
typedef _OnInputStreamClosed = void Function(
  UuidValue methodStreamId,
  String parameterName,
  CloseReason? closeReason,
  MethodStreamCallContext callContext,
);

/// Manages the streams for an endpoint method call.
/// Should only be used by Serverpod packages.
@internal
class MethodStreamManager {
  static const Duration _closeTimeout = Duration(seconds: 6);

  /// The originating HTTP request.
  final HttpRequest? httpRequest;

  final Map<String, _InputStreamContext> _inputStreamContexts = {};
  final Map<String, _OutputStreamContext> _outputStreamContexts = {};

  final _OnOutputStreamValue? _onOutputStreamValue;
  final _OnOutputStreamError? _onOutputStreamError;
  final _OnOutputStreamClosed? _onOutputStreamClosed;
  final _OnInputStreamClosed? _onInputStreamClosed;

  MethodStreamManager({
    required this.httpRequest,
    _OnInputStreamClosed? onInputStreamClosed,
    _OnOutputStreamClosed? onOutputStreamClosed,
    _OnOutputStreamError? onOutputStreamError,
    _OnOutputStreamValue? onOutputStreamValue,
  })  : _onInputStreamClosed = onInputStreamClosed,
        _onOutputStreamClosed = onOutputStreamClosed,
        _onOutputStreamError = onOutputStreamError,
        _onOutputStreamValue = onOutputStreamValue;

  int get openInputStreamCount => _inputStreamContexts.length;

  int get openOutputStreamCount => _outputStreamContexts.length;

  Future<void> closeAllStreams() async {
    var inputControllers =
        _inputStreamContexts.values.map((c) => c.controller).toList();
    _inputStreamContexts.clear();

    var outboundStreamContexts = _outputStreamContexts.values.toList();
    _outputStreamContexts.clear();

    var closeSubscriptionFutures = outboundStreamContexts.map(
      (c) => c.subscription.cancel().timeout(
            _closeTimeout,
            onTimeout: () async {
              await c.controller.onCancel?.call();
              return null;
              // This type case is needed to avoid a runtime exception
              // Filed as bug on dart-lang/sdk: https://github.com/dart-lang/sdk/issues/56846
            } as Future<Null> Function()?,
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
  }) async {
    var outputStreamContext = await _createOutputController(
      methodStreamCallContext,
      session,
      methodStreamId,
    );

    var inputStreams = _createInputStreams(
      methodStreamCallContext,
      methodStreamId,
      session,
    );
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
        await _handleMethodWithFutureReturn(
          methodStreamCallContext: methodStreamCallContext,
          session: session,
          streamParams: streamParams,
          outputController: outputStreamContext.controller,
          methodStreamId: methodStreamId,
        );
        break;
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

  Future<_OutputStreamContext> _createOutputController(
    MethodStreamCallContext methodStreamCallContext,
    Session session,
    UuidValue methodStreamId,
  ) async {
    bool isCancelled = false;
    var revokedAuthenticationHandler =
        await _RevokedAuthenticationHandler.createIfAuthenticationIsRequired(
      methodStreamCallContext.endpoint,
      session,
      onRevokedAuthentication: () => closeStream(
        endpoint: methodStreamCallContext.fullEndpointPath,
        method: methodStreamCallContext.method.name,
        methodStreamId: methodStreamId,
        reason: CloseReason.error,
      ),
    );

    var outputController = StreamController(onCancel: () async {
      /// Guard against multiple calls to onCancel
      /// This is required because we invoke the onCancel
      /// method manually if the stream is closed by a timeout
      /// or a request from the client.
      if (isCancelled) return;
      isCancelled = true;
      session.serverpod.logVerbose(
          'Cancelling method output stream for ${methodStreamCallContext.fullEndpointPath}.'
          '${methodStreamCallContext.method.name}, id $methodStreamId');
      await revokedAuthenticationHandler?.destroy(session);
      await _closeOutboundStream(methodStreamCallContext, methodStreamId);
      await session.close();
    });

    var streamKey = _buildStreamKey(
      endpoint: methodStreamCallContext.fullEndpointPath,
      method: methodStreamCallContext.method.name,
      methodStreamId: methodStreamId,
    );

    late StreamSubscription subscription;
    subscription = outputController.stream.listen(
      (value) async {
        _onOutputStreamValue?.call(
            methodStreamId, value, methodStreamCallContext);
      },
      onError: (e, s) {
        // All method calls that return futures are unawaited to ensure that
        // the calls are invoked synchronously. If an 'await' is added
        // here, processing new messages might be initiated before the
        // subscription is canceled.
        if (e is _StreamComplete) {
          _updateCloseReason(streamKey, CloseReason.done);
          unawaited(subscription.cancel());
          return;
        }

        _onOutputStreamError?.call(
            methodStreamId, e, s, methodStreamCallContext);

        _updateCloseReason(streamKey, CloseReason.error);

        unawaited(session.close(error: e, stackTrace: s));

        /// Required to close stream when error occurs.
        /// This will also close the input streams.
        /// We can't use the "cancelOnError" option
        /// for the listen method because this cancels
        /// the stream before the onError callback has
        /// been called.
        unawaited(subscription.cancel());
      },
    );

    var outputStreamContext =
        _OutputStreamContext(outputController, subscription);
    _outputStreamContexts[_buildStreamKey(
      endpoint: methodStreamCallContext.fullEndpointPath,
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
    Session session,
  ) {
    var inputStreams = <String, StreamController>{};

    for (var streamParam in callContext.inputStreams) {
      var parameterName = streamParam.name;
      var controller = StreamController(onCancel: () async {
        session.serverpod.logVerbose(
            'Cancelling method input stream for ${callContext.fullEndpointPath}.'
            '${callContext.method.name}.$parameterName, id $methodStreamId');
        var context = _inputStreamContexts.remove(_buildStreamKey(
          endpoint: callContext.fullEndpointPath,
          method: callContext.method.name,
          parameter: parameterName,
          methodStreamId: methodStreamId,
        ));

        if (context == null) {
          return;
        }

        _onInputStreamClosed?.call(
          methodStreamId,
          parameterName,
          CloseReason.done,
          callContext,
        );
      });

      inputStreams[parameterName] = controller;
      _inputStreamContexts[_buildStreamKey(
        endpoint: callContext.fullEndpointPath,
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
      endpoint: methodStreamCallContext.fullEndpointPath,
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
      session.serverpod.internalSubmitEvent(
        ExceptionEvent(e, stackTrace),
        space: OriginSpace.application,
        context: contextFromSession(
          session,
          httpRequest: httpRequest,
        ),
      );

      _updateCloseReason(streamKey, CloseReason.error);
      outputController.addError(e, stackTrace);
    }

    await outputController.close();
  }

  Future<void> _closeOutboundStream(
      MethodStreamCallContext callContext, UuidValue methodStreamId) async {
    var context = _outputStreamContexts.remove(
      _buildStreamKey(
        endpoint: callContext.fullEndpointPath,
        method: callContext.method.name,
        methodStreamId: methodStreamId,
      ),
    );

    if (context == null) return;

    _onOutputStreamClosed?.call(
        methodStreamId, context.closeReason, callContext);

    var inputStreamControllers = <StreamController>[];
    for (var streamParam in callContext.inputStreams) {
      var paramStreamContext = _inputStreamContexts.remove(_buildStreamKey(
        endpoint: callContext.fullEndpointPath,
        method: callContext.method.name,
        parameter: streamParam.name,
        methodStreamId: methodStreamId,
      ));

      if (paramStreamContext == null) {
        continue;
      }

      _onInputStreamClosed?.call(
        methodStreamId,
        streamParam.name,
        context.closeReason ?? CloseReason.done,
        callContext,
      );

      inputStreamControllers.add(paramStreamContext.controller);
    }

    await _closeControllers(inputStreamControllers);
  }

  void _handleMethodWithStreamReturn({
    required MethodStreamCallContext methodStreamCallContext,
    required UuidValue methodStreamId,
    required Session session,
    required Map<String, Stream<dynamic>> streamParams,
    required StreamController outputController,
    required StreamSubscription subscription,
  }) {
    Stream<dynamic> methodStream;
    try {
      methodStream = methodStreamCallContext.method.call(
        session,
        methodStreamCallContext.arguments,
        streamParams,
      );
    } catch (e, stackTrace) {
      session.serverpod.internalSubmitEvent(
        ExceptionEvent(e, stackTrace),
        space: OriginSpace.application,
        context: contextFromSession(
          session,
          httpRequest: httpRequest,
        ),
      );

      outputController.addError(e, stackTrace);
      return;
    }

    outputController.addStream(methodStream).whenComplete(
          // The stream complete message is sent as an error to circumvent
          // branching when passing along stream events to the handler.
          () => outputController.addError(_StreamComplete()),
        );
  }
}

/// Passed as the last message on a stream to indicate that the stream is
/// complete and no more messages will be sent from the endpoint.
class _StreamComplete {}
