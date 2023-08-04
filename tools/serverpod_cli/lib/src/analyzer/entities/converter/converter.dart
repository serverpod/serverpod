import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

// ignore: implementation_imports
import 'package:yaml/src/equality.dart';

List<String> convertIndexList(String stringifiedFields) {
  return stringifiedFields.split(',').map((field) => field.trim()).toList();
}

T convertToEnum<T extends Enum>({
  required String value,
  required T enumDefault,
  required List<T> enumValues,
}) {
  return enumValues.firstWhere(
    (v) => v.name.toLowerCase() == value.toLowerCase(),
    orElse: () => enumDefault,
  );
}

typedef DeepNestedNodeHandler = YamlMap Function(
    String? content, SourceSpan span);

YamlMap convertStringifiedNestedNodesToYamlMap(
  String? content,
  SourceSpan span, {
  String? firstKey,
  void Function(String key, SourceSpan? span)? onDuplicateKey,
  void Function(String key, SourceSpan? span)? onNegatedKeyWithValue,
}) {
  var stringifiedNodes = _extractStringifiedNodes(content);

  Map<dynamic, YamlNode> initNodes = _extractInitialNode(
    firstKey,
    stringifiedNodes,
    content,
    span,
  );

  var startNodeIndex = initNodes.length;
  var fieldKeyValuePairs = _extractKeyValuePairs(
    stringifiedNodes.skip(startNodeIndex),
    content,
    span,
    onNegatedKeyWithValue: onNegatedKeyWithValue,
    handleDeepNestedNodes: (nestedContent, nestedSpan) {
      // recursion
      return convertStringifiedNestedNodesToYamlMap(
        nestedContent,
        nestedSpan,
        onDuplicateKey: onDuplicateKey,
        onNegatedKeyWithValue: onNegatedKeyWithValue,
      );
    },
  );

  var duplicates = _findDuplicateKeys(fieldKeyValuePairs);
  for (var duplicate in duplicates) {
    onDuplicateKey?.call(
      duplicate,
      _extractSubSpan(content, span, duplicate),
    );
  }

  Map<dynamic, YamlNode> internalNodes = fieldKeyValuePairs.fold(
    initNodes,
    (aggregate, pair) => {...aggregate, ...pair},
  );

  // deepEqualsMap is needed to be able to compare YamlScala as keys
  var nodes = deepEqualsMap<dynamic, YamlNode>();
  nodes.addAll(internalNodes);

  return YamlMap.internal(nodes, span, CollectionStyle.ANY);
}

Map<dynamic, YamlNode> _extractInitialNode(
  String? firstKey,
  List<String> options,
  String? content,
  SourceSpan span,
) {
  if (firstKey == null) return {};

  var initRawValue = options.isNotEmpty ? options.first : null;
  return _createdYamlScalarNode(
    firstKey,
    initRawValue,
    _extractSubSpan(content, span, initRawValue),
  );
}

List<String> _extractStringifiedNodes(String? input) {
  if (input == null) return [];

  // Split on comma, but not if the comma is inside < > or ( )
  return input
      .split(RegExp(r',(?![^(]*\))(?![^<]*>)'))
      .map((e) => e.trim())
      .toList();
}

Iterable<Map<YamlScalar, YamlNode>> _extractKeyValuePairs(
  Iterable<String> fieldOptions,
  String? content,
  SourceSpan span, {
  void Function(String key, SourceSpan? span)? onNegatedKeyWithValue,
  required DeepNestedNodeHandler handleDeepNestedNodes,
}) {
  if (content == null) return [];

  var fieldPairs = fieldOptions.map((stringifiedKeyValuePair) {
    var keyValueSpan = _extractSubSpan(content, span, stringifiedKeyValuePair);

    if (_hasNestedStringifiedValues(stringifiedKeyValuePair)) {
      var nestedComponents =
          stringifiedKeyValuePair.replaceAll(')', '').split('(');

      var key = nestedComponents.first;
      var stringifiedContent = nestedComponents.last;

      if (stringifiedContent == '') {
        return _createdYamlScalarNode(
          key,
          null,
          keyValueSpan,
        );
      } else {
        var nestedSpan = _extractSubSpan(content, span, stringifiedContent);
        var nodeMap = handleDeepNestedNodes(stringifiedContent, nestedSpan);

        return _createYamlMapNode(key, nodeMap, keyValueSpan);
      }
    }

    List<String> keyValuePair = stringifiedKeyValuePair.split('=');

    String key = keyValuePair.first;
    String? value = keyValuePair.length == 2 ? keyValuePair.last : null;

    if (stringifiedKeyValuePair.contains('=') && key.startsWith('!')) {
      onNegatedKeyWithValue?.call(
        key,
        _extractSubSpan(keyValueSpan.text, keyValueSpan, key),
      );
    }

    if (!stringifiedKeyValuePair.contains('=')) {
      if (key.startsWith('!')) {
        key = key.substring(1);
        value = 'false';
      } else {
        value = 'true';
      }
    }

    return _createdYamlScalarNode(
      key,
      value,
      keyValueSpan,
    );
  });

  return fieldPairs;
}

bool _hasNestedStringifiedValues(String stringifiedKeyValuePair) =>
    stringifiedKeyValuePair.contains('(');

SourceSpan _extractSubSpan(
  String? content,
  SourceSpan contentSpan,
  String? subContent,
) {
  if (content == null) return contentSpan;
  if (subContent == null) return contentSpan;

  var start = _findStartIndex(content, subContent);
  if (start == -1) return contentSpan;

  var end = start + subContent.length;
  return contentSpan.subspan(start, end);
}

int _findStartIndex(String fullString, String subString) {
  if (subString == '') return fullString.length;
  return fullString.lastIndexOf(subString);
}

Set<String> _findDuplicateKeys(Iterable<Map<YamlScalar, dynamic>> list) {
  var seenStrings = <String>{};
  var duplicates = <String>{};

  for (var pair in list) {
    var v = pair.entries.first;
    if (seenStrings.contains(v.key.value)) {
      duplicates.add(v.key.value);
    } else {
      seenStrings.add(v.key.value);
    }
  }

  return duplicates;
}

Map<YamlScalar, YamlScalar> _createdYamlScalarNode(
  String rawKey,
  String? rawValue,
  SourceSpan span,
) {
  var trimmedKey = rawKey.trim();
  var keySpan = _extractSubSpan(span.text, span, trimmedKey);
  var key = YamlScalar.internalWithSpan(trimmedKey, keySpan);

  var trimmedValue = rawValue?.trim();
  var valueSpan = _extractSubSpan(span.text, span, trimmedValue);
  var value = YamlScalar.internalWithSpan(trimmedValue, valueSpan);

  return {key: value};
}

Map<YamlScalar, YamlMap> _createYamlMapNode(
  String rawKey,
  YamlMap value,
  SourceSpan span,
) {
  var trimmedKey = rawKey.trim();
  var keySpan = _extractSubSpan(span.text, span, trimmedKey);
  var key = YamlScalar.internalWithSpan(trimmedKey, keySpan);

  return {key: value};
}
