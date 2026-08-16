import 'package:uuid/uuid_value.dart';

import '../../authentication/authentication_info.dart';

import 'event_handler.dart';

/// Represents the type of "operation" during which the event was caused.
///
/// An operation is a client-originated call / operation or a scheduled operation,
/// i.e. a method call, a streaming call, a web call, or a future call.
enum OperationType {
  /// A future call.
  future,

  /// A web call.
  web,

  /// A method call.
  method,

  /// A streaming call / message.
  stream,

  /// An internal operation.
  /// Typically corresponds to an [InternalSession].
  internal,
}

/// Represents the operation that the event was caused by or in relation to.
/// An operation is a client-originated call / operation or a scheduled operation,
/// i.e. a method call, a streaming call, a web call, or a future call.
base class OperationEventContext extends DiagnosticEventContext {
  /// The type of operation.
  /// Null if unknown, for example if an HTTP request is invalid
  /// and no call operation can be determined.
  final OperationType? operationType;

  /// The session ID of the operation, if available.
  final UuidValue? sessionId;

  /// The user authentication information, if available.
  final AuthenticationInfo? userAuthInfo;

  /// Creates a new [OperationEventContext].
  const OperationEventContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    this.operationType,
    this.sessionId,
    this.userAuthInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'operationType': '$operationType',
      'sessionId': sessionId != null ? '$sessionId' : null,
      'userAuthInfo': userAuthInfo != null ? '$userAuthInfo' : null,
    };
  }

  @override
  String toString() {
    return '$runtimeType($serverName, $serverId, $serverRunMode, '
        '$operationType, $sessionId, $userAuthInfo)';
  }
}

/// The context of a future call operation.
final class FutureCallOpContext extends OperationEventContext {
  /// The name of the future call.
  final String futureCallName;

  /// Creates a new [FutureCallOpContext].
  const FutureCallOpContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    required this.futureCallName,
  }) : super(operationType: OperationType.future);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'futureCallName': futureCallName,
    };
  }
}

/// The context of a client call operation.
/// Subclasses represent web, method, and method streaming calls.
base class ClientCallOpContext extends OperationEventContext {
  /// Information identifying the client caller.
  final String? remoteInfo;

  /// The URI that the client invoked.
  final Uri uri;

  /// Creates a new [ClientCallOpContext].
  const ClientCallOpContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    super.operationType,
    super.sessionId,
    super.userAuthInfo,
    this.remoteInfo,
    required this.uri,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'remoteInfo': remoteInfo,
      'uri': '$uri',
    };
  }
}

/// The context of a web call operation.
final class WebCallOpContext extends ClientCallOpContext {
  /// Creates a new [WebCallOpContext].
  const WebCallOpContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.remoteInfo,
    required super.uri,
  }) : super(operationType: OperationType.web);
}

/// The context of a method call operation.
final class MethodCallOpContext extends ClientCallOpContext {
  /// The name of the endpoint.
  final String endpoint;

  /// The name of the method.
  final String methodName;

  /// Creates a new [MethodCallOpContext].
  const MethodCallOpContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    super.operationType = OperationType.method,
    super.sessionId,
    super.userAuthInfo,
    super.remoteInfo,
    required super.uri,
    required this.endpoint,
    required this.methodName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'endpoint': endpoint,
      'methodName': methodName,
    };
  }
}

/// The context of a stream operation / message.
final class StreamOpContext extends MethodCallOpContext {
  /// The ID of the stream connection, if available.
  final UuidValue? streamConnectionId;

  /// Creates a new [StreamOpContext].
  const StreamOpContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.remoteInfo,
    required super.uri,
    required super.endpoint,
    required super.methodName,
    required this.streamConnectionId,
  }) : super(operationType: OperationType.stream);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'streamConnectionId': streamConnectionId != null
          ? '$streamConnectionId'
          : null,
    };
  }
}
