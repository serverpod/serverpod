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
import 'auth_user/models/auth_user.dart' as _i2;
import 'auth_user/models/auth_user_blocked_exception.dart' as _i3;
import 'auth_user/models/auth_user_model.dart' as _i4;
import 'auth_user/models/auth_user_not_found_exception.dart' as _i5;
import 'common/models/auth_strategy.dart' as _i6;
import 'common/models/auth_success.dart' as _i7;
import 'jwt/models/jwt_token_info.dart' as _i8;
import 'jwt/models/refresh_token_expired_exception.dart' as _i9;
import 'jwt/models/refresh_token_invalid_secret_exception.dart' as _i10;
import 'jwt/models/refresh_token_malformed_exception.dart' as _i11;
import 'jwt/models/refresh_token_not_found_exception.dart' as _i12;
import 'jwt/models/token_pair.dart' as _i13;
import 'profile/models/user_profile.dart' as _i14;
import 'profile/models/user_profile_data.dart' as _i15;
import 'profile/models/user_profile_image.dart' as _i16;
import 'profile/models/user_profile_model.dart' as _i17;
import 'session/models/server_side_session_info.dart' as _i18;
export 'auth_user/models/auth_user.dart';
export 'auth_user/models/auth_user_blocked_exception.dart';
export 'auth_user/models/auth_user_model.dart';
export 'auth_user/models/auth_user_not_found_exception.dart';
export 'common/models/auth_strategy.dart';
export 'common/models/auth_success.dart';
export 'jwt/models/jwt_token_info.dart';
export 'jwt/models/refresh_token_expired_exception.dart';
export 'jwt/models/refresh_token_invalid_secret_exception.dart';
export 'jwt/models/refresh_token_malformed_exception.dart';
export 'jwt/models/refresh_token_not_found_exception.dart';
export 'jwt/models/token_pair.dart';
export 'profile/models/user_profile.dart';
export 'profile/models/user_profile_data.dart';
export 'profile/models/user_profile_image.dart';
export 'profile/models/user_profile_model.dart';
export 'session/models/server_side_session_info.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_auth_core.')) return className;
    return className.substring(20);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != t.toString()) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AuthUser) {
      return _i2.AuthUser.fromJson(data) as T;
    }
    if (t == _i3.AuthUserBlockedException) {
      return _i3.AuthUserBlockedException.fromJson(data) as T;
    }
    if (t == _i4.AuthUserModel) {
      return _i4.AuthUserModel.fromJson(data) as T;
    }
    if (t == _i5.AuthUserNotFoundException) {
      return _i5.AuthUserNotFoundException.fromJson(data) as T;
    }
    if (t == _i6.AuthStrategy) {
      return _i6.AuthStrategy.fromJson(data) as T;
    }
    if (t == _i7.AuthSuccess) {
      return _i7.AuthSuccess.fromJson(data) as T;
    }
    if (t == _i8.JwtTokenInfo) {
      return _i8.JwtTokenInfo.fromJson(data) as T;
    }
    if (t == _i9.RefreshTokenExpiredException) {
      return _i9.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i10.RefreshTokenInvalidSecretException) {
      return _i10.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i11.RefreshTokenMalformedException) {
      return _i11.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i12.RefreshTokenNotFoundException) {
      return _i12.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i13.TokenPair) {
      return _i13.TokenPair.fromJson(data) as T;
    }
    if (t == _i14.UserProfile) {
      return _i14.UserProfile.fromJson(data) as T;
    }
    if (t == _i15.UserProfileData) {
      return _i15.UserProfileData.fromJson(data) as T;
    }
    if (t == _i16.UserProfileImage) {
      return _i16.UserProfileImage.fromJson(data) as T;
    }
    if (t == _i17.UserProfileModel) {
      return _i17.UserProfileModel.fromJson(data) as T;
    }
    if (t == _i18.ServerSideSessionInfo) {
      return _i18.ServerSideSessionInfo.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthUser?>()) {
      return (data != null ? _i2.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AuthUserBlockedException?>()) {
      return (data != null ? _i3.AuthUserBlockedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.AuthUserModel?>()) {
      return (data != null ? _i4.AuthUserModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthUserNotFoundException?>()) {
      return (data != null
              ? _i5.AuthUserNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.AuthStrategy?>()) {
      return (data != null ? _i6.AuthStrategy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AuthSuccess?>()) {
      return (data != null ? _i7.AuthSuccess.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.JwtTokenInfo?>()) {
      return (data != null ? _i8.JwtTokenInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.RefreshTokenExpiredException?>()) {
      return (data != null
              ? _i9.RefreshTokenExpiredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.RefreshTokenInvalidSecretException?>()) {
      return (data != null
              ? _i10.RefreshTokenInvalidSecretException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.RefreshTokenMalformedException?>()) {
      return (data != null
              ? _i11.RefreshTokenMalformedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.RefreshTokenNotFoundException?>()) {
      return (data != null
              ? _i12.RefreshTokenNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.TokenPair?>()) {
      return (data != null ? _i13.TokenPair.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserProfile?>()) {
      return (data != null ? _i14.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.UserProfileData?>()) {
      return (data != null ? _i15.UserProfileData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserProfileImage?>()) {
      return (data != null ? _i16.UserProfileImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserProfileModel?>()) {
      return (data != null ? _i17.UserProfileModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ServerSideSessionInfo?>()) {
      return (data != null ? _i18.ServerSideSessionInfo.fromJson(data) : null)
          as T;
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

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_auth_core.',
        '',
      );
    }

    switch (data) {
      case _i2.AuthUser():
        return 'AuthUser';
      case _i3.AuthUserBlockedException():
        return 'AuthUserBlockedException';
      case _i4.AuthUserModel():
        return 'AuthUserModel';
      case _i5.AuthUserNotFoundException():
        return 'AuthUserNotFoundException';
      case _i6.AuthStrategy():
        return 'AuthStrategy';
      case _i7.AuthSuccess():
        return 'AuthSuccess';
      case _i8.JwtTokenInfo():
        return 'JwtTokenInfo';
      case _i9.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _i10.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i11.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _i12.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i13.TokenPair():
        return 'TokenPair';
      case _i14.UserProfile():
        return 'UserProfile';
      case _i15.UserProfileData():
        return 'UserProfileData';
      case _i16.UserProfileImage():
        return 'UserProfileImage';
      case _i17.UserProfileModel():
        return 'UserProfileModel';
      case _i18.ServerSideSessionInfo():
        return 'ServerSideSessionInfo';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthUser') {
      return deserialize<_i2.AuthUser>(data['data']);
    }
    if (dataClassName == 'AuthUserBlockedException') {
      return deserialize<_i3.AuthUserBlockedException>(data['data']);
    }
    if (dataClassName == 'AuthUserModel') {
      return deserialize<_i4.AuthUserModel>(data['data']);
    }
    if (dataClassName == 'AuthUserNotFoundException') {
      return deserialize<_i5.AuthUserNotFoundException>(data['data']);
    }
    if (dataClassName == 'AuthStrategy') {
      return deserialize<_i6.AuthStrategy>(data['data']);
    }
    if (dataClassName == 'AuthSuccess') {
      return deserialize<_i7.AuthSuccess>(data['data']);
    }
    if (dataClassName == 'JwtTokenInfo') {
      return deserialize<_i8.JwtTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i9.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i10.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i11.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i12.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i13.TokenPair>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i14.UserProfile>(data['data']);
    }
    if (dataClassName == 'UserProfileData') {
      return deserialize<_i15.UserProfileData>(data['data']);
    }
    if (dataClassName == 'UserProfileImage') {
      return deserialize<_i16.UserProfileImage>(data['data']);
    }
    if (dataClassName == 'UserProfileModel') {
      return deserialize<_i17.UserProfileModel>(data['data']);
    }
    if (dataClassName == 'ServerSideSessionInfo') {
      return deserialize<_i18.ServerSideSessionInfo>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
