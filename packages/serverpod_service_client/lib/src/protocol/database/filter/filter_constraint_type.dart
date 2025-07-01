/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum FilterConstraintType implements _i1.SerializableModel {
  equals,
  notEquals,
  like,
  iLike,
  notLike,
  notILike,
  lessThan,
  lessThanOrEquals,
  greaterThan,
  greaterThanOrEquals,
  between,
  inThePast,
  isNull,
  isNotNull;

  static FilterConstraintType fromJson(int index) {
    switch (index) {
      case 0:
        return FilterConstraintType.equals;
      case 1:
        return FilterConstraintType.notEquals;
      case 2:
        return FilterConstraintType.like;
      case 3:
        return FilterConstraintType.iLike;
      case 4:
        return FilterConstraintType.notLike;
      case 5:
        return FilterConstraintType.notILike;
      case 6:
        return FilterConstraintType.lessThan;
      case 7:
        return FilterConstraintType.lessThanOrEquals;
      case 8:
        return FilterConstraintType.greaterThan;
      case 9:
        return FilterConstraintType.greaterThanOrEquals;
      case 10:
        return FilterConstraintType.between;
      case 11:
        return FilterConstraintType.inThePast;
      case 12:
        return FilterConstraintType.isNull;
      case 13:
        return FilterConstraintType.isNotNull;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "FilterConstraintType"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
