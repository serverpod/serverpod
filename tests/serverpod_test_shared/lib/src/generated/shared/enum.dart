/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

enum SharedEnum implements _i1.SerializableModel {
  one('1', 'The first value', 10),
  two('2', 'The second value', 0),
  three('3', 'The third value', 0);

  const SharedEnum(
    this.shortName,
    this.description,
    this.priority,
  );

  final String shortName;

  final String description;

  final int priority;

  static SharedEnum fromJson(String name) {
    switch (name) {
      case 'one':
        return SharedEnum.one;
      case 'two':
        return SharedEnum.two;
      case 'three':
        return SharedEnum.three;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SharedEnum"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
