/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../../providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i2;

/// Exception to be thrown if email reset request fails.
///
/// Inspect the [reason] to determine whether this was due to invalid or unknown
/// credentials, or whether the client has been blocked outright.
abstract class EmailAccountPasswordResetException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  EmailAccountPasswordResetException._({required this.type});

  factory EmailAccountPasswordResetException(
          {required _i2.EmailAccountPasswordResetExceptionReason type}) =
      _EmailAccountPasswordResetExceptionImpl;

  factory EmailAccountPasswordResetException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetException(
        type: _i2.EmailAccountPasswordResetExceptionReason.fromJson(
            (jsonSerialization['type'] as int)));
  }

  _i2.EmailAccountPasswordResetExceptionReason type;

  /// Returns a shallow copy of this [EmailAccountPasswordResetException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetException copyWith(
      {_i2.EmailAccountPasswordResetExceptionReason? type});
  @override
  Map<String, dynamic> toJson() {
    return {'type': type.toJson()};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'type': type.toJson()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmailAccountPasswordResetExceptionImpl
    extends EmailAccountPasswordResetException {
  _EmailAccountPasswordResetExceptionImpl(
      {required _i2.EmailAccountPasswordResetExceptionReason type})
      : super._(type: type);

  /// Returns a shallow copy of this [EmailAccountPasswordResetException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetException copyWith(
      {_i2.EmailAccountPasswordResetExceptionReason? type}) {
    return EmailAccountPasswordResetException(type: type ?? this.type);
  }
}
