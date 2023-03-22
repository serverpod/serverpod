import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

import '../util/extensions.dart';
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
  final String? subDir;

  EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.fileName,
    required this.subDir,
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
  final bool serverOnly;

  ProtocolFileDefinition({
    required this.fileName,
    required this.className,
    required this.serverOnly,
    this.subDir,
  });

  /// Generate the file reference [String] to this file.
  String fileRef() {
    return p.posix
        // ignore: prefer_interpolation_to_compose_strings
        .joinAll(p.split('${(subDir + '/') ?? ''}$fileName.dart'));
  }
}

class ClassDefinition extends ProtocolFileDefinition {
  final String? tableName;
  final List<FieldDefinition> fields;
  final List<IndexDefinition>? indexes;
  final List<String>? documentation;
  final bool isException;

  ClassDefinition({
    required super.fileName,
    required super.className,
    required this.fields,
    required super.serverOnly,
    required this.isException,
    this.tableName,
    this.indexes,
    super.subDir,
    this.documentation,
  });
}

class EnumDefinition extends ProtocolFileDefinition {
  List<EnumValueDefinition> values;
  final List<String>? documentation;

  EnumDefinition({
    required super.fileName,
    required super.className,
    required this.values,
    required super.serverOnly,
    super.subDir,
    this.documentation,
  });
}

class EnumValueDefinition {
  final String name;
  final List<String>? documentation;

  EnumValueDefinition(this.name, [this.documentation]);
}
