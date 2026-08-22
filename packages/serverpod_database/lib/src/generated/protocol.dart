/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'bulk_data.dart' as _iix79rrm;
import 'bulk_data_exception.dart' as _i6ksrbgg;
import 'bulk_query_column_description.dart' as _i5qwhk8q;
import 'bulk_query_result.dart' as _iehqmka8;
import 'column_definition.dart' as _i2sdi2ed;
import 'column_migration.dart' as _iyvv4rq3;
import 'column_type.dart' as _i4ua1ejo;
import 'database_definition.dart' as _i1k8jo17;
import 'database_definitions.dart' as _i2pwr6iz;
import 'database_migration.dart' as _ije4ra3g;
import 'database_migration_action.dart' as _ib6ced2r;
import 'database_migration_action_type.dart' as _if91rmm0;
import 'database_migration_version.dart' as _i2x83mx1;
import 'database_migration_warning.dart' as _i14avsk8;
import 'database_migration_warning_type.dart' as _iwrp118f;
import 'deferrable_constraint.dart' as _itb06st2;
import 'enum_serialization.dart' as _iwiq4jz5;
import 'filter/filter.dart' as _illmf2iz;
import 'filter/filter_constraint.dart' as _iuvcfldi;
import 'filter/filter_constraint_type.dart' as _ioh6182a;
import 'foreign_key_action.dart' as _i4d2ox9e;
import 'foreign_key_definition.dart' as _imvri9vh;
import 'foreign_key_match_type.dart' as _itqha47z;
import 'gin_operator_class.dart' as _ip0ed67z;
import 'index_definition.dart' as _i1hq2rno;
import 'index_element_definition.dart' as _iljgnmzh;
import 'index_element_definition_type.dart' as _i7xr2xwk;
import 'migrations_apply_result.dart' as _irowguds;
import 'table_definition.dart' as _id9bvszm;
import 'table_migration.dart' as _ifqv8t7l;
import 'vector_distance_function.dart' as _i5i4fyxu;
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
export 'deferrable_constraint.dart';
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

class Protocol extends _iss.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_iss.SerializationManager> _hostProtocols = {};

  void registerHostProtocol(
    String projectName,
    _iss.SerializationManager protocol,
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

    if (t == _iix79rrm.BulkData) {
      return _iix79rrm.BulkData.fromJson(data) as T;
    }
    if (t == _i6ksrbgg.BulkDataException) {
      return _i6ksrbgg.BulkDataException.fromJson(data) as T;
    }
    if (t == _i5qwhk8q.BulkQueryColumnDescription) {
      return _i5qwhk8q.BulkQueryColumnDescription.fromJson(data) as T;
    }
    if (t == _iehqmka8.BulkQueryResult) {
      return _iehqmka8.BulkQueryResult.fromJson(data) as T;
    }
    if (t == _i2sdi2ed.ColumnDefinition) {
      return _i2sdi2ed.ColumnDefinition.fromJson(data) as T;
    }
    if (t == _iyvv4rq3.ColumnMigration) {
      return _iyvv4rq3.ColumnMigration.fromJson(data) as T;
    }
    if (t == _i4ua1ejo.ColumnType) {
      return _i4ua1ejo.ColumnType.fromJson(data) as T;
    }
    if (t == _i1k8jo17.DatabaseDefinition) {
      return _i1k8jo17.DatabaseDefinition.fromJson(data) as T;
    }
    if (t == _i2pwr6iz.DatabaseDefinitions) {
      return _i2pwr6iz.DatabaseDefinitions.fromJson(data) as T;
    }
    if (t == _ije4ra3g.DatabaseMigration) {
      return _ije4ra3g.DatabaseMigration.fromJson(data) as T;
    }
    if (t == _ib6ced2r.DatabaseMigrationAction) {
      return _ib6ced2r.DatabaseMigrationAction.fromJson(data) as T;
    }
    if (t == _if91rmm0.DatabaseMigrationActionType) {
      return _if91rmm0.DatabaseMigrationActionType.fromJson(data) as T;
    }
    if (t == _i2x83mx1.DatabaseMigrationVersionModel) {
      return _i2x83mx1.DatabaseMigrationVersionModel.fromJson(data) as T;
    }
    if (t == _i14avsk8.DatabaseMigrationWarning) {
      return _i14avsk8.DatabaseMigrationWarning.fromJson(data) as T;
    }
    if (t == _iwrp118f.DatabaseMigrationWarningType) {
      return _iwrp118f.DatabaseMigrationWarningType.fromJson(data) as T;
    }
    if (t == _itb06st2.DeferrableConstraint) {
      return _itb06st2.DeferrableConstraint.fromJson(data) as T;
    }
    if (t == _iwiq4jz5.EnumSerialization) {
      return _iwiq4jz5.EnumSerialization.fromJson(data) as T;
    }
    if (t == _illmf2iz.Filter) {
      return _illmf2iz.Filter.fromJson(data) as T;
    }
    if (t == _iuvcfldi.FilterConstraint) {
      return _iuvcfldi.FilterConstraint.fromJson(data) as T;
    }
    if (t == _ioh6182a.FilterConstraintType) {
      return _ioh6182a.FilterConstraintType.fromJson(data) as T;
    }
    if (t == _i4d2ox9e.ForeignKeyAction) {
      return _i4d2ox9e.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _imvri9vh.ForeignKeyDefinition) {
      return _imvri9vh.ForeignKeyDefinition.fromJson(data) as T;
    }
    if (t == _itqha47z.ForeignKeyMatchType) {
      return _itqha47z.ForeignKeyMatchType.fromJson(data) as T;
    }
    if (t == _ip0ed67z.GinOperatorClass) {
      return _ip0ed67z.GinOperatorClass.fromJson(data) as T;
    }
    if (t == _i1hq2rno.IndexDefinition) {
      return _i1hq2rno.IndexDefinition.fromJson(data) as T;
    }
    if (t == _iljgnmzh.IndexElementDefinition) {
      return _iljgnmzh.IndexElementDefinition.fromJson(data) as T;
    }
    if (t == _i7xr2xwk.IndexElementDefinitionType) {
      return _i7xr2xwk.IndexElementDefinitionType.fromJson(data) as T;
    }
    if (t == _irowguds.MigrationsApplyResult) {
      return _irowguds.MigrationsApplyResult.fromJson(data) as T;
    }
    if (t == _id9bvszm.TableDefinition) {
      return _id9bvszm.TableDefinition.fromJson(data) as T;
    }
    if (t == _ifqv8t7l.TableMigration) {
      return _ifqv8t7l.TableMigration.fromJson(data) as T;
    }
    if (t == _i5i4fyxu.VectorDistanceFunction) {
      return _i5i4fyxu.VectorDistanceFunction.fromJson(data) as T;
    }
    if (t == _iss.getType<_iix79rrm.BulkData?>()) {
      return (data != null ? _iix79rrm.BulkData.fromJson(data) : null) as T;
    }
    if (t == _iss.getType<_i6ksrbgg.BulkDataException?>()) {
      return (data != null ? _i6ksrbgg.BulkDataException.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i5qwhk8q.BulkQueryColumnDescription?>()) {
      return (data != null
              ? _i5qwhk8q.BulkQueryColumnDescription.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_iehqmka8.BulkQueryResult?>()) {
      return (data != null ? _iehqmka8.BulkQueryResult.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i2sdi2ed.ColumnDefinition?>()) {
      return (data != null ? _i2sdi2ed.ColumnDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_iyvv4rq3.ColumnMigration?>()) {
      return (data != null ? _iyvv4rq3.ColumnMigration.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i4ua1ejo.ColumnType?>()) {
      return (data != null ? _i4ua1ejo.ColumnType.fromJson(data) : null) as T;
    }
    if (t == _iss.getType<_i1k8jo17.DatabaseDefinition?>()) {
      return (data != null ? _i1k8jo17.DatabaseDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i2pwr6iz.DatabaseDefinitions?>()) {
      return (data != null
              ? _i2pwr6iz.DatabaseDefinitions.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_ije4ra3g.DatabaseMigration?>()) {
      return (data != null ? _ije4ra3g.DatabaseMigration.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_ib6ced2r.DatabaseMigrationAction?>()) {
      return (data != null
              ? _ib6ced2r.DatabaseMigrationAction.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_if91rmm0.DatabaseMigrationActionType?>()) {
      return (data != null
              ? _if91rmm0.DatabaseMigrationActionType.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_i2x83mx1.DatabaseMigrationVersionModel?>()) {
      return (data != null
              ? _i2x83mx1.DatabaseMigrationVersionModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_i14avsk8.DatabaseMigrationWarning?>()) {
      return (data != null
              ? _i14avsk8.DatabaseMigrationWarning.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_iwrp118f.DatabaseMigrationWarningType?>()) {
      return (data != null
              ? _iwrp118f.DatabaseMigrationWarningType.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_itb06st2.DeferrableConstraint?>()) {
      return (data != null
              ? _itb06st2.DeferrableConstraint.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_iwiq4jz5.EnumSerialization?>()) {
      return (data != null ? _iwiq4jz5.EnumSerialization.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_illmf2iz.Filter?>()) {
      return (data != null ? _illmf2iz.Filter.fromJson(data) : null) as T;
    }
    if (t == _iss.getType<_iuvcfldi.FilterConstraint?>()) {
      return (data != null ? _iuvcfldi.FilterConstraint.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_ioh6182a.FilterConstraintType?>()) {
      return (data != null
              ? _ioh6182a.FilterConstraintType.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_i4d2ox9e.ForeignKeyAction?>()) {
      return (data != null ? _i4d2ox9e.ForeignKeyAction.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_imvri9vh.ForeignKeyDefinition?>()) {
      return (data != null
              ? _imvri9vh.ForeignKeyDefinition.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_itqha47z.ForeignKeyMatchType?>()) {
      return (data != null
              ? _itqha47z.ForeignKeyMatchType.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_ip0ed67z.GinOperatorClass?>()) {
      return (data != null ? _ip0ed67z.GinOperatorClass.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i1hq2rno.IndexDefinition?>()) {
      return (data != null ? _i1hq2rno.IndexDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_iljgnmzh.IndexElementDefinition?>()) {
      return (data != null
              ? _iljgnmzh.IndexElementDefinition.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_i7xr2xwk.IndexElementDefinitionType?>()) {
      return (data != null
              ? _i7xr2xwk.IndexElementDefinitionType.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_irowguds.MigrationsApplyResult?>()) {
      return (data != null
              ? _irowguds.MigrationsApplyResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_id9bvszm.TableDefinition?>()) {
      return (data != null ? _id9bvszm.TableDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_ifqv8t7l.TableMigration?>()) {
      return (data != null ? _ifqv8t7l.TableMigration.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i5i4fyxu.VectorDistanceFunction?>()) {
      return (data != null
              ? _i5i4fyxu.VectorDistanceFunction.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_isd.BulkQueryColumnDescription>) {
      return (data as List)
              .map((e) => deserialize<_isd.BulkQueryColumnDescription>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.TableDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.TableDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.DatabaseMigrationVersionModel>) {
      return (data as List)
              .map((e) => deserialize<_isd.DatabaseMigrationVersionModel>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.DatabaseMigrationAction>) {
      return (data as List)
              .map((e) => deserialize<_isd.DatabaseMigrationAction>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.DatabaseMigrationWarning>) {
      return (data as List)
              .map((e) => deserialize<_isd.DatabaseMigrationWarning>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_isd.FilterConstraint>) {
      return (data as List)
              .map((e) => deserialize<_isd.FilterConstraint>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.IndexElementDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.IndexElementDefinition>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _iss.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == _iss.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_isd.ColumnDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.ColumnDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.ForeignKeyDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.ForeignKeyDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.IndexDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.IndexDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.ColumnMigration>) {
      return (data as List)
              .map((e) => deserialize<_isd.ColumnMigration>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iix79rrm.BulkData => 'BulkData',
      _i6ksrbgg.BulkDataException => 'BulkDataException',
      _i5qwhk8q.BulkQueryColumnDescription => 'BulkQueryColumnDescription',
      _iehqmka8.BulkQueryResult => 'BulkQueryResult',
      _i2sdi2ed.ColumnDefinition => 'ColumnDefinition',
      _iyvv4rq3.ColumnMigration => 'ColumnMigration',
      _i4ua1ejo.ColumnType => 'ColumnType',
      _i1k8jo17.DatabaseDefinition => 'DatabaseDefinition',
      _i2pwr6iz.DatabaseDefinitions => 'DatabaseDefinitions',
      _ije4ra3g.DatabaseMigration => 'DatabaseMigration',
      _ib6ced2r.DatabaseMigrationAction => 'DatabaseMigrationAction',
      _if91rmm0.DatabaseMigrationActionType => 'DatabaseMigrationActionType',
      _i2x83mx1.DatabaseMigrationVersionModel =>
        'DatabaseMigrationVersionModel',
      _i14avsk8.DatabaseMigrationWarning => 'DatabaseMigrationWarning',
      _iwrp118f.DatabaseMigrationWarningType => 'DatabaseMigrationWarningType',
      _itb06st2.DeferrableConstraint => 'DeferrableConstraint',
      _iwiq4jz5.EnumSerialization => 'EnumSerialization',
      _illmf2iz.Filter => 'Filter',
      _iuvcfldi.FilterConstraint => 'FilterConstraint',
      _ioh6182a.FilterConstraintType => 'FilterConstraintType',
      _i4d2ox9e.ForeignKeyAction => 'ForeignKeyAction',
      _imvri9vh.ForeignKeyDefinition => 'ForeignKeyDefinition',
      _itqha47z.ForeignKeyMatchType => 'ForeignKeyMatchType',
      _ip0ed67z.GinOperatorClass => 'GinOperatorClass',
      _i1hq2rno.IndexDefinition => 'IndexDefinition',
      _iljgnmzh.IndexElementDefinition => 'IndexElementDefinition',
      _i7xr2xwk.IndexElementDefinitionType => 'IndexElementDefinitionType',
      _irowguds.MigrationsApplyResult => 'MigrationsApplyResult',
      _id9bvszm.TableDefinition => 'TableDefinition',
      _ifqv8t7l.TableMigration => 'TableMigration',
      _i5i4fyxu.VectorDistanceFunction => 'VectorDistanceFunction',
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
      case _iix79rrm.BulkData():
        return 'BulkData';
      case _i6ksrbgg.BulkDataException():
        return 'BulkDataException';
      case _i5qwhk8q.BulkQueryColumnDescription():
        return 'BulkQueryColumnDescription';
      case _iehqmka8.BulkQueryResult():
        return 'BulkQueryResult';
      case _i2sdi2ed.ColumnDefinition():
        return 'ColumnDefinition';
      case _iyvv4rq3.ColumnMigration():
        return 'ColumnMigration';
      case _i4ua1ejo.ColumnType():
        return 'ColumnType';
      case _i1k8jo17.DatabaseDefinition():
        return 'DatabaseDefinition';
      case _i2pwr6iz.DatabaseDefinitions():
        return 'DatabaseDefinitions';
      case _ije4ra3g.DatabaseMigration():
        return 'DatabaseMigration';
      case _ib6ced2r.DatabaseMigrationAction():
        return 'DatabaseMigrationAction';
      case _if91rmm0.DatabaseMigrationActionType():
        return 'DatabaseMigrationActionType';
      case _i2x83mx1.DatabaseMigrationVersionModel():
        return 'DatabaseMigrationVersionModel';
      case _i14avsk8.DatabaseMigrationWarning():
        return 'DatabaseMigrationWarning';
      case _iwrp118f.DatabaseMigrationWarningType():
        return 'DatabaseMigrationWarningType';
      case _itb06st2.DeferrableConstraint():
        return 'DeferrableConstraint';
      case _iwiq4jz5.EnumSerialization():
        return 'EnumSerialization';
      case _illmf2iz.Filter():
        return 'Filter';
      case _iuvcfldi.FilterConstraint():
        return 'FilterConstraint';
      case _ioh6182a.FilterConstraintType():
        return 'FilterConstraintType';
      case _i4d2ox9e.ForeignKeyAction():
        return 'ForeignKeyAction';
      case _imvri9vh.ForeignKeyDefinition():
        return 'ForeignKeyDefinition';
      case _itqha47z.ForeignKeyMatchType():
        return 'ForeignKeyMatchType';
      case _ip0ed67z.GinOperatorClass():
        return 'GinOperatorClass';
      case _i1hq2rno.IndexDefinition():
        return 'IndexDefinition';
      case _iljgnmzh.IndexElementDefinition():
        return 'IndexElementDefinition';
      case _i7xr2xwk.IndexElementDefinitionType():
        return 'IndexElementDefinitionType';
      case _irowguds.MigrationsApplyResult():
        return 'MigrationsApplyResult';
      case _id9bvszm.TableDefinition():
        return 'TableDefinition';
      case _ifqv8t7l.TableMigration():
        return 'TableMigration';
      case _i5i4fyxu.VectorDistanceFunction():
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
      return deserialize<_iix79rrm.BulkData>(data['data']);
    }
    if (dataClassName == 'BulkDataException') {
      return deserialize<_i6ksrbgg.BulkDataException>(data['data']);
    }
    if (dataClassName == 'BulkQueryColumnDescription') {
      return deserialize<_i5qwhk8q.BulkQueryColumnDescription>(data['data']);
    }
    if (dataClassName == 'BulkQueryResult') {
      return deserialize<_iehqmka8.BulkQueryResult>(data['data']);
    }
    if (dataClassName == 'ColumnDefinition') {
      return deserialize<_i2sdi2ed.ColumnDefinition>(data['data']);
    }
    if (dataClassName == 'ColumnMigration') {
      return deserialize<_iyvv4rq3.ColumnMigration>(data['data']);
    }
    if (dataClassName == 'ColumnType') {
      return deserialize<_i4ua1ejo.ColumnType>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinition') {
      return deserialize<_i1k8jo17.DatabaseDefinition>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinitions') {
      return deserialize<_i2pwr6iz.DatabaseDefinitions>(data['data']);
    }
    if (dataClassName == 'DatabaseMigration') {
      return deserialize<_ije4ra3g.DatabaseMigration>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationAction') {
      return deserialize<_ib6ced2r.DatabaseMigrationAction>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationActionType') {
      return deserialize<_if91rmm0.DatabaseMigrationActionType>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersionModel') {
      return deserialize<_i2x83mx1.DatabaseMigrationVersionModel>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarning') {
      return deserialize<_i14avsk8.DatabaseMigrationWarning>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarningType') {
      return deserialize<_iwrp118f.DatabaseMigrationWarningType>(data['data']);
    }
    if (dataClassName == 'DeferrableConstraint') {
      return deserialize<_itb06st2.DeferrableConstraint>(data['data']);
    }
    if (dataClassName == 'EnumSerialization') {
      return deserialize<_iwiq4jz5.EnumSerialization>(data['data']);
    }
    if (dataClassName == 'Filter') {
      return deserialize<_illmf2iz.Filter>(data['data']);
    }
    if (dataClassName == 'FilterConstraint') {
      return deserialize<_iuvcfldi.FilterConstraint>(data['data']);
    }
    if (dataClassName == 'FilterConstraintType') {
      return deserialize<_ioh6182a.FilterConstraintType>(data['data']);
    }
    if (dataClassName == 'ForeignKeyAction') {
      return deserialize<_i4d2ox9e.ForeignKeyAction>(data['data']);
    }
    if (dataClassName == 'ForeignKeyDefinition') {
      return deserialize<_imvri9vh.ForeignKeyDefinition>(data['data']);
    }
    if (dataClassName == 'ForeignKeyMatchType') {
      return deserialize<_itqha47z.ForeignKeyMatchType>(data['data']);
    }
    if (dataClassName == 'GinOperatorClass') {
      return deserialize<_ip0ed67z.GinOperatorClass>(data['data']);
    }
    if (dataClassName == 'IndexDefinition') {
      return deserialize<_i1hq2rno.IndexDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinition') {
      return deserialize<_iljgnmzh.IndexElementDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinitionType') {
      return deserialize<_i7xr2xwk.IndexElementDefinitionType>(data['data']);
    }
    if (dataClassName == 'MigrationsApplyResult') {
      return deserialize<_irowguds.MigrationsApplyResult>(data['data']);
    }
    if (dataClassName == 'TableDefinition') {
      return deserialize<_id9bvszm.TableDefinition>(data['data']);
    }
    if (dataClassName == 'TableMigration') {
      return deserialize<_ifqv8t7l.TableMigration>(data['data']);
    }
    if (dataClassName == 'VectorDistanceFunction') {
      return deserialize<_i5i4fyxu.VectorDistanceFunction>(data['data']);
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
          ? _iss.SerializationManager.toEncodableForProtocol(wrapped)
          : _iss.SerializationManager.toEncodable(wrapped);
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
