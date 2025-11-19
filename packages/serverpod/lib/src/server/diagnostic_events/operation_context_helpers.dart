/// These helpers are for internal framework use only.
library;

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

/// Creates a new [ClientCallOpContext] given a [Server]
/// and an [Request].
ClientCallOpContext contextFromRequest(
  Server server,
  Request request, [
  OperationType? operationType,
]) {
  return ClientCallOpContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
    operationType: operationType,
    sessionId: null,
    userAuthInfo: null,
    remoteInfo: request.remoteInfo,
    uri: request.requestedUri,
  );
}

/// Creates a new [OperationEventContext] given a [Session]
/// and an [Request] if available.
OperationEventContext contextFromSession(
  Session session, {
  Request? request,
}) {
  return switch (session) {
    FutureCallSession futureCall => _fromFutureCall(
      futureCall,
    ),
    WebCallSession webCall => _fromWebCall(webCall, request),
    MethodCallSession methodCall => _fromMethodCall(
      methodCall,
    ),
    MethodStreamSession methodStream => _fromMethodStream(
      methodStream,
      request: request,
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
) => FutureCallOpContext(
  serverName: session.server.name,
  serverId: session.server.serverId,
  serverRunMode: session.server.runMode,
  userAuthInfo: session.authInfoOrNull,
  sessionId: session.sessionId,
  futureCallName: session.futureCallName,
);

WebCallOpContext _fromWebCall(
  WebCallSession session,
  Request? request,
) => WebCallOpContext(
  serverName: session.server.name,
  serverId: session.server.serverId,
  serverRunMode: session.server.runMode,
  userAuthInfo: session.authInfoOrNull,
  sessionId: session.sessionId,
  remoteInfo: request?.remoteInfo,
  uri: request?.requestedUri ?? Uri.http('', session.endpoint),
);

MethodCallOpContext _fromMethodCall(
  MethodCallSession session,
) => MethodCallOpContext(
  serverName: session.server.name,
  serverId: session.server.serverId,
  serverRunMode: session.server.runMode,
  userAuthInfo: session.authInfoOrNull,
  sessionId: session.sessionId,
  remoteInfo: session.remoteInfo,
  uri: session.uri,
  endpoint: session.endpoint,
  methodName: session.method,
);

StreamOpContext _fromMethodStream(
  MethodStreamSession session, {
  Request? request,
}) => StreamOpContext(
  serverName: session.server.name,
  serverId: session.server.serverId,
  serverRunMode: session.server.runMode,
  userAuthInfo: session.authInfoOrNull,
  sessionId: session.sessionId,
  remoteInfo: request?.remoteInfo,
  uri: request?.requestedUri ?? Uri.http('localhost'),
  endpoint: session.endpoint,
  methodName: session.method,
  streamConnectionId: session.connectionId,
);

StreamOpContext _fromStreaming(
  StreamingSession session,
) => StreamOpContext(
  serverName: session.server.name,
  serverId: session.server.serverId,
  serverRunMode: session.server.runMode,
  userAuthInfo: session.authInfoOrNull,
  sessionId: session.sessionId,
  remoteInfo: session.remoteInfo,
  uri: session.request.requestedUri,
  endpoint: session.endpoint,
  methodName: '-',
  streamConnectionId: null,
);
