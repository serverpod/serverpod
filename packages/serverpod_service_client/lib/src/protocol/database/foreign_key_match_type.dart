/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Defines how a foreign key should be matched.
enum ForeignKeyMatchType implements _i1.SerializableModel {
  /// [full] will not allow one column of a multicolumn foreign key
  /// to be null unless all foreign key columns are null.
  full,

  /// [partial] is not yet implemented in postgres. Don't use this.
  partial,

  /// [simple] allows any of the foreign key columns to be null.
  /// If any of them are null, the row is not required to have a
  /// match in the referenced table. (Default)
  simple;

  static ForeignKeyMatchType fromJson(int index) {
    switch (index) {
      case 0:
        return full;
      case 1:
        return partial;
      case 2:
        return simple;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "ForeignKeyMatchType"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
