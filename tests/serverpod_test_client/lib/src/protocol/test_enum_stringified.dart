/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Just an test enum.
enum TestEnumStringified with _i1.SerializableEntity {
  one,
  two,
  three;

  static TestEnumStringified fromJson(String name) {
    switch (name) {
      case 'one':
        return one;
      case 'two':
        return two;
      case 'three':
        return three;
      default:
        throw ArgumentError(
            'Value "$name" cannot be converted to "TestEnumStringified"');
    }
  }

  @override
  String toJson() => name;
  @override
  String toString() => toJson();
}
