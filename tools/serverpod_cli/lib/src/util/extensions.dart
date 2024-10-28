import 'package:yaml/yaml.dart';

extension KeyExposingYamlMap on YamlMap {
  YamlScalar? key(String keyName) {
    return nodes.keys
        .whereType<YamlScalar>()
        .where((element) => element.value == keyName)
        .firstOrNull;
  }
}
