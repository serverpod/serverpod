/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// All the types, that are possible for columns.
/// Contains all the values of [TypeDefinition.databaseType]
enum ColumnType with _i1.SerializableEntity {
  /// Used for auto incrementing ids
  serial,

  /// Dart type: [String]
  text,

  /// Dart type: [bool]
  boolean,

  /// Dart type: [int]
  integer,

  /// Dart type: [double]
  doublePrecision,

  /// Dart type: [DateTime]
  timestampWithoutTimeZone,

  /// Dart type: [ByteData]
  bytea,

  /// Dart type: [Duration]
  bigint,

  /// Dart type: [UuidValue]
  uuid,

  /// Esp. for serializable objects.
  json,

  /// Used for unknown types, that have never been
  /// used by Serverpod.
  unknown;

  static ColumnType? fromJson(int index) {
    switch (index) {
      case 0:
        return serial;
      case 1:
        return text;
      case 2:
        return boolean;
      case 3:
        return integer;
      case 4:
        return doublePrecision;
      case 5:
        return timestampWithoutTimeZone;
      case 6:
        return bytea;
      case 7:
        return bigint;
      case 8:
        return uuid;
      case 9:
        return json;
      case 10:
        return unknown;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
