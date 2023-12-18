import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/shared.dart';

String createFieldName(
  bool serverCode,
  SerializableModelFieldDefinition field,
) {
  if (field.hiddenSerializableField(serverCode)) {
    return createImplicitFieldName(field.name);
  }

  return field.name;
}

String createForeignFieldName(ListRelationDefinition relation) {
  if (relation.implicitForeignField) {
    return createImplicitFieldName(relation.foreignFieldName);
  }

  return relation.foreignFieldName;
}

String createImplicitFieldName(String fieldName) {
  return '\$$fieldName';
}

TypeReference typeWhereExpressionBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'WhereExpressionBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByListBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByListBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference _typeWithTableCallback(
  String className,
  String typeName,
  bool serverCode, {
  nullable = true,
}) {
  return TypeReference(
    (t) => t
      ..symbol = typeName
      ..types.addAll([
        refer('${className}Table'),
      ])
      ..url = serverpodUrl(serverCode)
      ..isNullable = nullable,
  );
}
