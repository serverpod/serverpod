/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'auth_key.dart' as _i2;
import 'cache_info.dart' as _i3;
import 'caches_info.dart' as _i4;
import 'cloud_storage.dart' as _i5;
import 'cloud_storage_direct_upload.dart' as _i6;
import 'cluster_info.dart' as _i7;
import 'cluster_server_info.dart' as _i8;
import 'database/column_definition.dart' as _i9;
import 'database/column_type.dart' as _i10;
import 'database/database_definition.dart' as _i11;
import 'database/database_migration.dart' as _i12;
import 'database/database_migration_action.dart' as _i13;
import 'database/database_migration_action_type.dart' as _i14;
import 'database/foreign_key_action.dart' as _i15;
import 'database/foreign_key_definition.dart' as _i16;
import 'database/foreign_key_match_type.dart' as _i17;
import 'database/index_definition.dart' as _i18;
import 'database/index_element_definition.dart' as _i19;
import 'database/index_element_definition_type.dart' as _i20;
import 'database/table_definition.dart' as _i21;
import 'database/table_migration.dart' as _i22;
import 'distributed_cache_entry.dart' as _i23;
import 'future_call_entry.dart' as _i24;
import 'log_entry.dart' as _i25;
import 'log_level.dart' as _i26;
import 'log_result.dart' as _i27;
import 'log_settings.dart' as _i28;
import 'log_settings_override.dart' as _i29;
import 'message_log_entry.dart' as _i30;
import 'method_info.dart' as _i31;
import 'query_log_entry.dart' as _i32;
import 'readwrite_test.dart' as _i33;
import 'runtime_settings.dart' as _i34;
import 'server_health_connection_info.dart' as _i35;
import 'server_health_metric.dart' as _i36;
import 'server_health_result.dart' as _i37;
import 'session_log_entry.dart' as _i38;
import 'session_log_filter.dart' as _i39;
import 'session_log_info.dart' as _i40;
import 'session_log_result.dart' as _i41;
import 'protocol.dart' as _i42;
export 'auth_key.dart';
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
export 'database/column_definition.dart';
export 'database/column_type.dart';
export 'database/database_definition.dart';
export 'database/database_migration.dart';
export 'database/database_migration_action.dart';
export 'database/database_migration_action_type.dart';
export 'database/foreign_key_action.dart';
export 'database/foreign_key_definition.dart';
export 'database/foreign_key_match_type.dart';
export 'database/index_definition.dart';
export 'database/index_element_definition.dart';
export 'database/index_element_definition_type.dart';
export 'database/table_definition.dart';
export 'database/table_migration.dart';
export 'distributed_cache_entry.dart';
export 'future_call_entry.dart';
export 'log_entry.dart';
export 'log_level.dart';
export 'log_result.dart';
export 'log_settings.dart';
export 'log_settings_override.dart';
export 'message_log_entry.dart';
export 'method_info.dart';
export 'query_log_entry.dart';
export 'readwrite_test.dart';
export 'runtime_settings.dart';
export 'server_health_connection_info.dart';
export 'server_health_metric.dart';
export 'server_health_result.dart';
export 'session_log_entry.dart';
export 'session_log_filter.dart';
export 'session_log_info.dart';
export 'session_log_result.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.AuthKey) {
      return _i2.AuthKey.fromJson(data, this) as T;
    }
    if (t == _i3.CacheInfo) {
      return _i3.CacheInfo.fromJson(data, this) as T;
    }
    if (t == _i4.CachesInfo) {
      return _i4.CachesInfo.fromJson(data, this) as T;
    }
    if (t == _i5.CloudStorageEntry) {
      return _i5.CloudStorageEntry.fromJson(data, this) as T;
    }
    if (t == _i6.CloudStorageDirectUploadEntry) {
      return _i6.CloudStorageDirectUploadEntry.fromJson(data, this) as T;
    }
    if (t == _i7.ClusterInfo) {
      return _i7.ClusterInfo.fromJson(data, this) as T;
    }
    if (t == _i8.ClusterServerInfo) {
      return _i8.ClusterServerInfo.fromJson(data, this) as T;
    }
    if (t == _i9.ColumnDefinition) {
      return _i9.ColumnDefinition.fromJson(data, this) as T;
    }
    if (t == _i10.ColumnType) {
      return _i10.ColumnType.fromJson(data) as T;
    }
    if (t == _i11.DatabaseDefinition) {
      return _i11.DatabaseDefinition.fromJson(data, this) as T;
    }
    if (t == _i12.DatabaseMigration) {
      return _i12.DatabaseMigration.fromJson(data, this) as T;
    }
    if (t == _i13.DatabaseMigrationAction) {
      return _i13.DatabaseMigrationAction.fromJson(data, this) as T;
    }
    if (t == _i14.DatabaseMigrationActionType) {
      return _i14.DatabaseMigrationActionType.fromJson(data) as T;
    }
    if (t == _i15.ForeignKeyAction) {
      return _i15.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _i16.ForeignKeyDefinition) {
      return _i16.ForeignKeyDefinition.fromJson(data, this) as T;
    }
    if (t == _i17.ForeignKeyMatchType) {
      return _i17.ForeignKeyMatchType.fromJson(data) as T;
    }
    if (t == _i18.IndexDefinition) {
      return _i18.IndexDefinition.fromJson(data, this) as T;
    }
    if (t == _i19.IndexElementDefinition) {
      return _i19.IndexElementDefinition.fromJson(data, this) as T;
    }
    if (t == _i20.IndexElementDefinitionType) {
      return _i20.IndexElementDefinitionType.fromJson(data) as T;
    }
    if (t == _i21.TableDefinition) {
      return _i21.TableDefinition.fromJson(data, this) as T;
    }
    if (t == _i22.TableMigration) {
      return _i22.TableMigration.fromJson(data, this) as T;
    }
    if (t == _i23.DistributedCacheEntry) {
      return _i23.DistributedCacheEntry.fromJson(data, this) as T;
    }
    if (t == _i24.FutureCallEntry) {
      return _i24.FutureCallEntry.fromJson(data, this) as T;
    }
    if (t == _i25.LogEntry) {
      return _i25.LogEntry.fromJson(data, this) as T;
    }
    if (t == _i26.LogLevel) {
      return _i26.LogLevel.fromJson(data) as T;
    }
    if (t == _i27.LogResult) {
      return _i27.LogResult.fromJson(data, this) as T;
    }
    if (t == _i28.LogSettings) {
      return _i28.LogSettings.fromJson(data, this) as T;
    }
    if (t == _i29.LogSettingsOverride) {
      return _i29.LogSettingsOverride.fromJson(data, this) as T;
    }
    if (t == _i30.MessageLogEntry) {
      return _i30.MessageLogEntry.fromJson(data, this) as T;
    }
    if (t == _i31.MethodInfo) {
      return _i31.MethodInfo.fromJson(data, this) as T;
    }
    if (t == _i32.QueryLogEntry) {
      return _i32.QueryLogEntry.fromJson(data, this) as T;
    }
    if (t == _i33.ReadWriteTestEntry) {
      return _i33.ReadWriteTestEntry.fromJson(data, this) as T;
    }
    if (t == _i34.RuntimeSettings) {
      return _i34.RuntimeSettings.fromJson(data, this) as T;
    }
    if (t == _i35.ServerHealthConnectionInfo) {
      return _i35.ServerHealthConnectionInfo.fromJson(data, this) as T;
    }
    if (t == _i36.ServerHealthMetric) {
      return _i36.ServerHealthMetric.fromJson(data, this) as T;
    }
    if (t == _i37.ServerHealthResult) {
      return _i37.ServerHealthResult.fromJson(data, this) as T;
    }
    if (t == _i38.SessionLogEntry) {
      return _i38.SessionLogEntry.fromJson(data, this) as T;
    }
    if (t == _i39.SessionLogFilter) {
      return _i39.SessionLogFilter.fromJson(data, this) as T;
    }
    if (t == _i40.SessionLogInfo) {
      return _i40.SessionLogInfo.fromJson(data, this) as T;
    }
    if (t == _i41.SessionLogResult) {
      return _i41.SessionLogResult.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.AuthKey?>()) {
      return (data != null ? _i2.AuthKey.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.CacheInfo?>()) {
      return (data != null ? _i3.CacheInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.CachesInfo?>()) {
      return (data != null ? _i4.CachesInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.CloudStorageEntry?>()) {
      return (data != null ? _i5.CloudStorageEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.CloudStorageDirectUploadEntry?>()) {
      return (data != null
          ? _i6.CloudStorageDirectUploadEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i7.ClusterInfo?>()) {
      return (data != null ? _i7.ClusterInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.ClusterServerInfo?>()) {
      return (data != null ? _i8.ClusterServerInfo.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.ColumnDefinition?>()) {
      return (data != null ? _i9.ColumnDefinition.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ColumnType?>()) {
      return (data != null ? _i10.ColumnType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.DatabaseDefinition?>()) {
      return (data != null
          ? _i11.DatabaseDefinition.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i12.DatabaseMigration?>()) {
      return (data != null ? _i12.DatabaseMigration.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i13.DatabaseMigrationAction?>()) {
      return (data != null
          ? _i13.DatabaseMigrationAction.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i14.DatabaseMigrationActionType?>()) {
      return (data != null
          ? _i14.DatabaseMigrationActionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.ForeignKeyAction?>()) {
      return (data != null ? _i15.ForeignKeyAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ForeignKeyDefinition?>()) {
      return (data != null
          ? _i16.ForeignKeyDefinition.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i17.ForeignKeyMatchType?>()) {
      return (data != null ? _i17.ForeignKeyMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.IndexDefinition?>()) {
      return (data != null ? _i18.IndexDefinition.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i19.IndexElementDefinition?>()) {
      return (data != null
          ? _i19.IndexElementDefinition.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i20.IndexElementDefinitionType?>()) {
      return (data != null
          ? _i20.IndexElementDefinitionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i21.TableDefinition?>()) {
      return (data != null ? _i21.TableDefinition.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i22.TableMigration?>()) {
      return (data != null ? _i22.TableMigration.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i23.DistributedCacheEntry?>()) {
      return (data != null
          ? _i23.DistributedCacheEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i24.FutureCallEntry?>()) {
      return (data != null ? _i24.FutureCallEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i25.LogEntry?>()) {
      return (data != null ? _i25.LogEntry.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i26.LogLevel?>()) {
      return (data != null ? _i26.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.LogResult?>()) {
      return (data != null ? _i27.LogResult.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i28.LogSettings?>()) {
      return (data != null ? _i28.LogSettings.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i29.LogSettingsOverride?>()) {
      return (data != null
          ? _i29.LogSettingsOverride.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i30.MessageLogEntry?>()) {
      return (data != null ? _i30.MessageLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i31.MethodInfo?>()) {
      return (data != null ? _i31.MethodInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i32.QueryLogEntry?>()) {
      return (data != null ? _i32.QueryLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i33.ReadWriteTestEntry?>()) {
      return (data != null
          ? _i33.ReadWriteTestEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i34.RuntimeSettings?>()) {
      return (data != null ? _i34.RuntimeSettings.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i35.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i35.ServerHealthConnectionInfo.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i36.ServerHealthMetric?>()) {
      return (data != null
          ? _i36.ServerHealthMetric.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i37.ServerHealthResult?>()) {
      return (data != null
          ? _i37.ServerHealthResult.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i38.SessionLogEntry?>()) {
      return (data != null ? _i38.SessionLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i39.SessionLogFilter?>()) {
      return (data != null ? _i39.SessionLogFilter.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i40.SessionLogInfo?>()) {
      return (data != null ? _i40.SessionLogInfo.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i41.SessionLogResult?>()) {
      return (data != null ? _i41.SessionLogResult.fromJson(data, this) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i42.ClusterServerInfo>) {
      return (data as List)
          .map((e) => deserialize<_i42.ClusterServerInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i42.TableDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.DatabaseMigrationAction>) {
      return (data as List)
          .map((e) => deserialize<_i42.DatabaseMigrationAction>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.IndexElementDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i42.IndexElementDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.ColumnDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i42.ColumnDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.ForeignKeyDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i42.ForeignKeyDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.IndexDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i42.IndexDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.LogEntry>) {
      return (data as List).map((e) => deserialize<_i42.LogEntry>(e)).toList()
          as dynamic;
    }
    if (t == List<_i42.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserialize<_i42.LogSettingsOverride>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserialize<_i42.ServerHealthMetric>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserialize<_i42.ServerHealthConnectionInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i42.QueryLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i42.MessageLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i42.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserialize<_i42.SessionLogInfo>(e))
          .toList() as dynamic;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i2.AuthKey) {
      return 'AuthKey';
    }
    if (data is _i3.CacheInfo) {
      return 'CacheInfo';
    }
    if (data is _i4.CachesInfo) {
      return 'CachesInfo';
    }
    if (data is _i5.CloudStorageEntry) {
      return 'CloudStorageEntry';
    }
    if (data is _i6.CloudStorageDirectUploadEntry) {
      return 'CloudStorageDirectUploadEntry';
    }
    if (data is _i7.ClusterInfo) {
      return 'ClusterInfo';
    }
    if (data is _i8.ClusterServerInfo) {
      return 'ClusterServerInfo';
    }
    if (data is _i9.ColumnDefinition) {
      return 'ColumnDefinition';
    }
    if (data is _i10.ColumnType) {
      return 'ColumnType';
    }
    if (data is _i11.DatabaseDefinition) {
      return 'DatabaseDefinition';
    }
    if (data is _i12.DatabaseMigration) {
      return 'DatabaseMigration';
    }
    if (data is _i13.DatabaseMigrationAction) {
      return 'DatabaseMigrationAction';
    }
    if (data is _i14.DatabaseMigrationActionType) {
      return 'DatabaseMigrationActionType';
    }
    if (data is _i15.ForeignKeyAction) {
      return 'ForeignKeyAction';
    }
    if (data is _i16.ForeignKeyDefinition) {
      return 'ForeignKeyDefinition';
    }
    if (data is _i17.ForeignKeyMatchType) {
      return 'ForeignKeyMatchType';
    }
    if (data is _i18.IndexDefinition) {
      return 'IndexDefinition';
    }
    if (data is _i19.IndexElementDefinition) {
      return 'IndexElementDefinition';
    }
    if (data is _i20.IndexElementDefinitionType) {
      return 'IndexElementDefinitionType';
    }
    if (data is _i21.TableDefinition) {
      return 'TableDefinition';
    }
    if (data is _i22.TableMigration) {
      return 'TableMigration';
    }
    if (data is _i23.DistributedCacheEntry) {
      return 'DistributedCacheEntry';
    }
    if (data is _i24.FutureCallEntry) {
      return 'FutureCallEntry';
    }
    if (data is _i25.LogEntry) {
      return 'LogEntry';
    }
    if (data is _i26.LogLevel) {
      return 'LogLevel';
    }
    if (data is _i27.LogResult) {
      return 'LogResult';
    }
    if (data is _i28.LogSettings) {
      return 'LogSettings';
    }
    if (data is _i29.LogSettingsOverride) {
      return 'LogSettingsOverride';
    }
    if (data is _i30.MessageLogEntry) {
      return 'MessageLogEntry';
    }
    if (data is _i31.MethodInfo) {
      return 'MethodInfo';
    }
    if (data is _i32.QueryLogEntry) {
      return 'QueryLogEntry';
    }
    if (data is _i33.ReadWriteTestEntry) {
      return 'ReadWriteTestEntry';
    }
    if (data is _i34.RuntimeSettings) {
      return 'RuntimeSettings';
    }
    if (data is _i35.ServerHealthConnectionInfo) {
      return 'ServerHealthConnectionInfo';
    }
    if (data is _i36.ServerHealthMetric) {
      return 'ServerHealthMetric';
    }
    if (data is _i37.ServerHealthResult) {
      return 'ServerHealthResult';
    }
    if (data is _i38.SessionLogEntry) {
      return 'SessionLogEntry';
    }
    if (data is _i39.SessionLogFilter) {
      return 'SessionLogFilter';
    }
    if (data is _i40.SessionLogInfo) {
      return 'SessionLogInfo';
    }
    if (data is _i41.SessionLogResult) {
      return 'SessionLogResult';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'AuthKey') {
      return deserialize<_i2.AuthKey>(data['data']);
    }
    if (data['className'] == 'CacheInfo') {
      return deserialize<_i3.CacheInfo>(data['data']);
    }
    if (data['className'] == 'CachesInfo') {
      return deserialize<_i4.CachesInfo>(data['data']);
    }
    if (data['className'] == 'CloudStorageEntry') {
      return deserialize<_i5.CloudStorageEntry>(data['data']);
    }
    if (data['className'] == 'CloudStorageDirectUploadEntry') {
      return deserialize<_i6.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (data['className'] == 'ClusterInfo') {
      return deserialize<_i7.ClusterInfo>(data['data']);
    }
    if (data['className'] == 'ClusterServerInfo') {
      return deserialize<_i8.ClusterServerInfo>(data['data']);
    }
    if (data['className'] == 'ColumnDefinition') {
      return deserialize<_i9.ColumnDefinition>(data['data']);
    }
    if (data['className'] == 'ColumnType') {
      return deserialize<_i10.ColumnType>(data['data']);
    }
    if (data['className'] == 'DatabaseDefinition') {
      return deserialize<_i11.DatabaseDefinition>(data['data']);
    }
    if (data['className'] == 'DatabaseMigration') {
      return deserialize<_i12.DatabaseMigration>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationAction') {
      return deserialize<_i13.DatabaseMigrationAction>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationActionType') {
      return deserialize<_i14.DatabaseMigrationActionType>(data['data']);
    }
    if (data['className'] == 'ForeignKeyAction') {
      return deserialize<_i15.ForeignKeyAction>(data['data']);
    }
    if (data['className'] == 'ForeignKeyDefinition') {
      return deserialize<_i16.ForeignKeyDefinition>(data['data']);
    }
    if (data['className'] == 'ForeignKeyMatchType') {
      return deserialize<_i17.ForeignKeyMatchType>(data['data']);
    }
    if (data['className'] == 'IndexDefinition') {
      return deserialize<_i18.IndexDefinition>(data['data']);
    }
    if (data['className'] == 'IndexElementDefinition') {
      return deserialize<_i19.IndexElementDefinition>(data['data']);
    }
    if (data['className'] == 'IndexElementDefinitionType') {
      return deserialize<_i20.IndexElementDefinitionType>(data['data']);
    }
    if (data['className'] == 'TableDefinition') {
      return deserialize<_i21.TableDefinition>(data['data']);
    }
    if (data['className'] == 'TableMigration') {
      return deserialize<_i22.TableMigration>(data['data']);
    }
    if (data['className'] == 'DistributedCacheEntry') {
      return deserialize<_i23.DistributedCacheEntry>(data['data']);
    }
    if (data['className'] == 'FutureCallEntry') {
      return deserialize<_i24.FutureCallEntry>(data['data']);
    }
    if (data['className'] == 'LogEntry') {
      return deserialize<_i25.LogEntry>(data['data']);
    }
    if (data['className'] == 'LogLevel') {
      return deserialize<_i26.LogLevel>(data['data']);
    }
    if (data['className'] == 'LogResult') {
      return deserialize<_i27.LogResult>(data['data']);
    }
    if (data['className'] == 'LogSettings') {
      return deserialize<_i28.LogSettings>(data['data']);
    }
    if (data['className'] == 'LogSettingsOverride') {
      return deserialize<_i29.LogSettingsOverride>(data['data']);
    }
    if (data['className'] == 'MessageLogEntry') {
      return deserialize<_i30.MessageLogEntry>(data['data']);
    }
    if (data['className'] == 'MethodInfo') {
      return deserialize<_i31.MethodInfo>(data['data']);
    }
    if (data['className'] == 'QueryLogEntry') {
      return deserialize<_i32.QueryLogEntry>(data['data']);
    }
    if (data['className'] == 'ReadWriteTestEntry') {
      return deserialize<_i33.ReadWriteTestEntry>(data['data']);
    }
    if (data['className'] == 'RuntimeSettings') {
      return deserialize<_i34.RuntimeSettings>(data['data']);
    }
    if (data['className'] == 'ServerHealthConnectionInfo') {
      return deserialize<_i35.ServerHealthConnectionInfo>(data['data']);
    }
    if (data['className'] == 'ServerHealthMetric') {
      return deserialize<_i36.ServerHealthMetric>(data['data']);
    }
    if (data['className'] == 'ServerHealthResult') {
      return deserialize<_i37.ServerHealthResult>(data['data']);
    }
    if (data['className'] == 'SessionLogEntry') {
      return deserialize<_i38.SessionLogEntry>(data['data']);
    }
    if (data['className'] == 'SessionLogFilter') {
      return deserialize<_i39.SessionLogFilter>(data['data']);
    }
    if (data['className'] == 'SessionLogInfo') {
      return deserialize<_i40.SessionLogInfo>(data['data']);
    }
    if (data['className'] == 'SessionLogResult') {
      return deserialize<_i41.SessionLogResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
