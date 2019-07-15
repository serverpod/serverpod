/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod/serverpod.dart';

import 'cache_info.dart';
import 'runtime_settings.dart';
import 'session_log_info.dart';
import 'caches_info.dart';
import 'future_call_entry.dart';
import 'query_log_entry.dart';
import 'server_health_metric.dart';
import 'log_result.dart';
import 'distributed_cache_entry.dart';
import 'log_entry.dart';
import 'log_level.dart';
import 'session_log_entry.dart';
import 'server_health_result.dart';
import 'session_log_result.dart';

export 'cache_info.dart';
export 'runtime_settings.dart';
export 'session_log_info.dart';
export 'caches_info.dart';
export 'future_call_entry.dart';
export 'query_log_entry.dart';
export 'server_health_metric.dart';
export 'log_result.dart';
export 'distributed_cache_entry.dart';
export 'log_entry.dart';
export 'log_level.dart';
export 'session_log_entry.dart';
export 'server_health_result.dart';
export 'session_log_result.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  Map<String, constructor> _constructors = <String, constructor>{};
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['CacheInfo'] = (Map<String, dynamic> serialization) => CacheInfo.fromSerialization(serialization);
    constructors['RuntimeSettings'] = (Map<String, dynamic> serialization) => RuntimeSettings.fromSerialization(serialization);
    constructors['SessionLogInfo'] = (Map<String, dynamic> serialization) => SessionLogInfo.fromSerialization(serialization);
    constructors['CachesInfo'] = (Map<String, dynamic> serialization) => CachesInfo.fromSerialization(serialization);
    constructors['FutureCallEntry'] = (Map<String, dynamic> serialization) => FutureCallEntry.fromSerialization(serialization);
    constructors['QueryLogEntry'] = (Map<String, dynamic> serialization) => QueryLogEntry.fromSerialization(serialization);
    constructors['ServerHealthMetric'] = (Map<String, dynamic> serialization) => ServerHealthMetric.fromSerialization(serialization);
    constructors['LogResult'] = (Map<String, dynamic> serialization) => LogResult.fromSerialization(serialization);
    constructors['DistributedCacheEntry'] = (Map<String, dynamic> serialization) => DistributedCacheEntry.fromSerialization(serialization);
    constructors['LogEntry'] = (Map<String, dynamic> serialization) => LogEntry.fromSerialization(serialization);
    constructors['LogLevel'] = (Map<String, dynamic> serialization) => LogLevel.fromSerialization(serialization);
    constructors['SessionLogEntry'] = (Map<String, dynamic> serialization) => SessionLogEntry.fromSerialization(serialization);
    constructors['ServerHealthResult'] = (Map<String, dynamic> serialization) => ServerHealthResult.fromSerialization(serialization);
    constructors['SessionLogResult'] = (Map<String, dynamic> serialization) => SessionLogResult.fromSerialization(serialization);
  }
}
