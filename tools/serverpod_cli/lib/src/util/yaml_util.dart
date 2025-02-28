import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

YamlMap loadYamlMap(String yamlString, {Uri? sourceUrl}) {
  var node = loadYamlNode(yamlString, sourceUrl: sourceUrl);
  if (node is YamlMap) return node;
  if (node is YamlScalar) {
    var value = node.value;
    // A empty or whitespace only string will parse as YamlScalar,
    // but is also a valid map
    if (value == null || (value is String && value.trim().isEmpty)) {
      return YamlMap();
    }
  }
  throw SourceSpanException('Expected a map', node.span);
}
