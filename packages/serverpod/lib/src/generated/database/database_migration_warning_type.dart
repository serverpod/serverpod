/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum DatabaseMigrationWarningType implements _i1.SerializableEntity {
  tableDropped,
  columnDropped,
  notNullAdded,
  uniqueIndexCreated;

  static DatabaseMigrationWarningType? fromJson(int index) {
    switch (index) {
      case 0:
        return tableDropped;
      case 1:
        return columnDropped;
      case 2:
        return notNullAdded;
      case 3:
        return uniqueIndexCreated;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
