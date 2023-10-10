import 'package:serverpod_cli/analyzer.dart';

String createHiddenFieldName(
  bool serverCode,
  SerializableEntityFieldDefinition field,
) {
  if (field.hiddenSerializableField(serverCode)) {
    return createImplicitFieldName(field.name);
  }

  return field.name;
}

String createImplicitFieldName(String fieldName) {
  return '\$$fieldName';
}
