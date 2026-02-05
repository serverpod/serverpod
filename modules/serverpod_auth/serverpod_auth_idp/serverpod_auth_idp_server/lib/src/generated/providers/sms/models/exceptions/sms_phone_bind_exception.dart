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
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../../providers/sms/models/exceptions/sms_phone_bind_exception_reason.dart'
    as _i2;

/// Exception thrown when SMS phone bind request fails.
///
/// Inspect the [reason] to determine the cause of the failure.
abstract class SmsPhoneBindException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  SmsPhoneBindException._({required this.reason});

  factory SmsPhoneBindException({
    required _i2.SmsPhoneBindExceptionReason reason,
  }) = _SmsPhoneBindExceptionImpl;

  factory SmsPhoneBindException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SmsPhoneBindException(
      reason: _i2.SmsPhoneBindExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i2.SmsPhoneBindExceptionReason reason;

  /// Returns a shallow copy of this [SmsPhoneBindException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsPhoneBindException copyWith({_i2.SmsPhoneBindExceptionReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsPhoneBindException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.SmsPhoneBindException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'SmsPhoneBindException(reason: $reason)';
  }
}

class _SmsPhoneBindExceptionImpl extends SmsPhoneBindException {
  _SmsPhoneBindExceptionImpl({required _i2.SmsPhoneBindExceptionReason reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [SmsPhoneBindException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsPhoneBindException copyWith({_i2.SmsPhoneBindExceptionReason? reason}) {
    return SmsPhoneBindException(reason: reason ?? this.reason);
  }
}
