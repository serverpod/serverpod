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
import 'package:serverpod_push_core_client/src/protocol/protocol.dart'
    as _iqi84yf1;
import 'push_delivery_outcome.dart' as _i7pp3ych;
import 'push_device_target.dart' as _i0dvde7a;

/// Result of sending to one [PushDeviceTarget].
abstract class PushSendResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushSendResult._({
    required this.target,
    required this.outcome,
    this.providerMessageId,
    this.errorCode,
    this.errorMessage,
    this.retryAfter,
  });

  factory PushSendResult({
    required _i0dvde7a.PushDeviceTarget target,
    required _i7pp3ych.PushDeliveryOutcome outcome,
    String? providerMessageId,
    String? errorCode,
    String? errorMessage,
    Duration? retryAfter,
  }) = _PushSendResultImpl;

  factory PushSendResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushSendResult(
      target: _iqi84yf1.Protocol().deserialize<_i0dvde7a.PushDeviceTarget>(
        jsonSerialization['target'],
      ),
      outcome: _i7pp3ych.PushDeliveryOutcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      providerMessageId: jsonSerialization['providerMessageId'] as String?,
      errorCode: jsonSerialization['errorCode'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      retryAfter: jsonSerialization['retryAfter'] == null
          ? null
          : _isc.DurationJsonExtension.fromJson(
              jsonSerialization['retryAfter'],
            ),
    );
  }

  _i0dvde7a.PushDeviceTarget target;

  _i7pp3ych.PushDeliveryOutcome outcome;

  String? providerMessageId;

  String? errorCode;

  String? errorMessage;

  Duration? retryAfter;

  /// Returns a shallow copy of this [PushSendResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushSendResult copyWith({
    _i0dvde7a.PushDeviceTarget? target,
    _i7pp3ych.PushDeliveryOutcome? outcome,
    String? providerMessageId,
    String? errorCode,
    String? errorMessage,
    Duration? retryAfter,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_core.PushSendResult',
      'target': target.toJson(),
      'outcome': outcome.toJson(),
      if (providerMessageId != null) 'providerMessageId': providerMessageId,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (retryAfter != null) 'retryAfter': retryAfter?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_push_core.PushSendResult',
      'target': target.toJsonForProtocol(),
      'outcome': outcome.toJson(),
      if (providerMessageId != null) 'providerMessageId': providerMessageId,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (retryAfter != null) 'retryAfter': retryAfter?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushSendResultImpl extends PushSendResult {
  _PushSendResultImpl({
    required _i0dvde7a.PushDeviceTarget target,
    required _i7pp3ych.PushDeliveryOutcome outcome,
    String? providerMessageId,
    String? errorCode,
    String? errorMessage,
    Duration? retryAfter,
  }) : super._(
         target: target,
         outcome: outcome,
         providerMessageId: providerMessageId,
         errorCode: errorCode,
         errorMessage: errorMessage,
         retryAfter: retryAfter,
       );

  /// Returns a shallow copy of this [PushSendResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushSendResult copyWith({
    _i0dvde7a.PushDeviceTarget? target,
    _i7pp3ych.PushDeliveryOutcome? outcome,
    Object? providerMessageId = _Undefined,
    Object? errorCode = _Undefined,
    Object? errorMessage = _Undefined,
    Object? retryAfter = _Undefined,
  }) {
    return PushSendResult(
      target: target ?? this.target.copyWith(),
      outcome: outcome ?? this.outcome,
      providerMessageId: providerMessageId is String?
          ? providerMessageId
          : this.providerMessageId,
      errorCode: errorCode is String? ? errorCode : this.errorCode,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      retryAfter: retryAfter is Duration? ? retryAfter : this.retryAfter,
    );
  }
}
