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

class RequestInfo {
  final String? clientIpAddress;
  final Uri uri;

  const RequestInfo(this.clientIpAddress, this.uri);

  static final empty = RequestInfo(null, Uri());
}

extension RequestEx on Request? {
  RequestInfo toRequestInfo() {
    // TODO: Determine how to get ConnectionInfo from relic.Request if possible.
    // For now, returning empty as per the previous TODO in web_server.dart
    // and because relic.Request does not seem to expose .connectionInfo directly.
    return RequestInfo.empty;
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
    clientIpAddress: requestInfo.clientIpAddress,
    uri: requestInfo.uri,
  );
}

/// Creates a new [OperationEventContext] given a [Session]
/// and an [Request] if available.
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
      clientIpAddress: requestInfo?.clientIpAddress,
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
      clientIpAddress: session.clientIpAddress,
      uri: session
          .uri, // MethodCallSession has its own uri field, which is used here.
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
      clientIpAddress: requestInfo?.clientIpAddress,
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
      clientIpAddress: session.clientIpAddress,
      uri: session.request.requestedUri, // Use requestedUri from relic.Request
      endpoint: session.endpoint,
      methodName: '-',
      streamConnectionId: null,
    );
