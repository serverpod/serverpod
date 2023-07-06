import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:source_span/source_span.dart';

class ValidateNode {
  /// The key of the node.
  String key;

  /// If true, the key must be present in the document.
  bool isRequired;

  /// If set, the key must match the restriction, add any errors to the collector.
  /// Should only be used together with a [Keyword.any].
  List<SourceSpanException>? Function(String, SourceSpan?)? keyRestriction;

  /// If set, the value must match the restriction, add any errors to the collector.
  List<SourceSpanException>? Function(dynamic, SourceSpan?)? valueRestriction;

  // A set of keys that are mutually exclusive with this key.
  late Set<String> mutuallyExclusiveKeys;

  /// If true, the value can be a stringified comma seperated version of
  /// the nested value. Will assume the first value in the nested Set is the first
  /// value in the stringified version and does not require the key to be present.
  /// All other values in the nested Set must have the key defined in the stringified
  /// version and be written like this: key=value, key2=value2, etc.
  /// The order of key and key2 does not matter.
  /// Full example: nodeKey: firstValue, key=value, key2=value2.
  bool allowStringifiedNestedValue;

  /// Any nested nodes for this key, setting any node here means the expected
  /// value is a YamlMap, unless allowStringifiedNestedValue is true.
  Set<ValidateNode> nested;

  ValidateNode(
    this.key, {
    this.isRequired = false,
    this.keyRestriction,
    this.valueRestriction,
    this.mutuallyExclusiveKeys = const {},
    this.allowStringifiedNestedValue = false,
    this.nested = const {},
  }) {
    if (allowStringifiedNestedValue && nested.isEmpty) {
      throw ArgumentError(
          'allowStringifiedNestedValue can only be true if nested is not empty.');
    }

    if (key != Keyword.any && keyRestriction != null) {
      throw ArgumentError(
          'keyRestriction can only be set if key is ${Keyword.any}.');
    }
  }
}
