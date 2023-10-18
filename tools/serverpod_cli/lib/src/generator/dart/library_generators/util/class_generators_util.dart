import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/shared.dart';

String createFieldName(
  bool serverCode,
  SerializableEntityFieldDefinition field,
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
  return TypeReference(
    (t) => t
      ..symbol = 'WhereExpressionBuilder'
      ..types.addAll([
        refer('${className}Table'),
      ])
      ..url = serverpodUrl(serverCode)
      ..isNullable = nullable,
  );
}
