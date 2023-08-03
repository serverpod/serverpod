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
}
