import 'package:analyzer/dart/element/element.dart';

import 'class_generator_dart.dart';
import 'types.dart';

class ProtocolDefinition {
  final List<EndpointDefinition> endpoints;
  final List<String> filePaths;

  ProtocolDefinition({
    required this.endpoints,
    required this.filePaths,
  });
}

class EndpointDefinition {
  final String name;
  final String? documentationComment;
  final String className;
  final String fileName;
  final List<MethodDefinition> methods;

  EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.fileName,
  });
}

class MethodDefinition {
  final String name;
  final String? documentationComment;
  final TypeDefinition returnType;
  final List<ParameterDefinition> parameters;
  final List<ParameterDefinition> parametersPositional;
  final List<ParameterDefinition> parametersNamed;

  MethodDefinition(
      {required this.name,
      required this.documentationComment,
      required this.parameters,
      required this.parametersPositional,
      required this.parametersNamed,
      required this.returnType});
}

class ParameterDefinition {
  final String name;
  final TypeDefinition type;
  final bool required;
  final ParameterElement? dartParameter;

  ParameterDefinition({
    required this.name,
    required this.type,
    required this.required,
    this.dartParameter,
  });
}

class IndexDefinition {
  final String name;
  late final List<String> fields;
  late final String type;
  late final bool unique;

  IndexDefinition(this.name, Map doc) {
    String fieldsStr = doc['fields'];
    fields = fieldsStr.split(',').map((String str) => str.trim()).toList();
    type = doc['type'] ?? 'btree';
    unique = (doc['unique'] ?? 'false') != 'false';
  }

  IndexDefinition.parsed({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
  });
}

abstract class ProtocolFileDefinition {
  final String fileName;
  final String className;
  final String? subDir;

  ProtocolFileDefinition({
    required this.fileName,
    required this.className,
    this.subDir,
  });
}

class ClassDefinition extends ProtocolFileDefinition {
  final String? tableName;
  final List<FieldDefinition> fields;
  final List<IndexDefinition>? indexes;

  ClassDefinition({
    required super.fileName,
    required super.className,
    required this.fields,
    this.tableName,
    this.indexes,
    super.subDir,
  });
}

class EnumDefinition extends ProtocolFileDefinition {
  List<String> values;

  EnumDefinition({
    required super.fileName,
    required super.className,
    required this.values,
    super.subDir,
  });
}
