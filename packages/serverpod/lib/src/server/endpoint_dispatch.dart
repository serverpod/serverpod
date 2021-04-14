import 'dart:io';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint.dart';
import 'server.dart';
import 'session.dart';

abstract class EndpointDispatch {
  Map<String, EndpointConnector> connectors = {};

  void initializeEndpoints(Server server);

  Future handleUriCall(Server server, String endpointName, Uri uri, String body, HttpRequest request) async {
    EndpointConnector? connector = connectors[endpointName];
    if (connector == null)
      return ResultInvalidParams('Endpoint $endpointName does not exist in $uri');

    Session session;

    try {
      session = Session(
        server: server,
        uri: uri,
        body: body,
        endpointName: endpointName,
        httpRequest: request,
      );
    }
    catch(e) {
      return ResultInvalidParams('Malformed call: $uri');
    }

    var methodName = session.methodCall!.methodName;
    var auth = session.authenticationKey;
    var inputParams = session.methodCall!.queryParameters;

    try {
      if (connector.endpoint.requireLogin) {
        if (auth == null) {
          await session.close();
          return ResultAuthenticationFailed('No authentication provided');
        }
        if (!await session.isUserSignedIn) {
          await session.close();
          return ResultAuthenticationFailed('Authentication failed');
        }
      }

      if (connector.endpoint.requiredScopes.length > 0) {

        if (!await session.isUserSignedIn) {
          await session.close();
          return ResultAuthenticationFailed('Sign in required to access this endpoint');
        }

        for (var requiredScope in connector.endpoint.requiredScopes) {
          if (!(await session.scopes)!.contains(requiredScope)) {
            await session.close();
            return ResultAuthenticationFailed('User does not have access to scope ${requiredScope.name}');
          }
        }
      }

      var method = connector.methodConnectors[methodName];
      if (method == null) {
        await session.close();
        return ResultInvalidParams('Method $methodName not found in call: $uri');
      }

      // TODO: Check parameters and check null safety

      Map<String, dynamic> paramMap = {};
      for (var paramName in inputParams.keys) {
        Type? type = method.params[paramName]?.type;
        if (type == null)
          continue;
        var formatted = _formatArg(inputParams[paramName], type, server.serializationManager);
        paramMap[paramName] = formatted;
      }

      var result = await method.call(session, paramMap);

      // Print session info
      int? authenticatedUserId = connector.endpoint.requireLogin ? await session.authenticatedUserId : null;
      if (connector.endpoint.logSessions)
        server.serverpod.logSession(session.methodCall!.endpointName, session.methodCall!.methodName, session.runningTime, session.queries, session.logs, authenticatedUserId, null, null);

      await session.close();

      return result;
    }
    catch (exception, stackTrace) {
      // Something did not work out
      int? sessionLogId = 0;
      if (connector.endpoint.logSessions)
        sessionLogId = await server.serverpod.logSession(session.methodCall!.endpointName, session.methodCall!.methodName, session.runningTime, session.queries, session.logs, null, exception.toString(), stackTrace);

      await session.close();
      return ResultInternalServerError(exception.toString(), stackTrace, sessionLogId);
    }
  }

  Object? _formatArg(String? input, Type type, SerializationManager serializationManager) {
    // Check for basic types
    if (type == String)
      return input;
    if (type == int)
      return int.tryParse(input!);
    if (type == double)
      return double.tryParse(input!);
    if (type == bool) {
      if (input == 'true')
        return true;
      else if (input == 'false')
        return false;
      return null;
    }
    if (type == DateTime)
      return DateTime.tryParse(input!);

    try {
      var data = jsonDecode(input!);
      return serializationManager.createEntityFromSerialization(data);
    }
    catch (error) {
      return null;
    }
  }
}

class EndpointConnector {
  final String name;
  final Endpoint endpoint;
  final Map<String, MethodConnector> methodConnectors;

  EndpointConnector({required this.name, required this.endpoint, required this.methodConnectors});
}

typedef Future MethodCall(Session session, Map<String, dynamic> params);

class MethodConnector {
  final String name;
  final Map<String, ParameterDescription> params;
  final MethodCall call;

  MethodConnector({required this.name, required this.params, required this.call});
}

class ParameterDescription {
  final String name;
  final Type type;
  final bool nullable;

  ParameterDescription({required this.name, required this.type, required this.nullable});
}

abstract class Result {}

class ResultInvalidParams extends Result {
  final String errorDescription;
  ResultInvalidParams(this.errorDescription);
  @override
  String toString() {
    return errorDescription;
  }
}

class ResultAuthenticationFailed extends Result {
  final String errorDescription;
  ResultAuthenticationFailed(this.errorDescription);
  @override
  String toString() {
    return errorDescription;
  }
}

class ResultInternalServerError extends Result {
  final String exception;
  final StackTrace stackTrace;
  final int? sessionLogId;
  ResultInternalServerError(this.exception, this.stackTrace, this.sessionLogId);
  @override
  String toString() {
    return '$exception\n$stackTrace';
  }
}

class ResultStatusCode extends Result {
  final int statusCode;
  ResultStatusCode(this.statusCode);
  @override
  String toString() {
    return 'Status Code: $statusCode';
  }
}