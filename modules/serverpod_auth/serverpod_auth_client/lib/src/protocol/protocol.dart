/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'apple_auth_info.dart' as _i2;
import 'authentication_fail_reason.dart' as _i3;
import 'authentication_response.dart' as _i4;
import 'email_auth.dart' as _i5;
import 'email_create_account_request.dart' as _i6;
import 'email_failed_sign_in.dart' as _i7;
import 'email_password_reset.dart' as _i8;
import 'email_reset.dart' as _i9;
import 'google_refresh_token.dart' as _i10;
import 'user_image.dart' as _i11;
import 'user_info.dart' as _i12;
import 'user_settings_config.dart' as _i13;
export 'apple_auth_info.dart';
export 'authentication_fail_reason.dart';
export 'authentication_response.dart';
export 'email_auth.dart';
export 'email_create_account_request.dart';
export 'email_failed_sign_in.dart';
export 'email_password_reset.dart';
export 'email_reset.dart';
export 'google_refresh_token.dart';
export 'user_image.dart';
export 'user_info.dart';
export 'user_settings_config.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.AppleAuthInfo) {
      return _i2.AppleAuthInfo.fromJson(data, this) as T;
    }
    if (t == _i3.AuthenticationFailReason) {
      return _i3.AuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i4.AuthenticationResponse) {
      return _i4.AuthenticationResponse.fromJson(data, this) as T;
    }
    if (t == _i5.EmailAuth) {
      return _i5.EmailAuth.fromJson(data, this) as T;
    }
    if (t == _i6.EmailCreateAccountRequest) {
      return _i6.EmailCreateAccountRequest.fromJson(data, this) as T;
    }
    if (t == _i7.EmailFailedSignIn) {
      return _i7.EmailFailedSignIn.fromJson(data, this) as T;
    }
    if (t == _i8.EmailPasswordReset) {
      return _i8.EmailPasswordReset.fromJson(data, this) as T;
    }
    if (t == _i9.EmailReset) {
      return _i9.EmailReset.fromJson(data, this) as T;
    }
    if (t == _i10.GoogleRefreshToken) {
      return _i10.GoogleRefreshToken.fromJson(data, this) as T;
    }
    if (t == _i11.UserImage) {
      return _i11.UserImage.fromJson(data, this) as T;
    }
    if (t == _i12.UserInfo) {
      return _i12.UserInfo.fromJson(data, this) as T;
    }
    if (t == _i13.UserSettingsConfig) {
      return _i13.UserSettingsConfig.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.AppleAuthInfo?>()) {
      return (data != null ? _i2.AppleAuthInfo.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i3.AuthenticationFailReason?>()) {
      return (data != null ? _i3.AuthenticationFailReason.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.AuthenticationResponse?>()) {
      return (data != null
          ? _i4.AuthenticationResponse.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i5.EmailAuth?>()) {
      return (data != null ? _i5.EmailAuth.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.EmailCreateAccountRequest?>()) {
      return (data != null
          ? _i6.EmailCreateAccountRequest.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailFailedSignIn?>()) {
      return (data != null ? _i7.EmailFailedSignIn.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.EmailPasswordReset?>()) {
      return (data != null ? _i8.EmailPasswordReset.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.EmailReset?>()) {
      return (data != null ? _i9.EmailReset.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i10.GoogleRefreshToken?>()) {
      return (data != null
          ? _i10.GoogleRefreshToken.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i11.UserImage?>()) {
      return (data != null ? _i11.UserImage.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i12.UserInfo?>()) {
      return (data != null ? _i12.UserInfo.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i13.UserSettingsConfig?>()) {
      return (data != null
          ? _i13.UserSettingsConfig.fromJson(data, this)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i2.AppleAuthInfo) {
      return 'AppleAuthInfo';
    }
    if (data is _i3.AuthenticationFailReason) {
      return 'AuthenticationFailReason';
    }
    if (data is _i4.AuthenticationResponse) {
      return 'AuthenticationResponse';
    }
    if (data is _i5.EmailAuth) {
      return 'EmailAuth';
    }
    if (data is _i6.EmailCreateAccountRequest) {
      return 'EmailCreateAccountRequest';
    }
    if (data is _i7.EmailFailedSignIn) {
      return 'EmailFailedSignIn';
    }
    if (data is _i8.EmailPasswordReset) {
      return 'EmailPasswordReset';
    }
    if (data is _i9.EmailReset) {
      return 'EmailReset';
    }
    if (data is _i10.GoogleRefreshToken) {
      return 'GoogleRefreshToken';
    }
    if (data is _i11.UserImage) {
      return 'UserImage';
    }
    if (data is _i12.UserInfo) {
      return 'UserInfo';
    }
    if (data is _i13.UserSettingsConfig) {
      return 'UserSettingsConfig';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'AppleAuthInfo') {
      return deserialize<_i2.AppleAuthInfo>(data['data']);
    }
    if (data['className'] == 'AuthenticationFailReason') {
      return deserialize<_i3.AuthenticationFailReason>(data['data']);
    }
    if (data['className'] == 'AuthenticationResponse') {
      return deserialize<_i4.AuthenticationResponse>(data['data']);
    }
    if (data['className'] == 'EmailAuth') {
      return deserialize<_i5.EmailAuth>(data['data']);
    }
    if (data['className'] == 'EmailCreateAccountRequest') {
      return deserialize<_i6.EmailCreateAccountRequest>(data['data']);
    }
    if (data['className'] == 'EmailFailedSignIn') {
      return deserialize<_i7.EmailFailedSignIn>(data['data']);
    }
    if (data['className'] == 'EmailPasswordReset') {
      return deserialize<_i8.EmailPasswordReset>(data['data']);
    }
    if (data['className'] == 'EmailReset') {
      return deserialize<_i9.EmailReset>(data['data']);
    }
    if (data['className'] == 'GoogleRefreshToken') {
      return deserialize<_i10.GoogleRefreshToken>(data['data']);
    }
    if (data['className'] == 'UserImage') {
      return deserialize<_i11.UserImage>(data['data']);
    }
    if (data['className'] == 'UserInfo') {
      return deserialize<_i12.UserInfo>(data['data']);
    }
    if (data['className'] == 'UserSettingsConfig') {
      return deserialize<_i13.UserSettingsConfig>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
