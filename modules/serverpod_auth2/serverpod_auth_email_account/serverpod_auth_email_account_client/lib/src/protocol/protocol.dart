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
import 'email_account.dart' as _i2;
import 'email_account_password_reset_request.dart' as _i3;
import 'email_account_request.dart' as _i4;
import 'package:serverpod_auth2_client/serverpod_auth2_client.dart' as _i5;
export 'email_account.dart';
export 'email_account_password_reset_request.dart';
export 'email_account_request.dart';
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
    if (t == _i2.EmailAccount) {
      return _i2.EmailAccount.fromJson(data) as T;
    }
    if (t == _i3.EmailAccountPasswordResetRequest) {
      return _i3.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _i4.EmailAccountRequest) {
      return _i4.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.EmailAccount?>()) {
      return (data != null ? _i2.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.EmailAccountPasswordResetRequest?>()) {
      return (data != null
          ? _i3.EmailAccountPasswordResetRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.EmailAccountRequest?>()) {
      return (data != null ? _i4.EmailAccountRequest.fromJson(data) : null)
          as T;
    }
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.EmailAccount) {
      return 'EmailAccount';
    }
    if (data is _i3.EmailAccountPasswordResetRequest) {
      return 'EmailAccountPasswordResetRequest';
    }
    if (data is _i4.EmailAccountRequest) {
      return 'EmailAccountRequest';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth2.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i2.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i3.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i4.EmailAccountRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth2.')) {
      data['className'] = dataClassName.substring(16);
      return _i5.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
