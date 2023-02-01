import 'package:yaml/yaml.dart';

extension NullableString on String? {
  /// Add [other] to [this], if and only if [this] is not [null].
  String? operator +(String other) {
    // print('$this + $other');
    if (this == null) {
      return null;
    } else {
      return '${this!}$other';
    }
  }
}

extension KeyExposingYamlMap on YamlMap {
  YamlScalar? key(String keyName) {
    return nodes.keys.firstWhere(
      (element) => element.value == keyName,
      orElse: () => null,
    );
  }
}
