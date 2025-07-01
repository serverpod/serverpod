import 'dart:typed_data';

import 'package:serverpod/src/authentication/authentication_info.dart';
import 'package:serverpod/src/authentication/scope.dart';
import 'package:serverpod/src/server/endpoint_parameter_helper.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint.dart';
import 'server.dart';
import 'session.dart';

/// The [EndpointDispatch] is responsible for directing requests to the [Server]
/// to the correct [Endpoint] and method. Typically, this class is overridden
/// by an Endpoints class that is generated.
abstract class EndpointDispatch {
  /// All connectors associating endpoint method names with the actual methods.
  Map<String, EndpointConnector> connectors = {};

  /// References to modules.
  Map<String, EndpointDispatch> modules = {};

  /// Initializes all endpoints that are connected to the dispatch.
  void initializeEndpoints(Server server);

  /// Finds an [EndpointConnector] by its name. If the connector is in a module,
  /// a period should separate the module name from the endpoint name.
  EndpointConnector? getConnectorByName(String endpointName) {
    var endpointComponents = endpointName.split('.');
    if (endpointComponents.isEmpty || endpointComponents.length > 2) {
      return null;
    }

    // Find correct connector
    EndpointConnector? connector;

    if (endpointComponents.length == 1) {
      // This is a standard server endpoint
      connector = connectors[_endpointFromName(endpointName)];
      if (connector == null) return null;
    } else {
      // Connector is in a module
      var modulePackage = endpointComponents[0];
      endpointName = endpointComponents[1];
      var module = modules[modulePackage];
      if (module == null) return null;

      connector = module.connectors[_endpointFromName(endpointName)];
      if (connector == null) return null;
    }

    return connector;
  }

  /// Tries to get a [MethodStreamCallContext] for a given endpoint and method name.
  /// If the method is not found, a [MethodNotFoundException] is thrown.
  /// If the endpoint is not found, an [EndpointNotFoundException] is thrown.
  /// If the user is not authorized to access the endpoint, a [NotAuthorizedException] is thrown.
  /// If the input parameters are invalid, an [InvalidParametersException] is thrown.
  /// If the found method is not a [MethodStreamConnector], an [InvalidEndpointMethodTypeException] is thrown.
  Future<MethodStreamCallContext> getMethodStreamCallContext({
    required Session Function(EndpointConnector connector)
        createSessionCallback,
    required String endpointPath,
    required String methodName,
    required Map<String, dynamic> arguments,
    required SerializationManager serializationManager,
    required List<String> requestedInputStreams,
  }) async {
    var (methodConnector, endpoint, parsedArguments) =
        await _getEndpointMethodConnector(
      createSessionCallback: createSessionCallback,
      endpointPath: endpointPath,
      methodName: methodName,
      arguments: arguments,
      serializationManager: serializationManager,
    );

    if (methodConnector is! MethodStreamConnector) {
      throw InvalidEndpointMethodTypeException(methodName, endpointPath);
    }

    List<StreamParameterDescription> inputStreams = parseRequestedInputStreams(
      descriptions: methodConnector.streamParams,
      requestedInputStreams: requestedInputStreams,
    );

    return MethodStreamCallContext(
      method: methodConnector,
      arguments: parsedArguments,
      inputStreams: inputStreams,
      endpoint: endpoint,
      fullEndpointPath: endpointPath,
    );
  }

  /// Tries to get an [EndpointConnector] for a given endpoint and method name.
  /// If the endpoint is not found, an [EndpointNotFoundException] is thrown.
  /// If the user is not authorized to access the endpoint, a [NotAuthorizedException] is thrown.
  Future<EndpointConnector> getEndpointConnector({
    required Session session,
    required String endpointPath,
  }) async {
    return _getEndpointConnector(endpointPath, (_) => session);
  }

  /// Tries to get a [MethodCallContext] for a given endpoint and method name.
  /// If the method is not found, a [MethodNotFoundException] is thrown.
  /// If the endpoint is not found, an [EndpointNotFoundException] is thrown.
  /// If the user is not authorized to access the endpoint, a [NotAuthorizedException] is thrown.
  /// If the input parameters are invalid, an [InvalidParametersException] is thrown.
  /// If the found method is not a [MethodConnector], an [InvalidEndpointMethodTypeException] is thrown.
  Future<MethodCallContext> getMethodCallContext({
    required Session Function(EndpointConnector connector)
        createSessionCallback,
    required String endpointPath,
    required String methodName,
    required Map<String, dynamic> parameters,
    required SerializationManager serializationManager,
  }) async {
    var (methodConnector, endpoint, parsedArguments) =
        await _getEndpointMethodConnector(
      createSessionCallback: createSessionCallback,
      endpointPath: endpointPath,
      methodName: methodName,
      arguments: parameters,
      serializationManager: serializationManager,
    );

    if (methodConnector is! MethodConnector) {
      throw InvalidEndpointMethodTypeException(methodName, endpointPath);
    }

    return MethodCallContext(
      method: methodConnector,
      arguments: parsedArguments,
      endpoint: endpoint,
    );
  }

  Future<(EndpointMethodConnector, Endpoint, Map<String, dynamic>)>
      _getEndpointMethodConnector({
    required Session Function(EndpointConnector connector)
        createSessionCallback,
    required String endpointPath,
    required String methodName,
    required Map<String, dynamic> arguments,
    required SerializationManager serializationManager,
  }) async {
    var endpointConnector =
        await _getEndpointConnector(endpointPath, createSessionCallback);

    var methodConnector = endpointConnector.methodConnectors[methodName];
    if (methodConnector == null) {
      throw MethodNotFoundException(
          'Method "$methodName" not found in endpoint: $endpointPath');
    }

    var parsedArguments = parseParameters(
      arguments,
      methodConnector.params,
      serializationManager,
    );

    return (methodConnector, endpointConnector.endpoint, parsedArguments);
  }

  Future<EndpointConnector> _getEndpointConnector(
      String endpointPath,
      Session Function(EndpointConnector connector)
          createSessionCallback) async {
    var connector = getConnectorByName(endpointPath);
    if (connector == null) {
      throw EndpointNotFoundException('Endpoint $endpointPath not found');
    }

    var session = createSessionCallback(connector);

    var authenticationFailedResult = await canUserAccessEndpoint(
      () => session.authenticated,
      connector.endpoint.requireLogin,
      connector.endpoint.requiredScopes,
    );
    if (authenticationFailedResult != null) {
      throw NotAuthorizedException(authenticationFailedResult);
    }
    return connector;
  }

  String _endpointFromName(String name) {
    var components = name.split('/');
    return components[0];
  }

  /// Checks if a user can access an [Endpoint]. If access is granted null is
  /// returned, otherwise a [ResultAuthenticationFailed] describing the issue is
  /// returned.
  static Future<ResultAuthenticationFailed?> canUserAccessEndpoint(
    Future<AuthenticationInfo?> Function() authInfoProvider,
    bool requiresLogin,
    Set<Scope> requiredScopes,
  ) async {
    var authenticationRequired = requiresLogin || requiredScopes.isNotEmpty;

    if (!authenticationRequired) {
      return null;
    }

    var info = await authInfoProvider();
    if (info == null) {
      return ResultAuthenticationFailed.unauthenticated(
        'No valid authentication provided',
      );
    }

    var missingUserScopes = Set.from(requiredScopes)..removeAll(info.scopes);

    if (missingUserScopes.isNotEmpty) {
      return ResultAuthenticationFailed.insufficientAccess(
        'User is missing required scope${missingUserScopes.length > 1 ? 's' : ''}: $missingUserScopes',
      );
    }

    return null;
  }

  /// Parses a list of requested input stream parameter descriptions and returns
  /// a list of stream parameter descriptions.
  ///
  /// Throws an exception if a required input stream parameter is missing.
  static List<StreamParameterDescription> parseRequestedInputStreams({
    required Map<String, StreamParameterDescription> descriptions,
    required List<String> requestedInputStreams,
  }) {
    var streamDescriptions = <StreamParameterDescription>[];
    for (var description in descriptions.values) {
      if (requestedInputStreams.contains(description.name)) {
        streamDescriptions.add(description);
      } else if (!description.nullable) {
        throw InvalidParametersException(
            'Missing required stream parameter: ${description.name}');
      }
    }

    return streamDescriptions;
  }
}

/// The [EndpointConnector] associates a name with and endpoint and its
/// [EndpointMethodConnector]s.
class EndpointConnector {
  /// Name of the [Endpoint].
  final String name;

  /// Reference to the [Endpoint].
  final Endpoint endpoint;

  /// All [EndpointMethodConnector]s associated with the [Endpoint].
  final Map<String, EndpointMethodConnector> methodConnectors;

  /// Creates a new [EndpointConnector].
  EndpointConnector({
    required this.name,
    required this.endpoint,
    required this.methodConnectors,
  });
}

/// Calls a named method referenced in a [MethodConnector].
typedef MethodCall = Future Function(
    Session session, Map<String, dynamic> params);

/// The [EndpointMethodConnector] is a base class for connectors that connect
/// methods their implementation.
abstract class EndpointMethodConnector {
  /// The name of the method.
  final String name;

  /// List of parameters used by the method.
  final Map<String, ParameterDescription> params;

  /// Creates a new [EndpointMethodConnector].
  EndpointMethodConnector({
    required this.name,
    required this.params,
  });
}

/// The [MethodConnector] hooks up a method with its name and the actual call
/// to the method.
class MethodConnector extends EndpointMethodConnector {
  /// A function that performs a call to the named method.
  final MethodCall call;

  /// True if the method returns void.
  /// If null, no assumption can be made about the return value.
  final bool? returnsVoid;

  /// Creates a new [MethodConnector].
  MethodConnector({
    required super.name,
    required super.params,
    required this.call,
    this.returnsVoid,
  });
}

/// Context for a [MethodConnector] call
class MethodCallContext {
  /// The method to call.
  final MethodConnector method;

  /// The arguments to pass to the method.
  final Map<String, dynamic> arguments;

  /// The endpoint the method is called on.
  final Endpoint endpoint;

  /// Creates a new [MethodCallContext].
  MethodCallContext({
    required this.method,
    required this.arguments,
    required this.endpoint,
  });
}

/// Context for a [MethodStreamConnector] call
class MethodStreamCallContext {
  /// The method to call.
  final MethodStreamConnector method;

  /// The arguments to pass to the method.
  final Map<String, dynamic> arguments;

  /// The endpoint the method is called on.
  final Endpoint endpoint;

  /// The full path to the endpoint, including module.
  final String fullEndpointPath;

  /// The input streams to pass to the method.
  final List<StreamParameterDescription> inputStreams;

  /// Creates a new [MethodStreamCallContext].
  MethodStreamCallContext({
    required this.method,
    required this.arguments,
    required this.inputStreams,
    required this.endpoint,
    required this.fullEndpointPath,
  });
}

/// Calls a named method referenced in a [MethodStreamConnector].
typedef MethodStream = dynamic Function(
  Session session,
  Map<String, dynamic> params,
  Map<String, Stream<dynamic>> streamParams,
);

/// The type of return value from a [MethodStreamConnector].
enum MethodStreamReturnType {
  /// The method returns a single value as a future.
  futureType,

  /// The method returns a stream of values.
  streamType,

  /// The method has future void return value.
  voidType,
}

/// The [MethodStreamConnector] hooks up a method with its name and
/// implementation. The method communicates with the client using a websocket
/// connection. Enabling support for streaming return values or parameters.
class MethodStreamConnector extends EndpointMethodConnector {
  /// The type of return value from the method.
  final MethodStreamReturnType returnType;

  /// List of parameter streams used by the method.
  final Map<String, StreamParameterDescription> streamParams;

  /// A function that performs a call to the named method.
  final MethodStream call;

  /// Creates a new [MethodStreamConnector].
  MethodStreamConnector({
    required super.name,
    required super.params,
    required this.returnType,
    required this.streamParams,
    required this.call,
  });
}

/// Defines a parameter in a [MethodConnector].
class ParameterDescription {
  /// The name of the parameter.
  final String name;

  /// The Dart type of the parameter.
  final Type type;

  /// True if the parameter can be nullable.
  final bool nullable;

  /// Creates a new [ParameterDescription].
  ParameterDescription(
      {required this.name, required this.type, required this.nullable});
}

/// Description of a stream parameter.
class StreamParameterDescription<T> {
  /// The name of the parameter.
  final String name;

  /// The type of the parameter.
  final Type type = T;

  /// True if the parameter can be nullable.
  final bool nullable;

  /// Creates a new [StreamParameterDescription].
  StreamParameterDescription({required this.name, required this.nullable});
}

/// The [Result] of an [Endpoint] method call.
abstract class Result {}

/// A successful result from an [Endpoint] method call containing the return
/// value of the call.
class ResultSuccess extends Result {
  /// The returned value of a successful [Endpoint] method call.
  final dynamic returnValue;

  /// True if [ByteData] should not be embedded in API serialization.
  final bool sendByteDataAsRaw;

  /// Creates a new successful result with a value.
  ResultSuccess(this.returnValue, {this.sendByteDataAsRaw = false});
}

/// The result of a failed [Endpoint] method call where the parameters where not
/// valid.
class ResultInvalidParams extends Result {
  /// Description of the error.
  final String errorDescription;

  /// Creates a new [ResultInvalidParams] object.
  ResultInvalidParams(this.errorDescription);

  @override
  String toString() {
    return errorDescription;
  }
}

/// The result of a failed [Endpoint] method call where the
/// endpoint was not found.
class ResultNoSuchEndpoint extends Result {
  /// Description of the error.
  final String errorDescription;

  /// Creates a new [ResultNoSuchEndpoint] object.
  ResultNoSuchEndpoint(this.errorDescription);

  @override
  String toString() {
    return errorDescription;
  }
}

/// The result of a failed [EndpointDispatch.getMethodStreamCallContext],
/// [EndpointDispatch.getMethodCallContext] or [EndpointDispatch.getEndpointConnector] call.
abstract class EndpointDispatchException implements Exception {
  /// Description of the error.
  String get message;

  @override
  String toString() {
    return 'Endpoint dispatch error: $message';
  }
}

/// The user is not authorized to access the endpoint.
class NotAuthorizedException extends EndpointDispatchException {
  @override
  String message;

  /// The result of the failed authentication.
  ResultAuthenticationFailed authenticationFailedResult;

  /// Creates a new [NotAuthorizedException].
  NotAuthorizedException(this.authenticationFailedResult,
      {this.message = 'Not authorized'});
}

/// The endpoint was not found.
class EndpointNotFoundException extends EndpointDispatchException {
  @override
  String message = 'Endpoint not found';

  /// Creates a new [EndpointNotFoundException].
  EndpointNotFoundException(this.message);
}

/// The endpoint method was not found.
class MethodNotFoundException extends EndpointDispatchException {
  @override
  String message = 'Method not found';

  /// Creates a new [MethodNotFoundException].
  MethodNotFoundException(this.message);
}

/// The found endpoint method was not of the expected type.
class InvalidEndpointMethodTypeException extends EndpointDispatchException {
  @override
  String get message =>
      'Endpoint method $_methodName in $_endpointPath is not of the expected type.';

  final String _methodName;
  final String _endpointPath;

  /// Creates a new [InvalidEndpointMethodTypeException].

  InvalidEndpointMethodTypeException(this._methodName, this._endpointPath);
}

/// The input parameters were invalid.
class InvalidParametersException extends EndpointDispatchException {
  @override
  String message = 'Invalid parameters';

  /// Creates a new [InvalidParametersException].
  InvalidParametersException(this.message);
}

/// The type of failures that can occur during authentication.
enum AuthenticationFailureReason {
  /// No valid authentication key was provided.
  unauthenticated,

  /// The authentication key provided did not have sufficient access.
  insufficientAccess,
}

/// The result of a failed [Endpoint] method call where authentication failed.
class ResultAuthenticationFailed extends Result {
  /// Description of the error.
  final String errorDescription;

  /// The reason why the authentication failed.
  final AuthenticationFailureReason reason;

  /// Creates a new [ResultAuthenticationFailed] object.
  ResultAuthenticationFailed._(this.errorDescription, this.reason);

  /// Creates a new [ResultAuthenticationFailed] object when the user failed to
  /// provide a valid authentication key.
  factory ResultAuthenticationFailed.unauthenticated(String message) =>
      ResultAuthenticationFailed._(
        message,
        AuthenticationFailureReason.unauthenticated,
      );

  /// Creates a new [ResultAuthenticationFailed] object when the user provided
  /// an authentication key that did not have sufficient access.
  factory ResultAuthenticationFailed.insufficientAccess(String message) =>
      ResultAuthenticationFailed._(
        message,
        AuthenticationFailureReason.insufficientAccess,
      );

  @override
  String toString() {
    return errorDescription;
  }
}

/// The result of a failed [Endpoint] method call where an [Exception] was
/// thrown during execution of the method.
class ResultInternalServerError extends Result {
  /// The Exception that was thrown.
  final String exception;

  /// Stack trace when the exception occurred.
  final StackTrace stackTrace;

  /// The session log id.
  final int? sessionLogId;

  /// Creates a new [ResultInternalServerError].
  ResultInternalServerError(this.exception, this.stackTrace, this.sessionLogId);

  @override
  String toString() {
    return '$exception\n$stackTrace';
  }
}

/// The result of a failed [Endpoint] method call, with a custom status code,
/// and an optional message.
class ResultStatusCode extends Result {
  /// The status code to be returned to the client.
  final int statusCode;

  /// Message / description of the error.
  final String? message;

  /// Creates a new [ResultStatusCode].
  ResultStatusCode(this.statusCode, [this.message]);

  @override
  String toString() {
    return 'Status Code: $statusCode${message != null ? ': $message' : ''}';
  }
}

/// The result of a failed [Endpoint] method call, with a custom exception.
class ExceptionResult<T extends SerializableException> extends Result {
  /// The exception to be returned to the client.
  final T model;

  /// Creates a new [ExceptionResult].
  ExceptionResult({
    required this.model,
  });

  @override
  String toString() => 'ExceptionResult(entity: $model)';
}
