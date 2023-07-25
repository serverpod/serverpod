/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum FilterConstraintType with _i1.SerializableEntity {
  equals,
  notEquals,
  like,
  lessThan,
  lessThanOrEquals,
  greaterThan,
  greaterThanOrEquals,
  between,
  contains,
  notContains,
  startsWith,
  endsWith,
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
        return lessThan;
      case 4:
        return lessThanOrEquals;
      case 5:
        return greaterThan;
      case 6:
        return greaterThanOrEquals;
      case 7:
        return between;
      case 8:
        return contains;
      case 9:
        return notContains;
      case 10:
        return startsWith;
      case 11:
        return endsWith;
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
