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
import '../exceptions/email_account_login_failure_reason.dart' as _i2;

abstract class EmailAccountLoginException
    implements _i1.SerializableException, _i1.SerializableModel {
  EmailAccountLoginException._({required this.reason});

  factory EmailAccountLoginException(
          {required _i2.EmailAccountLoginFailureReason reason}) =
      _EmailAccountLoginExceptionImpl;

  factory EmailAccountLoginException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountLoginException(
        reason: _i2.EmailAccountLoginFailureReason.fromJson(
            (jsonSerialization['reason'] as int)));
  }

  _i2.EmailAccountLoginFailureReason reason;

  /// Returns a shallow copy of this [EmailAccountLoginException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountLoginException copyWith(
      {_i2.EmailAccountLoginFailureReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {'reason': reason.toJson()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmailAccountLoginExceptionImpl extends EmailAccountLoginException {
  _EmailAccountLoginExceptionImpl(
      {required _i2.EmailAccountLoginFailureReason reason})
      : super._(reason: reason);

  /// Returns a shallow copy of this [EmailAccountLoginException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountLoginException copyWith(
      {_i2.EmailAccountLoginFailureReason? reason}) {
    return EmailAccountLoginException(reason: reason ?? this.reason);
  }
}
