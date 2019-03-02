import 'dart:mirrors';

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
        _paramsOptional.add(_Parameter(parameter));
      else
        _paramsRequired.add(_Parameter(parameter));
    }
  }

  Future<Result> handleUriCall(Uri uri) async {
    List callArgs = [];

    var inputs = uri.queryParameters;

    // Check required parameters
    for (final rParam in _paramsRequired) {
      // Check that it exists
      String input = inputs[rParam.name];
      if (input == null)
        return ResultInvalidParams();

      // Validate argument
      Object arg = _formatArg(input, rParam);
      if (arg == null)
        return ResultInvalidParams();

      // Add to call list
      callArgs.add(arg);
    }

    // Check optional parameters
    for (final oParam in _paramsOptional) {
      // Check if it exists
      String input = inputs[oParam.name];
      if (input == null)
        continue;

      // Validate argument
      Object arg = _formatArg(input, oParam);
      if (arg == null)
        return ResultInvalidParams();

      // Add to call list
      callArgs.add(arg);
    }

    // Call handleCall method
    return _handleCallMirror.apply(callArgs).reflectee;
  }

  Object _formatArg(String input, _Parameter paramDef) {
    if (paramDef.type == String)
      return input;
    if (paramDef.type == int)
      return int.tryParse(input);
  }
}

abstract class Result {
}

class ResultInvalidParams extends Result {
}

class ResultSuccess extends Result {
  final Object data;

  ResultSuccess([this.data]);

  String formatData() => data.toString();
}

class _Parameter {
  _Parameter(ParameterMirror parameterMirror) {
    type = parameterMirror.type.reflectedType;
    name = MirrorSystem.getName(parameterMirror.simpleName);
    assert(type == int || type == String);
  }

  String name;
  Type type;

  @override
  String toString() {
    return '$name ($type)';
  }
}