import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'package:serverpod/src/authentication/scope.dart';
import 'server.dart';
import 'session.dart';
import '../database/database.dart';

abstract class Endpoint {
  String get name;

  final _methods = <String, _Method>{};

  Server _server;
  Server get server => _server;

  Database get database => _server.database;

  List<Scope> get allowedScopes => [scopeAny];

  Endpoint(Server server) {
    _server = server;
    _server.addEndpoint(this);

    // Find remotely callable methods, first argument should be a Session object
    final mirror = reflect(this);
    ClassMirror classMirror = reflectClass(this.runtimeType);

    for (Symbol methodSymbol in classMirror.instanceMembers.keys) {
      MethodMirror methodMirror = classMirror.instanceMembers[methodSymbol];

      if (methodMirror.parameters.length >= 1 &&
          !methodMirror.parameters[0].isOptional &&
          !methodMirror.parameters[0].isNamed &&
          methodMirror.parameters[0].type.reflectedType == Session) {

        ClosureMirror closureMirror = mirror.getField(methodSymbol);
        var method = _Method(methodSymbol, closureMirror, server);
        _methods[method.name] = method;
      }
    }
  }

  Future handleUriCall(Uri uri) async {
    List callArgs = [];

    var inputs = uri.queryParameters;

    String auth = inputs['auth'];
    String methodName = inputs['method'];

    if (methodName == null)
      return ResultInvalidParams('method missing in call: $uri');

    var method = _methods[methodName];
    if (method == null)
      return ResultInvalidParams('Method $methodName not found in call: $uri');

    // Always add the session as the first argument
    callArgs.add(
      Session(
        server: server,
        authenticationKey: auth,
      ),
    );

    // Check required parameters
    for (final requiredParam in method.paramsRequired) {
      if (requiredParam.type == Session)
        continue;

      // Check that it exists
      String input = inputs[requiredParam.name];
      if (input == null)
        return ResultInvalidParams('Parameter ${requiredParam.name} is missing in call: $uri');

      // Validate argument
      Object arg = _formatArg(input, requiredParam, server.serializationManager);
      if (arg == null)
        return ResultInvalidParams('Parameter ${requiredParam.name} has invalid type: $uri');

      // Add to call list
      callArgs.add(arg);
    }

    // Check optional parameters
    for (final optionalParam in method.paramsOptional) {
      // Check if it exists
      String input = inputs[optionalParam.name];
      if (input == null)
        continue;

      // Validate argument
      Object arg = _formatArg(input, optionalParam, server.serializationManager);
      if (arg == null)
        return ResultInvalidParams('Parameter ${optionalParam.name} has invalid type: $uri');

      // Add to call list
      callArgs.add(arg);
    }

    // Call handleCall method
    return method.callMirror.apply(callArgs).reflectee;
  }

  Object _formatArg(String input, _Parameter paramDef, SerializationManager serializationManager) {
    // Check for basic types
    if (paramDef.type == String)
      return input;
    if (paramDef.type == int)
      return int.tryParse(input);

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

abstract class Result {
}

class ResultInvalidParams extends Result {
  final String errorDescription;
  ResultInvalidParams(this.errorDescription);
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

    assert(type == Session || type == int || type == String || serializationManager.constructors[type.toString()] != null);
  }

  String name;
  Type type;

  @override
  String toString() {
    return '$name ($type)';
  }
}