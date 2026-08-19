/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

/// The definition of a (desired) column in the database.
abstract class ColumnDefinition
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  ColumnDefinition._({
    required this.name,
    this.fieldName,
    required this.columnType,
    required this.isNullable,
    this.columnDefault,
    this.dartType,
    this.vectorDimension,
  });

  factory ColumnDefinition({
    required String name,
    String? fieldName,
    required _isd.ColumnType columnType,
    required bool isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  }) = _ColumnDefinitionImpl;

  factory ColumnDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return ColumnDefinition(
      name: jsonSerialization['name'] as String,
      fieldName: jsonSerialization['fieldName'] as String?,
      columnType: _isd.ColumnType.fromJson(
        (jsonSerialization['columnType'] as int),
      ),
      isNullable: _iss.BoolJsonExtension.fromJson(
        jsonSerialization['isNullable'],
      ),
      columnDefault: jsonSerialization['columnDefault'] as String?,
      dartType: jsonSerialization['dartType'] as String?,
      vectorDimension: jsonSerialization['vectorDimension'] as int?,
    );
  }

  /// The column name
  String name;

  /// The Dart/model field name this column belongs to (when known).
  /// Used to match columns across renames. Is nullable since it is not
  /// available when analyzing the database.
  String? fieldName;

  /// The actual column type
  _isd.ColumnType columnType;

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
  @_iss.useResult
  ColumnDefinition copyWith({
    String? name,
    String? fieldName,
    _isd.ColumnType? columnType,
    bool? isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ColumnDefinition',
      'name': name,
      if (fieldName != null) 'fieldName': fieldName,
      'columnType': columnType.toJson(),
      'isNullable': isNullable,
      if (columnDefault != null) 'columnDefault': columnDefault,
      if (dartType != null) 'dartType': dartType,
      if (vectorDimension != null) 'vectorDimension': vectorDimension,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ColumnDefinition',
      'name': name,
      if (fieldName != null) 'fieldName': fieldName,
      'columnType': columnType.toJson(),
      'isNullable': isNullable,
      if (columnDefault != null) 'columnDefault': columnDefault,
      if (dartType != null) 'dartType': dartType,
      if (vectorDimension != null) 'vectorDimension': vectorDimension,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ColumnDefinitionImpl extends ColumnDefinition {
  _ColumnDefinitionImpl({
    required String name,
    String? fieldName,
    required _isd.ColumnType columnType,
    required bool isNullable,
    String? columnDefault,
    String? dartType,
    int? vectorDimension,
  }) : super._(
         name: name,
         fieldName: fieldName,
         columnType: columnType,
         isNullable: isNullable,
         columnDefault: columnDefault,
         dartType: dartType,
         vectorDimension: vectorDimension,
       );

  /// Returns a shallow copy of this [ColumnDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  ColumnDefinition copyWith({
    String? name,
    Object? fieldName = _Undefined,
    _isd.ColumnType? columnType,
    bool? isNullable,
    Object? columnDefault = _Undefined,
    Object? dartType = _Undefined,
    Object? vectorDimension = _Undefined,
  }) {
    return ColumnDefinition(
      name: name ?? this.name,
      fieldName: fieldName is String? ? fieldName : this.fieldName,
      columnType: columnType ?? this.columnType,
      isNullable: isNullable ?? this.isNullable,
      columnDefault: columnDefault is String?
          ? columnDefault
          : this.columnDefault,
      dartType: dartType is String? ? dartType : this.dartType,
      vectorDimension: vectorDimension is int?
          ? vectorDimension
          : this.vectorDimension,
    );
  }
}
