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
import 'authentication_token_info.dart' as _i2;
import 'refresh_token_expired_exception.dart' as _i3;
import 'refresh_token_invalid_secret_exception.dart' as _i4;
import 'refresh_token_malformed_exception.dart' as _i5;
import 'refresh_token_not_found_exception.dart' as _i6;
import 'token_pair.dart' as _i7;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i8;
export 'authentication_token_info.dart';
export 'refresh_token_expired_exception.dart';
export 'refresh_token_invalid_secret_exception.dart';
export 'refresh_token_malformed_exception.dart';
export 'refresh_token_not_found_exception.dart';
export 'token_pair.dart';
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
    if (t == _i2.AuthenticationTokenInfo) {
      return _i2.AuthenticationTokenInfo.fromJson(data) as T;
    }
    if (t == _i3.RefreshTokenExpiredException) {
      return _i3.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i4.RefreshTokenInvalidSecretException) {
      return _i4.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i5.RefreshTokenMalformedException) {
      return _i5.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i6.RefreshTokenNotFoundException) {
      return _i6.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i7.TokenPair) {
      return _i7.TokenPair.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthenticationTokenInfo?>()) {
      return (data != null ? _i2.AuthenticationTokenInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.RefreshTokenExpiredException?>()) {
      return (data != null
          ? _i3.RefreshTokenExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.RefreshTokenInvalidSecretException?>()) {
      return (data != null
          ? _i4.RefreshTokenInvalidSecretException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.RefreshTokenMalformedException?>()) {
      return (data != null
          ? _i5.RefreshTokenMalformedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.RefreshTokenNotFoundException?>()) {
      return (data != null
          ? _i6.RefreshTokenNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.TokenPair?>()) {
      return (data != null ? _i7.TokenPair.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.AuthenticationTokenInfo():
        return 'AuthenticationTokenInfo';
      case _i3.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _i4.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i5.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _i6.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i7.TokenPair():
        return 'TokenPair';
    }
    className = _i8.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AuthenticationTokenInfo') {
      return deserialize<_i2.AuthenticationTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i3.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i4.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i5.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i6.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i7.TokenPair>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
