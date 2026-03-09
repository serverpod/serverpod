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
import 'bulk_data.dart' as _i2;
import 'bulk_data_exception.dart' as _i3;
import 'bulk_query_column_description.dart' as _i4;
import 'bulk_query_result.dart' as _i5;
import 'column_definition.dart' as _i6;
import 'column_migration.dart' as _i7;
import 'column_type.dart' as _i8;
import 'database_definition.dart' as _i9;
import 'database_definitions.dart' as _i10;
import 'database_migration.dart' as _i11;
import 'database_migration_action.dart' as _i12;
import 'database_migration_action_type.dart' as _i13;
import 'database_migration_version.dart' as _i14;
import 'database_migration_warning.dart' as _i15;
import 'database_migration_warning_type.dart' as _i16;
import 'enum_serialization.dart' as _i17;
import 'filter/filter.dart' as _i18;
import 'filter/filter_constraint.dart' as _i19;
import 'filter/filter_constraint_type.dart' as _i20;
import 'foreign_key_action.dart' as _i21;
import 'foreign_key_definition.dart' as _i22;
import 'foreign_key_match_type.dart' as _i23;
import 'index_definition.dart' as _i24;
import 'index_element_definition.dart' as _i25;
import 'index_element_definition_type.dart' as _i26;
import 'table_definition.dart' as _i27;
import 'table_migration.dart' as _i28;
import 'vector_distance_function.dart' as _i29;
import 'package:serverpod_database/serverpod_database.dart' as _i30;
export 'bulk_data.dart';
export 'bulk_data_exception.dart';
export 'bulk_query_column_description.dart';
export 'bulk_query_result.dart';
export 'column_definition.dart';
export 'column_migration.dart';
export 'column_type.dart';
export 'database_definition.dart';
export 'database_definitions.dart';
export 'database_migration.dart';
export 'database_migration_action.dart';
export 'database_migration_action_type.dart';
export 'database_migration_version.dart';
export 'database_migration_warning.dart';
export 'database_migration_warning_type.dart';
export 'enum_serialization.dart';
export 'filter/filter.dart';
export 'filter/filter_constraint.dart';
export 'filter/filter_constraint_type.dart';
export 'foreign_key_action.dart';
export 'foreign_key_definition.dart';
export 'foreign_key_match_type.dart';
export 'index_definition.dart';
export 'index_element_definition.dart';
export 'index_element_definition_type.dart';
export 'table_definition.dart';
export 'table_migration.dart';
export 'vector_distance_function.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod.')) return className;
    return className.substring(10);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.BulkData) {
      return _i2.BulkData.fromJson(data) as T;
    }
    if (t == _i3.BulkDataException) {
      return _i3.BulkDataException.fromJson(data) as T;
    }
    if (t == _i4.BulkQueryColumnDescription) {
      return _i4.BulkQueryColumnDescription.fromJson(data) as T;
    }
    if (t == _i5.BulkQueryResult) {
      return _i5.BulkQueryResult.fromJson(data) as T;
    }
    if (t == _i6.ColumnDefinition) {
      return _i6.ColumnDefinition.fromJson(data) as T;
    }
    if (t == _i7.ColumnMigration) {
      return _i7.ColumnMigration.fromJson(data) as T;
    }
    if (t == _i8.ColumnType) {
      return _i8.ColumnType.fromJson(data) as T;
    }
    if (t == _i9.DatabaseDefinition) {
      return _i9.DatabaseDefinition.fromJson(data) as T;
    }
    if (t == _i10.DatabaseDefinitions) {
      return _i10.DatabaseDefinitions.fromJson(data) as T;
    }
    if (t == _i11.DatabaseMigration) {
      return _i11.DatabaseMigration.fromJson(data) as T;
    }
    if (t == _i12.DatabaseMigrationAction) {
      return _i12.DatabaseMigrationAction.fromJson(data) as T;
    }
    if (t == _i13.DatabaseMigrationActionType) {
      return _i13.DatabaseMigrationActionType.fromJson(data) as T;
    }
    if (t == _i14.DatabaseMigrationVersionModel) {
      return _i14.DatabaseMigrationVersionModel.fromJson(data) as T;
    }
    if (t == _i15.DatabaseMigrationWarning) {
      return _i15.DatabaseMigrationWarning.fromJson(data) as T;
    }
    if (t == _i16.DatabaseMigrationWarningType) {
      return _i16.DatabaseMigrationWarningType.fromJson(data) as T;
    }
    if (t == _i17.EnumSerialization) {
      return _i17.EnumSerialization.fromJson(data) as T;
    }
    if (t == _i18.Filter) {
      return _i18.Filter.fromJson(data) as T;
    }
    if (t == _i19.FilterConstraint) {
      return _i19.FilterConstraint.fromJson(data) as T;
    }
    if (t == _i20.FilterConstraintType) {
      return _i20.FilterConstraintType.fromJson(data) as T;
    }
    if (t == _i21.ForeignKeyAction) {
      return _i21.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _i22.ForeignKeyDefinition) {
      return _i22.ForeignKeyDefinition.fromJson(data) as T;
    }
    if (t == _i23.ForeignKeyMatchType) {
      return _i23.ForeignKeyMatchType.fromJson(data) as T;
    }
    if (t == _i24.IndexDefinition) {
      return _i24.IndexDefinition.fromJson(data) as T;
    }
    if (t == _i25.IndexElementDefinition) {
      return _i25.IndexElementDefinition.fromJson(data) as T;
    }
    if (t == _i26.IndexElementDefinitionType) {
      return _i26.IndexElementDefinitionType.fromJson(data) as T;
    }
    if (t == _i27.TableDefinition) {
      return _i27.TableDefinition.fromJson(data) as T;
    }
    if (t == _i28.TableMigration) {
      return _i28.TableMigration.fromJson(data) as T;
    }
    if (t == _i29.VectorDistanceFunction) {
      return _i29.VectorDistanceFunction.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.BulkData?>()) {
      return (data != null ? _i2.BulkData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.BulkDataException?>()) {
      return (data != null ? _i3.BulkDataException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BulkQueryColumnDescription?>()) {
      return (data != null
              ? _i4.BulkQueryColumnDescription.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i5.BulkQueryResult?>()) {
      return (data != null ? _i5.BulkQueryResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ColumnDefinition?>()) {
      return (data != null ? _i6.ColumnDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ColumnMigration?>()) {
      return (data != null ? _i7.ColumnMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ColumnType?>()) {
      return (data != null ? _i8.ColumnType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DatabaseDefinition?>()) {
      return (data != null ? _i9.DatabaseDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.DatabaseDefinitions?>()) {
      return (data != null ? _i10.DatabaseDefinitions.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.DatabaseMigration?>()) {
      return (data != null ? _i11.DatabaseMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.DatabaseMigrationAction?>()) {
      return (data != null ? _i12.DatabaseMigrationAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.DatabaseMigrationActionType?>()) {
      return (data != null
              ? _i13.DatabaseMigrationActionType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.DatabaseMigrationVersionModel?>()) {
      return (data != null
              ? _i14.DatabaseMigrationVersionModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.DatabaseMigrationWarning?>()) {
      return (data != null
              ? _i15.DatabaseMigrationWarning.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.DatabaseMigrationWarningType?>()) {
      return (data != null
              ? _i16.DatabaseMigrationWarningType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.EnumSerialization?>()) {
      return (data != null ? _i17.EnumSerialization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Filter?>()) {
      return (data != null ? _i18.Filter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.FilterConstraint?>()) {
      return (data != null ? _i19.FilterConstraint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.FilterConstraintType?>()) {
      return (data != null ? _i20.FilterConstraintType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ForeignKeyAction?>()) {
      return (data != null ? _i21.ForeignKeyAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ForeignKeyDefinition?>()) {
      return (data != null ? _i22.ForeignKeyDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.ForeignKeyMatchType?>()) {
      return (data != null ? _i23.ForeignKeyMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.IndexDefinition?>()) {
      return (data != null ? _i24.IndexDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.IndexElementDefinition?>()) {
      return (data != null ? _i25.IndexElementDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.IndexElementDefinitionType?>()) {
      return (data != null
              ? _i26.IndexElementDefinitionType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i27.TableDefinition?>()) {
      return (data != null ? _i27.TableDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.TableMigration?>()) {
      return (data != null ? _i28.TableMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.VectorDistanceFunction?>()) {
      return (data != null ? _i29.VectorDistanceFunction.fromJson(data) : null)
          as T;
    }
    if (t == List<_i30.BulkQueryColumnDescription>) {
      return (data as List)
              .map((e) => deserialize<_i30.BulkQueryColumnDescription>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.TableDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i30.TableDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.DatabaseMigrationVersionModel>) {
      return (data as List)
              .map((e) => deserialize<_i30.DatabaseMigrationVersionModel>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.DatabaseMigrationAction>) {
      return (data as List)
              .map((e) => deserialize<_i30.DatabaseMigrationAction>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.DatabaseMigrationWarning>) {
      return (data as List)
              .map((e) => deserialize<_i30.DatabaseMigrationWarning>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i30.FilterConstraint>) {
      return (data as List)
              .map((e) => deserialize<_i30.FilterConstraint>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.IndexElementDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i30.IndexElementDefinition>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i30.ColumnDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i30.ColumnDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.ForeignKeyDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i30.ForeignKeyDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.IndexDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i30.IndexDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.ColumnMigration>) {
      return (data as List)
              .map((e) => deserialize<_i30.ColumnMigration>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.BulkData => 'BulkData',
      _i3.BulkDataException => 'BulkDataException',
      _i4.BulkQueryColumnDescription => 'BulkQueryColumnDescription',
      _i5.BulkQueryResult => 'BulkQueryResult',
      _i6.ColumnDefinition => 'ColumnDefinition',
      _i7.ColumnMigration => 'ColumnMigration',
      _i8.ColumnType => 'ColumnType',
      _i9.DatabaseDefinition => 'DatabaseDefinition',
      _i10.DatabaseDefinitions => 'DatabaseDefinitions',
      _i11.DatabaseMigration => 'DatabaseMigration',
      _i12.DatabaseMigrationAction => 'DatabaseMigrationAction',
      _i13.DatabaseMigrationActionType => 'DatabaseMigrationActionType',
      _i14.DatabaseMigrationVersionModel => 'DatabaseMigrationVersionModel',
      _i15.DatabaseMigrationWarning => 'DatabaseMigrationWarning',
      _i16.DatabaseMigrationWarningType => 'DatabaseMigrationWarningType',
      _i17.EnumSerialization => 'EnumSerialization',
      _i18.Filter => 'Filter',
      _i19.FilterConstraint => 'FilterConstraint',
      _i20.FilterConstraintType => 'FilterConstraintType',
      _i21.ForeignKeyAction => 'ForeignKeyAction',
      _i22.ForeignKeyDefinition => 'ForeignKeyDefinition',
      _i23.ForeignKeyMatchType => 'ForeignKeyMatchType',
      _i24.IndexDefinition => 'IndexDefinition',
      _i25.IndexElementDefinition => 'IndexElementDefinition',
      _i26.IndexElementDefinitionType => 'IndexElementDefinitionType',
      _i27.TableDefinition => 'TableDefinition',
      _i28.TableMigration => 'TableMigration',
      _i29.VectorDistanceFunction => 'VectorDistanceFunction',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('serverpod.', '');
    }

    switch (data) {
      case _i2.BulkData():
        return 'BulkData';
      case _i3.BulkDataException():
        return 'BulkDataException';
      case _i4.BulkQueryColumnDescription():
        return 'BulkQueryColumnDescription';
      case _i5.BulkQueryResult():
        return 'BulkQueryResult';
      case _i6.ColumnDefinition():
        return 'ColumnDefinition';
      case _i7.ColumnMigration():
        return 'ColumnMigration';
      case _i8.ColumnType():
        return 'ColumnType';
      case _i9.DatabaseDefinition():
        return 'DatabaseDefinition';
      case _i10.DatabaseDefinitions():
        return 'DatabaseDefinitions';
      case _i11.DatabaseMigration():
        return 'DatabaseMigration';
      case _i12.DatabaseMigrationAction():
        return 'DatabaseMigrationAction';
      case _i13.DatabaseMigrationActionType():
        return 'DatabaseMigrationActionType';
      case _i14.DatabaseMigrationVersionModel():
        return 'DatabaseMigrationVersionModel';
      case _i15.DatabaseMigrationWarning():
        return 'DatabaseMigrationWarning';
      case _i16.DatabaseMigrationWarningType():
        return 'DatabaseMigrationWarningType';
      case _i17.EnumSerialization():
        return 'EnumSerialization';
      case _i18.Filter():
        return 'Filter';
      case _i19.FilterConstraint():
        return 'FilterConstraint';
      case _i20.FilterConstraintType():
        return 'FilterConstraintType';
      case _i21.ForeignKeyAction():
        return 'ForeignKeyAction';
      case _i22.ForeignKeyDefinition():
        return 'ForeignKeyDefinition';
      case _i23.ForeignKeyMatchType():
        return 'ForeignKeyMatchType';
      case _i24.IndexDefinition():
        return 'IndexDefinition';
      case _i25.IndexElementDefinition():
        return 'IndexElementDefinition';
      case _i26.IndexElementDefinitionType():
        return 'IndexElementDefinitionType';
      case _i27.TableDefinition():
        return 'TableDefinition';
      case _i28.TableMigration():
        return 'TableMigration';
      case _i29.VectorDistanceFunction():
        return 'VectorDistanceFunction';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BulkData') {
      return deserialize<_i2.BulkData>(data['data']);
    }
    if (dataClassName == 'BulkDataException') {
      return deserialize<_i3.BulkDataException>(data['data']);
    }
    if (dataClassName == 'BulkQueryColumnDescription') {
      return deserialize<_i4.BulkQueryColumnDescription>(data['data']);
    }
    if (dataClassName == 'BulkQueryResult') {
      return deserialize<_i5.BulkQueryResult>(data['data']);
    }
    if (dataClassName == 'ColumnDefinition') {
      return deserialize<_i6.ColumnDefinition>(data['data']);
    }
    if (dataClassName == 'ColumnMigration') {
      return deserialize<_i7.ColumnMigration>(data['data']);
    }
    if (dataClassName == 'ColumnType') {
      return deserialize<_i8.ColumnType>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinition') {
      return deserialize<_i9.DatabaseDefinition>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinitions') {
      return deserialize<_i10.DatabaseDefinitions>(data['data']);
    }
    if (dataClassName == 'DatabaseMigration') {
      return deserialize<_i11.DatabaseMigration>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationAction') {
      return deserialize<_i12.DatabaseMigrationAction>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationActionType') {
      return deserialize<_i13.DatabaseMigrationActionType>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersionModel') {
      return deserialize<_i14.DatabaseMigrationVersionModel>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarning') {
      return deserialize<_i15.DatabaseMigrationWarning>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarningType') {
      return deserialize<_i16.DatabaseMigrationWarningType>(data['data']);
    }
    if (dataClassName == 'EnumSerialization') {
      return deserialize<_i17.EnumSerialization>(data['data']);
    }
    if (dataClassName == 'Filter') {
      return deserialize<_i18.Filter>(data['data']);
    }
    if (dataClassName == 'FilterConstraint') {
      return deserialize<_i19.FilterConstraint>(data['data']);
    }
    if (dataClassName == 'FilterConstraintType') {
      return deserialize<_i20.FilterConstraintType>(data['data']);
    }
    if (dataClassName == 'ForeignKeyAction') {
      return deserialize<_i21.ForeignKeyAction>(data['data']);
    }
    if (dataClassName == 'ForeignKeyDefinition') {
      return deserialize<_i22.ForeignKeyDefinition>(data['data']);
    }
    if (dataClassName == 'ForeignKeyMatchType') {
      return deserialize<_i23.ForeignKeyMatchType>(data['data']);
    }
    if (dataClassName == 'IndexDefinition') {
      return deserialize<_i24.IndexDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinition') {
      return deserialize<_i25.IndexElementDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinitionType') {
      return deserialize<_i26.IndexElementDefinitionType>(data['data']);
    }
    if (dataClassName == 'TableDefinition') {
      return deserialize<_i27.TableDefinition>(data['data']);
    }
    if (dataClassName == 'TableMigration') {
      return deserialize<_i28.TableMigration>(data['data']);
    }
    if (dataClassName == 'VectorDistanceFunction') {
      return deserialize<_i29.VectorDistanceFunction>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
