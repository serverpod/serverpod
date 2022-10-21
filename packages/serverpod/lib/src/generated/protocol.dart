/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
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
export 'session_log_result.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.AuthKey:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i2.AuthKey.fromJson(jsonSerialization, serializationManager),
    _i3.CacheInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i3.CacheInfo.fromJson(jsonSerialization, serializationManager),
    _i4.CachesInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i4.CachesInfo.fromJson(jsonSerialization, serializationManager),
    _i5.CloudStorageEntry: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i5.CloudStorageEntry.fromJson(jsonSerialization, serializationManager),
    _i6.CloudStorageDirectUploadEntry:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i6.CloudStorageDirectUploadEntry.fromJson(
                jsonSerialization, serializationManager),
    _i7.ClusterInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i7.ClusterInfo.fromJson(jsonSerialization, serializationManager),
    _i8.ClusterServerInfo: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i8.ClusterServerInfo.fromJson(jsonSerialization, serializationManager),
    _i9.DistributedCacheEntry:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i9.DistributedCacheEntry.fromJson(
                jsonSerialization, serializationManager),
    _i10.FutureCallEntry: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i10.FutureCallEntry.fromJson(jsonSerialization, serializationManager),
    _i11.LogEntry:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i11.LogEntry.fromJson(jsonSerialization, serializationManager),
    _i12.LogLevel:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i12.LogLevel.fromJson(jsonSerialization),
    _i13.LogResult:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i13.LogResult.fromJson(jsonSerialization, serializationManager),
    _i14.LogSettings:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i14.LogSettings.fromJson(jsonSerialization, serializationManager),
    _i15.LogSettingsOverride:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i15.LogSettingsOverride.fromJson(
                jsonSerialization, serializationManager),
    _i16.MessageLogEntry: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i16.MessageLogEntry.fromJson(jsonSerialization, serializationManager),
    _i17.MethodInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i17.MethodInfo.fromJson(jsonSerialization, serializationManager),
    _i18.QueryLogEntry: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i18.QueryLogEntry.fromJson(jsonSerialization, serializationManager),
    _i19.ReadWriteTestEntry:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i19.ReadWriteTestEntry.fromJson(
                jsonSerialization, serializationManager),
    _i20.RuntimeSettings: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i20.RuntimeSettings.fromJson(jsonSerialization, serializationManager),
    _i21.ServerHealthConnectionInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i21.ServerHealthConnectionInfo.fromJson(
                jsonSerialization, serializationManager),
    _i22.ServerHealthMetric:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i22.ServerHealthMetric.fromJson(
                jsonSerialization, serializationManager),
    _i23.ServerHealthResult:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i23.ServerHealthResult.fromJson(
                jsonSerialization, serializationManager),
    _i24.SessionLogEntry: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i24.SessionLogEntry.fromJson(jsonSerialization, serializationManager),
    _i25.SessionLogFilter: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i25.SessionLogFilter.fromJson(jsonSerialization, serializationManager),
    _i26.SessionLogInfo: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i26.SessionLogInfo.fromJson(jsonSerialization, serializationManager),
    _i27.SessionLogResult: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i27.SessionLogResult.fromJson(jsonSerialization, serializationManager),
    _i1.getType<_i2.AuthKey?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i2.AuthKey.fromJson(jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i3.CacheInfo?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i3.CacheInfo.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i4.CachesInfo?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i4.CachesInfo.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i5.CloudStorageEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i5.CloudStorageEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i6.CloudStorageDirectUploadEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i6.CloudStorageDirectUploadEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i7.ClusterInfo?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i7.ClusterInfo.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i8.ClusterServerInfo?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i8.ClusterServerInfo.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i9.DistributedCacheEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i9.DistributedCacheEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i10.FutureCallEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i10.FutureCallEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i11.LogEntry?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i11.LogEntry.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i12.LogLevel?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i12.LogLevel.fromJson(jsonSerialization)
                : null,
    _i1.getType<_i13.LogResult?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i13.LogResult.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i14.LogSettings?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i14.LogSettings.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i15.LogSettingsOverride?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i15.LogSettingsOverride.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i16.MessageLogEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i16.MessageLogEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i17.MethodInfo?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i17.MethodInfo.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i18.QueryLogEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i18.QueryLogEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i19.ReadWriteTestEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i19.ReadWriteTestEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i20.RuntimeSettings?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i20.RuntimeSettings.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i21.ServerHealthConnectionInfo?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i21.ServerHealthConnectionInfo.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i22.ServerHealthMetric?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i22.ServerHealthMetric.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i23.ServerHealthResult?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i23.ServerHealthResult.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i24.SessionLogEntry?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i24.SessionLogEntry.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i25.SessionLogFilter?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i25.SessionLogFilter.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i26.SessionLogInfo?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i26.SessionLogInfo.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i27.SessionLogResult?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i27.SessionLogResult.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    List<String>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<String>(e))
                .toList(),
    _i1.getType<List<String>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<String>(e))
                    .toList()
                : null,
    List<_i28.ClusterServerInfo>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) =>
                serializationManager.deserializeJson<_i28.ClusterServerInfo>(e))
            .toList(),
    List<_i28.LogEntry>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i28.LogEntry>(e))
            .toList(),
    List<_i28.LogSettingsOverride>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager
                    .deserializeJson<_i28.LogSettingsOverride>(e))
                .toList(),
    List<_i28.ServerHealthMetric>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager
                    .deserializeJson<_i28.ServerHealthMetric>(e))
                .toList(),
    List<_i28.ServerHealthConnectionInfo>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager
                    .deserializeJson<_i28.ServerHealthConnectionInfo>(e))
                .toList(),
    List<_i28.QueryLogEntry>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i28.QueryLogEntry>(e))
                .toList(),
    List<_i28.MessageLogEntry>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) =>
                serializationManager.deserializeJson<_i28.MessageLogEntry>(e))
            .toList(),
    List<_i28.SessionLogInfo>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) =>
                serializationManager.deserializeJson<_i28.SessionLogInfo>(e))
            .toList(),
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};

  final Map<Type, _i1.Table> _typeTableMapping = {
    _i2.AuthKey: _i2.AuthKey.t,
    _i5.CloudStorageEntry: _i5.CloudStorageEntry.t,
    _i6.CloudStorageDirectUploadEntry: _i6.CloudStorageDirectUploadEntry.t,
    _i10.FutureCallEntry: _i10.FutureCallEntry.t,
    _i11.LogEntry: _i11.LogEntry.t,
    _i16.MessageLogEntry: _i16.MessageLogEntry.t,
    _i17.MethodInfo: _i17.MethodInfo.t,
    _i18.QueryLogEntry: _i18.QueryLogEntry.t,
    _i19.ReadWriteTestEntry: _i19.ReadWriteTestEntry.t,
    _i20.RuntimeSettings: _i20.RuntimeSettings.t,
    _i21.ServerHealthConnectionInfo: _i21.ServerHealthConnectionInfo.t,
    _i22.ServerHealthMetric: _i22.ServerHealthMetric.t,
    _i24.SessionLogEntry: _i24.SessionLogEntry.t,
  };

  @override
  Map<Type, _i1.Table> get typeTableMapping {
    return _typeTableMapping;
  }
}
