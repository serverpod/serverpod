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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The id of the server that handled this session.
  final String serverId;

  /// The starting time of this session.
  final DateTime time;

  /// The module this session is associated with, if any.
  final String? module;

  /// The endpoint this session is associated with, if any.
  final String? endpoint;

  /// The method this session is associated with, if any.
  final String? method;

  /// The running time of this session. May be null if the session is still
  /// active.
  final double? duration;

  /// The number of queries performed during this session.
  final int? numQueries;

  /// True if this session was slow to complete.
  final bool? slow;

  /// If the session ends with an exception, the error field will be set.
  final String? error;

  /// If the session ends with an exception, a stack trace will be set.
  final String? stackTrace;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  final int? authenticatedUserId;

  /// True if the session is still open.
  final bool? isOpen;

  /// Timestamp of the last time this record was modified.
  final DateTime touched;

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

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SessionLogEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.module,
                  module,
                ) ||
                other.module == module) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration) &&
            (identical(
                  other.numQueries,
                  numQueries,
                ) ||
                other.numQueries == numQueries) &&
            (identical(
                  other.slow,
                  slow,
                ) ||
                other.slow == slow) &&
            (identical(
                  other.error,
                  error,
                ) ||
                other.error == error) &&
            (identical(
                  other.stackTrace,
                  stackTrace,
                ) ||
                other.stackTrace == stackTrace) &&
            (identical(
                  other.authenticatedUserId,
                  authenticatedUserId,
                ) ||
                other.authenticatedUserId == authenticatedUserId) &&
            (identical(
                  other.isOpen,
                  isOpen,
                ) ||
                other.isOpen == isOpen) &&
            (identical(
                  other.touched,
                  touched,
                ) ||
                other.touched == touched));
  }

  @override
  int get hashCode => Object.hash(
        id,
        serverId,
        time,
        module,
        endpoint,
        method,
        duration,
        numQueries,
        slow,
        error,
        stackTrace,
        authenticatedUserId,
        isOpen,
        touched,
      );

  SessionLogEntry copyWith({
    int? id,
    String? serverId,
    DateTime? time,
    String? module,
    String? endpoint,
    String? method,
    double? duration,
    int? numQueries,
    bool? slow,
    String? error,
    String? stackTrace,
    int? authenticatedUserId,
    bool? isOpen,
    DateTime? touched,
  }) {
    return SessionLogEntry(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      module: module ?? this.module,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      duration: duration ?? this.duration,
      numQueries: numQueries ?? this.numQueries,
      slow: slow ?? this.slow,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      authenticatedUserId: authenticatedUserId ?? this.authenticatedUserId,
      isOpen: isOpen ?? this.isOpen,
      touched: touched ?? this.touched,
    );
  }
}
