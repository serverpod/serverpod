// ignore_for_file: public_member_api_docs
// TODO: Add documentation

import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Represents the operation that the event was caused by or in relation to.
/// An operation is a client-originated call / operation or a scheduled operation,
/// i.e. a method call, a streaming call, a web call, a future call, etc.
class OperationContext extends EventContext {
  final UuidValue sessionId;
  final AuthenticationInfo? userAuthInfo;
  final int? sessionLogId;

  const OperationContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required this.sessionId,
    this.userAuthInfo,
    this.sessionLogId,
  });

  @override
  Map<String, String> toMap() {
    return {
      ...super.toMap(),
      'sessionId': '$sessionId',
      'userAuthInfo': '$userAuthInfo',
      'sessionLogId': '$sessionLogId',
    };
  }

  @override
  String toString() {
    return '$runtimeType($serverName, $serverId, $serverRunMode, $sessionId, $userAuthInfo, $sessionLogId)';
  }
}

class FutureCallContext extends OperationContext {
  final String futureCallName;

  const FutureCallContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.sessionLogId,
    required this.futureCallName,
  });

  @override
  Map<String, String> toMap() {
    return {
      ...super.toMap(),
      'futureCallName': futureCallName,
    };
  }
}

/// Represents a client call operation.
/// Instances of this type represent web calls.
/// Subclasses represent method and method streaming calls.
class ClientCallContext extends OperationContext {
  final ConnectionInfo connectionInfo;
  final Uri uri;

  const ClientCallContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.sessionLogId,
    required this.connectionInfo,
    required this.uri,
  });

  @override
  Map<String, String> toMap() {
    return {
      ...super.toMap(),
      'connectionInfo': '$connectionInfo',
      'uri': '$uri',
    };
  }
}

class MethodContext extends ClientCallContext {
  final String endpoint;
  final String methodName;

  const MethodContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.sessionLogId,
    required super.connectionInfo,
    required super.uri,
    required this.endpoint,
    required this.methodName,
  });

  @override
  Map<String, String> toMap() {
    return {
      ...super.toMap(),
      'endpoint': endpoint,
      'methodName': methodName,
    };
  }
}

class MethodStreamContext extends MethodContext {
  final UuidValue streamConnectionId;

  const MethodStreamContext({
    required super.serverName,
    required super.serverId,
    required super.serverRunMode,
    required super.sessionId,
    super.userAuthInfo,
    super.sessionLogId,
    required super.connectionInfo,
    required super.uri,
    required super.endpoint,
    required super.methodName,
    required this.streamConnectionId,
  });

  @override
  Map<String, String> toMap() {
    return {
      ...super.toMap(),
      'streamConnectionId': '$streamConnectionId',
    };
  }
}

ClientCallContext contextFromHttpRequest(
  Server server,
  HttpRequest httpRequest,
) {
  return ClientCallContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
    sessionId: const Uuid().v4obj(), // TODO: revise?
    userAuthInfo: null,
    sessionLogId: null,
    connectionInfo: httpRequest.connectionInfo?.toConnectionInfo() ??
        ConnectionInfo.empty(),
    uri: httpRequest.uri,
  );
}

OperationContext contextFromSession(
  Session session, {
  HttpRequest? httpRequest,
  int? sessionLogId,
}) {
  return switch (session) {
    FutureCallSession futureCall => _fromFutureCall(
        futureCall,
        sessionLogId: sessionLogId,
      ),
    WebCallSession webCall => _fromWebCall(
        webCall,
        httpRequest: httpRequest,
        sessionLogId: sessionLogId,
      ),
    MethodCallSession methodCall => _fromMethodCall(
        methodCall,
        sessionLogId: sessionLogId,
      ),
    MethodStreamSession methodStream => _fromMethodStream(
        methodStream,
        sessionLogId: sessionLogId,
      ),
    // StreamingSession streaming => _fromStreaming(
    //     streaming,
    //     sessionLogId: sessionLogId,
    //   ),
    _ => OperationContext(
        serverName: session.server.name,
        serverId: session.server.serverId,
        serverRunMode: session.server.runMode,
        userAuthInfo: session.authInfoOrNull,
        sessionId: session.sessionId,
        sessionLogId: sessionLogId,
      ),
  };
}

FutureCallContext _fromFutureCall(
  FutureCallSession session, {
  int? sessionLogId,
}) =>
    FutureCallContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      sessionLogId: sessionLogId,
      futureCallName: session.futureCallName,
    );

ClientCallContext _fromWebCall(
  WebCallSession session, {
  HttpRequest? httpRequest,
  int? sessionLogId,
}) =>
    ClientCallContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      sessionLogId: sessionLogId,
      connectionInfo: _safeHttpToConnInfo(httpRequest?.connectionInfo),
      uri: httpRequest?.uri ?? Uri.http('localhost'),
    );

MethodContext _fromMethodCall(
  MethodCallSession session, {
  int? sessionLogId,
}) =>
    MethodContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      sessionLogId: sessionLogId,
      connectionInfo: _safeHttpToConnInfo(session.httpRequest.connectionInfo),
      uri: session.uri,
      endpoint: session.endpoint,
      methodName: session.method,
    );

MethodStreamContext _fromMethodStream(
  MethodStreamSession session, {
  HttpRequest? httpRequest,
  int? sessionLogId,
}) =>
    MethodStreamContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      sessionLogId: sessionLogId,
      connectionInfo: _safeHttpToConnInfo(httpRequest?.connectionInfo),
      uri: httpRequest?.uri ?? Uri.http('localhost'),
      endpoint: session.endpoint,
      methodName: session.method,
      streamConnectionId: session.connectionId,
    );

// OperationContext _fromStreaming(
//   StreamingSession session, {
//   int? sessionLogId,
// }) =>
//     MethodStreamContext(
//       serverName: session.server.name,
//       serverId: session.server.serverId,
//       serverRunMode: session.server.runMode,
//       connectionInfo: session.httpRequest.connectionInfo,
//       uri: session.uri,
//       endpoint: session.endpoint,
//       methodName: session.method,
//       userAuthInfo: session.authInfoOrNull,
//       sessionId: session.sessionId,
//       sessionLogId: sessionLogId ?? session.sessionLogId,
//     );

/// Represents the connection information of a network request.
/// Can be HTTP but also other types of network connections.
class ConnectionInfo {
  final InternetAddress remoteAddress;
  final int remotePort;
  final int localPort;

  const ConnectionInfo({
    required this.remoteAddress,
    required this.remotePort,
    required this.localPort,
  });

  ConnectionInfo.empty()
      : this(
          remoteAddress: InternetAddress.anyIPv4,
          remotePort: 0,
          localPort: 0,
        );

  @override
  String toString() {
    return 'remote: $remoteAddress:$remotePort local port:$localPort)';
  }
}

extension _ConnectionInfoExtension on HttpConnectionInfo {
  ConnectionInfo toConnectionInfo() => ConnectionInfo(
        remoteAddress: remoteAddress,
        remotePort: remotePort,
        localPort: localPort,
      );
}

ConnectionInfo _safeHttpToConnInfo(HttpConnectionInfo? connectionInfo) =>
    connectionInfo?.toConnectionInfo() ?? ConnectionInfo.empty();
