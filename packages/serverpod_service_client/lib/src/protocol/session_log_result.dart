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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_service_client/src/protocol/protocol.dart'
    as _ian793c4;
import 'session_log_info.dart' as _i783h20h;

/// A list of SessionLogInfo.
abstract class SessionLogResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionLogResult._({required this.sessionLog});

  factory SessionLogResult({
    required List<_i783h20h.SessionLogInfo> sessionLog,
  }) = _SessionLogResultImpl;

  factory SessionLogResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogResult(
      sessionLog: _ian793c4.Protocol()
          .deserialize<List<_i783h20h.SessionLogInfo>>(
            jsonSerialization['sessionLog'],
          ),
    );
  }

  /// The list of SessionLogInfo.
  List<_i783h20h.SessionLogInfo> sessionLog;

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    return _isc.SerializationManager.encode(this);
  }
}

class _SessionLogResultImpl extends SessionLogResult {
  _SessionLogResultImpl({required List<_i783h20h.SessionLogInfo> sessionLog})
    : super._(sessionLog: sessionLog);

  /// Returns a shallow copy of this [SessionLogResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionLogResult copyWith({List<_i783h20h.SessionLogInfo>? sessionLog}) {
    return SessionLogResult(
      sessionLog:
          sessionLog ?? this.sessionLog.map((e0) => e0.copyWith()).toList(),
    );
  }
}
