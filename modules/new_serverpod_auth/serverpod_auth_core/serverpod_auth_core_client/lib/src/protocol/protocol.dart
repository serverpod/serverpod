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
import 'auth_user/models/auth_user_blocked_exception.dart' as _i2;
import 'auth_user/models/auth_user_model.dart' as _i3;
import 'auth_user/models/auth_user_not_found_exception.dart' as _i4;
import 'common/models/auth_strategy.dart' as _i5;
import 'common/models/auth_success.dart' as _i6;
import 'jwt/models/authentication_token_info.dart' as _i7;
import 'jwt/models/refresh_token_expired_exception.dart' as _i8;
import 'jwt/models/refresh_token_invalid_secret_exception.dart' as _i9;
import 'jwt/models/refresh_token_malformed_exception.dart' as _i10;
import 'jwt/models/refresh_token_not_found_exception.dart' as _i11;
import 'jwt/models/token_pair.dart' as _i12;
import 'profile/models/user_profile_model.dart' as _i13;
import 'session/models/auth_session_info.dart' as _i14;
export 'auth_user/models/auth_user_blocked_exception.dart';
export 'auth_user/models/auth_user_model.dart';
export 'auth_user/models/auth_user_not_found_exception.dart';
export 'common/models/auth_strategy.dart';
export 'common/models/auth_success.dart';
export 'jwt/models/authentication_token_info.dart';
export 'jwt/models/refresh_token_expired_exception.dart';
export 'jwt/models/refresh_token_invalid_secret_exception.dart';
export 'jwt/models/refresh_token_malformed_exception.dart';
export 'jwt/models/refresh_token_not_found_exception.dart';
export 'jwt/models/token_pair.dart';
export 'profile/models/user_profile_model.dart';
export 'session/models/auth_session_info.dart';
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
    if (t == _i2.AuthUserBlockedException) {
      return _i2.AuthUserBlockedException.fromJson(data) as T;
    }
    if (t == _i3.AuthUserModel) {
      return _i3.AuthUserModel.fromJson(data) as T;
    }
    if (t == _i4.AuthUserNotFoundException) {
      return _i4.AuthUserNotFoundException.fromJson(data) as T;
    }
    if (t == _i5.AuthStrategy) {
      return _i5.AuthStrategy.fromJson(data) as T;
    }
    if (t == _i6.AuthSuccess) {
      return _i6.AuthSuccess.fromJson(data) as T;
    }
    if (t == _i7.AuthenticationTokenInfo) {
      return _i7.AuthenticationTokenInfo.fromJson(data) as T;
    }
    if (t == _i8.RefreshTokenExpiredException) {
      return _i8.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i9.RefreshTokenInvalidSecretException) {
      return _i9.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i10.RefreshTokenMalformedException) {
      return _i10.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i11.RefreshTokenNotFoundException) {
      return _i11.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i12.TokenPair) {
      return _i12.TokenPair.fromJson(data) as T;
    }
    if (t == _i13.UserProfileModel) {
      return _i13.UserProfileModel.fromJson(data) as T;
    }
    if (t == _i14.AuthSessionInfo) {
      return _i14.AuthSessionInfo.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthUserBlockedException?>()) {
      return (data != null ? _i2.AuthUserBlockedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.AuthUserModel?>()) {
      return (data != null ? _i3.AuthUserModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthUserNotFoundException?>()) {
      return (data != null
          ? _i4.AuthUserNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.AuthStrategy?>()) {
      return (data != null ? _i5.AuthStrategy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AuthSuccess?>()) {
      return (data != null ? _i6.AuthSuccess.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AuthenticationTokenInfo?>()) {
      return (data != null ? _i7.AuthenticationTokenInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.RefreshTokenExpiredException?>()) {
      return (data != null
          ? _i8.RefreshTokenExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.RefreshTokenInvalidSecretException?>()) {
      return (data != null
          ? _i9.RefreshTokenInvalidSecretException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.RefreshTokenMalformedException?>()) {
      return (data != null
          ? _i10.RefreshTokenMalformedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.RefreshTokenNotFoundException?>()) {
      return (data != null
          ? _i11.RefreshTokenNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.TokenPair?>()) {
      return (data != null ? _i12.TokenPair.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.UserProfileModel?>()) {
      return (data != null ? _i13.UserProfileModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AuthSessionInfo?>()) {
      return (data != null ? _i14.AuthSessionInfo.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.AuthUserBlockedException():
        return 'AuthUserBlockedException';
      case _i3.AuthUserModel():
        return 'AuthUserModel';
      case _i4.AuthUserNotFoundException():
        return 'AuthUserNotFoundException';
      case _i5.AuthStrategy():
        return 'AuthStrategy';
      case _i6.AuthSuccess():
        return 'AuthSuccess';
      case _i7.AuthenticationTokenInfo():
        return 'AuthenticationTokenInfo';
      case _i8.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _i9.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i10.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _i11.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i12.TokenPair():
        return 'TokenPair';
      case _i13.UserProfileModel():
        return 'UserProfileModel';
      case _i14.AuthSessionInfo():
        return 'AuthSessionInfo';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthUserBlockedException') {
      return deserialize<_i2.AuthUserBlockedException>(data['data']);
    }
    if (dataClassName == 'AuthUserModel') {
      return deserialize<_i3.AuthUserModel>(data['data']);
    }
    if (dataClassName == 'AuthUserNotFoundException') {
      return deserialize<_i4.AuthUserNotFoundException>(data['data']);
    }
    if (dataClassName == 'AuthStrategy') {
      return deserialize<_i5.AuthStrategy>(data['data']);
    }
    if (dataClassName == 'AuthSuccess') {
      return deserialize<_i6.AuthSuccess>(data['data']);
    }
    if (dataClassName == 'AuthenticationTokenInfo') {
      return deserialize<_i7.AuthenticationTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i8.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i9.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i10.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i11.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i12.TokenPair>(data['data']);
    }
    if (dataClassName == 'UserProfileModel') {
      return deserialize<_i13.UserProfileModel>(data['data']);
    }
    if (dataClassName == 'AuthSessionInfo') {
      return deserialize<_i14.AuthSessionInfo>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
