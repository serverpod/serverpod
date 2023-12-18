import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
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

  static List<SerializableModelFieldDefinition> filterRelationByName(
    ClassDefinition classDefinition,
    ClassDefinition foreignClass,
    String relationFieldName,
    String? relationName,
  ) {
    if (relationName == null) return [];

    Iterable<SerializableModelFieldDefinition> fields = foreignClass.fields;

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
