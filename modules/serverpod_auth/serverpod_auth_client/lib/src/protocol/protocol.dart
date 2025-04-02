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
import 'apple_auth_info.dart' as _i2;
import 'auth_key.dart' as _i3;
import 'authentication_fail_reason.dart' as _i4;
import 'authentication_response.dart' as _i5;
import 'google_refresh_token.dart' as _i6;
import 'user_image.dart' as _i7;
import 'user_info.dart' as _i8;
import 'user_info_public.dart' as _i9;
import 'user_settings_config.dart' as _i10;
export 'apple_auth_info.dart';
export 'auth_key.dart';
export 'authentication_fail_reason.dart';
export 'authentication_response.dart';
export 'google_refresh_token.dart';
export 'user_image.dart';
export 'user_info.dart';
export 'user_info_public.dart';
export 'user_settings_config.dart';
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
    if (t == _i2.AppleAuthInfo) {
      return _i2.AppleAuthInfo.fromJson(data) as T;
    }
    if (t == _i3.AuthKey) {
      return _i3.AuthKey.fromJson(data) as T;
    }
    if (t == _i4.AuthenticationFailReason) {
      return _i4.AuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i5.AuthenticationResponse) {
      return _i5.AuthenticationResponse.fromJson(data) as T;
    }
    if (t == _i6.GoogleRefreshToken) {
      return _i6.GoogleRefreshToken.fromJson(data) as T;
    }
    if (t == _i7.UserImage) {
      return _i7.UserImage.fromJson(data) as T;
    }
    if (t == _i8.UserInfo) {
      return _i8.UserInfo.fromJson(data) as T;
    }
    if (t == _i9.UserInfoPublic) {
      return _i9.UserInfoPublic.fromJson(data) as T;
    }
    if (t == _i10.UserSettingsConfig) {
      return _i10.UserSettingsConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AppleAuthInfo?>()) {
      return (data != null ? _i2.AppleAuthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AuthKey?>()) {
      return (data != null ? _i3.AuthKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthenticationFailReason?>()) {
      return (data != null ? _i4.AuthenticationFailReason.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AuthenticationResponse?>()) {
      return (data != null ? _i5.AuthenticationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.GoogleRefreshToken?>()) {
      return (data != null ? _i6.GoogleRefreshToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.UserImage?>()) {
      return (data != null ? _i7.UserImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.UserInfo?>()) {
      return (data != null ? _i8.UserInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserInfoPublic?>()) {
      return (data != null ? _i9.UserInfoPublic.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UserSettingsConfig?>()) {
      return (data != null ? _i10.UserSettingsConfig.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.AppleAuthInfo) {
      return 'AppleAuthInfo';
    }
    if (data is _i3.AuthKey) {
      return 'AuthKey';
    }
    if (data is _i4.AuthenticationFailReason) {
      return 'AuthenticationFailReason';
    }
    if (data is _i5.AuthenticationResponse) {
      return 'AuthenticationResponse';
    }
    if (data is _i6.GoogleRefreshToken) {
      return 'GoogleRefreshToken';
    }
    if (data is _i7.UserImage) {
      return 'UserImage';
    }
    if (data is _i8.UserInfo) {
      return 'UserInfo';
    }
    if (data is _i9.UserInfoPublic) {
      return 'UserInfoPublic';
    }
    if (data is _i10.UserSettingsConfig) {
      return 'UserSettingsConfig';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppleAuthInfo') {
      return deserialize<_i2.AppleAuthInfo>(data['data']);
    }
    if (dataClassName == 'AuthKey') {
      return deserialize<_i3.AuthKey>(data['data']);
    }
    if (dataClassName == 'AuthenticationFailReason') {
      return deserialize<_i4.AuthenticationFailReason>(data['data']);
    }
    if (dataClassName == 'AuthenticationResponse') {
      return deserialize<_i5.AuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'GoogleRefreshToken') {
      return deserialize<_i6.GoogleRefreshToken>(data['data']);
    }
    if (dataClassName == 'UserImage') {
      return deserialize<_i7.UserImage>(data['data']);
    }
    if (dataClassName == 'UserInfo') {
      return deserialize<_i8.UserInfo>(data['data']);
    }
    if (dataClassName == 'UserInfoPublic') {
      return deserialize<_i9.UserInfoPublic>(data['data']);
    }
    if (dataClassName == 'UserSettingsConfig') {
      return deserialize<_i10.UserSettingsConfig>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
