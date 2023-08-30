/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Log entry for a session.
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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      module: serializationManager
          .deserialize<String?>(jsonSerialization['module']),
      endpoint: serializationManager
          .deserialize<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserialize<String?>(jsonSerialization['method']),
      duration: serializationManager
          .deserialize<double?>(jsonSerialization['duration']),
      numQueries: serializationManager
          .deserialize<int?>(jsonSerialization['numQueries']),
      slow: serializationManager.deserialize<bool?>(jsonSerialization['slow']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      authenticatedUserId: serializationManager
          .deserialize<int?>(jsonSerialization['authenticatedUserId']),
      isOpen:
          serializationManager.deserialize<bool?>(jsonSerialization['isOpen']),
      touched: serializationManager
          .deserialize<DateTime>(jsonSerialization['touched']),
    );
  }

  int? id;

  /// The id of the server that handled this session.
  String serverId;

  /// The starting time of this session.
  DateTime time;

  /// The module this session is associated with, if any.
  String? module;

  /// The endpoint this session is associated with, if any.
  String? endpoint;

  /// The method this session is associated with, if any.
  String? method;

  /// The running time of this session. May be null if the session is still
  /// active.
  double? duration;

  /// The number of queries performed during this session.
  int? numQueries;

  /// True if this session was slow to complete.
  bool? slow;

  /// If the session ends with an exception, the error field will be set.
  String? error;

  /// If the session ends with an exception, a stack trace will be set.
  String? stackTrace;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  int? authenticatedUserId;

  /// True if the session is still open.
  bool? isOpen;

  /// Timestamp of the last time this record was modified.
  DateTime touched;

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
