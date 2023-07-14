import 'dart:math';

import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

// ignore: implementation_imports
import 'package:yaml/src/equality.dart';

List<String> convertIndexList(String stringifiedFields) {
  return stringifiedFields.split(',').map((field) => field.trim()).toList();
}

YamlMap convertStringifiedNestedNodesToYamlMap(
  String? content,
  SourceSpan span, {
  String? firstKey,
  void Function(String key, SourceSpan? span)? onDuplicateKey,
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
  return _createdYamlNode(
    firstKey,
    initRawValue,
    _extractSubSpan(content, span, initRawValue),
  );
}

List<String> _extractStringifiedNodes(String? input) {
  if (input == null) return [];

  // Split on comma, but not if the comma is inside < >
  return input.split(RegExp(r',(?![^<]*>)')).map((e) => e.trim()).toList();
}

Iterable<Map<YamlScalar, YamlNode>> _extractKeyValuePairs(
  Iterable<String> fieldOptions,
  String? content,
  SourceSpan span,
) {
  if (content == null) return [];

  var fieldPairs = fieldOptions.map((stringifiedKeyValuePair) {
    var keyValuePair = stringifiedKeyValuePair.split('=');

    var key = keyValuePair.first;
    var value = keyValuePair.length == 2 ? keyValuePair.last : null;

    var keyValueSpan = _extractSubSpan(content, span, stringifiedKeyValuePair);

    return _createdYamlNode(
      key,
      value,
      keyValueSpan,
    );
  });

  return fieldPairs;
}

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

Map<YamlScalar, YamlNode> _createdYamlNode(
  String rawKey,
  dynamic rawValue,
  SourceSpan span,
) {
  var fullSpanLength = span.length;

  var keySpanEnd = min(rawKey.length, fullSpanLength);

  var keySpan = span.subspan(0, keySpanEnd);
  var key = YamlScalar.internalWithSpan(rawKey, keySpan);

  var valueLength = rawValue?.toString().length ?? 0;
  var valueSpanStart = fullSpanLength - valueLength;

  var valueSpan = span.subspan(valueSpanStart);
  var value = YamlScalar.internalWithSpan(rawValue, valueSpan);

  return {key: value};
}
