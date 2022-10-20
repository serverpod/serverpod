/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

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
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.AppleAuthInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i2.AppleAuthInfo.fromJson(jsonSerialization, serializationManager),
    _i3.AuthenticationFailReason:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i3.AuthenticationFailReason.fromJson(jsonSerialization),
    _i4.AuthenticationResponse:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i4.AuthenticationResponse.fromJson(
                jsonSerialization, serializationManager),
    _i5.EmailAuth:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i5.EmailAuth.fromJson(jsonSerialization, serializationManager),
    _i6.EmailCreateAccountRequest:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i6.EmailCreateAccountRequest.fromJson(
                jsonSerialization, serializationManager),
    _i7.EmailFailedSignIn: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i7.EmailFailedSignIn.fromJson(jsonSerialization, serializationManager),
    _i8.EmailPasswordReset:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i8.EmailPasswordReset.fromJson(
                jsonSerialization, serializationManager),
    _i9.EmailReset:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i9.EmailReset.fromJson(jsonSerialization, serializationManager),
    _i10.GoogleRefreshToken:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i10.GoogleRefreshToken.fromJson(
                jsonSerialization, serializationManager),
    _i11.UserImage:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i11.UserImage.fromJson(jsonSerialization, serializationManager),
    _i12.UserInfo:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i12.UserInfo.fromJson(jsonSerialization, serializationManager),
    _i13.UserSettingsConfig:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i13.UserSettingsConfig.fromJson(
                jsonSerialization, serializationManager),
    _i1.getType<_i2.AppleAuthInfo?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i2.AppleAuthInfo.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i3.AuthenticationFailReason?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i3.AuthenticationFailReason.fromJson(jsonSerialization)
                : null,
    _i1.getType<_i4.AuthenticationResponse?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i4.AuthenticationResponse.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i5.EmailAuth?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i5.EmailAuth.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i6.EmailCreateAccountRequest?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i6.EmailCreateAccountRequest.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i7.EmailFailedSignIn?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i7.EmailFailedSignIn.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i8.EmailPasswordReset?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i8.EmailPasswordReset.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i9.EmailReset?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i9.EmailReset.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i10.GoogleRefreshToken?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i10.GoogleRefreshToken.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i11.UserImage?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i11.UserImage.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i12.UserInfo?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i12.UserInfo.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i13.UserSettingsConfig?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i13.UserSettingsConfig.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    List<String>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<String>(e))
                .toList(),
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};
}
