/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod_client/serverpod_client.dart';

import 'auth_key.dart';
import 'cache_info.dart';
import 'caches_info.dart';
import 'cloud_storage.dart';
import 'cloud_storage_direct_upload.dart';
import 'distributed_cache_entry.dart';
import 'future_call_entry.dart';
import 'log_entry.dart';
import 'log_level.dart';
import 'log_result.dart';
import 'log_settings.dart';
import 'log_settings_override.dart';
import 'method_info.dart';
import 'query_log_entry.dart';
import 'readwrite_test.dart';
import 'runtime_settings.dart';
import 'server_health_metric.dart';
import 'server_health_result.dart';
import 'session_log_entry.dart';
import 'session_log_filter.dart';
import 'session_log_info.dart';
import 'session_log_result.dart';

export 'auth_key.dart';
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'distributed_cache_entry.dart';
export 'future_call_entry.dart';
export 'log_entry.dart';
export 'log_level.dart';
export 'log_result.dart';
export 'log_settings.dart';
export 'log_settings_override.dart';
export 'method_info.dart';
export 'query_log_entry.dart';
export 'readwrite_test.dart';
export 'runtime_settings.dart';
export 'server_health_metric.dart';
export 'server_health_result.dart';
export 'session_log_entry.dart';
export 'session_log_filter.dart';
export 'session_log_info.dart';
export 'session_log_result.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['AuthKey'] = (Map<String, dynamic> serialization) =>
        AuthKey.fromSerialization(serialization);
    constructors['CacheInfo'] = (Map<String, dynamic> serialization) =>
        CacheInfo.fromSerialization(serialization);
    constructors['CachesInfo'] = (Map<String, dynamic> serialization) =>
        CachesInfo.fromSerialization(serialization);
    constructors['CloudStorageEntry'] = (Map<String, dynamic> serialization) =>
        CloudStorageEntry.fromSerialization(serialization);
    constructors['CloudStorageDirectUploadEntry'] =
        (Map<String, dynamic> serialization) =>
            CloudStorageDirectUploadEntry.fromSerialization(serialization);
    constructors['DistributedCacheEntry'] =
        (Map<String, dynamic> serialization) =>
            DistributedCacheEntry.fromSerialization(serialization);
    constructors['FutureCallEntry'] = (Map<String, dynamic> serialization) =>
        FutureCallEntry.fromSerialization(serialization);
    constructors['LogEntry'] = (Map<String, dynamic> serialization) =>
        LogEntry.fromSerialization(serialization);
    constructors['LogLevel'] = (Map<String, dynamic> serialization) =>
        LogLevel.fromSerialization(serialization);
    constructors['LogResult'] = (Map<String, dynamic> serialization) =>
        LogResult.fromSerialization(serialization);
    constructors['LogSettings'] = (Map<String, dynamic> serialization) =>
        LogSettings.fromSerialization(serialization);
    constructors['LogSettingsOverride'] =
        (Map<String, dynamic> serialization) =>
            LogSettingsOverride.fromSerialization(serialization);
    constructors['MethodInfo'] = (Map<String, dynamic> serialization) =>
        MethodInfo.fromSerialization(serialization);
    constructors['QueryLogEntry'] = (Map<String, dynamic> serialization) =>
        QueryLogEntry.fromSerialization(serialization);
    constructors['ReadWriteTestEntry'] = (Map<String, dynamic> serialization) =>
        ReadWriteTestEntry.fromSerialization(serialization);
    constructors['RuntimeSettings'] = (Map<String, dynamic> serialization) =>
        RuntimeSettings.fromSerialization(serialization);
    constructors['ServerHealthMetric'] = (Map<String, dynamic> serialization) =>
        ServerHealthMetric.fromSerialization(serialization);
    constructors['ServerHealthResult'] = (Map<String, dynamic> serialization) =>
        ServerHealthResult.fromSerialization(serialization);
    constructors['SessionLogEntry'] = (Map<String, dynamic> serialization) =>
        SessionLogEntry.fromSerialization(serialization);
    constructors['SessionLogFilter'] = (Map<String, dynamic> serialization) =>
        SessionLogFilter.fromSerialization(serialization);
    constructors['SessionLogInfo'] = (Map<String, dynamic> serialization) =>
        SessionLogInfo.fromSerialization(serialization);
    constructors['SessionLogResult'] = (Map<String, dynamic> serialization) =>
        SessionLogResult.fromSerialization(serialization);
  }
}
