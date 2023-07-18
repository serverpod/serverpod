import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:source_span/source_span.dart';

class ValidateNode {
  /// The key of the node.
  String key;

  /// If true, the key must be present in the document.
  bool isRequired;

  // If true, the key will be marked as deprecated with a warning.
  bool isDeprecated;

  // If true, the key will be marked as deprecated with an error.
  bool isRemoved;

  /// Set to communicate what the alternative implementation of a deprecated
  /// value is.
  String alternativeUsageMessage;

  /// If set, the key must match the restriction if an error is returned the key
  /// is considered invalid.
  /// Should only be used together with a [Keyword.any].
  List<SourceSpanException>? Function(String, SourceSpan?)? keyRestriction;

  /// If set, the value must match the restriction if an error is returned the
  /// value is considered invalid.
  List<SourceSpanException>? Function(dynamic, SourceSpan?)? valueRestriction;

  // A set of keys that are mutually exclusive with this key.
  late Set<String> mutuallyExclusiveKeys;

  /// If true, the value can be a stringified comma separated version of
  /// the nested value. If implicitFirstKey is used, then assume the first value
  /// in the nested Set is the first value in the stringified version and does
  /// not require the key to be present. All other values in the nested Set must
  /// have the key defined in the stringified version and be written like
  /// this: key=value, key2=value2, etc.
  /// The order of key and key2 does not matter.
  /// Full example: nodeKey: firstValue, key=value, key2=value2.
  StringifiedNestedValues allowStringifiedNestedValue;

  /// Any nested nodes for this key, setting any node here means the expected
  /// value is a YamlMap, unless allowStringifiedNestedValue is true.
  Set<ValidateNode> nested;

  ValidateNode(
    this.key, {
    this.isRequired = false,
    this.isDeprecated = false,
    this.isRemoved = false,
    this.alternativeUsageMessage = '',
    this.keyRestriction,
    this.valueRestriction,
    this.mutuallyExclusiveKeys = const {},
    this.allowStringifiedNestedValue = const StringifiedNestedValues(),
    this.nested = const {},
  }) {
    if (allowStringifiedNestedValue.isAllowed && nested.isEmpty) {
      throw ArgumentError(
          'allowStringifiedNestedValue can only be true if nested is not empty.');
    }

    if (key != Keyword.any && keyRestriction != null) {
      throw ArgumentError(
          'keyRestriction can only be set if key is ${Keyword.any}.');
    }
  }
}

class StringifiedNestedValues {
  /// Allow nested values to be written as a stringified version of the nested nodes.
  final bool isAllowed;

  /// If true, the first value in the nested Set is the first value in the
  /// stringified version and does not require the key to be present.
  final bool hasImplicitFirstKey;

  const StringifiedNestedValues({
    this.isAllowed = false,
    this.hasImplicitFirstKey = false,
  });
}
