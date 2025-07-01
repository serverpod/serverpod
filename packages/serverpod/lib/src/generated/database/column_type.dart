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

/// All the types, that are possible for columns.
/// Contains all the values of [TypeDefinition.databaseType]
enum ColumnType implements _i1.SerializableModel {
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
  unknown,

  /// Dart type: [Vector]
  vector,

  /// Dart type: [HalfVector]
  halfvec,

  /// Dart type: [SparseVector]
  sparsevec,

  /// Dart type: [Bit]
  bit;

  static ColumnType fromJson(int index) {
    switch (index) {
      case 0:
        return ColumnType.text;
      case 1:
        return ColumnType.boolean;
      case 2:
        return ColumnType.integer;
      case 3:
        return ColumnType.doublePrecision;
      case 4:
        return ColumnType.timestampWithoutTimeZone;
      case 5:
        return ColumnType.bytea;
      case 6:
        return ColumnType.bigint;
      case 7:
        return ColumnType.uuid;
      case 8:
        return ColumnType.json;
      case 9:
        return ColumnType.unknown;
      case 10:
        return ColumnType.vector;
      case 11:
        return ColumnType.halfvec;
      case 12:
        return ColumnType.sparsevec;
      case 13:
        return ColumnType.bit;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "ColumnType"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
