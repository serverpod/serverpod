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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'cache_info.dart' as _ihncus9g;
import 'caches_info.dart' as _iuu4tkmh;
import 'cloud_storage.dart' as _il44s43u;
import 'cloud_storage_direct_download.dart' as _i97jjzdk;
import 'cloud_storage_direct_upload.dart' as _ihrv9246;
import 'cluster_info.dart' as _ix58cu06;
import 'cluster_server_info.dart' as _i0iseagh;
import 'database_migration_version.dart' as _i2x83mx1;
import 'distributed_cache_entry.dart' as _imsb8zuu;
import 'exceptions/access_denied.dart' as _ier2zjtm;
import 'exceptions/file_not_found.dart' as _icej9e0v;
import 'future_call_claim_entry.dart' as _iil91lk2;
import 'future_call_entry.dart' as _ipstj2hb;
import 'future_call_scheduling.dart' as _is8pd350;
import 'log_entry.dart' as _iv7ld46g;
import 'log_level.dart' as _iavjjqw5;
import 'log_result.dart' as _i6wf5evp;
import 'log_settings.dart' as _illv0ea4;
import 'log_settings_override.dart' as _i5sjxqb6;
import 'message_log_entry.dart' as _iky1nb92;
import 'method_info.dart' as _iphoy7x3;
import 'query_log_entry.dart' as _inqjskye;
import 'readwrite_test.dart' as _i2c0cuss;
import 'runtime_settings.dart' as _im7ye3v2;
import 'server_health_connection_info.dart' as _igb3a02z;
import 'server_health_metric.dart' as _i8823art;
import 'server_health_result.dart' as _ife0uun1;
import 'serverpod_sql_exception.dart' as _i641wcmx;
import 'session_log_entry.dart' as _i3jtimpl;
import 'session_log_filter.dart' as _i2jy9zag;
import 'session_log_info.dart' as _i783h20h;
import 'session_log_result.dart' as _idz92mnt;
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_download.dart';
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

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ihncus9g.CacheInfo) {
      return _ihncus9g.CacheInfo.fromJson(data) as T;
    }
    if (t == _iuu4tkmh.CachesInfo) {
      return _iuu4tkmh.CachesInfo.fromJson(data) as T;
    }
    if (t == _il44s43u.CloudStorageEntry) {
      return _il44s43u.CloudStorageEntry.fromJson(data) as T;
    }
    if (t == _i97jjzdk.CloudStorageDirectDownloadEntry) {
      return _i97jjzdk.CloudStorageDirectDownloadEntry.fromJson(data) as T;
    }
    if (t == _ihrv9246.CloudStorageDirectUploadEntry) {
      return _ihrv9246.CloudStorageDirectUploadEntry.fromJson(data) as T;
    }
    if (t == _ix58cu06.ClusterInfo) {
      return _ix58cu06.ClusterInfo.fromJson(data) as T;
    }
    if (t == _i0iseagh.ClusterServerInfo) {
      return _i0iseagh.ClusterServerInfo.fromJson(data) as T;
    }
    if (t == _is8pd350.CronFutureCallScheduling) {
      return _is8pd350.CronFutureCallScheduling.fromJson(data) as T;
    }
    if (t == _i2x83mx1.DatabaseMigrationVersion) {
      return _i2x83mx1.DatabaseMigrationVersion.fromJson(data) as T;
    }
    if (t == _imsb8zuu.DistributedCacheEntry) {
      return _imsb8zuu.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _ier2zjtm.AccessDeniedException) {
      return _ier2zjtm.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _icej9e0v.FileNotFoundException) {
      return _icej9e0v.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _iil91lk2.FutureCallClaimEntry) {
      return _iil91lk2.FutureCallClaimEntry.fromJson(data) as T;
    }
    if (t == _ipstj2hb.FutureCallEntry) {
      return _ipstj2hb.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _is8pd350.IntervalFutureCallScheduling) {
      return _is8pd350.IntervalFutureCallScheduling.fromJson(data) as T;
    }
    if (t == _iv7ld46g.LogEntry) {
      return _iv7ld46g.LogEntry.fromJson(data) as T;
    }
    if (t == _iavjjqw5.LogLevel) {
      return _iavjjqw5.LogLevel.fromJson(data) as T;
    }
    if (t == _i6wf5evp.LogResult) {
      return _i6wf5evp.LogResult.fromJson(data) as T;
    }
    if (t == _illv0ea4.LogSettings) {
      return _illv0ea4.LogSettings.fromJson(data) as T;
    }
    if (t == _i5sjxqb6.LogSettingsOverride) {
      return _i5sjxqb6.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _iky1nb92.MessageLogEntry) {
      return _iky1nb92.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _iphoy7x3.MethodInfo) {
      return _iphoy7x3.MethodInfo.fromJson(data) as T;
    }
    if (t == _inqjskye.QueryLogEntry) {
      return _inqjskye.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i2c0cuss.ReadWriteTestEntry) {
      return _i2c0cuss.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _im7ye3v2.RuntimeSettings) {
      return _im7ye3v2.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _igb3a02z.ServerHealthConnectionInfo) {
      return _igb3a02z.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i8823art.ServerHealthMetric) {
      return _i8823art.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _ife0uun1.ServerHealthResult) {
      return _ife0uun1.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i641wcmx.ServerpodSqlException) {
      return _i641wcmx.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i3jtimpl.SessionLogEntry) {
      return _i3jtimpl.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i2jy9zag.SessionLogFilter) {
      return _i2jy9zag.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i783h20h.SessionLogInfo) {
      return _i783h20h.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _idz92mnt.SessionLogResult) {
      return _idz92mnt.SessionLogResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_ihncus9g.CacheInfo?>()) {
      return (data != null ? _ihncus9g.CacheInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuu4tkmh.CachesInfo?>()) {
      return (data != null ? _iuu4tkmh.CachesInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il44s43u.CloudStorageEntry?>()) {
      return (data != null ? _il44s43u.CloudStorageEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i97jjzdk.CloudStorageDirectDownloadEntry?>()) {
      return (data != null
              ? _i97jjzdk.CloudStorageDirectDownloadEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihrv9246.CloudStorageDirectUploadEntry?>()) {
      return (data != null
              ? _ihrv9246.CloudStorageDirectUploadEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ix58cu06.ClusterInfo?>()) {
      return (data != null ? _ix58cu06.ClusterInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0iseagh.ClusterServerInfo?>()) {
      return (data != null ? _i0iseagh.ClusterServerInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_is8pd350.CronFutureCallScheduling?>()) {
      return (data != null
              ? _is8pd350.CronFutureCallScheduling.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2x83mx1.DatabaseMigrationVersion?>()) {
      return (data != null
              ? _i2x83mx1.DatabaseMigrationVersion.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imsb8zuu.DistributedCacheEntry?>()) {
      return (data != null
              ? _imsb8zuu.DistributedCacheEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ier2zjtm.AccessDeniedException?>()) {
      return (data != null
              ? _ier2zjtm.AccessDeniedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_icej9e0v.FileNotFoundException?>()) {
      return (data != null
              ? _icej9e0v.FileNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iil91lk2.FutureCallClaimEntry?>()) {
      return (data != null
              ? _iil91lk2.FutureCallClaimEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ipstj2hb.FutureCallEntry?>()) {
      return (data != null ? _ipstj2hb.FutureCallEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_is8pd350.IntervalFutureCallScheduling?>()) {
      return (data != null
              ? _is8pd350.IntervalFutureCallScheduling.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iv7ld46g.LogEntry?>()) {
      return (data != null ? _iv7ld46g.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iavjjqw5.LogLevel?>()) {
      return (data != null ? _iavjjqw5.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6wf5evp.LogResult?>()) {
      return (data != null ? _i6wf5evp.LogResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_illv0ea4.LogSettings?>()) {
      return (data != null ? _illv0ea4.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5sjxqb6.LogSettingsOverride?>()) {
      return (data != null
              ? _i5sjxqb6.LogSettingsOverride.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iky1nb92.MessageLogEntry?>()) {
      return (data != null ? _iky1nb92.MessageLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iphoy7x3.MethodInfo?>()) {
      return (data != null ? _iphoy7x3.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_inqjskye.QueryLogEntry?>()) {
      return (data != null ? _inqjskye.QueryLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2c0cuss.ReadWriteTestEntry?>()) {
      return (data != null ? _i2c0cuss.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im7ye3v2.RuntimeSettings?>()) {
      return (data != null ? _im7ye3v2.RuntimeSettings.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igb3a02z.ServerHealthConnectionInfo?>()) {
      return (data != null
              ? _igb3a02z.ServerHealthConnectionInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i8823art.ServerHealthMetric?>()) {
      return (data != null ? _i8823art.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ife0uun1.ServerHealthResult?>()) {
      return (data != null ? _ife0uun1.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i641wcmx.ServerpodSqlException?>()) {
      return (data != null
              ? _i641wcmx.ServerpodSqlException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i3jtimpl.SessionLogEntry?>()) {
      return (data != null ? _i3jtimpl.SessionLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2jy9zag.SessionLogFilter?>()) {
      return (data != null ? _i2jy9zag.SessionLogFilter.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i783h20h.SessionLogInfo?>()) {
      return (data != null ? _i783h20h.SessionLogInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idz92mnt.SessionLogResult?>()) {
      return (data != null ? _idz92mnt.SessionLogResult.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i0iseagh.ClusterServerInfo>) {
      return (data as List)
              .map((e) => deserialize<_i0iseagh.ClusterServerInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iv7ld46g.LogEntry>) {
      return (data as List)
              .map((e) => deserialize<_iv7ld46g.LogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i5sjxqb6.LogSettingsOverride>) {
      return (data as List)
              .map((e) => deserialize<_i5sjxqb6.LogSettingsOverride>(e))
              .toList()
          as T;
    }
    if (t == List<_i8823art.ServerHealthMetric>) {
      return (data as List)
              .map((e) => deserialize<_i8823art.ServerHealthMetric>(e))
              .toList()
          as T;
    }
    if (t == List<_igb3a02z.ServerHealthConnectionInfo>) {
      return (data as List)
              .map((e) => deserialize<_igb3a02z.ServerHealthConnectionInfo>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iv7ld46g.LogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iv7ld46g.LogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_inqjskye.QueryLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_inqjskye.QueryLogEntry>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_inqjskye.QueryLogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_inqjskye.QueryLogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iky1nb92.MessageLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_iky1nb92.MessageLogEntry>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iky1nb92.MessageLogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iky1nb92.MessageLogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i783h20h.SessionLogInfo>) {
      return (data as List)
              .map((e) => deserialize<_i783h20h.SessionLogInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_isd.TableDefinition>) {
      return (data as List)
              .map((e) => deserialize<_isd.TableDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _isd.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ihncus9g.CacheInfo => 'CacheInfo',
      _iuu4tkmh.CachesInfo => 'CachesInfo',
      _il44s43u.CloudStorageEntry => 'CloudStorageEntry',
      _i97jjzdk.CloudStorageDirectDownloadEntry =>
        'CloudStorageDirectDownloadEntry',
      _ihrv9246.CloudStorageDirectUploadEntry =>
        'CloudStorageDirectUploadEntry',
      _ix58cu06.ClusterInfo => 'ClusterInfo',
      _i0iseagh.ClusterServerInfo => 'ClusterServerInfo',
      _is8pd350.CronFutureCallScheduling => 'CronFutureCallScheduling',
      _i2x83mx1.DatabaseMigrationVersion => 'DatabaseMigrationVersion',
      _imsb8zuu.DistributedCacheEntry => 'DistributedCacheEntry',
      _ier2zjtm.AccessDeniedException => 'AccessDeniedException',
      _icej9e0v.FileNotFoundException => 'FileNotFoundException',
      _iil91lk2.FutureCallClaimEntry => 'FutureCallClaimEntry',
      _ipstj2hb.FutureCallEntry => 'FutureCallEntry',
      _is8pd350.IntervalFutureCallScheduling => 'IntervalFutureCallScheduling',
      _iv7ld46g.LogEntry => 'LogEntry',
      _iavjjqw5.LogLevel => 'LogLevel',
      _i6wf5evp.LogResult => 'LogResult',
      _illv0ea4.LogSettings => 'LogSettings',
      _i5sjxqb6.LogSettingsOverride => 'LogSettingsOverride',
      _iky1nb92.MessageLogEntry => 'MessageLogEntry',
      _iphoy7x3.MethodInfo => 'MethodInfo',
      _inqjskye.QueryLogEntry => 'QueryLogEntry',
      _i2c0cuss.ReadWriteTestEntry => 'ReadWriteTestEntry',
      _im7ye3v2.RuntimeSettings => 'RuntimeSettings',
      _igb3a02z.ServerHealthConnectionInfo => 'ServerHealthConnectionInfo',
      _i8823art.ServerHealthMetric => 'ServerHealthMetric',
      _ife0uun1.ServerHealthResult => 'ServerHealthResult',
      _i641wcmx.ServerpodSqlException => 'ServerpodSqlException',
      _i3jtimpl.SessionLogEntry => 'SessionLogEntry',
      _i2jy9zag.SessionLogFilter => 'SessionLogFilter',
      _i783h20h.SessionLogInfo => 'SessionLogInfo',
      _idz92mnt.SessionLogResult => 'SessionLogResult',
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
      case _ihncus9g.CacheInfo():
        return 'CacheInfo';
      case _iuu4tkmh.CachesInfo():
        return 'CachesInfo';
      case _il44s43u.CloudStorageEntry():
        return 'CloudStorageEntry';
      case _i97jjzdk.CloudStorageDirectDownloadEntry():
        return 'CloudStorageDirectDownloadEntry';
      case _ihrv9246.CloudStorageDirectUploadEntry():
        return 'CloudStorageDirectUploadEntry';
      case _ix58cu06.ClusterInfo():
        return 'ClusterInfo';
      case _i0iseagh.ClusterServerInfo():
        return 'ClusterServerInfo';
      case _is8pd350.CronFutureCallScheduling():
        return 'CronFutureCallScheduling';
      case _i2x83mx1.DatabaseMigrationVersion():
        return 'DatabaseMigrationVersion';
      case _imsb8zuu.DistributedCacheEntry():
        return 'DistributedCacheEntry';
      case _ier2zjtm.AccessDeniedException():
        return 'AccessDeniedException';
      case _icej9e0v.FileNotFoundException():
        return 'FileNotFoundException';
      case _iil91lk2.FutureCallClaimEntry():
        return 'FutureCallClaimEntry';
      case _ipstj2hb.FutureCallEntry():
        return 'FutureCallEntry';
      case _is8pd350.IntervalFutureCallScheduling():
        return 'IntervalFutureCallScheduling';
      case _iv7ld46g.LogEntry():
        return 'LogEntry';
      case _iavjjqw5.LogLevel():
        return 'LogLevel';
      case _i6wf5evp.LogResult():
        return 'LogResult';
      case _illv0ea4.LogSettings():
        return 'LogSettings';
      case _i5sjxqb6.LogSettingsOverride():
        return 'LogSettingsOverride';
      case _iky1nb92.MessageLogEntry():
        return 'MessageLogEntry';
      case _iphoy7x3.MethodInfo():
        return 'MethodInfo';
      case _inqjskye.QueryLogEntry():
        return 'QueryLogEntry';
      case _i2c0cuss.ReadWriteTestEntry():
        return 'ReadWriteTestEntry';
      case _im7ye3v2.RuntimeSettings():
        return 'RuntimeSettings';
      case _igb3a02z.ServerHealthConnectionInfo():
        return 'ServerHealthConnectionInfo';
      case _i8823art.ServerHealthMetric():
        return 'ServerHealthMetric';
      case _ife0uun1.ServerHealthResult():
        return 'ServerHealthResult';
      case _i641wcmx.ServerpodSqlException():
        return 'ServerpodSqlException';
      case _i3jtimpl.SessionLogEntry():
        return 'SessionLogEntry';
      case _i2jy9zag.SessionLogFilter():
        return 'SessionLogFilter';
      case _i783h20h.SessionLogInfo():
        return 'SessionLogInfo';
      case _idz92mnt.SessionLogResult():
        return 'SessionLogResult';
    }
    className = _isd.Protocol().getClassNameForObject(data);
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
      return deserialize<_ihncus9g.CacheInfo>(data['data']);
    }
    if (dataClassName == 'CachesInfo') {
      return deserialize<_iuu4tkmh.CachesInfo>(data['data']);
    }
    if (dataClassName == 'CloudStorageEntry') {
      return deserialize<_il44s43u.CloudStorageEntry>(data['data']);
    }
    if (dataClassName == 'CloudStorageDirectDownloadEntry') {
      return deserialize<_i97jjzdk.CloudStorageDirectDownloadEntry>(
        data['data'],
      );
    }
    if (dataClassName == 'CloudStorageDirectUploadEntry') {
      return deserialize<_ihrv9246.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (dataClassName == 'ClusterInfo') {
      return deserialize<_ix58cu06.ClusterInfo>(data['data']);
    }
    if (dataClassName == 'ClusterServerInfo') {
      return deserialize<_i0iseagh.ClusterServerInfo>(data['data']);
    }
    if (dataClassName == 'CronFutureCallScheduling') {
      return deserialize<_is8pd350.CronFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersion') {
      return deserialize<_i2x83mx1.DatabaseMigrationVersion>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_imsb8zuu.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_ier2zjtm.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_icej9e0v.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallClaimEntry') {
      return deserialize<_iil91lk2.FutureCallClaimEntry>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_ipstj2hb.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'IntervalFutureCallScheduling') {
      return deserialize<_is8pd350.IntervalFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_iv7ld46g.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_iavjjqw5.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i6wf5evp.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_illv0ea4.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i5sjxqb6.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_iky1nb92.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_iphoy7x3.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_inqjskye.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i2c0cuss.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_im7ye3v2.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_igb3a02z.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i8823art.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_ife0uun1.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i641wcmx.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i3jtimpl.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i2jy9zag.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i783h20h.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_idz92mnt.SessionLogResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_database.')) {
      data['className'] = dataClassName.substring(19);
      return _isd.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _isd.Protocol().registerHostProtocol('serverpod', this);
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
