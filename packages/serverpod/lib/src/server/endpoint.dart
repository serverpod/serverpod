import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'server.dart';
import '../database/database.dart';

abstract class Endpoint {
  String get name;

  final _paramsRequired = <_Parameter>[];
  final _paramsOptional = <_Parameter>[];

  Server _server;
  Server get server => _server;

  Database get database => _server.database;

  ClosureMirror _handleCallMirror;

  Endpoint(Server server) {
    _server = server;
    _server.addEndpoint(this);

    // Find parameters for handleCall function
    final mirror = reflect(this);

    try {
      _handleCallMirror = mirror.getField(Symbol('handleCall'));
    }
    catch(_) {};
    assert(_handleCallMirror != null, 'Missing handeCall method in Endpoint $name');

    final parameters = _handleCallMirror.function.parameters;

    for (ParameterMirror parameter in parameters) {
      if (parameter.isOptional)
        _paramsOptional.add(_Parameter(parameter, _server.serializationManager));
      else
        _paramsRequired.add(_Parameter(parameter, _server.serializationManager));
    }
  }

  Future<Result> handleUriCall(Uri uri) async {
    List callArgs = [];

    var inputs = uri.queryParameters;

    // Check required parameters
    for (final requiredParam in _paramsRequired) {
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
    for (final optionalParam in _paramsOptional) {
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
    return _handleCallMirror.apply(callArgs).reflectee;
  }

  Object _formatArg(String input, _Parameter paramDef, SerializationManager serializationManager) {
    // Check for basic types
    if (paramDef.type == String)
      return input;
    if (paramDef.type == int)
      return int.tryParse(input);

    try {
      var data = jsonDecode(input);
      serializationManager.createEntityFromSerialization(data);
    }
    catch (_) {
      return null;
    }
    return null;
  }

  void printDefinition() {
    stdout.writeln('$name:');
    stdout.writeln('  requiredParameters:');
    for (var param in _paramsRequired) {
      stdout.writeln('    - ${param.name}: ${param.type}');
    }
    stdout.writeln('  optionalParameters:');
    for (var param in _paramsOptional) {
      stdout.writeln('    - ${param.name}: ${param.type}');
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

class ResultSuccess extends Result {
  final Object data;

  ResultSuccess([this.data]);

  String formatData() => data.toString();
}

class _Parameter {
  _Parameter(ParameterMirror parameterMirror, SerializationManager serializationManager) {
    type = parameterMirror.type.reflectedType;
    name = MirrorSystem.getName(parameterMirror.simpleName);

    assert(type == int || type == String || serializationManager.constructors[type.toString()] != null);
  }

  String name;
  Type type;

  @override
  String toString() {
    return '$name ($type)';
  }
}