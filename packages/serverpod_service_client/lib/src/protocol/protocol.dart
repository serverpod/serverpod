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
import 'future_call_scheduling.dart' as _i8;
import 'database_migration_version.dart' as _i9;
import 'distributed_cache_entry.dart' as _i10;
import 'exceptions/access_denied.dart' as _i11;
import 'exceptions/file_not_found.dart' as _i12;
import 'future_call_claim_entry.dart' as _i13;
import 'future_call_entry.dart' as _i14;
import 'log_entry.dart' as _i15;
import 'log_level.dart' as _i16;
import 'log_result.dart' as _i17;
import 'log_settings.dart' as _i18;
import 'log_settings_override.dart' as _i19;
import 'message_log_entry.dart' as _i20;
import 'method_info.dart' as _i21;
import 'query_log_entry.dart' as _i22;
import 'readwrite_test.dart' as _i23;
import 'runtime_settings.dart' as _i24;
import 'server_health_connection_info.dart' as _i25;
import 'server_health_metric.dart' as _i26;
import 'server_health_result.dart' as _i27;
import 'serverpod_sql_exception.dart' as _i28;
import 'session_log_entry.dart' as _i29;
import 'session_log_filter.dart' as _i30;
import 'session_log_info.dart' as _i31;
import 'session_log_result.dart' as _i32;
import 'package:serverpod_database/src/generated/table_definition.dart' as _i33;
import 'package:serverpod_database/serverpod_database.dart' as _i34;
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
export 'future_call_scheduling.dart';
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

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i2.CacheInfo] = (data, protocol) => _i2.CacheInfo.fromJson(data);
    map[_i3.CachesInfo] = (data, protocol) => _i3.CachesInfo.fromJson(data);
    map[_i4.CloudStorageEntry] = (data, protocol) =>
        _i4.CloudStorageEntry.fromJson(data);
    map[_i5.CloudStorageDirectUploadEntry] = (data, protocol) =>
        _i5.CloudStorageDirectUploadEntry.fromJson(data);
    map[_i6.ClusterInfo] = (data, protocol) => _i6.ClusterInfo.fromJson(data);
    map[_i7.ClusterServerInfo] = (data, protocol) =>
        _i7.ClusterServerInfo.fromJson(data);
    map[_i8.CronFutureCallScheduling] = (data, protocol) =>
        _i8.CronFutureCallScheduling.fromJson(data);
    map[_i9.DatabaseMigrationVersion] = (data, protocol) =>
        _i9.DatabaseMigrationVersion.fromJson(data);
    map[_i10.DistributedCacheEntry] = (data, protocol) =>
        _i10.DistributedCacheEntry.fromJson(data);
    map[_i11.AccessDeniedException] = (data, protocol) =>
        _i11.AccessDeniedException.fromJson(data);
    map[_i12.FileNotFoundException] = (data, protocol) =>
        _i12.FileNotFoundException.fromJson(data);
    map[_i13.FutureCallClaimEntry] = (data, protocol) =>
        _i13.FutureCallClaimEntry.fromJson(data);
    map[_i14.FutureCallEntry] = (data, protocol) =>
        _i14.FutureCallEntry.fromJson(data);
    map[_i8.IntervalFutureCallScheduling] = (data, protocol) =>
        _i8.IntervalFutureCallScheduling.fromJson(data);
    map[_i15.LogEntry] = (data, protocol) => _i15.LogEntry.fromJson(data);
    map[_i16.LogLevel] = (data, protocol) => _i16.LogLevel.fromJson(data);
    map[_i17.LogResult] = (data, protocol) => _i17.LogResult.fromJson(data);
    map[_i18.LogSettings] = (data, protocol) => _i18.LogSettings.fromJson(data);
    map[_i19.LogSettingsOverride] = (data, protocol) =>
        _i19.LogSettingsOverride.fromJson(data);
    map[_i20.MessageLogEntry] = (data, protocol) =>
        _i20.MessageLogEntry.fromJson(data);
    map[_i21.MethodInfo] = (data, protocol) => _i21.MethodInfo.fromJson(data);
    map[_i22.QueryLogEntry] = (data, protocol) =>
        _i22.QueryLogEntry.fromJson(data);
    map[_i23.ReadWriteTestEntry] = (data, protocol) =>
        _i23.ReadWriteTestEntry.fromJson(data);
    map[_i24.RuntimeSettings] = (data, protocol) =>
        _i24.RuntimeSettings.fromJson(data);
    map[_i25.ServerHealthConnectionInfo] = (data, protocol) =>
        _i25.ServerHealthConnectionInfo.fromJson(data);
    map[_i26.ServerHealthMetric] = (data, protocol) =>
        _i26.ServerHealthMetric.fromJson(data);
    map[_i27.ServerHealthResult] = (data, protocol) =>
        _i27.ServerHealthResult.fromJson(data);
    map[_i28.ServerpodSqlException] = (data, protocol) =>
        _i28.ServerpodSqlException.fromJson(data);
    map[_i29.SessionLogEntry] = (data, protocol) =>
        _i29.SessionLogEntry.fromJson(data);
    map[_i30.SessionLogFilter] = (data, protocol) =>
        _i30.SessionLogFilter.fromJson(data);
    map[_i31.SessionLogInfo] = (data, protocol) =>
        _i31.SessionLogInfo.fromJson(data);
    map[_i32.SessionLogResult] = (data, protocol) =>
        _i32.SessionLogResult.fromJson(data);
    map[_i1.getType<_i2.CacheInfo?>()] = (data, protocol) =>
        (data != null ? _i2.CacheInfo.fromJson(data) : null);
    map[_i1.getType<_i3.CachesInfo?>()] = (data, protocol) =>
        (data != null ? _i3.CachesInfo.fromJson(data) : null);
    map[_i1.getType<_i4.CloudStorageEntry?>()] = (data, protocol) =>
        (data != null ? _i4.CloudStorageEntry.fromJson(data) : null);
    map[_i1.getType<_i5.CloudStorageDirectUploadEntry?>()] = (data, protocol) =>
        (data != null
        ? _i5.CloudStorageDirectUploadEntry.fromJson(data)
        : null);
    map[_i1.getType<_i6.ClusterInfo?>()] = (data, protocol) =>
        (data != null ? _i6.ClusterInfo.fromJson(data) : null);
    map[_i1.getType<_i7.ClusterServerInfo?>()] = (data, protocol) =>
        (data != null ? _i7.ClusterServerInfo.fromJson(data) : null);
    map[_i1.getType<_i8.CronFutureCallScheduling?>()] = (data, protocol) =>
        (data != null ? _i8.CronFutureCallScheduling.fromJson(data) : null);
    map[_i1.getType<_i9.DatabaseMigrationVersion?>()] = (data, protocol) =>
        (data != null ? _i9.DatabaseMigrationVersion.fromJson(data) : null);
    map[_i1.getType<_i10.DistributedCacheEntry?>()] = (data, protocol) =>
        (data != null ? _i10.DistributedCacheEntry.fromJson(data) : null);
    map[_i1.getType<_i11.AccessDeniedException?>()] = (data, protocol) =>
        (data != null ? _i11.AccessDeniedException.fromJson(data) : null);
    map[_i1.getType<_i12.FileNotFoundException?>()] = (data, protocol) =>
        (data != null ? _i12.FileNotFoundException.fromJson(data) : null);
    map[_i1.getType<_i13.FutureCallClaimEntry?>()] = (data, protocol) =>
        (data != null ? _i13.FutureCallClaimEntry.fromJson(data) : null);
    map[_i1.getType<_i14.FutureCallEntry?>()] = (data, protocol) =>
        (data != null ? _i14.FutureCallEntry.fromJson(data) : null);
    map[_i1.getType<_i8.IntervalFutureCallScheduling?>()] = (data, protocol) =>
        (data != null ? _i8.IntervalFutureCallScheduling.fromJson(data) : null);
    map[_i1.getType<_i15.LogEntry?>()] = (data, protocol) =>
        (data != null ? _i15.LogEntry.fromJson(data) : null);
    map[_i1.getType<_i16.LogLevel?>()] = (data, protocol) =>
        (data != null ? _i16.LogLevel.fromJson(data) : null);
    map[_i1.getType<_i17.LogResult?>()] = (data, protocol) =>
        (data != null ? _i17.LogResult.fromJson(data) : null);
    map[_i1.getType<_i18.LogSettings?>()] = (data, protocol) =>
        (data != null ? _i18.LogSettings.fromJson(data) : null);
    map[_i1.getType<_i19.LogSettingsOverride?>()] = (data, protocol) =>
        (data != null ? _i19.LogSettingsOverride.fromJson(data) : null);
    map[_i1.getType<_i20.MessageLogEntry?>()] = (data, protocol) =>
        (data != null ? _i20.MessageLogEntry.fromJson(data) : null);
    map[_i1.getType<_i21.MethodInfo?>()] = (data, protocol) =>
        (data != null ? _i21.MethodInfo.fromJson(data) : null);
    map[_i1.getType<_i22.QueryLogEntry?>()] = (data, protocol) =>
        (data != null ? _i22.QueryLogEntry.fromJson(data) : null);
    map[_i1.getType<_i23.ReadWriteTestEntry?>()] = (data, protocol) =>
        (data != null ? _i23.ReadWriteTestEntry.fromJson(data) : null);
    map[_i1.getType<_i24.RuntimeSettings?>()] = (data, protocol) =>
        (data != null ? _i24.RuntimeSettings.fromJson(data) : null);
    map[_i1.getType<_i25.ServerHealthConnectionInfo?>()] = (data, protocol) =>
        (data != null ? _i25.ServerHealthConnectionInfo.fromJson(data) : null);
    map[_i1.getType<_i26.ServerHealthMetric?>()] = (data, protocol) =>
        (data != null ? _i26.ServerHealthMetric.fromJson(data) : null);
    map[_i1.getType<_i27.ServerHealthResult?>()] = (data, protocol) =>
        (data != null ? _i27.ServerHealthResult.fromJson(data) : null);
    map[_i1.getType<_i28.ServerpodSqlException?>()] = (data, protocol) =>
        (data != null ? _i28.ServerpodSqlException.fromJson(data) : null);
    map[_i1.getType<_i29.SessionLogEntry?>()] = (data, protocol) =>
        (data != null ? _i29.SessionLogEntry.fromJson(data) : null);
    map[_i1.getType<_i30.SessionLogFilter?>()] = (data, protocol) =>
        (data != null ? _i30.SessionLogFilter.fromJson(data) : null);
    map[_i1.getType<_i31.SessionLogInfo?>()] = (data, protocol) =>
        (data != null ? _i31.SessionLogInfo.fromJson(data) : null);
    map[_i1.getType<_i32.SessionLogResult?>()] = (data, protocol) =>
        (data != null ? _i32.SessionLogResult.fromJson(data) : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[_i1.getType<List<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toList()
        : null);
    map[List<_i7.ClusterServerInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i7.ClusterServerInfo>(e))
        .toList();
    map[List<_i15.LogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i15.LogEntry>(e))
        .toList();
    map[List<_i19.LogSettingsOverride>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i19.LogSettingsOverride>(e))
        .toList();
    map[List<_i26.ServerHealthMetric>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i26.ServerHealthMetric>(e))
        .toList();
    map[List<_i25.ServerHealthConnectionInfo>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<_i25.ServerHealthConnectionInfo>(e),
            )
            .toList();
    map[List<_i15.LogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i15.LogEntry>(e))
        .toList();
    map[_i1.getType<List<_i15.LogEntry>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i15.LogEntry>(e))
              .toList()
        : null);
    map[List<_i22.QueryLogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i22.QueryLogEntry>(e))
        .toList();
    map[_i1.getType<List<_i22.QueryLogEntry>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i22.QueryLogEntry>(e))
              .toList()
        : null);
    map[List<_i20.MessageLogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i20.MessageLogEntry>(e))
        .toList();
    map[_i1.getType<List<_i20.MessageLogEntry>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i20.MessageLogEntry>(e))
              .toList()
        : null);
    map[List<_i22.QueryLogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i22.QueryLogEntry>(e))
        .toList();
    map[List<_i20.MessageLogEntry>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i20.MessageLogEntry>(e))
        .toList();
    map[List<_i31.SessionLogInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i31.SessionLogInfo>(e))
        .toList();
    map[List<_i33.TableDefinition>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i33.TableDefinition>(e))
        .toList();
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    return map;
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
    try {
      return _i34.Protocol().deserialize<T>(data, t);
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
      _i8.CronFutureCallScheduling => 'CronFutureCallScheduling',
      _i9.DatabaseMigrationVersion => 'DatabaseMigrationVersion',
      _i10.DistributedCacheEntry => 'DistributedCacheEntry',
      _i11.AccessDeniedException => 'AccessDeniedException',
      _i12.FileNotFoundException => 'FileNotFoundException',
      _i13.FutureCallClaimEntry => 'FutureCallClaimEntry',
      _i14.FutureCallEntry => 'FutureCallEntry',
      _i8.IntervalFutureCallScheduling => 'IntervalFutureCallScheduling',
      _i15.LogEntry => 'LogEntry',
      _i16.LogLevel => 'LogLevel',
      _i17.LogResult => 'LogResult',
      _i18.LogSettings => 'LogSettings',
      _i19.LogSettingsOverride => 'LogSettingsOverride',
      _i20.MessageLogEntry => 'MessageLogEntry',
      _i21.MethodInfo => 'MethodInfo',
      _i22.QueryLogEntry => 'QueryLogEntry',
      _i23.ReadWriteTestEntry => 'ReadWriteTestEntry',
      _i24.RuntimeSettings => 'RuntimeSettings',
      _i25.ServerHealthConnectionInfo => 'ServerHealthConnectionInfo',
      _i26.ServerHealthMetric => 'ServerHealthMetric',
      _i27.ServerHealthResult => 'ServerHealthResult',
      _i28.ServerpodSqlException => 'ServerpodSqlException',
      _i29.SessionLogEntry => 'SessionLogEntry',
      _i30.SessionLogFilter => 'SessionLogFilter',
      _i31.SessionLogInfo => 'SessionLogInfo',
      _i32.SessionLogResult => 'SessionLogResult',
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
      case _i8.CronFutureCallScheduling():
        return 'CronFutureCallScheduling';
      case _i9.DatabaseMigrationVersion():
        return 'DatabaseMigrationVersion';
      case _i10.DistributedCacheEntry():
        return 'DistributedCacheEntry';
      case _i11.AccessDeniedException():
        return 'AccessDeniedException';
      case _i12.FileNotFoundException():
        return 'FileNotFoundException';
      case _i13.FutureCallClaimEntry():
        return 'FutureCallClaimEntry';
      case _i14.FutureCallEntry():
        return 'FutureCallEntry';
      case _i8.IntervalFutureCallScheduling():
        return 'IntervalFutureCallScheduling';
      case _i15.LogEntry():
        return 'LogEntry';
      case _i16.LogLevel():
        return 'LogLevel';
      case _i17.LogResult():
        return 'LogResult';
      case _i18.LogSettings():
        return 'LogSettings';
      case _i19.LogSettingsOverride():
        return 'LogSettingsOverride';
      case _i20.MessageLogEntry():
        return 'MessageLogEntry';
      case _i21.MethodInfo():
        return 'MethodInfo';
      case _i22.QueryLogEntry():
        return 'QueryLogEntry';
      case _i23.ReadWriteTestEntry():
        return 'ReadWriteTestEntry';
      case _i24.RuntimeSettings():
        return 'RuntimeSettings';
      case _i25.ServerHealthConnectionInfo():
        return 'ServerHealthConnectionInfo';
      case _i26.ServerHealthMetric():
        return 'ServerHealthMetric';
      case _i27.ServerHealthResult():
        return 'ServerHealthResult';
      case _i28.ServerpodSqlException():
        return 'ServerpodSqlException';
      case _i29.SessionLogEntry():
        return 'SessionLogEntry';
      case _i30.SessionLogFilter():
        return 'SessionLogFilter';
      case _i31.SessionLogInfo():
        return 'SessionLogInfo';
      case _i32.SessionLogResult():
        return 'SessionLogResult';
    }
    className = _i34.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_database.$className';
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
    if (dataClassName == 'CronFutureCallScheduling') {
      return deserialize<_i8.CronFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersion') {
      return deserialize<_i9.DatabaseMigrationVersion>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_i10.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i11.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_i12.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallClaimEntry') {
      return deserialize<_i13.FutureCallClaimEntry>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_i14.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'IntervalFutureCallScheduling') {
      return deserialize<_i8.IntervalFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_i15.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_i16.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i17.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_i18.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i19.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_i20.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_i21.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_i22.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i23.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_i24.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_i25.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i26.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_i27.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i28.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i29.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i30.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i31.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_i32.SessionLogResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_database.')) {
      data['className'] = dataClassName.substring(19);
      return _i34.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i34.Protocol().registerHostProtocol('serverpod', this);
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
