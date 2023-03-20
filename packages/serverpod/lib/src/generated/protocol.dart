/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'auth_key.dart' as _i2;
import 'cache_info.dart' as _i3;
import 'caches_info.dart' as _i4;
import 'cloud_storage.dart' as _i5;
import 'cloud_storage_direct_upload.dart' as _i6;
import 'cluster_info.dart' as _i7;
import 'cluster_server_info.dart' as _i8;
import 'database/column_definition.dart' as _i9;
import 'database/column_type.dart' as _i10;
import 'database/foreign_key_action.dart' as _i11;
import 'database/foreign_key_definition.dart' as _i12;
import 'database/index_definition.dart' as _i13;
import 'database/table_definition.dart' as _i14;
import 'distributed_cache_entry.dart' as _i15;
import 'future_call_entry.dart' as _i16;
import 'log_entry.dart' as _i17;
import 'log_level.dart' as _i18;
import 'log_result.dart' as _i19;
import 'log_settings.dart' as _i20;
import 'log_settings_override.dart' as _i21;
import 'message_log_entry.dart' as _i22;
import 'method_info.dart' as _i23;
import 'query_log_entry.dart' as _i24;
import 'readwrite_test.dart' as _i25;
import 'runtime_settings.dart' as _i26;
import 'server_health_connection_info.dart' as _i27;
import 'server_health_metric.dart' as _i28;
import 'server_health_result.dart' as _i29;
import 'session_log_entry.dart' as _i30;
import 'session_log_filter.dart' as _i31;
import 'session_log_info.dart' as _i32;
import 'session_log_result.dart' as _i33;
import 'protocol.dart' as _i34;
import 'package:serverpod/protocol.dart' as _i35;
export 'auth_key.dart';
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
export 'database/column_definition.dart';
export 'database/column_type.dart';
export 'database/foreign_key_action.dart';
export 'database/foreign_key_definition.dart';
export 'database/index_definition.dart';
export 'database/table_definition.dart';
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
export 'session_log_result.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
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
    if (t == _i11.ForeignKeyAction) {
      return _i11.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _i12.ForeignKeyDefinition) {
      return _i12.ForeignKeyDefinition.fromJson(data, this) as T;
    }
    if (t == _i13.IndexDefinition) {
      return _i13.IndexDefinition.fromJson(data, this) as T;
    }
    if (t == _i14.TableDefinition) {
      return _i14.TableDefinition.fromJson(data, this) as T;
    }
    if (t == _i15.DistributedCacheEntry) {
      return _i15.DistributedCacheEntry.fromJson(data, this) as T;
    }
    if (t == _i16.FutureCallEntry) {
      return _i16.FutureCallEntry.fromJson(data, this) as T;
    }
    if (t == _i17.LogEntry) {
      return _i17.LogEntry.fromJson(data, this) as T;
    }
    if (t == _i18.LogLevel) {
      return _i18.LogLevel.fromJson(data) as T;
    }
    if (t == _i19.LogResult) {
      return _i19.LogResult.fromJson(data, this) as T;
    }
    if (t == _i20.LogSettings) {
      return _i20.LogSettings.fromJson(data, this) as T;
    }
    if (t == _i21.LogSettingsOverride) {
      return _i21.LogSettingsOverride.fromJson(data, this) as T;
    }
    if (t == _i22.MessageLogEntry) {
      return _i22.MessageLogEntry.fromJson(data, this) as T;
    }
    if (t == _i23.MethodInfo) {
      return _i23.MethodInfo.fromJson(data, this) as T;
    }
    if (t == _i24.QueryLogEntry) {
      return _i24.QueryLogEntry.fromJson(data, this) as T;
    }
    if (t == _i25.ReadWriteTestEntry) {
      return _i25.ReadWriteTestEntry.fromJson(data, this) as T;
    }
    if (t == _i26.RuntimeSettings) {
      return _i26.RuntimeSettings.fromJson(data, this) as T;
    }
    if (t == _i27.ServerHealthConnectionInfo) {
      return _i27.ServerHealthConnectionInfo.fromJson(data, this) as T;
    }
    if (t == _i28.ServerHealthMetric) {
      return _i28.ServerHealthMetric.fromJson(data, this) as T;
    }
    if (t == _i29.ServerHealthResult) {
      return _i29.ServerHealthResult.fromJson(data, this) as T;
    }
    if (t == _i30.SessionLogEntry) {
      return _i30.SessionLogEntry.fromJson(data, this) as T;
    }
    if (t == _i31.SessionLogFilter) {
      return _i31.SessionLogFilter.fromJson(data, this) as T;
    }
    if (t == _i32.SessionLogInfo) {
      return _i32.SessionLogInfo.fromJson(data, this) as T;
    }
    if (t == _i33.SessionLogResult) {
      return _i33.SessionLogResult.fromJson(data, this) as T;
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
    if (t == _i1.getType<_i11.ForeignKeyAction?>()) {
      return (data != null ? _i11.ForeignKeyAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ForeignKeyDefinition?>()) {
      return (data != null
          ? _i12.ForeignKeyDefinition.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i13.IndexDefinition?>()) {
      return (data != null ? _i13.IndexDefinition.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.TableDefinition?>()) {
      return (data != null ? _i14.TableDefinition.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i15.DistributedCacheEntry?>()) {
      return (data != null
          ? _i15.DistributedCacheEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i16.FutureCallEntry?>()) {
      return (data != null ? _i16.FutureCallEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.LogEntry?>()) {
      return (data != null ? _i17.LogEntry.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i18.LogLevel?>()) {
      return (data != null ? _i18.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.LogResult?>()) {
      return (data != null ? _i19.LogResult.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i20.LogSettings?>()) {
      return (data != null ? _i20.LogSettings.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i21.LogSettingsOverride?>()) {
      return (data != null
          ? _i21.LogSettingsOverride.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i22.MessageLogEntry?>()) {
      return (data != null ? _i22.MessageLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i23.MethodInfo?>()) {
      return (data != null ? _i23.MethodInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i24.QueryLogEntry?>()) {
      return (data != null ? _i24.QueryLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i25.ReadWriteTestEntry?>()) {
      return (data != null
          ? _i25.ReadWriteTestEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i26.RuntimeSettings?>()) {
      return (data != null ? _i26.RuntimeSettings.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i27.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i27.ServerHealthConnectionInfo.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i28.ServerHealthMetric?>()) {
      return (data != null
          ? _i28.ServerHealthMetric.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i29.ServerHealthResult?>()) {
      return (data != null
          ? _i29.ServerHealthResult.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i30.SessionLogEntry?>()) {
      return (data != null ? _i30.SessionLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i31.SessionLogFilter?>()) {
      return (data != null ? _i31.SessionLogFilter.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i32.SessionLogInfo?>()) {
      return (data != null ? _i32.SessionLogInfo.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i33.SessionLogResult?>()) {
      return (data != null ? _i33.SessionLogResult.fromJson(data, this) : null)
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
    if (t == List<_i34.ClusterServerInfo>) {
      return (data as List)
          .map((e) => deserialize<_i34.ClusterServerInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.ColumnDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i34.ColumnDefinition>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i34.ForeignKeyDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i34.ForeignKeyDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.IndexDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i34.IndexDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.LogEntry>) {
      return (data as List).map((e) => deserialize<_i34.LogEntry>(e)).toList()
          as dynamic;
    }
    if (t == List<_i34.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserialize<_i34.LogSettingsOverride>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserialize<_i34.ServerHealthMetric>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserialize<_i34.ServerHealthConnectionInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i34.QueryLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i34.MessageLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i34.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserialize<_i34.SessionLogInfo>(e))
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
    if (data is _i11.ForeignKeyAction) {
      return 'ForeignKeyAction';
    }
    if (data is _i12.ForeignKeyDefinition) {
      return 'ForeignKeyDefinition';
    }
    if (data is _i13.IndexDefinition) {
      return 'IndexDefinition';
    }
    if (data is _i14.TableDefinition) {
      return 'TableDefinition';
    }
    if (data is _i15.DistributedCacheEntry) {
      return 'DistributedCacheEntry';
    }
    if (data is _i16.FutureCallEntry) {
      return 'FutureCallEntry';
    }
    if (data is _i17.LogEntry) {
      return 'LogEntry';
    }
    if (data is _i18.LogLevel) {
      return 'LogLevel';
    }
    if (data is _i19.LogResult) {
      return 'LogResult';
    }
    if (data is _i20.LogSettings) {
      return 'LogSettings';
    }
    if (data is _i21.LogSettingsOverride) {
      return 'LogSettingsOverride';
    }
    if (data is _i22.MessageLogEntry) {
      return 'MessageLogEntry';
    }
    if (data is _i23.MethodInfo) {
      return 'MethodInfo';
    }
    if (data is _i24.QueryLogEntry) {
      return 'QueryLogEntry';
    }
    if (data is _i25.ReadWriteTestEntry) {
      return 'ReadWriteTestEntry';
    }
    if (data is _i26.RuntimeSettings) {
      return 'RuntimeSettings';
    }
    if (data is _i27.ServerHealthConnectionInfo) {
      return 'ServerHealthConnectionInfo';
    }
    if (data is _i28.ServerHealthMetric) {
      return 'ServerHealthMetric';
    }
    if (data is _i29.ServerHealthResult) {
      return 'ServerHealthResult';
    }
    if (data is _i30.SessionLogEntry) {
      return 'SessionLogEntry';
    }
    if (data is _i31.SessionLogFilter) {
      return 'SessionLogFilter';
    }
    if (data is _i32.SessionLogInfo) {
      return 'SessionLogInfo';
    }
    if (data is _i33.SessionLogResult) {
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
    if (data['className'] == 'ForeignKeyAction') {
      return deserialize<_i11.ForeignKeyAction>(data['data']);
    }
    if (data['className'] == 'ForeignKeyDefinition') {
      return deserialize<_i12.ForeignKeyDefinition>(data['data']);
    }
    if (data['className'] == 'IndexDefinition') {
      return deserialize<_i13.IndexDefinition>(data['data']);
    }
    if (data['className'] == 'TableDefinition') {
      return deserialize<_i14.TableDefinition>(data['data']);
    }
    if (data['className'] == 'DistributedCacheEntry') {
      return deserialize<_i15.DistributedCacheEntry>(data['data']);
    }
    if (data['className'] == 'FutureCallEntry') {
      return deserialize<_i16.FutureCallEntry>(data['data']);
    }
    if (data['className'] == 'LogEntry') {
      return deserialize<_i17.LogEntry>(data['data']);
    }
    if (data['className'] == 'LogLevel') {
      return deserialize<_i18.LogLevel>(data['data']);
    }
    if (data['className'] == 'LogResult') {
      return deserialize<_i19.LogResult>(data['data']);
    }
    if (data['className'] == 'LogSettings') {
      return deserialize<_i20.LogSettings>(data['data']);
    }
    if (data['className'] == 'LogSettingsOverride') {
      return deserialize<_i21.LogSettingsOverride>(data['data']);
    }
    if (data['className'] == 'MessageLogEntry') {
      return deserialize<_i22.MessageLogEntry>(data['data']);
    }
    if (data['className'] == 'MethodInfo') {
      return deserialize<_i23.MethodInfo>(data['data']);
    }
    if (data['className'] == 'QueryLogEntry') {
      return deserialize<_i24.QueryLogEntry>(data['data']);
    }
    if (data['className'] == 'ReadWriteTestEntry') {
      return deserialize<_i25.ReadWriteTestEntry>(data['data']);
    }
    if (data['className'] == 'RuntimeSettings') {
      return deserialize<_i26.RuntimeSettings>(data['data']);
    }
    if (data['className'] == 'ServerHealthConnectionInfo') {
      return deserialize<_i27.ServerHealthConnectionInfo>(data['data']);
    }
    if (data['className'] == 'ServerHealthMetric') {
      return deserialize<_i28.ServerHealthMetric>(data['data']);
    }
    if (data['className'] == 'ServerHealthResult') {
      return deserialize<_i29.ServerHealthResult>(data['data']);
    }
    if (data['className'] == 'SessionLogEntry') {
      return deserialize<_i30.SessionLogEntry>(data['data']);
    }
    if (data['className'] == 'SessionLogFilter') {
      return deserialize<_i31.SessionLogFilter>(data['data']);
    }
    if (data['className'] == 'SessionLogInfo') {
      return deserialize<_i32.SessionLogInfo>(data['data']);
    }
    if (data['className'] == 'SessionLogResult') {
      return deserialize<_i33.SessionLogResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    switch (t) {
      case _i2.AuthKey:
        return _i2.AuthKey.t;
      case _i5.CloudStorageEntry:
        return _i5.CloudStorageEntry.t;
      case _i6.CloudStorageDirectUploadEntry:
        return _i6.CloudStorageDirectUploadEntry.t;
      case _i16.FutureCallEntry:
        return _i16.FutureCallEntry.t;
      case _i17.LogEntry:
        return _i17.LogEntry.t;
      case _i22.MessageLogEntry:
        return _i22.MessageLogEntry.t;
      case _i23.MethodInfo:
        return _i23.MethodInfo.t;
      case _i24.QueryLogEntry:
        return _i24.QueryLogEntry.t;
      case _i25.ReadWriteTestEntry:
        return _i25.ReadWriteTestEntry.t;
      case _i26.RuntimeSettings:
        return _i26.RuntimeSettings.t;
      case _i27.ServerHealthConnectionInfo:
        return _i27.ServerHealthConnectionInfo.t;
      case _i28.ServerHealthMetric:
        return _i28.ServerHealthMetric.t;
      case _i30.SessionLogEntry:
        return _i30.SessionLogEntry.t;
    }
    return null;
  }

  static List<_i35.TableDefinition> getDesiredDatabaseStructure() => [
        _i35.TableDefinition(
          name: 'serverpod_auth_key',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'userId',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'hash',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'key',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'scopeNames',
              columnType: _i35.ColumnType.json,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'method',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_auth_key_userId_idx',
              fields: ['userId'],
              type: 'btree',
              isUnique: false,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_cloud_storage',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'storageId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'path',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'addedTime',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'expiration',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'byteData',
              columnType: _i35.ColumnType.bytea,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'verified',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_cloud_storage_path_idx',
              fields: [
                'storageId',
                'path',
              ],
              type: 'btree',
              isUnique: true,
            ),
            _i35.IndexDefinition(
              indexName: 'serverpod_cloud_storage_expiration',
              fields: ['expiration'],
              type: 'btree',
              isUnique: false,
            ),
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_cloud_storage_direct_upload',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'storageId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'path',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'expiration',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'authKey',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_cloud_storage_direct_upload_storage_path',
              fields: [
                'storageId',
                'path',
              ],
              type: 'btree',
              isUnique: true,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_future_call',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'name',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'time',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'serializedObject',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'identifier',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_future_call_time_idx',
              fields: ['time'],
              type: 'btree',
              isUnique: false,
            ),
            _i35.IndexDefinition(
              indexName: 'serverpod_future_call_serverId_idx',
              fields: ['serverId'],
              type: 'btree',
              isUnique: false,
            ),
            _i35.IndexDefinition(
              indexName: 'serverpod_future_call_identifier_idx',
              fields: ['identifier'],
              type: 'btree',
              isUnique: false,
            ),
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_log',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'sessionLogId',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'messageId',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'reference',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'time',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'logLevel',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'message',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'error',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'stackTrace',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'order',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [
            _i35.ForeignKeyDefinition(
              constraintName: 'serverpod_log_fk_0',
              column: 'sessionLogId',
              referenceTable: 'serverpod_session_log',
              referenceColumn: 'id',
              onUpdate: null,
              onDelete: _i35.ForeignKeyAction.cascade,
            )
          ],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_log_sessionLogId_idx',
              fields: ['sessionLogId'],
              type: 'btree',
              isUnique: false,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_message_log',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'sessionLogId',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'messageId',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'endpoint',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'messageName',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'duration',
              columnType: _i35.ColumnType.doublePrecision,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'error',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'stackTrace',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'slow',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'order',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [
            _i35.ForeignKeyDefinition(
              constraintName: 'serverpod_message_log_fk_0',
              column: 'sessionLogId',
              referenceTable: 'serverpod_session_log',
              referenceColumn: 'id',
              onUpdate: null,
              onDelete: _i35.ForeignKeyAction.cascade,
            )
          ],
          indexes: [],
        ),
        _i35.TableDefinition(
          name: 'serverpod_method',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'endpoint',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'method',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_method_endpoint_method_idx',
              fields: [
                'endpoint',
                'method',
              ],
              type: 'btree',
              isUnique: true,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_query_log',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'sessionLogId',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'messageId',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'query',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'duration',
              columnType: _i35.ColumnType.doublePrecision,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'numRows',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'error',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'stackTrace',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'slow',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'order',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [
            _i35.ForeignKeyDefinition(
              constraintName: 'serverpod_query_log_fk_0',
              column: 'sessionLogId',
              referenceTable: 'serverpod_session_log',
              referenceColumn: 'id',
              onUpdate: null,
              onDelete: _i35.ForeignKeyAction.cascade,
            )
          ],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_query_log_sessionLogId_idx',
              fields: ['sessionLogId'],
              type: 'btree',
              isUnique: false,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_readwrite_test',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'number',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [],
        ),
        _i35.TableDefinition(
          name: 'serverpod_runtime_settings',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'logSettings',
              columnType: _i35.ColumnType.json,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'logSettingsOverrides',
              columnType: _i35.ColumnType.json,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'logServiceCalls',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'logMalformedCalls',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [],
        ),
        _i35.TableDefinition(
          name: 'serverpod_health_connection_info',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'timestamp',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'active',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'closing',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'idle',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'granularity',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_health_connection_info_timestamp_idx',
              fields: [
                'timestamp',
                'serverId',
                'granularity',
              ],
              type: 'btree',
              isUnique: true,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_health_metric',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'name',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'timestamp',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'isHealthy',
              columnType: _i35.ColumnType.boolean,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'value',
              columnType: _i35.ColumnType.doublePrecision,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'granularity',
              columnType: _i35.ColumnType.integer,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_health_metric_timestamp_idx',
              fields: [
                'timestamp',
                'serverId',
                'name',
                'granularity',
              ],
              type: 'btree',
              isUnique: true,
            )
          ],
        ),
        _i35.TableDefinition(
          name: 'serverpod_session_log',
          columns: [
            _i35.ColumnDefinition(
              name: 'id',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'serverId',
              columnType: _i35.ColumnType.text,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'time',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
            _i35.ColumnDefinition(
              name: 'module',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'endpoint',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'method',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'duration',
              columnType: _i35.ColumnType.doublePrecision,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'numQueries',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'slow',
              columnType: _i35.ColumnType.boolean,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'error',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'stackTrace',
              columnType: _i35.ColumnType.text,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'authenticatedUserId',
              columnType: _i35.ColumnType.integer,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'isOpen',
              columnType: _i35.ColumnType.boolean,
              isNullable: true,
            ),
            _i35.ColumnDefinition(
              name: 'touched',
              columnType: _i35.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [
            _i35.IndexDefinition(
              indexName: 'serverpod_session_log_serverid_idx',
              fields: ['serverId'],
              type: 'btree',
              isUnique: false,
            ),
            _i35.IndexDefinition(
              indexName: 'serverpod_session_log_touched_idx',
              fields: ['touched'],
              type: 'btree',
              isUnique: false,
            ),
            _i35.IndexDefinition(
              indexName: 'serverpod_session_log_isopen_idx',
              fields: ['isOpen'],
              type: 'btree',
              isUnique: false,
            ),
          ],
        ),
      ];
}
