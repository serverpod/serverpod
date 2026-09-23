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
import 'push_acknowledge_failure_reason.dart' as _ioxstfh2;

/// Thrown when acknowledge cannot be applied.
abstract class PushAcknowledgeException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  PushAcknowledgeException._({required this.reason});

  factory PushAcknowledgeException({
    required _ioxstfh2.PushAcknowledgeFailureReason reason,
  }) = _PushAcknowledgeExceptionImpl;

  factory PushAcknowledgeException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PushAcknowledgeException(
      reason: _ioxstfh2.PushAcknowledgeFailureReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _ioxstfh2.PushAcknowledgeFailureReason reason;

  /// Returns a shallow copy of this [PushAcknowledgeException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushAcknowledgeException copyWith({
    _ioxstfh2.PushAcknowledgeFailureReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_store.PushAcknowledgeException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_push_store.PushAcknowledgeException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'PushAcknowledgeException(reason: $reason)';
  }
}

class _PushAcknowledgeExceptionImpl extends PushAcknowledgeException {
  _PushAcknowledgeExceptionImpl({
    required _ioxstfh2.PushAcknowledgeFailureReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [PushAcknowledgeException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushAcknowledgeException copyWith({
    _ioxstfh2.PushAcknowledgeFailureReason? reason,
  }) {
    return PushAcknowledgeException(reason: reason ?? this.reason);
  }
}
