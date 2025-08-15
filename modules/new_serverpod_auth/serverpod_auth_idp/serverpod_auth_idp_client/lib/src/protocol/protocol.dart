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
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i2;
import 'providers/email/models/exceptions/email_account_login_failure_reason.dart'
    as _i3;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i4;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i5;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _i6;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _i7;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i9;
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_failure_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
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
    if (t == _i4.EmailAccountPasswordResetException) {
      return _i4.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _i5.EmailAccountPasswordResetExceptionReason) {
      return _i5.EmailAccountPasswordResetExceptionReason.fromJson(data) as T;
    }
    if (t == _i6.EmailAccountRequestException) {
      return _i6.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountRequestExceptionReason) {
      return _i7.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i8.GoogleIdTokenVerificationException) {
      return _i8.GoogleIdTokenVerificationException.fromJson(data) as T;
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
    if (t == _i1.getType<_i4.EmailAccountPasswordResetException?>()) {
      return (data != null
          ? _i4.EmailAccountPasswordResetException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
          ? _i5.EmailAccountPasswordResetExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.EmailAccountRequestException?>()) {
      return (data != null
          ? _i6.EmailAccountRequestException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccountRequestExceptionReason?>()) {
      return (data != null
          ? _i7.EmailAccountRequestExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.GoogleIdTokenVerificationException?>()) {
      return (data != null
          ? _i8.GoogleIdTokenVerificationException.fromJson(data)
          : null) as T;
    }
    try {
      return _i9.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.EmailAccountLoginException) {
      return 'EmailAccountLoginException';
    }
    if (data is _i3.EmailAccountLoginFailureReason) {
      return 'EmailAccountLoginFailureReason';
    }
    if (data is _i4.EmailAccountPasswordResetException) {
      return 'EmailAccountPasswordResetException';
    }
    if (data is _i5.EmailAccountPasswordResetExceptionReason) {
      return 'EmailAccountPasswordResetExceptionReason';
    }
    if (data is _i6.EmailAccountRequestException) {
      return 'EmailAccountRequestException';
    }
    if (data is _i7.EmailAccountRequestExceptionReason) {
      return 'EmailAccountRequestExceptionReason';
    }
    if (data is _i8.GoogleIdTokenVerificationException) {
      return 'GoogleIdTokenVerificationException';
    }
    className = _i9.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
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
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i4.EmailAccountPasswordResetException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_i5.EmailAccountPasswordResetExceptionReason>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_i6.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_i7.EmailAccountRequestExceptionReason>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i8.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i9.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
