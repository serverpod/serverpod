/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class SessionLogEntry extends _i1.SerializableEntity {
  SessionLogEntry({
    this.id,
    required this.serverId,
    required this.time,
    this.module,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUserId,
    this.isOpen,
    required this.touched,
  });

  factory SessionLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      module: serializationManager
          .deserializeJson<String?>(jsonSerialization['module']),
      endpoint: serializationManager
          .deserializeJson<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserializeJson<String?>(jsonSerialization['method']),
      duration: serializationManager
          .deserializeJson<double?>(jsonSerialization['duration']),
      numQueries: serializationManager
          .deserializeJson<int?>(jsonSerialization['numQueries']),
      slow: serializationManager
          .deserializeJson<bool?>(jsonSerialization['slow']),
      error: serializationManager
          .deserializeJson<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserializeJson<String?>(jsonSerialization['stackTrace']),
      authenticatedUserId: serializationManager
          .deserializeJson<int?>(jsonSerialization['authenticatedUserId']),
      isOpen: serializationManager
          .deserializeJson<bool?>(jsonSerialization['isOpen']),
      touched: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['touched']),
    );
  }

  int? id;

  String serverId;

  DateTime time;

  String? module;

  String? endpoint;

  String? method;

  double? duration;

  int? numQueries;

  bool? slow;

  String? error;

  String? stackTrace;

  int? authenticatedUserId;

  bool? isOpen;

  DateTime touched;

  @override
  String get className => 'SessionLogEntry';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'time': time,
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
      'isOpen': isOpen,
      'touched': touched,
    };
  }
}
