/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'session_log_info.dart' as _i2;

/// A list of SessionLogInfo.
abstract class SessionLogResult implements _i1.SerializableModel {
  SessionLogResult._({required this.sessionLog});

  factory SessionLogResult({required List<_i2.SessionLogInfo> sessionLog}) =
      _SessionLogResultImpl;

  factory SessionLogResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogResult(
        sessionLog: (jsonSerialization['sessionLog'] as List)
            .map(
                (e) => _i2.SessionLogInfo.fromJson((e as Map<String, dynamic>)))
            .toList());
  }

  /// The list of SessionLogInfo.
  List<_i2.SessionLogInfo> sessionLog;

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionLogResult copyWith({List<_i2.SessionLogInfo>? sessionLog});
  @override
  Map<String, dynamic> toJson() {
    return {'sessionLog': sessionLog.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SessionLogResultImpl extends SessionLogResult {
  _SessionLogResultImpl({required List<_i2.SessionLogInfo> sessionLog})
      : super._(sessionLog: sessionLog);

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionLogResult copyWith({List<_i2.SessionLogInfo>? sessionLog}) {
    return SessionLogResult(
        sessionLog:
            sessionLog ?? this.sessionLog.map((e0) => e0.copyWith()).toList());
  }
}
