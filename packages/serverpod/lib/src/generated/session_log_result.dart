/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'session_log_info.dart' as _i783h20h;

/// A list of SessionLogInfo.
abstract class SessionLogResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionLogResult._({required this.sessionLog});

  factory SessionLogResult({
    required List<_i783h20h.SessionLogInfo> sessionLog,
  }) = _SessionLogResultImpl;

  factory SessionLogResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogResult(
      sessionLog: _ic00rqxb.Protocol()
          .deserialize<List<_i783h20h.SessionLogInfo>>(
            jsonSerialization['sessionLog'],
          ),
    );
  }

  /// The list of SessionLogInfo.
  List<_i783h20h.SessionLogInfo> sessionLog;

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionLogResult copyWith({List<_i783h20h.SessionLogInfo>? sessionLog});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.SessionLogResult',
      'sessionLog': sessionLog.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.SessionLogResult',
      'sessionLog': sessionLog.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SessionLogResultImpl extends SessionLogResult {
  _SessionLogResultImpl({required List<_i783h20h.SessionLogInfo> sessionLog})
    : super._(sessionLog: sessionLog);

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionLogResult copyWith({List<_i783h20h.SessionLogInfo>? sessionLog}) {
    return SessionLogResult(
      sessionLog:
          sessionLog ?? this.sessionLog.map((e0) => e0.copyWith()).toList(),
    );
  }
}
