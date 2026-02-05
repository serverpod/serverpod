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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../../providers/sms/models/exceptions/sms_account_request_exception_reason.dart'
    as _i2;

/// Exception thrown when SMS account creation request fails.
///
/// Inspect the [reason] to determine the cause of the failure.
abstract class SmsAccountRequestException
    implements _i1.SerializableException, _i1.SerializableModel {
  SmsAccountRequestException._({required this.reason});

  factory SmsAccountRequestException({
    required _i2.SmsAccountRequestExceptionReason reason,
  }) = _SmsAccountRequestExceptionImpl;

  factory SmsAccountRequestException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SmsAccountRequestException(
      reason: _i2.SmsAccountRequestExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i2.SmsAccountRequestExceptionReason reason;

  /// Returns a shallow copy of this [SmsAccountRequestException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsAccountRequestException copyWith({
    _i2.SmsAccountRequestExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsAccountRequestException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'SmsAccountRequestException(reason: $reason)';
  }
}

class _SmsAccountRequestExceptionImpl extends SmsAccountRequestException {
  _SmsAccountRequestExceptionImpl({
    required _i2.SmsAccountRequestExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [SmsAccountRequestException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsAccountRequestException copyWith({
    _i2.SmsAccountRequestExceptionReason? reason,
  }) {
    return SmsAccountRequestException(reason: reason ?? this.reason);
  }
}
