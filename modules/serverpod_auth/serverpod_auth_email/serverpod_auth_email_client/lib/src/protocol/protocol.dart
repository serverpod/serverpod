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
import 'email_auth.dart' as _i2;
import 'email_create_account_request.dart' as _i3;
import 'email_failed_sign_in.dart' as _i4;
import 'email_password_reset.dart' as _i5;
import 'email_reset.dart' as _i6;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i7;
export 'email_auth.dart';
export 'email_create_account_request.dart';
export 'email_failed_sign_in.dart';
export 'email_password_reset.dart';
export 'email_reset.dart';
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
    if (t == _i2.EmailAuth) {
      return _i2.EmailAuth.fromJson(data) as T;
    }
    if (t == _i3.EmailCreateAccountRequest) {
      return _i3.EmailCreateAccountRequest.fromJson(data) as T;
    }
    if (t == _i4.EmailFailedSignIn) {
      return _i4.EmailFailedSignIn.fromJson(data) as T;
    }
    if (t == _i5.EmailPasswordReset) {
      return _i5.EmailPasswordReset.fromJson(data) as T;
    }
    if (t == _i6.EmailReset) {
      return _i6.EmailReset.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.EmailAuth?>()) {
      return (data != null ? _i2.EmailAuth.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.EmailCreateAccountRequest?>()) {
      return (data != null
          ? _i3.EmailCreateAccountRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.EmailFailedSignIn?>()) {
      return (data != null ? _i4.EmailFailedSignIn.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EmailPasswordReset?>()) {
      return (data != null ? _i5.EmailPasswordReset.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.EmailReset?>()) {
      return (data != null ? _i6.EmailReset.fromJson(data) : null) as T;
    }
    try {
      return _i7.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.EmailAuth) {
      return 'EmailAuth';
    }
    if (data is _i3.EmailCreateAccountRequest) {
      return 'EmailCreateAccountRequest';
    }
    if (data is _i4.EmailFailedSignIn) {
      return 'EmailFailedSignIn';
    }
    if (data is _i5.EmailPasswordReset) {
      return 'EmailPasswordReset';
    }
    if (data is _i6.EmailReset) {
      return 'EmailReset';
    }
    className = _i7.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailAuth') {
      return deserialize<_i2.EmailAuth>(data['data']);
    }
    if (dataClassName == 'EmailCreateAccountRequest') {
      return deserialize<_i3.EmailCreateAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailFailedSignIn') {
      return deserialize<_i4.EmailFailedSignIn>(data['data']);
    }
    if (dataClassName == 'EmailPasswordReset') {
      return deserialize<_i5.EmailPasswordReset>(data['data']);
    }
    if (dataClassName == 'EmailReset') {
      return deserialize<_i6.EmailReset>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i7.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
