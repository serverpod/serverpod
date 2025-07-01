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
import '../database/column_type.dart' as _i2;

/// The definition of a (desired) column in the database.
abstract class ColumnDefinition implements _i1.SerializableModel {
  ColumnDefinition._({
    required this.name,
    required this.columnType,
    required this.isNullable,
    this.columnDefault,
    this.dartType,
    this.vectorDimension,
  });

  factory ColumnDefinition({
    required String name,
    required _i2.ColumnType columnType,
    required bool isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  }) = _ColumnDefinitionImpl;

  factory ColumnDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return ColumnDefinition(
      name: jsonSerialization['name'] as String,
      columnType:
          _i2.ColumnType.fromJson((jsonSerialization['columnType'] as int)),
      isNullable: jsonSerialization['isNullable'] as bool,
      columnDefault: jsonSerialization['columnDefault'] as String?,
      dartType: jsonSerialization['dartType'] as String?,
      vectorDimension: jsonSerialization['vectorDimension'] as int?,
    );
  }

  /// The column name
  String name;

  /// The actual column type
  _i2.ColumnType columnType;

  /// Whether this column is nullable.
  bool isNullable;

  /// The default for the column.
  String? columnDefault;

  /// The (dart) type specified in the yaml file.
  /// Is nullable, since this is not available when
  /// analyzing the database.
  String? dartType;

  /// Stores the dimension of Vector type (e.g., 1536 for Vector(1536)).
  /// Only populated for Vector types.
  int? vectorDimension;

  /// Returns a shallow copy of this [ColumnDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ColumnDefinition copyWith({
    String? name,
    _i2.ColumnType? columnType,
    bool? isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'columnType': columnType.toJson(),
      'isNullable': isNullable,
      if (columnDefault != null) 'columnDefault': columnDefault,
      if (dartType != null) 'dartType': dartType,
      if (vectorDimension != null) 'vectorDimension': vectorDimension,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ColumnDefinitionImpl extends ColumnDefinition {
  _ColumnDefinitionImpl({
    required String name,
    required _i2.ColumnType columnType,
    required bool isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  }) : super._(
          name: name,
          columnType: columnType,
          isNullable: isNullable,
          columnDefault: columnDefault,
          dartType: dartType,
          vectorDimension: vectorDimension,
        );

  /// Returns a shallow copy of this [ColumnDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ColumnDefinition copyWith({
    String? name,
    _i2.ColumnType? columnType,
    bool? isNullable,
    Object? columnDefault = _Undefined,
    Object? dartType = _Undefined,
    Object? vectorDimension = _Undefined,
  }) {
    return ColumnDefinition(
      name: name ?? this.name,
      columnType: columnType ?? this.columnType,
      isNullable: isNullable ?? this.isNullable,
      columnDefault:
          columnDefault is String? ? columnDefault : this.columnDefault,
      dartType: dartType is String? ? dartType : this.dartType,
      vectorDimension:
          vectorDimension is int? ? vectorDimension : this.vectorDimension,
    );
  }
}
