/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'auth_key.dart' as _i2;
import 'cache_info.dart' as _i3;
import 'caches_info.dart' as _i4;
import 'cloud_storage.dart' as _i5;
import 'cloud_storage_direct_upload.dart' as _i6;
import 'cluster_info.dart' as _i7;
import 'cluster_server_info.dart' as _i8;
import 'distributed_cache_entry.dart' as _i9;
import 'future_call_entry.dart' as _i10;
import 'log_entry.dart' as _i11;
import 'log_level.dart' as _i12;
import 'log_result.dart' as _i13;
import 'log_settings.dart' as _i14;
import 'log_settings_override.dart' as _i15;
import 'message_log_entry.dart' as _i16;
import 'method_info.dart' as _i17;
import 'query_log_entry.dart' as _i18;
import 'readwrite_test.dart' as _i19;
import 'runtime_settings.dart' as _i20;
import 'server_health_connection_info.dart' as _i21;
import 'server_health_metric.dart' as _i22;
import 'server_health_result.dart' as _i23;
import 'session_log_entry.dart' as _i24;
import 'session_log_filter.dart' as _i25;
import 'session_log_info.dart' as _i26;
import 'session_log_result.dart' as _i27;
import 'protocol.dart' as _i28;
export 'auth_key.dart';
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
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
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserializeJson<T>(
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
    if (t == _i9.DistributedCacheEntry) {
      return _i9.DistributedCacheEntry.fromJson(data, this) as T;
    }
    if (t == _i10.FutureCallEntry) {
      return _i10.FutureCallEntry.fromJson(data, this) as T;
    }
    if (t == _i11.LogEntry) {
      return _i11.LogEntry.fromJson(data, this) as T;
    }
    if (t == _i12.LogLevel) {
      return _i12.LogLevel.fromJson(data) as T;
    }
    if (t == _i13.LogResult) {
      return _i13.LogResult.fromJson(data, this) as T;
    }
    if (t == _i14.LogSettings) {
      return _i14.LogSettings.fromJson(data, this) as T;
    }
    if (t == _i15.LogSettingsOverride) {
      return _i15.LogSettingsOverride.fromJson(data, this) as T;
    }
    if (t == _i16.MessageLogEntry) {
      return _i16.MessageLogEntry.fromJson(data, this) as T;
    }
    if (t == _i17.MethodInfo) {
      return _i17.MethodInfo.fromJson(data, this) as T;
    }
    if (t == _i18.QueryLogEntry) {
      return _i18.QueryLogEntry.fromJson(data, this) as T;
    }
    if (t == _i19.ReadWriteTestEntry) {
      return _i19.ReadWriteTestEntry.fromJson(data, this) as T;
    }
    if (t == _i20.RuntimeSettings) {
      return _i20.RuntimeSettings.fromJson(data, this) as T;
    }
    if (t == _i21.ServerHealthConnectionInfo) {
      return _i21.ServerHealthConnectionInfo.fromJson(data, this) as T;
    }
    if (t == _i22.ServerHealthMetric) {
      return _i22.ServerHealthMetric.fromJson(data, this) as T;
    }
    if (t == _i23.ServerHealthResult) {
      return _i23.ServerHealthResult.fromJson(data, this) as T;
    }
    if (t == _i24.SessionLogEntry) {
      return _i24.SessionLogEntry.fromJson(data, this) as T;
    }
    if (t == _i25.SessionLogFilter) {
      return _i25.SessionLogFilter.fromJson(data, this) as T;
    }
    if (t == _i26.SessionLogInfo) {
      return _i26.SessionLogInfo.fromJson(data, this) as T;
    }
    if (t == _i27.SessionLogResult) {
      return _i27.SessionLogResult.fromJson(data, this) as T;
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
    if (t == _i1.getType<_i9.DistributedCacheEntry?>()) {
      return (data != null
          ? _i9.DistributedCacheEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i10.FutureCallEntry?>()) {
      return (data != null ? _i10.FutureCallEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i11.LogEntry?>()) {
      return (data != null ? _i11.LogEntry.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i12.LogLevel?>()) {
      return (data != null ? _i12.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.LogResult?>()) {
      return (data != null ? _i13.LogResult.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i14.LogSettings?>()) {
      return (data != null ? _i14.LogSettings.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i15.LogSettingsOverride?>()) {
      return (data != null
          ? _i15.LogSettingsOverride.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i16.MessageLogEntry?>()) {
      return (data != null ? _i16.MessageLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.MethodInfo?>()) {
      return (data != null ? _i17.MethodInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i18.QueryLogEntry?>()) {
      return (data != null ? _i18.QueryLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ReadWriteTestEntry?>()) {
      return (data != null
          ? _i19.ReadWriteTestEntry.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i20.RuntimeSettings?>()) {
      return (data != null ? _i20.RuntimeSettings.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i21.ServerHealthConnectionInfo.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i22.ServerHealthMetric?>()) {
      return (data != null
          ? _i22.ServerHealthMetric.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i23.ServerHealthResult?>()) {
      return (data != null
          ? _i23.ServerHealthResult.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i24.SessionLogEntry?>()) {
      return (data != null ? _i24.SessionLogEntry.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i25.SessionLogFilter?>()) {
      return (data != null ? _i25.SessionLogFilter.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i26.SessionLogInfo?>()) {
      return (data != null ? _i26.SessionLogInfo.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i27.SessionLogResult?>()) {
      return (data != null ? _i27.SessionLogResult.fromJson(data, this) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserializeJson<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i28.ClusterServerInfo>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.ClusterServerInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.LogEntry>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.LogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.LogSettingsOverride>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.ServerHealthMetric>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.ServerHealthConnectionInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.QueryLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.MessageLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i28.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserializeJson<_i28.SessionLogInfo>(e))
          .toList() as dynamic;
    }
    return super.deserializeJson<T>(data, t);
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
    if (data is _i9.DistributedCacheEntry) {
      return 'DistributedCacheEntry';
    }
    if (data is _i10.FutureCallEntry) {
      return 'FutureCallEntry';
    }
    if (data is _i11.LogEntry) {
      return 'LogEntry';
    }
    if (data is _i12.LogLevel) {
      return 'LogLevel';
    }
    if (data is _i13.LogResult) {
      return 'LogResult';
    }
    if (data is _i14.LogSettings) {
      return 'LogSettings';
    }
    if (data is _i15.LogSettingsOverride) {
      return 'LogSettingsOverride';
    }
    if (data is _i16.MessageLogEntry) {
      return 'MessageLogEntry';
    }
    if (data is _i17.MethodInfo) {
      return 'MethodInfo';
    }
    if (data is _i18.QueryLogEntry) {
      return 'QueryLogEntry';
    }
    if (data is _i19.ReadWriteTestEntry) {
      return 'ReadWriteTestEntry';
    }
    if (data is _i20.RuntimeSettings) {
      return 'RuntimeSettings';
    }
    if (data is _i21.ServerHealthConnectionInfo) {
      return 'ServerHealthConnectionInfo';
    }
    if (data is _i22.ServerHealthMetric) {
      return 'ServerHealthMetric';
    }
    if (data is _i23.ServerHealthResult) {
      return 'ServerHealthResult';
    }
    if (data is _i24.SessionLogEntry) {
      return 'SessionLogEntry';
    }
    if (data is _i25.SessionLogFilter) {
      return 'SessionLogFilter';
    }
    if (data is _i26.SessionLogInfo) {
      return 'SessionLogInfo';
    }
    if (data is _i27.SessionLogResult) {
      return 'SessionLogResult';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'AuthKey') {
      return deserializeJson<_i2.AuthKey>(data['data']);
    }
    if (data['className'] == 'CacheInfo') {
      return deserializeJson<_i3.CacheInfo>(data['data']);
    }
    if (data['className'] == 'CachesInfo') {
      return deserializeJson<_i4.CachesInfo>(data['data']);
    }
    if (data['className'] == 'CloudStorageEntry') {
      return deserializeJson<_i5.CloudStorageEntry>(data['data']);
    }
    if (data['className'] == 'CloudStorageDirectUploadEntry') {
      return deserializeJson<_i6.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (data['className'] == 'ClusterInfo') {
      return deserializeJson<_i7.ClusterInfo>(data['data']);
    }
    if (data['className'] == 'ClusterServerInfo') {
      return deserializeJson<_i8.ClusterServerInfo>(data['data']);
    }
    if (data['className'] == 'DistributedCacheEntry') {
      return deserializeJson<_i9.DistributedCacheEntry>(data['data']);
    }
    if (data['className'] == 'FutureCallEntry') {
      return deserializeJson<_i10.FutureCallEntry>(data['data']);
    }
    if (data['className'] == 'LogEntry') {
      return deserializeJson<_i11.LogEntry>(data['data']);
    }
    if (data['className'] == 'LogLevel') {
      return deserializeJson<_i12.LogLevel>(data['data']);
    }
    if (data['className'] == 'LogResult') {
      return deserializeJson<_i13.LogResult>(data['data']);
    }
    if (data['className'] == 'LogSettings') {
      return deserializeJson<_i14.LogSettings>(data['data']);
    }
    if (data['className'] == 'LogSettingsOverride') {
      return deserializeJson<_i15.LogSettingsOverride>(data['data']);
    }
    if (data['className'] == 'MessageLogEntry') {
      return deserializeJson<_i16.MessageLogEntry>(data['data']);
    }
    if (data['className'] == 'MethodInfo') {
      return deserializeJson<_i17.MethodInfo>(data['data']);
    }
    if (data['className'] == 'QueryLogEntry') {
      return deserializeJson<_i18.QueryLogEntry>(data['data']);
    }
    if (data['className'] == 'ReadWriteTestEntry') {
      return deserializeJson<_i19.ReadWriteTestEntry>(data['data']);
    }
    if (data['className'] == 'RuntimeSettings') {
      return deserializeJson<_i20.RuntimeSettings>(data['data']);
    }
    if (data['className'] == 'ServerHealthConnectionInfo') {
      return deserializeJson<_i21.ServerHealthConnectionInfo>(data['data']);
    }
    if (data['className'] == 'ServerHealthMetric') {
      return deserializeJson<_i22.ServerHealthMetric>(data['data']);
    }
    if (data['className'] == 'ServerHealthResult') {
      return deserializeJson<_i23.ServerHealthResult>(data['data']);
    }
    if (data['className'] == 'SessionLogEntry') {
      return deserializeJson<_i24.SessionLogEntry>(data['data']);
    }
    if (data['className'] == 'SessionLogFilter') {
      return deserializeJson<_i25.SessionLogFilter>(data['data']);
    }
    if (data['className'] == 'SessionLogInfo') {
      return deserializeJson<_i26.SessionLogInfo>(data['data']);
    }
    if (data['className'] == 'SessionLogResult') {
      return deserializeJson<_i27.SessionLogResult>(data['data']);
    }
    return super.deserializeJsonByClassName(data);
  }
}
