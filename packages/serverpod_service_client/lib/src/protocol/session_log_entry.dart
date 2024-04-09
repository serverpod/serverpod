/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

/// Log entry for a session.
abstract class SessionLogEntry extends _i1.SerializableEntity {
  SessionLogEntry._({
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

  factory SessionLogEntry({
    int? id,
    required String serverId,
    required DateTime time,
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
    required DateTime touched,
  }) = _SessionLogEntryImpl;

  factory SessionLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogEntry(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      time: _i2.DateTimeExt.getDateTime<DateTime>(jsonSerialization['time'])!,
      module: jsonSerialization['module'] as String?,
      endpoint: jsonSerialization['endpoint'] as String?,
      method: jsonSerialization['method'] as String?,
      duration: jsonSerialization['duration'] as double?,
      numQueries: jsonSerialization['numQueries'] as int?,
      slow: jsonSerialization['slow'] as bool?,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      authenticatedUserId: jsonSerialization['authenticatedUserId'] as int?,
      isOpen: jsonSerialization['isOpen'] as bool?,
      touched:
          _i2.DateTimeExt.getDateTime<DateTime>(jsonSerialization['touched'])!,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'serverId': serverId,
      'time': time.toJson(),
      if (module != null) 'module': module,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (duration != null) 'duration': duration,
      if (numQueries != null) 'numQueries': numQueries,
      if (slow != null) 'slow': slow,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      if (authenticatedUserId != null)
        'authenticatedUserId': authenticatedUserId,
      if (isOpen != null) 'isOpen': isOpen,
      'touched': touched.toJson(),
    };
  }
}

class _Undefined {}

class _SessionLogEntryImpl extends SessionLogEntry {
  _SessionLogEntryImpl({
    int? id,
    required String serverId,
    required DateTime time,
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
    required DateTime touched,
  }) : super._(
          id: id,
          serverId: serverId,
          time: time,
          module: module,
          endpoint: endpoint,
          method: method,
          duration: duration,
          numQueries: numQueries,
          slow: slow,
          error: error,
          stackTrace: stackTrace,
          authenticatedUserId: authenticatedUserId,
          isOpen: isOpen,
          touched: touched,
        );

  @override
  SessionLogEntry copyWith({
    Object? id = _Undefined,
    String? serverId,
    DateTime? time,
    Object? module = _Undefined,
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
    Object? duration = _Undefined,
    Object? numQueries = _Undefined,
    Object? slow = _Undefined,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    Object? authenticatedUserId = _Undefined,
    Object? isOpen = _Undefined,
    DateTime? touched,
  }) {
    return SessionLogEntry(
      id: id is int? ? id : this.id,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      module: module is String? ? module : this.module,
      endpoint: endpoint is String? ? endpoint : this.endpoint,
      method: method is String? ? method : this.method,
      duration: duration is double? ? duration : this.duration,
      numQueries: numQueries is int? ? numQueries : this.numQueries,
      slow: slow is bool? ? slow : this.slow,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      authenticatedUserId: authenticatedUserId is int?
          ? authenticatedUserId
          : this.authenticatedUserId,
      isOpen: isOpen is bool? ? isOpen : this.isOpen,
      touched: touched ?? this.touched,
    );
  }
}
