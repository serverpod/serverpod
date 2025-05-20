/// These helpers are for internal framework use only.
library;

import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/session.dart';

/// Creates a new [DiagnosticEventContext] given a [Server] instance.
DiagnosticEventContext contextFromServer(Server server) {
  return DiagnosticEventContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
  );
}

class RequestInfo {
  final ConnectionInfo connectionInfo;
  final Uri uri;

  const RequestInfo(this.connectionInfo, this.uri);

  static final empty = RequestInfo(ConnectionInfo.empty(), Uri());
}

extension HttpRequestEx on HttpRequest? {
  RequestInfo toRequestInfo() {
    final self = this;
    if (self == null) return RequestInfo.empty;
    return RequestInfo(
      self.connectionInfo?.toConnectionInfo() ?? ConnectionInfo.empty(),
      self.uri,
    );
  }
}

/// Creates a new [ClientCallOpContext] given a [Server]
/// and an [RequestInfo].
ClientCallOpContext contextFromRequest(
  Server server,
  RequestInfo requestInfo, [
  OperationType? operationType,
]) {
  return ClientCallOpContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
    operationType: operationType,
    sessionId: null,
    userAuthInfo: null,
    connectionInfo: requestInfo.connectionInfo,
    uri: requestInfo.uri,
  );
}

/// Creates a new [OperationEventContext] given a [Session]
/// and an [HttpRequest] if available.
OperationEventContext contextFromSession(
  Session session, {
  RequestInfo? requestInfo,
}) {
  return switch (session) {
    FutureCallSession futureCall => _fromFutureCall(
        futureCall,
      ),
    WebCallSession webCall => _fromWebCall(webCall, requestInfo),
    MethodCallSession methodCall => _fromMethodCall(
        methodCall,
      ),
    MethodStreamSession methodStream => _fromMethodStream(
        methodStream,
        requestInfo: requestInfo,
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
  WebCallSession session,
  RequestInfo? requestInfo,
) =>
    WebCallOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: requestInfo?.connectionInfo ?? ConnectionInfo.empty(),
      uri: requestInfo?.uri ?? Uri.http('', session.endpoint),
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
  RequestInfo? requestInfo,
}) =>
    StreamOpContext(
      serverName: session.server.name,
      serverId: session.server.serverId,
      serverRunMode: session.server.runMode,
      userAuthInfo: session.authInfoOrNull,
      sessionId: session.sessionId,
      connectionInfo: requestInfo?.connectionInfo ?? ConnectionInfo.empty(),
      uri: requestInfo?.uri ?? Uri.http('localhost'),
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
