/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum ServerOnlyEnum implements _i1.SerializableModel {
  foo,
  bar;

  static ServerOnlyEnum fromJson(int index) {
    switch (index) {
      case 0:
        return foo;
      case 1:
        return bar;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "ServerOnlyEnum"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
