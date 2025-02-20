import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Creates a new [DiagnosticEventContext] given a [Server] instance.
DiagnosticEventContext contextFromServer(Server server) {
  return DiagnosticEventContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
  );
}

/// Creates a new [ClientCallOpContext] given a [Server]
/// and an [HttpRequest].
ClientCallOpContext contextFromHttpRequest(
  Server server,
  HttpRequest httpRequest,
  OperationType operationType,
) {
  return ClientCallOpContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
    operationType: operationType,
    sessionId: null,
    userAuthInfo: null,
    connectionInfo: httpRequest.connectionInfo?.toConnectionInfo() ??
        ConnectionInfo.empty(),
    uri: httpRequest.uri,
  );
}

/// Creates a new [OperationEventContext] given a [Session]
/// and an [HttpRequest] if available.
OperationEventContext contextFromSession(
  Session session, {
  HttpRequest? httpRequest,
}) {
  return switch (session) {
    FutureCallSession futureCall => _fromFutureCall(
        futureCall,
      ),
    WebCallSession webCall => _fromWebCall(
        webCall,
        httpRequest: httpRequest,
      ),
    MethodCallSession methodCall => _fromMethodCall(
        methodCall,
      ),
    MethodStreamSession methodStream => _fromMethodStream(
        methodStream,
        httpRequest: httpRequest,
      ),
    StreamingSession streaming => _fromStreaming(
        streaming,
      ),
    // likely InternalSession or InternalServerpodSession
    _ => OperationEventContext(
        serverName: session.server.name,
        serverId: session.server.serverId,
        serverRunMode: session.server.runMode,
        operationType: OperationType.internal,
        userAuthInfo: session.authInfoOrNull,
        sessionId: session.sessionId,
      ),
  };
}

FutureCallOpContext _fromFutureCall(
  FutureCallSession session,
) =>
    FutureCallOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      futureCallName: session.futureCallName,
    );

WebCallOpContext _fromWebCall(
  WebCallSession session, {
  HttpRequest? httpRequest,
}) =>
    WebCallOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: _safeHttpToConnInfo(httpRequest?.connectionInfo),
      uri: httpRequest?.uri ?? Uri.http('localhost'),
    );

MethodCallOpContext _fromMethodCall(
  MethodCallSession session,
) =>
    MethodCallOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: _safeHttpToConnInfo(session.httpRequest.connectionInfo),
      uri: session.uri,
      endpoint: session.endpoint,
      methodName: session.method,
    );

StreamOpContext _fromMethodStream(
  MethodStreamSession session, {
  HttpRequest? httpRequest,
}) =>
    StreamOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: _safeHttpToConnInfo(httpRequest?.connectionInfo),
      uri: httpRequest?.uri ?? Uri.http('localhost'),
      endpoint: session.endpoint,
      methodName: session.method,
      streamConnectionId: session.connectionId,
    );

StreamOpContext _fromStreaming(
  StreamingSession session,
) =>
    StreamOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: session.httpRequest.connectionInfo?.toConnectionInfo() ??
          ConnectionInfo.empty(),
      uri: session.httpRequest.uri,
      endpoint: session.endpoint,
      methodName: '-',
      streamConnectionId: null,
    );

ConnectionInfo _safeHttpToConnInfo(HttpConnectionInfo? connectionInfo) =>
    connectionInfo?.toConnectionInfo() ?? ConnectionInfo.empty();
