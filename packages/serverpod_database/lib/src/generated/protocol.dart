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
import 'gin_operator_class.dart' as _i24;
import 'index_definition.dart' as _i25;
import 'index_element_definition.dart' as _i26;
import 'index_element_definition_type.dart' as _i27;
import 'migrations_apply_result.dart' as _i28;
import 'table_definition.dart' as _i29;
import 'table_migration.dart' as _i30;
import 'vector_distance_function.dart' as _i31;
import 'package:serverpod_database/serverpod_database.dart' as _i32;
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
export 'gin_operator_class.dart';
export 'index_definition.dart';
export 'index_element_definition.dart';
export 'index_element_definition_type.dart';
export 'migrations_apply_result.dart';
export 'table_definition.dart';
export 'table_migration.dart';
export 'vector_distance_function.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_i1.SerializationManager> _hostProtocols = {};

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i2.BulkData] = (data, protocol) => _i2.BulkData.fromJson(data);
    map[_i3.BulkDataException] = (data, protocol) =>
        _i3.BulkDataException.fromJson(data);
    map[_i4.BulkQueryColumnDescription] = (data, protocol) =>
        _i4.BulkQueryColumnDescription.fromJson(data);
    map[_i5.BulkQueryResult] = (data, protocol) =>
        _i5.BulkQueryResult.fromJson(data);
    map[_i6.ColumnDefinition] = (data, protocol) =>
        _i6.ColumnDefinition.fromJson(data);
    map[_i7.ColumnMigration] = (data, protocol) =>
        _i7.ColumnMigration.fromJson(data);
    map[_i8.ColumnType] = (data, protocol) => _i8.ColumnType.fromJson(data);
    map[_i9.DatabaseDefinition] = (data, protocol) =>
        _i9.DatabaseDefinition.fromJson(data);
    map[_i10.DatabaseDefinitions] = (data, protocol) =>
        _i10.DatabaseDefinitions.fromJson(data);
    map[_i11.DatabaseMigration] = (data, protocol) =>
        _i11.DatabaseMigration.fromJson(data);
    map[_i12.DatabaseMigrationAction] = (data, protocol) =>
        _i12.DatabaseMigrationAction.fromJson(data);
    map[_i13.DatabaseMigrationActionType] = (data, protocol) =>
        _i13.DatabaseMigrationActionType.fromJson(data);
    map[_i14.DatabaseMigrationVersionModel] = (data, protocol) =>
        _i14.DatabaseMigrationVersionModel.fromJson(data);
    map[_i15.DatabaseMigrationWarning] = (data, protocol) =>
        _i15.DatabaseMigrationWarning.fromJson(data);
    map[_i16.DatabaseMigrationWarningType] = (data, protocol) =>
        _i16.DatabaseMigrationWarningType.fromJson(data);
    map[_i17.EnumSerialization] = (data, protocol) =>
        _i17.EnumSerialization.fromJson(data);
    map[_i18.Filter] = (data, protocol) => _i18.Filter.fromJson(data);
    map[_i19.FilterConstraint] = (data, protocol) =>
        _i19.FilterConstraint.fromJson(data);
    map[_i20.FilterConstraintType] = (data, protocol) =>
        _i20.FilterConstraintType.fromJson(data);
    map[_i21.ForeignKeyAction] = (data, protocol) =>
        _i21.ForeignKeyAction.fromJson(data);
    map[_i22.ForeignKeyDefinition] = (data, protocol) =>
        _i22.ForeignKeyDefinition.fromJson(data);
    map[_i23.ForeignKeyMatchType] = (data, protocol) =>
        _i23.ForeignKeyMatchType.fromJson(data);
    map[_i24.GinOperatorClass] = (data, protocol) =>
        _i24.GinOperatorClass.fromJson(data);
    map[_i25.IndexDefinition] = (data, protocol) =>
        _i25.IndexDefinition.fromJson(data);
    map[_i26.IndexElementDefinition] = (data, protocol) =>
        _i26.IndexElementDefinition.fromJson(data);
    map[_i27.IndexElementDefinitionType] = (data, protocol) =>
        _i27.IndexElementDefinitionType.fromJson(data);
    map[_i28.MigrationsApplyResult] = (data, protocol) =>
        _i28.MigrationsApplyResult.fromJson(data);
    map[_i29.TableDefinition] = (data, protocol) =>
        _i29.TableDefinition.fromJson(data);
    map[_i30.TableMigration] = (data, protocol) =>
        _i30.TableMigration.fromJson(data);
    map[_i31.VectorDistanceFunction] = (data, protocol) =>
        _i31.VectorDistanceFunction.fromJson(data);
    map[_i1.getType<_i2.BulkData?>()] = (data, protocol) =>
        (data != null ? _i2.BulkData.fromJson(data) : null);
    map[_i1.getType<_i3.BulkDataException?>()] = (data, protocol) =>
        (data != null ? _i3.BulkDataException.fromJson(data) : null);
    map[_i1.getType<_i4.BulkQueryColumnDescription?>()] = (data, protocol) =>
        (data != null ? _i4.BulkQueryColumnDescription.fromJson(data) : null);
    map[_i1.getType<_i5.BulkQueryResult?>()] = (data, protocol) =>
        (data != null ? _i5.BulkQueryResult.fromJson(data) : null);
    map[_i1.getType<_i6.ColumnDefinition?>()] = (data, protocol) =>
        (data != null ? _i6.ColumnDefinition.fromJson(data) : null);
    map[_i1.getType<_i7.ColumnMigration?>()] = (data, protocol) =>
        (data != null ? _i7.ColumnMigration.fromJson(data) : null);
    map[_i1.getType<_i8.ColumnType?>()] = (data, protocol) =>
        (data != null ? _i8.ColumnType.fromJson(data) : null);
    map[_i1.getType<_i9.DatabaseDefinition?>()] = (data, protocol) =>
        (data != null ? _i9.DatabaseDefinition.fromJson(data) : null);
    map[_i1.getType<_i10.DatabaseDefinitions?>()] = (data, protocol) =>
        (data != null ? _i10.DatabaseDefinitions.fromJson(data) : null);
    map[_i1.getType<_i11.DatabaseMigration?>()] = (data, protocol) =>
        (data != null ? _i11.DatabaseMigration.fromJson(data) : null);
    map[_i1.getType<_i12.DatabaseMigrationAction?>()] = (data, protocol) =>
        (data != null ? _i12.DatabaseMigrationAction.fromJson(data) : null);
    map[_i1.getType<_i13.DatabaseMigrationActionType?>()] = (data, protocol) =>
        (data != null ? _i13.DatabaseMigrationActionType.fromJson(data) : null);
    map[_i1
        .getType<_i14.DatabaseMigrationVersionModel?>()] = (data, protocol) =>
        (data != null
        ? _i14.DatabaseMigrationVersionModel.fromJson(data)
        : null);
    map[_i1.getType<_i15.DatabaseMigrationWarning?>()] = (data, protocol) =>
        (data != null ? _i15.DatabaseMigrationWarning.fromJson(data) : null);
    map[_i1.getType<_i16.DatabaseMigrationWarningType?>()] = (data, protocol) =>
        (data != null
        ? _i16.DatabaseMigrationWarningType.fromJson(data)
        : null);
    map[_i1.getType<_i17.EnumSerialization?>()] = (data, protocol) =>
        (data != null ? _i17.EnumSerialization.fromJson(data) : null);
    map[_i1.getType<_i18.Filter?>()] = (data, protocol) =>
        (data != null ? _i18.Filter.fromJson(data) : null);
    map[_i1.getType<_i19.FilterConstraint?>()] = (data, protocol) =>
        (data != null ? _i19.FilterConstraint.fromJson(data) : null);
    map[_i1.getType<_i20.FilterConstraintType?>()] = (data, protocol) =>
        (data != null ? _i20.FilterConstraintType.fromJson(data) : null);
    map[_i1.getType<_i21.ForeignKeyAction?>()] = (data, protocol) =>
        (data != null ? _i21.ForeignKeyAction.fromJson(data) : null);
    map[_i1.getType<_i22.ForeignKeyDefinition?>()] = (data, protocol) =>
        (data != null ? _i22.ForeignKeyDefinition.fromJson(data) : null);
    map[_i1.getType<_i23.ForeignKeyMatchType?>()] = (data, protocol) =>
        (data != null ? _i23.ForeignKeyMatchType.fromJson(data) : null);
    map[_i1.getType<_i24.GinOperatorClass?>()] = (data, protocol) =>
        (data != null ? _i24.GinOperatorClass.fromJson(data) : null);
    map[_i1.getType<_i25.IndexDefinition?>()] = (data, protocol) =>
        (data != null ? _i25.IndexDefinition.fromJson(data) : null);
    map[_i1.getType<_i26.IndexElementDefinition?>()] = (data, protocol) =>
        (data != null ? _i26.IndexElementDefinition.fromJson(data) : null);
    map[_i1.getType<_i27.IndexElementDefinitionType?>()] = (data, protocol) =>
        (data != null ? _i27.IndexElementDefinitionType.fromJson(data) : null);
    map[_i1.getType<_i28.MigrationsApplyResult?>()] = (data, protocol) =>
        (data != null ? _i28.MigrationsApplyResult.fromJson(data) : null);
    map[_i1.getType<_i29.TableDefinition?>()] = (data, protocol) =>
        (data != null ? _i29.TableDefinition.fromJson(data) : null);
    map[_i1.getType<_i30.TableMigration?>()] = (data, protocol) =>
        (data != null ? _i30.TableMigration.fromJson(data) : null);
    map[_i1.getType<_i31.VectorDistanceFunction?>()] = (data, protocol) =>
        (data != null ? _i31.VectorDistanceFunction.fromJson(data) : null);
    map[List<_i32.BulkQueryColumnDescription>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<_i32.BulkQueryColumnDescription>(e),
            )
            .toList();
    map[List<_i32.TableDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.TableDefinition>(e))
        .toList();
    map[List<_i32.DatabaseMigrationVersionModel>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<_i32.DatabaseMigrationVersionModel>(e),
            )
            .toList();
    map[List<_i32.DatabaseMigrationAction>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.DatabaseMigrationAction>(e))
        .toList();
    map[List<_i32.DatabaseMigrationWarning>] = (data, protocol) =>
        (data as List)
            .map((e) => protocol.deserialize<_i32.DatabaseMigrationWarning>(e))
            .toList();
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[List<_i32.FilterConstraint>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.FilterConstraint>(e))
        .toList();
    map[List<_i32.IndexElementDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.IndexElementDefinition>(e))
        .toList();
    map[Map<String, String>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String>(v),
      ),
    );
    map[_i1.getType<Map<String, String>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<String>(v),
            ),
          )
        : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[_i1.getType<List<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toList()
        : null);
    map[List<_i32.ColumnDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.ColumnDefinition>(e))
        .toList();
    map[List<_i32.ForeignKeyDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.ForeignKeyDefinition>(e))
        .toList();
    map[List<_i32.IndexDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.IndexDefinition>(e))
        .toList();
    map[List<_i32.ColumnMigration>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i32.ColumnMigration>(e))
        .toList();
    return map;
  }

  void registerHostProtocol(
    String projectName,
    _i1.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

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

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
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
      _i24.GinOperatorClass => 'GinOperatorClass',
      _i25.IndexDefinition => 'IndexDefinition',
      _i26.IndexElementDefinition => 'IndexElementDefinition',
      _i27.IndexElementDefinitionType => 'IndexElementDefinitionType',
      _i28.MigrationsApplyResult => 'MigrationsApplyResult',
      _i29.TableDefinition => 'TableDefinition',
      _i30.TableMigration => 'TableMigration',
      _i31.VectorDistanceFunction => 'VectorDistanceFunction',
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
      case _i24.GinOperatorClass():
        return 'GinOperatorClass';
      case _i25.IndexDefinition():
        return 'IndexDefinition';
      case _i26.IndexElementDefinition():
        return 'IndexElementDefinition';
      case _i27.IndexElementDefinitionType():
        return 'IndexElementDefinitionType';
      case _i28.MigrationsApplyResult():
        return 'MigrationsApplyResult';
      case _i29.TableDefinition():
        return 'TableDefinition';
      case _i30.TableMigration():
        return 'TableMigration';
      case _i31.VectorDistanceFunction():
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
    if (dataClassName == 'GinOperatorClass') {
      return deserialize<_i24.GinOperatorClass>(data['data']);
    }
    if (dataClassName == 'IndexDefinition') {
      return deserialize<_i25.IndexDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinition') {
      return deserialize<_i26.IndexElementDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinitionType') {
      return deserialize<_i27.IndexElementDefinitionType>(data['data']);
    }
    if (dataClassName == 'MigrationsApplyResult') {
      return deserialize<_i28.MigrationsApplyResult>(data['data']);
    }
    if (dataClassName == 'TableDefinition') {
      return deserialize<_i29.TableDefinition>(data['data']);
    }
    if (dataClassName == 'TableMigration') {
      return deserialize<_i30.TableMigration>(data['data']);
    }
    if (dataClassName == 'VectorDistanceFunction') {
      return deserialize<_i31.VectorDistanceFunction>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _i1.SerializationManager.toEncodableForProtocol(wrapped)
          : _i1.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on FormatException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  String getModuleName() => 'serverpod';

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
