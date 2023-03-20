/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum ForeignKeyAction with _i1.SerializableEntity {
  setNull,
  setDefault,
  restrict,
  noAction,
  cascade;

  static ForeignKeyAction? fromJson(int index) {
    switch (index) {
      case 0:
        return setNull;
      case 1:
        return setDefault;
      case 2:
        return restrict;
      case 3:
        return noAction;
      case 4:
        return cascade;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
