/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum ByNameEnum implements _i1.SerializableModel {
  byName1,
  byName2;

  static ByNameEnum fromJson(String name) {
    switch (name) {
      case 'byName1':
        return ByNameEnum.byName1;
      case 'byName2':
        return ByNameEnum.byName2;
      default:
        throw ArgumentError(
            'Value "$name" cannot be converted to "ByNameEnum"');
    }
  }

  @override
  String toJson() => name;
  @override
  String toString() => name;
}
