import 'package:yaml/yaml.dart';

extension KeyExposingYamlMap on YamlMap {
  YamlScalar? key(String keyName) {
    return nodes.keys
        .where((element) => element is YamlScalar && element.value == keyName)
        .firstOrNull;
  }
}
