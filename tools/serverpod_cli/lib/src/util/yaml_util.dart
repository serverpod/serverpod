import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

YamlMap loadYamlMap(String yamlString, {Uri? sourceUrl}) {
  var node = loadYaml(yamlString, sourceUrl: sourceUrl) as YamlNode;
  if (node is YamlMap) return node;
  if (node is YamlScalar) {
    var value = node.value;
    // An empty string will parse as YamlScalar, but is also a valid map
    if (value is String && value.isEmpty) return YamlMap();
  }
  throw SourceSpanException('Expected a map', node.span);
}
