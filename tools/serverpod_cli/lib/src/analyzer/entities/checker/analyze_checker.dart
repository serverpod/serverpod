import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:yaml/yaml.dart';

class AnalyzeChecker {
  static bool isIdType(dynamic type) {
    if (type is! String) return false;

    return type == 'int' || type == 'int?';
  }

  static bool isParentDefined(dynamic node) {
    if (node is! YamlMap) return false;
    return node.containsKey(Keyword.parent);
  }

  static bool isOptionalDefined(dynamic node) {
    if (node is! YamlMap) return false;
    return node.containsKey(Keyword.optional);
  }

  static List<SerializableEntityFieldDefinition> filterRelationByName(
    ClassDefinition classDefinition,
    ClassDefinition foreignClass,
    String relationFieldName,
    String? relationName,
  ) {
    if (relationName == null) return [];

    Iterable<SerializableEntityFieldDefinition> fields = foreignClass.fields;

    if (foreignClass.tableName == classDefinition.tableName) {
      fields = fields.where((referenceField) {
        return referenceField.name != relationFieldName;
      });
    }

    return fields.where((referenceField) {
      return referenceField.relation?.name == relationName;
    }).toList();
  }
}
