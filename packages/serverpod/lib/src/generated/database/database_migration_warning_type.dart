/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum DatabaseMigrationWarningType with _i1.SerializableModel {
  tableDropped,
  columnDropped,
  notNullAdded,
  uniqueIndexCreated;

  static DatabaseMigrationWarningType? fromJson(String name) {
    switch (name) {
      case 'tableDropped':
        return tableDropped;
      case 'columnDropped':
        return columnDropped;
      case 'notNullAdded':
        return notNullAdded;
      case 'uniqueIndexCreated':
        return uniqueIndexCreated;
      default:
        return null;
    }
  }

  @override
  String toJson() => name;
  @override
  String toString() => toJson();
}
