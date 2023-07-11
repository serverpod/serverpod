/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

/// The definition of a (desired) column in the database.
class ColumnDefinition extends _i1.SerializableEntity {
  ColumnDefinition({
    required this.name,
    required this.columnType,
    this.enumValueNames,
    required this.isNullable,
    this.columnDefault,
    this.dartType,
  });

  factory ColumnDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ColumnDefinition(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      columnType: serializationManager
          .deserialize<_i2.ColumnType>(jsonSerialization['columnType']),
      enumValueNames: serializationManager
          .deserialize<List<String>?>(jsonSerialization['enumValueNames']),
      isNullable: serializationManager
          .deserialize<bool>(jsonSerialization['isNullable']),
      columnDefault: serializationManager
          .deserialize<String?>(jsonSerialization['columnDefault']),
      dartType: serializationManager
          .deserialize<String?>(jsonSerialization['dartType']),
    );
  }

  /// The column name
  String name;

  /// The actual column type
  _i2.ColumnType columnType;

  /// A list of the enum value names, if this is an enum, otherwise null.
  List<String>? enumValueNames;

  /// Whether this column is nullable.
  bool isNullable;

  /// The default for the column.
  String? columnDefault;

  /// The (dart) type specified in the yaml file.
  /// Is nullable, since this is not available when
  /// analyzing the database.
  String? dartType;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'columnType': columnType,
      'enumValueNames': enumValueNames,
      'isNullable': isNullable,
      'columnDefault': columnDefault,
      'dartType': dartType,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'name': name,
      'columnType': columnType,
      'enumValueNames': enumValueNames,
      'isNullable': isNullable,
      'columnDefault': columnDefault,
      'dartType': dartType,
    };
  }
}
