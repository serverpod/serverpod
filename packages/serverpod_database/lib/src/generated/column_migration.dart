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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'package:serverpod_database/serverpod_database.dart' as _i2;

abstract class ColumnMigration implements _i1.SerializableModel {
  ColumnMigration._({
    required this.columnName,
    this.newColumnName,
    required this.addNullable,
    required this.removeNullable,
    required this.changeDefault,
    this.newDefault,
    this.newType,
  });

  factory ColumnMigration({
    required String columnName,
    String? newColumnName,
    required bool addNullable,
    required bool removeNullable,
    required bool changeDefault,
    String? newDefault,
    _i2.ColumnType? newType,
  }) = _ColumnMigrationImpl;

  factory ColumnMigration.fromJson(Map<String, dynamic> jsonSerialization) {
    return ColumnMigration(
      columnName: jsonSerialization['columnName'] as String,
      newColumnName: jsonSerialization['newColumnName'] as String?,
      addNullable: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['addNullable'],
      ),
      removeNullable: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['removeNullable'],
      ),
      changeDefault: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['changeDefault'],
      ),
      newDefault: jsonSerialization['newDefault'] as String?,
      newType: jsonSerialization['newType'] == null
          ? null
          : _i2.ColumnType.fromJson((jsonSerialization['newType'] as int)),
    );
  }

  String columnName;

  String? newColumnName;

  bool addNullable;

  bool removeNullable;

  bool changeDefault;

  String? newDefault;

  _i2.ColumnType? newType;

  /// Returns a shallow copy of this [ColumnMigration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ColumnMigration copyWith({
    String? columnName,
    String? newColumnName,
    bool? addNullable,
    bool? removeNullable,
    bool? changeDefault,
    String? newDefault,
    _i2.ColumnType? newType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ColumnMigration',
      'columnName': columnName,
      if (newColumnName != null) 'newColumnName': newColumnName,
      'addNullable': addNullable,
      'removeNullable': removeNullable,
      'changeDefault': changeDefault,
      if (newDefault != null) 'newDefault': newDefault,
      if (newType != null) 'newType': newType?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ColumnMigrationImpl extends ColumnMigration {
  _ColumnMigrationImpl({
    required String columnName,
    String? newColumnName,
    required bool addNullable,
    required bool removeNullable,
    required bool changeDefault,
    String? newDefault,
    _i2.ColumnType? newType,
  }) : super._(
         columnName: columnName,
         newColumnName: newColumnName,
         addNullable: addNullable,
         removeNullable: removeNullable,
         changeDefault: changeDefault,
         newDefault: newDefault,
         newType: newType,
       );

  /// Returns a shallow copy of this [ColumnMigration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ColumnMigration copyWith({
    String? columnName,
    Object? newColumnName = _Undefined,
    bool? addNullable,
    bool? removeNullable,
    bool? changeDefault,
    Object? newDefault = _Undefined,
    Object? newType = _Undefined,
  }) {
    return ColumnMigration(
      columnName: columnName ?? this.columnName,
      newColumnName: newColumnName is String?
          ? newColumnName
          : this.newColumnName,
      addNullable: addNullable ?? this.addNullable,
      removeNullable: removeNullable ?? this.removeNullable,
      changeDefault: changeDefault ?? this.changeDefault,
      newDefault: newDefault is String? ? newDefault : this.newDefault,
      newType: newType is _i2.ColumnType? ? newType : this.newType,
    );
  }
}
