import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

// ignore: implementation_imports
import 'package:yaml/src/equality.dart';

List<String> convertIndexList(String stringifiedFields) {
  return stringifiedFields.split(',').map((field) => field.trim()).toList();
}

YamlMap convertStringifiedNestedNodesToYamlMap(
  String? content,
  YamlNode contentNode,
  ValidateNode node, {
  void Function(String key, SourceSpan? span)? onDuplicateKey,
}) {
  var options = _extractOptions(content);

  var initRawValue = options.isNotEmpty ? options.first : null;

  var fieldKeyValuePairs = _extractKeyValuePairs(options.skip(1));

  var duplicates = _findDuplicateKeys(fieldKeyValuePairs);
  for (var duplicate in duplicates) {
    onDuplicateKey?.call(duplicate, contentNode.span);
  }

  Map<dynamic, YamlNode> initNodes = _createdYamlNode(
    node.nested.first.key,
    initRawValue,
    contentNode.span,
  );

  Map<dynamic, YamlNode> internalNodes =
      fieldKeyValuePairs.fold(initNodes, (aggregate, pair) {
    var node = _createdYamlNode(
      pair.key,
      pair.value,
      contentNode.span,
    );
    return {...aggregate, ...node};
  });

  // deepEqialsMap is needed to be able to compare YamlScala as keys
  var nodes = deepEqualsMap<dynamic, YamlNode>();
  nodes.addAll(internalNodes);

  return YamlMap.internal(nodes, contentNode.span, CollectionStyle.ANY);
}

List<String> _extractOptions(String? input) {
  if (input == null) return [];

  // Split on comma, but not if the comma is inside < >
  return input.split(RegExp(r',(?![^<]*>)')).map((e) => e.trim()).toList();
}

Iterable<MapEntry<String, dynamic>> _extractKeyValuePairs(
  Iterable<String> fieldOptions,
) {
  var fieldPairs = fieldOptions.map((stringifiedKeyValuePair) {
    var keyValuePair = stringifiedKeyValuePair.split('=');

    var key = keyValuePair.first;
    var value = keyValuePair.length == 2 ? keyValuePair.last : null;

    return MapEntry(key, value);
  });

  return fieldPairs;
}

Set<String> _findDuplicateKeys(Iterable<MapEntry<String, dynamic>> list) {
  var seenStrings = <String>{};
  var duplicates = <String>{};

  for (var pair in list) {
    if (seenStrings.contains(pair.key)) {
      duplicates.add(pair.key);
    } else {
      seenStrings.add(pair.key);
    }
  }

  return duplicates;
}

Map<dynamic, YamlNode> _createdYamlNode(
  String rawKey,
  dynamic rawValue,
  SourceSpan span,
) {
  var key = YamlScalar.internalWithSpan(rawKey, span);
  var value = YamlScalar.internalWithSpan(rawValue, span);

  return {key: value};
}
