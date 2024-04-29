/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ColumnMigration extends _i1.SerializableEntity {
  ColumnMigration._({
    required this.columnName,
    required this.addNullable,
    required this.removeNullable,
    required this.changeDefault,
    this.newDefault,
  });

  factory ColumnMigration({
    required String columnName,
    required bool addNullable,
    required bool removeNullable,
    required bool changeDefault,
    String? newDefault,
  }) = _ColumnMigrationImpl;

  factory ColumnMigration.fromJson(Map<String, dynamic> jsonSerialization) {
    return ColumnMigration(
      columnName: jsonSerialization['columnName'] as String,
      addNullable: jsonSerialization['addNullable'] as bool,
      removeNullable: jsonSerialization['removeNullable'] as bool,
      changeDefault: jsonSerialization['changeDefault'] as bool,
      newDefault: jsonSerialization['newDefault'] as String?,
    );
  }

  String columnName;

  bool addNullable;

  bool removeNullable;

  bool changeDefault;

  String? newDefault;

  ColumnMigration copyWith({
    String? columnName,
    bool? addNullable,
    bool? removeNullable,
    bool? changeDefault,
    String? newDefault,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'columnName': columnName,
      'addNullable': addNullable,
      'removeNullable': removeNullable,
      'changeDefault': changeDefault,
      if (newDefault != null) 'newDefault': newDefault,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'columnName': columnName,
      'addNullable': addNullable,
      'removeNullable': removeNullable,
      'changeDefault': changeDefault,
      if (newDefault != null) 'newDefault': newDefault,
    };
  }
}

class _Undefined {}

class _ColumnMigrationImpl extends ColumnMigration {
  _ColumnMigrationImpl({
    required String columnName,
    required bool addNullable,
    required bool removeNullable,
    required bool changeDefault,
    String? newDefault,
  }) : super._(
          columnName: columnName,
          addNullable: addNullable,
          removeNullable: removeNullable,
          changeDefault: changeDefault,
          newDefault: newDefault,
        );

  @override
  ColumnMigration copyWith({
    String? columnName,
    bool? addNullable,
    bool? removeNullable,
    bool? changeDefault,
    Object? newDefault = _Undefined,
  }) {
    return ColumnMigration(
      columnName: columnName ?? this.columnName,
      addNullable: addNullable ?? this.addNullable,
      removeNullable: removeNullable ?? this.removeNullable,
      changeDefault: changeDefault ?? this.changeDefault,
      newDefault: newDefault is String? ? newDefault : this.newDefault,
    );
  }
}
