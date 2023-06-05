/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// The log filter is used when searching for specific log entries.
abstract class SessionLogFilter extends _i1.SerializableEntity {
  const SessionLogFilter._();

  const factory SessionLogFilter({
    String? endpoint,
    String? method,
    String? futureCall,
    required bool slow,
    required bool error,
    required bool open,
    int? lastSessionLogId,
  }) = _SessionLogFilter;

  factory SessionLogFilter.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogFilter(
      endpoint: serializationManager
          .deserialize<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserialize<String?>(jsonSerialization['method']),
      futureCall: serializationManager
          .deserialize<String?>(jsonSerialization['futureCall']),
      slow: serializationManager.deserialize<bool>(jsonSerialization['slow']),
      error: serializationManager.deserialize<bool>(jsonSerialization['error']),
      open: serializationManager.deserialize<bool>(jsonSerialization['open']),
      lastSessionLogId: serializationManager
          .deserialize<int?>(jsonSerialization['lastSessionLogId']),
    );
  }

  SessionLogFilter copyWith({
    String? endpoint,
    String? method,
    String? futureCall,
    bool? slow,
    bool? error,
    bool? open,
    int? lastSessionLogId,
  });

  /// The endpoint to get logs from. Null will return logs from any endpoint.
  String? get endpoint;

  /// The method to get logs from. Null will return logs from any method.
  String? get method;

  /// The name of a future call to get logs from.
  String? get futureCall;

  /// If true, only return slow sessions.
  bool get slow;

  /// If true, only return sessions ending with an exception.
  bool get error;

  /// If true, only return open sessions.
  bool get open;

  /// Last session id to start the list of logs from. Used for pagination.
  int? get lastSessionLogId;
}

class _Undefined {}

/// The log filter is used when searching for specific log entries.
class _SessionLogFilter extends SessionLogFilter {
  const _SessionLogFilter({
    this.endpoint,
    this.method,
    this.futureCall,
    required this.slow,
    required this.error,
    required this.open,
    this.lastSessionLogId,
  }) : super._();

  /// The endpoint to get logs from. Null will return logs from any endpoint.
  @override
  final String? endpoint;

  /// The method to get logs from. Null will return logs from any method.
  @override
  final String? method;

  /// The name of a future call to get logs from.
  @override
  final String? futureCall;

  /// If true, only return slow sessions.
  @override
  final bool slow;

  /// If true, only return sessions ending with an exception.
  @override
  final bool error;

  /// If true, only return open sessions.
  @override
  final bool open;

  /// Last session id to start the list of logs from. Used for pagination.
  @override
  final int? lastSessionLogId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'slow': slow,
      'error': error,
      'open': open,
      'lastSessionLogId': lastSessionLogId,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SessionLogFilter &&
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
                  other.futureCall,
                  futureCall,
                ) ||
                other.futureCall == futureCall) &&
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
                  other.open,
                  open,
                ) ||
                other.open == open) &&
            (identical(
                  other.lastSessionLogId,
                  lastSessionLogId,
                ) ||
                other.lastSessionLogId == lastSessionLogId));
  }

  @override
  int get hashCode => Object.hash(
        endpoint,
        method,
        futureCall,
        slow,
        error,
        open,
        lastSessionLogId,
      );

  @override
  SessionLogFilter copyWith({
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
    Object? futureCall = _Undefined,
    bool? slow,
    bool? error,
    bool? open,
    Object? lastSessionLogId = _Undefined,
  }) {
    return SessionLogFilter(
      endpoint: endpoint == _Undefined ? this.endpoint : (endpoint as String?),
      method: method == _Undefined ? this.method : (method as String?),
      futureCall:
          futureCall == _Undefined ? this.futureCall : (futureCall as String?),
      slow: slow ?? this.slow,
      error: error ?? this.error,
      open: open ?? this.open,
      lastSessionLogId: lastSessionLogId == _Undefined
          ? this.lastSessionLogId
          : (lastSessionLogId as int?),
    );
  }
}
