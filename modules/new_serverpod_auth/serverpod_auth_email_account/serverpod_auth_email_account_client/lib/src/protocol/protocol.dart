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
import 'exceptions/email_account_login_exception.dart' as _i2;
import 'exceptions/email_account_login_failure_reason.dart' as _i3;
import 'exceptions/email_account_password_policy_violation_exception.dart'
    as _i4;
import 'exceptions/email_account_password_reset_request_expired_exception.dart'
    as _i5;
import 'exceptions/email_account_password_reset_request_not_found_exception.dart'
    as _i6;
import 'exceptions/email_account_password_reset_request_too_many_attempts_exception.dart'
    as _i7;
import 'exceptions/email_account_password_reset_request_unauthorized_exception.dart'
    as _i8;
import 'exceptions/email_account_password_reset_too_many_attempts_exception.dart'
    as _i9;
import 'exceptions/email_account_request_expired_exception.dart' as _i10;
import 'exceptions/email_account_request_not_found_exception.dart' as _i11;
import 'exceptions/email_account_request_not_verified_exception.dart' as _i12;
import 'exceptions/email_account_request_too_many_attempts_exception.dart'
    as _i13;
import 'exceptions/email_account_request_unauthorized_exception.dart' as _i14;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i15;
export 'exceptions/email_account_login_exception.dart';
export 'exceptions/email_account_login_failure_reason.dart';
export 'exceptions/email_account_password_policy_violation_exception.dart';
export 'exceptions/email_account_password_reset_request_expired_exception.dart';
export 'exceptions/email_account_password_reset_request_not_found_exception.dart';
export 'exceptions/email_account_password_reset_request_too_many_attempts_exception.dart';
export 'exceptions/email_account_password_reset_request_unauthorized_exception.dart';
export 'exceptions/email_account_password_reset_too_many_attempts_exception.dart';
export 'exceptions/email_account_request_expired_exception.dart';
export 'exceptions/email_account_request_not_found_exception.dart';
export 'exceptions/email_account_request_not_verified_exception.dart';
export 'exceptions/email_account_request_too_many_attempts_exception.dart';
export 'exceptions/email_account_request_unauthorized_exception.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.EmailAccountLoginException) {
      return _i2.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i3.EmailAccountLoginFailureReason) {
      return _i3.EmailAccountLoginFailureReason.fromJson(data) as T;
    }
    if (t == _i4.EmailAccountPasswordPolicyViolationException) {
      return _i4.EmailAccountPasswordPolicyViolationException.fromJson(data)
          as T;
    }
    if (t == _i5.EmailAccountPasswordResetRequestExpiredException) {
      return _i5.EmailAccountPasswordResetRequestExpiredException.fromJson(data)
          as T;
    }
    if (t == _i6.EmailAccountPasswordResetRequestNotFoundException) {
      return _i6.EmailAccountPasswordResetRequestNotFoundException.fromJson(
          data) as T;
    }
    if (t == _i7.EmailAccountPasswordResetRequestTooManyAttemptsException) {
      return _i7.EmailAccountPasswordResetRequestTooManyAttemptsException
          .fromJson(data) as T;
    }
    if (t == _i8.EmailAccountPasswordResetRequestUnauthorizedException) {
      return _i8.EmailAccountPasswordResetRequestUnauthorizedException.fromJson(
          data) as T;
    }
    if (t == _i9.EmailAccountPasswordResetTooManyAttemptsException) {
      return _i9.EmailAccountPasswordResetTooManyAttemptsException.fromJson(
          data) as T;
    }
    if (t == _i10.EmailAccountRequestExpiredException) {
      return _i10.EmailAccountRequestExpiredException.fromJson(data) as T;
    }
    if (t == _i11.EmailAccountRequestNotFoundException) {
      return _i11.EmailAccountRequestNotFoundException.fromJson(data) as T;
    }
    if (t == _i12.EmailAccountRequestNotVerifiedException) {
      return _i12.EmailAccountRequestNotVerifiedException.fromJson(data) as T;
    }
    if (t == _i13.EmailAccountRequestTooManyAttemptsException) {
      return _i13.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          as T;
    }
    if (t == _i14.EmailAccountRequestUnauthorizedException) {
      return _i14.EmailAccountRequestUnauthorizedException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.EmailAccountLoginException?>()) {
      return (data != null
          ? _i2.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i3.EmailAccountLoginFailureReason?>()) {
      return (data != null
          ? _i3.EmailAccountLoginFailureReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.EmailAccountPasswordPolicyViolationException?>()) {
      return (data != null
          ? _i4.EmailAccountPasswordPolicyViolationException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i5.EmailAccountPasswordResetRequestExpiredException?>()) {
      return (data != null
          ? _i5.EmailAccountPasswordResetRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i6.EmailAccountPasswordResetRequestNotFoundException?>()) {
      return (data != null
          ? _i6.EmailAccountPasswordResetRequestNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i7.EmailAccountPasswordResetRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i7.EmailAccountPasswordResetRequestTooManyAttemptsException
              .fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i8.EmailAccountPasswordResetRequestUnauthorizedException?>()) {
      return (data != null
          ? _i8.EmailAccountPasswordResetRequestUnauthorizedException.fromJson(
              data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i9.EmailAccountPasswordResetTooManyAttemptsException?>()) {
      return (data != null
          ? _i9.EmailAccountPasswordResetTooManyAttemptsException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.EmailAccountRequestExpiredException?>()) {
      return (data != null
          ? _i10.EmailAccountRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.EmailAccountRequestNotFoundException?>()) {
      return (data != null
          ? _i11.EmailAccountRequestNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.EmailAccountRequestNotVerifiedException?>()) {
      return (data != null
          ? _i12.EmailAccountRequestNotVerifiedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.EmailAccountRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i13.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.EmailAccountRequestUnauthorizedException?>()) {
      return (data != null
          ? _i14.EmailAccountRequestUnauthorizedException.fromJson(data)
          : null) as T;
    }
    try {
      return _i15.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i3.EmailAccountLoginFailureReason():
        return 'EmailAccountLoginFailureReason';
      case _i4.EmailAccountPasswordPolicyViolationException():
        return 'EmailAccountPasswordPolicyViolationException';
      case _i5.EmailAccountPasswordResetRequestExpiredException():
        return 'EmailAccountPasswordResetRequestExpiredException';
      case _i6.EmailAccountPasswordResetRequestNotFoundException():
        return 'EmailAccountPasswordResetRequestNotFoundException';
      case _i7.EmailAccountPasswordResetRequestTooManyAttemptsException():
        return 'EmailAccountPasswordResetRequestTooManyAttemptsException';
      case _i8.EmailAccountPasswordResetRequestUnauthorizedException():
        return 'EmailAccountPasswordResetRequestUnauthorizedException';
      case _i9.EmailAccountPasswordResetTooManyAttemptsException():
        return 'EmailAccountPasswordResetTooManyAttemptsException';
      case _i10.EmailAccountRequestExpiredException():
        return 'EmailAccountRequestExpiredException';
      case _i11.EmailAccountRequestNotFoundException():
        return 'EmailAccountRequestNotFoundException';
      case _i12.EmailAccountRequestNotVerifiedException():
        return 'EmailAccountRequestNotVerifiedException';
      case _i13.EmailAccountRequestTooManyAttemptsException():
        return 'EmailAccountRequestTooManyAttemptsException';
      case _i14.EmailAccountRequestUnauthorizedException():
        return 'EmailAccountRequestUnauthorizedException';
    }
    className = _i15.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_user.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i2.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginFailureReason') {
      return deserialize<_i3.EmailAccountLoginFailureReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordPolicyViolationException') {
      return deserialize<_i4.EmailAccountPasswordPolicyViolationException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestExpiredException') {
      return deserialize<_i5.EmailAccountPasswordResetRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestNotFoundException') {
      return deserialize<_i6.EmailAccountPasswordResetRequestNotFoundException>(
          data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestTooManyAttemptsException') {
      return deserialize<
              _i7.EmailAccountPasswordResetRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestUnauthorizedException') {
      return deserialize<
          _i8
          .EmailAccountPasswordResetRequestUnauthorizedException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetTooManyAttemptsException') {
      return deserialize<_i9.EmailAccountPasswordResetTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExpiredException') {
      return deserialize<_i10.EmailAccountRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotFoundException') {
      return deserialize<_i11.EmailAccountRequestNotFoundException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotVerifiedException') {
      return deserialize<_i12.EmailAccountRequestNotVerifiedException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestTooManyAttemptsException') {
      return deserialize<_i13.EmailAccountRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestUnauthorizedException') {
      return deserialize<_i14.EmailAccountRequestUnauthorizedException>(
          data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i15.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
