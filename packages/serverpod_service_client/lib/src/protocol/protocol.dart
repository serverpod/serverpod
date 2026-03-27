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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'cache_info.dart' as _i2;
import 'caches_info.dart' as _i3;
import 'cloud_storage.dart' as _i4;
import 'cloud_storage_direct_upload.dart' as _i5;
import 'cluster_info.dart' as _i6;
import 'cluster_server_info.dart' as _i7;
import 'database_migration_version.dart' as _i8;
import 'distributed_cache_entry.dart' as _i9;
import 'exceptions/access_denied.dart' as _i10;
import 'exceptions/file_not_found.dart' as _i11;
import 'future_call_claim_entry.dart' as _i12;
import 'future_call_entry.dart' as _i13;
import 'log_entry.dart' as _i14;
import 'log_level.dart' as _i15;
import 'log_result.dart' as _i16;
import 'log_settings.dart' as _i17;
import 'log_settings_override.dart' as _i18;
import 'message_log_entry.dart' as _i19;
import 'method_info.dart' as _i20;
import 'query_log_entry.dart' as _i21;
import 'readwrite_test.dart' as _i22;
import 'runtime_settings.dart' as _i23;
import 'server_health_connection_info.dart' as _i24;
import 'server_health_metric.dart' as _i25;
import 'server_health_result.dart' as _i26;
import 'serverpod_sql_exception.dart' as _i27;
import 'session_log_entry.dart' as _i28;
import 'session_log_filter.dart' as _i29;
import 'session_log_info.dart' as _i30;
import 'session_log_result.dart' as _i31;
import 'package:serverpod_database/src/generated/table_definition.dart' as _i32;
import 'package:serverpod_database/serverpod_database.dart' as _i33;
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
export 'database_migration_version.dart';
export 'distributed_cache_entry.dart';
export 'exceptions/access_denied.dart';
export 'exceptions/file_not_found.dart';
export 'future_call_claim_entry.dart';
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
export 'serverpod_sql_exception.dart';
export 'session_log_entry.dart';
export 'session_log_filter.dart';
export 'session_log_info.dart';
export 'session_log_result.dart';
export 'client.dart';

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

    if (t == _i2.CacheInfo) {
      return _i2.CacheInfo.fromJson(data) as T;
    }
    if (t == _i3.CachesInfo) {
      return _i3.CachesInfo.fromJson(data) as T;
    }
    if (t == _i4.CloudStorageEntry) {
      return _i4.CloudStorageEntry.fromJson(data) as T;
    }
    if (t == _i5.CloudStorageDirectUploadEntry) {
      return _i5.CloudStorageDirectUploadEntry.fromJson(data) as T;
    }
    if (t == _i6.ClusterInfo) {
      return _i6.ClusterInfo.fromJson(data) as T;
    }
    if (t == _i7.ClusterServerInfo) {
      return _i7.ClusterServerInfo.fromJson(data) as T;
    }
    if (t == _i8.DatabaseMigrationVersion) {
      return _i8.DatabaseMigrationVersion.fromJson(data) as T;
    }
    if (t == _i9.DistributedCacheEntry) {
      return _i9.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _i10.AccessDeniedException) {
      return _i10.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i11.FileNotFoundException) {
      return _i11.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _i12.FutureCallClaimEntry) {
      return _i12.FutureCallClaimEntry.fromJson(data) as T;
    }
    if (t == _i13.FutureCallEntry) {
      return _i13.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _i14.LogEntry) {
      return _i14.LogEntry.fromJson(data) as T;
    }
    if (t == _i15.LogLevel) {
      return _i15.LogLevel.fromJson(data) as T;
    }
    if (t == _i16.LogResult) {
      return _i16.LogResult.fromJson(data) as T;
    }
    if (t == _i17.LogSettings) {
      return _i17.LogSettings.fromJson(data) as T;
    }
    if (t == _i18.LogSettingsOverride) {
      return _i18.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _i19.MessageLogEntry) {
      return _i19.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _i20.MethodInfo) {
      return _i20.MethodInfo.fromJson(data) as T;
    }
    if (t == _i21.QueryLogEntry) {
      return _i21.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i22.ReadWriteTestEntry) {
      return _i22.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _i23.RuntimeSettings) {
      return _i23.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _i24.ServerHealthConnectionInfo) {
      return _i24.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i25.ServerHealthMetric) {
      return _i25.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _i26.ServerHealthResult) {
      return _i26.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i27.ServerpodSqlException) {
      return _i27.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i28.SessionLogEntry) {
      return _i28.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i29.SessionLogFilter) {
      return _i29.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i30.SessionLogInfo) {
      return _i30.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _i31.SessionLogResult) {
      return _i31.SessionLogResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.CacheInfo?>()) {
      return (data != null ? _i2.CacheInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CachesInfo?>()) {
      return (data != null ? _i3.CachesInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CloudStorageEntry?>()) {
      return (data != null ? _i4.CloudStorageEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CloudStorageDirectUploadEntry?>()) {
      return (data != null
              ? _i5.CloudStorageDirectUploadEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.ClusterInfo?>()) {
      return (data != null ? _i6.ClusterInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ClusterServerInfo?>()) {
      return (data != null ? _i7.ClusterServerInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DatabaseMigrationVersion?>()) {
      return (data != null ? _i8.DatabaseMigrationVersion.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.DistributedCacheEntry?>()) {
      return (data != null ? _i9.DistributedCacheEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.AccessDeniedException?>()) {
      return (data != null ? _i10.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.FileNotFoundException?>()) {
      return (data != null ? _i11.FileNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.FutureCallClaimEntry?>()) {
      return (data != null ? _i12.FutureCallClaimEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.FutureCallEntry?>()) {
      return (data != null ? _i13.FutureCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.LogEntry?>()) {
      return (data != null ? _i14.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.LogLevel?>()) {
      return (data != null ? _i15.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.LogResult?>()) {
      return (data != null ? _i16.LogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.LogSettings?>()) {
      return (data != null ? _i17.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.LogSettingsOverride?>()) {
      return (data != null ? _i18.LogSettingsOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.MessageLogEntry?>()) {
      return (data != null ? _i19.MessageLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.MethodInfo?>()) {
      return (data != null ? _i20.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.QueryLogEntry?>()) {
      return (data != null ? _i21.QueryLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ReadWriteTestEntry?>()) {
      return (data != null ? _i22.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.RuntimeSettings?>()) {
      return (data != null ? _i23.RuntimeSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ServerHealthConnectionInfo?>()) {
      return (data != null
              ? _i24.ServerHealthConnectionInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.ServerHealthMetric?>()) {
      return (data != null ? _i25.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.ServerHealthResult?>()) {
      return (data != null ? _i26.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.ServerpodSqlException?>()) {
      return (data != null ? _i27.ServerpodSqlException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.SessionLogEntry?>()) {
      return (data != null ? _i28.SessionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.SessionLogFilter?>()) {
      return (data != null ? _i29.SessionLogFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.SessionLogInfo?>()) {
      return (data != null ? _i30.SessionLogInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.SessionLogResult?>()) {
      return (data != null ? _i31.SessionLogResult.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i7.ClusterServerInfo>) {
      return (data as List)
              .map((e) => deserialize<_i7.ClusterServerInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.LogEntry>) {
      return (data as List).map((e) => deserialize<_i14.LogEntry>(e)).toList()
          as T;
    }
    if (t == List<_i18.LogSettingsOverride>) {
      return (data as List)
              .map((e) => deserialize<_i18.LogSettingsOverride>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.ServerHealthMetric>) {
      return (data as List)
              .map((e) => deserialize<_i25.ServerHealthMetric>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.ServerHealthConnectionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i24.ServerHealthConnectionInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.QueryLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i21.QueryLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.MessageLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i19.MessageLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.SessionLogInfo>) {
      return (data as List)
              .map((e) => deserialize<_i30.SessionLogInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.TableDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i32.TableDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i33.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.CacheInfo => 'CacheInfo',
      _i3.CachesInfo => 'CachesInfo',
      _i4.CloudStorageEntry => 'CloudStorageEntry',
      _i5.CloudStorageDirectUploadEntry => 'CloudStorageDirectUploadEntry',
      _i6.ClusterInfo => 'ClusterInfo',
      _i7.ClusterServerInfo => 'ClusterServerInfo',
      _i8.DatabaseMigrationVersion => 'DatabaseMigrationVersion',
      _i9.DistributedCacheEntry => 'DistributedCacheEntry',
      _i10.AccessDeniedException => 'AccessDeniedException',
      _i11.FileNotFoundException => 'FileNotFoundException',
      _i12.FutureCallClaimEntry => 'FutureCallClaimEntry',
      _i13.FutureCallEntry => 'FutureCallEntry',
      _i14.LogEntry => 'LogEntry',
      _i15.LogLevel => 'LogLevel',
      _i16.LogResult => 'LogResult',
      _i17.LogSettings => 'LogSettings',
      _i18.LogSettingsOverride => 'LogSettingsOverride',
      _i19.MessageLogEntry => 'MessageLogEntry',
      _i20.MethodInfo => 'MethodInfo',
      _i21.QueryLogEntry => 'QueryLogEntry',
      _i22.ReadWriteTestEntry => 'ReadWriteTestEntry',
      _i23.RuntimeSettings => 'RuntimeSettings',
      _i24.ServerHealthConnectionInfo => 'ServerHealthConnectionInfo',
      _i25.ServerHealthMetric => 'ServerHealthMetric',
      _i26.ServerHealthResult => 'ServerHealthResult',
      _i27.ServerpodSqlException => 'ServerpodSqlException',
      _i28.SessionLogEntry => 'SessionLogEntry',
      _i29.SessionLogFilter => 'SessionLogFilter',
      _i30.SessionLogInfo => 'SessionLogInfo',
      _i31.SessionLogResult => 'SessionLogResult',
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
      case _i2.CacheInfo():
        return 'CacheInfo';
      case _i3.CachesInfo():
        return 'CachesInfo';
      case _i4.CloudStorageEntry():
        return 'CloudStorageEntry';
      case _i5.CloudStorageDirectUploadEntry():
        return 'CloudStorageDirectUploadEntry';
      case _i6.ClusterInfo():
        return 'ClusterInfo';
      case _i7.ClusterServerInfo():
        return 'ClusterServerInfo';
      case _i8.DatabaseMigrationVersion():
        return 'DatabaseMigrationVersion';
      case _i9.DistributedCacheEntry():
        return 'DistributedCacheEntry';
      case _i10.AccessDeniedException():
        return 'AccessDeniedException';
      case _i11.FileNotFoundException():
        return 'FileNotFoundException';
      case _i12.FutureCallClaimEntry():
        return 'FutureCallClaimEntry';
      case _i13.FutureCallEntry():
        return 'FutureCallEntry';
      case _i14.LogEntry():
        return 'LogEntry';
      case _i15.LogLevel():
        return 'LogLevel';
      case _i16.LogResult():
        return 'LogResult';
      case _i17.LogSettings():
        return 'LogSettings';
      case _i18.LogSettingsOverride():
        return 'LogSettingsOverride';
      case _i19.MessageLogEntry():
        return 'MessageLogEntry';
      case _i20.MethodInfo():
        return 'MethodInfo';
      case _i21.QueryLogEntry():
        return 'QueryLogEntry';
      case _i22.ReadWriteTestEntry():
        return 'ReadWriteTestEntry';
      case _i23.RuntimeSettings():
        return 'RuntimeSettings';
      case _i24.ServerHealthConnectionInfo():
        return 'ServerHealthConnectionInfo';
      case _i25.ServerHealthMetric():
        return 'ServerHealthMetric';
      case _i26.ServerHealthResult():
        return 'ServerHealthResult';
      case _i27.ServerpodSqlException():
        return 'ServerpodSqlException';
      case _i28.SessionLogEntry():
        return 'SessionLogEntry';
      case _i29.SessionLogFilter():
        return 'SessionLogFilter';
      case _i30.SessionLogInfo():
        return 'SessionLogInfo';
      case _i31.SessionLogResult():
        return 'SessionLogResult';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CacheInfo') {
      return deserialize<_i2.CacheInfo>(data['data']);
    }
    if (dataClassName == 'CachesInfo') {
      return deserialize<_i3.CachesInfo>(data['data']);
    }
    if (dataClassName == 'CloudStorageEntry') {
      return deserialize<_i4.CloudStorageEntry>(data['data']);
    }
    if (dataClassName == 'CloudStorageDirectUploadEntry') {
      return deserialize<_i5.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (dataClassName == 'ClusterInfo') {
      return deserialize<_i6.ClusterInfo>(data['data']);
    }
    if (dataClassName == 'ClusterServerInfo') {
      return deserialize<_i7.ClusterServerInfo>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersion') {
      return deserialize<_i8.DatabaseMigrationVersion>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_i9.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i10.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_i11.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallClaimEntry') {
      return deserialize<_i12.FutureCallClaimEntry>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_i13.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_i14.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_i15.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i16.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_i17.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i18.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_i19.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_i20.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_i21.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i22.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_i23.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_i24.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i25.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_i26.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i27.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i28.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i29.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i30.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_i31.SessionLogResult>(data['data']);
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
