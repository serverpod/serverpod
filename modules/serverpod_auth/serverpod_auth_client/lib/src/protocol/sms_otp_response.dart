/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Information about SMS OTP response.
class SmsOtpResponse extends _i1.SerializableEntity {
  SmsOtpResponse({
    required this.success,
    this.hash,
    this.failReason,
  });

  factory SmsOtpResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SmsOtpResponse(
      success:
          serializationManager.deserialize<bool>(jsonSerialization['success']),
      hash:
          serializationManager.deserialize<String?>(jsonSerialization['hash']),
      failReason:
          serializationManager.deserialize<_i2.AuthenticationFailReason?>(
              jsonSerialization['failReason']),
    );
  }

  /// True if the authentication was successful.
  bool success;

  String? hash;

  /// Reason for a failed authentication attempt, only set if the authentication
  /// failed.
  _i2.AuthenticationFailReason? failReason;

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'hash': hash,
      'failReason': failReason,
    };
  }
}
