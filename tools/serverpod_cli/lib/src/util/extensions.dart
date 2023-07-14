import 'package:yaml/yaml.dart';

extension KeyExposingYamlMap on YamlMap {
  YamlScalar? key(String keyName) {
    return nodes.keys.firstWhere(
      (element) => element.value == keyName,
      orElse: () => null,
    );
  }
}
