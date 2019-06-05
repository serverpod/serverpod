import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'package:serverpod/src/authentication/scope.dart';
import 'server.dart';
import 'session.dart';
import '../database/database.dart';

abstract class Endpoint {
  String _name;
  String get name => _name;

  final _methods = <String, _Method>{};

  Server _server;
  Server get server => _server;

  Database get database => _server.database;

  List<Scope> get allowedScopes => [scopeAny];

  bool get requireLogin => false;

  void initialize(Server server, String name) {
    _server = server;
    _name = name;

    // Find remotely callable methods, first argument should be a Session object
    final mirror = reflect(this);
    ClassMirror classMirror = reflectClass(this.runtimeType);

    for (Symbol methodSymbol in classMirror.instanceMembers.keys) {
      MethodMirror methodMirror = classMirror.instanceMembers[methodSymbol];

      var methodName = MirrorSystem.getName(methodSymbol);

      if (methodMirror.parameters.length >= 1 &&
          !methodMirror.parameters[0].isOptional &&
          !methodMirror.parameters[0].isNamed &&
          methodMirror.parameters[0].type.reflectedType == Session &&
          !methodName.startsWith('_')) {

        ClosureMirror closureMirror = mirror.getField(methodSymbol);
        var method = _Method(methodSymbol, closureMirror, server);
        _methods[method.name] = method;
      }
    }
  }

  Future handleUriCall(Uri uri) async {
    List callArgs = [];

    Session session = Session(
      server: server,
      uri: uri,
      endpointName: name,
    );

    var methodName = session.methodName;
    var auth = session.authenticationKey;
    var inputParams = session.queryParameters;

    if (methodName == null)
      return ResultInvalidParams('method missing in call: $uri');

    if (requireLogin) {
      if (auth == null)
        return ResultAuthenticationFailed('No authentication provided');
      if (!await session.isUserSignedIn)
        return ResultAuthenticationFailed('Authentication failed');
    }

    var method = _methods[methodName];
    if (method == null)
      return ResultInvalidParams('Method $methodName not found in call: $uri');

    // Always add the session as the first argument
    callArgs.add(session);

    // Check required parameters
    for (final requiredParam in method.paramsRequired) {
      if (requiredParam.type == Session)
        continue;

      // Check that it exists
      String input = inputParams[requiredParam.name];
      Object arg;

      // Validate argument
      if (input != null) {
        arg = _formatArg(input, requiredParam, server.serializationManager);
        if (arg == null)
          return ResultInvalidParams('Parameter ${requiredParam.name} has invalid type: $uri value: $input');
      }

      // Add to call list
      callArgs.add(arg);
    }

    // Check optional parameters
    for (final optionalParam in method.paramsOptional) {
      // Check if it exists
      String input = inputParams[optionalParam.name];
      if (input == null)
        continue;

      // Validate argument
      Object arg = _formatArg(input, optionalParam, server.serializationManager);
      if (arg == null)
        return ResultInvalidParams('Optional parameter ${optionalParam.name} has invalid type: $uri');

      // Add to call list
      callArgs.add(arg);
    }

    // Call handleCall method
    var result = await method.callMirror.apply(callArgs).reflectee;

    // Print session info
    server.logDebug('CALL: ${session.endpointName}.${session.methodName} time: ${session.runningTime.inMilliseconds}ms numQueries: ${session.queries.length}');

    return result;
  }

  Object _formatArg(String input, _Parameter paramDef, SerializationManager serializationManager) {
    // Check for basic types
    if (paramDef.type == String)
      return input;
    if (paramDef.type == int)
      return int.tryParse(input);
    if (paramDef.type == double)
      return double.tryParse(input);
    if (paramDef.type == bool) {
      if (input == 'true')
        return true;
      else if (input == 'false')
        return false;
      return null;
    }
    if (paramDef.type == DateTime)
      return DateTime.tryParse(input);

    try {
      var data = jsonDecode(input);
      return serializationManager.createEntityFromSerialization(data);
    }
    catch (error) {
      return null;
    }
  }

  void printDefinition() {
    stdout.writeln('$name:');

    for (var methodName in _methods.keys) {
      var method = _methods[methodName];

      stdout.writeln('  ${methodName}:');
      stdout.writeln('    requiredParameters:');
      for (var param in method.paramsRequired) {
        if (param.type == Session)
          continue;
        stdout.writeln('      - ${param.name}: ${param.type}');
      }
      stdout.writeln('    optionalParameters:');
      for (var param in method.paramsOptional) {
        stdout.writeln('      - ${param.name}: ${param.type}');
      }
      stdout.writeln('    namedParameters:');
      for (var param in method.paramsNamed) {
        stdout.writeln('      - ${param.name}: ${param.type}');
      }
      stdout.writeln('    returnType: ${method.returnType}');
    }
  }
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

class _Method {
  String name;
  Type returnType;
  final paramsRequired = <_Parameter>[];
  final paramsOptional = <_Parameter>[];
  final paramsNamed = <_Parameter>[];
  ClosureMirror callMirror;

  _Method(Symbol symbol, ClosureMirror closureMirror, Server server) {
    final parameters = closureMirror.function.parameters;

    for (ParameterMirror parameter in parameters) {
      if (parameter.isOptional)
        paramsOptional.add(_Parameter(parameter, server.serializationManager));
      else if (parameter.isNamed)
        paramsNamed.add(_Parameter(parameter, server.serializationManager));
      else
        paramsRequired.add(_Parameter(parameter, server.serializationManager));
    }

    assert(paramsRequired.length >= 1 && paramsRequired[0].type == Session, 'First parameter in handleCall method in Endpoint $name must be a Session object');

    returnType = closureMirror.function.returnType.reflectedType;

    name = MirrorSystem.getName(symbol);
    callMirror = closureMirror;
  }
}

class _Parameter {
  _Parameter(ParameterMirror parameterMirror, SerializationManager serializationManager) {
    type = parameterMirror.type.reflectedType;
    name = MirrorSystem.getName(parameterMirror.simpleName);

    assert(type == Session || type == int || type == double || type == bool || type == String || type == DateTime || serializationManager.constructors[type.toString()] != null, 'Unserializable type $type');
  }

  String name;
  Type type;

  @override
  String toString() {
    return '$name ($type)';
  }
}