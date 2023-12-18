/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum FilterConstraintType with _i1.SerializableModel {
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

  static FilterConstraintType? fromJson(int index) {
    switch (index) {
      case 0:
        return equals;
      case 1:
        return notEquals;
      case 2:
        return like;
      case 3:
        return iLike;
      case 4:
        return notLike;
      case 5:
        return notILike;
      case 6:
        return lessThan;
      case 7:
        return lessThanOrEquals;
      case 8:
        return greaterThan;
      case 9:
        return greaterThanOrEquals;
      case 10:
        return between;
      case 11:
        return inThePast;
      case 12:
        return isNull;
      case 13:
        return isNotNull;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
