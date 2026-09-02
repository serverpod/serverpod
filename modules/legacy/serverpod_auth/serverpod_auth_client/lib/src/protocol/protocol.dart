/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'apple_auth_info.dart' as _iy492fk4;
import 'auth_key.dart' as _i8lzboul;
import 'authentication_fail_reason.dart' as _ika0ufek;
import 'authentication_response.dart' as _i6gspdjt;
import 'email_auth.dart' as _il95bqq6;
import 'email_create_account_request.dart' as _ilnsxyj8;
import 'email_failed_sign_in.dart' as _iaz0raab;
import 'email_password_reset.dart' as _iiusgova;
import 'email_reset.dart' as _ifm8n60r;
import 'google_refresh_token.dart' as _is585jau;
import 'user_image.dart' as _i0mx5j5p;
import 'user_info.dart' as _iliwsvmu;
import 'user_info_public.dart' as _iabwsxht;
import 'user_settings_config.dart' as _i5rdiffu;
export 'apple_auth_info.dart';
export 'auth_key.dart';
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
export 'user_info_public.dart';
export 'user_settings_config.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_isc.SerializationManager> _hostProtocols = {};

  void registerHostProtocol(
    String projectName,
    _isc.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_auth.')) return className;
    return className.substring(15);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iy492fk4.AppleAuthInfo) {
      return _iy492fk4.AppleAuthInfo.fromJson(data) as T;
    }
    if (t == _i8lzboul.AuthKey) {
      return _i8lzboul.AuthKey.fromJson(data) as T;
    }
    if (t == _ika0ufek.AuthenticationFailReason) {
      return _ika0ufek.AuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i6gspdjt.AuthenticationResponse) {
      return _i6gspdjt.AuthenticationResponse.fromJson(data) as T;
    }
    if (t == _il95bqq6.EmailAuth) {
      return _il95bqq6.EmailAuth.fromJson(data) as T;
    }
    if (t == _ilnsxyj8.EmailCreateAccountRequest) {
      return _ilnsxyj8.EmailCreateAccountRequest.fromJson(data) as T;
    }
    if (t == _iaz0raab.EmailFailedSignIn) {
      return _iaz0raab.EmailFailedSignIn.fromJson(data) as T;
    }
    if (t == _iiusgova.EmailPasswordReset) {
      return _iiusgova.EmailPasswordReset.fromJson(data) as T;
    }
    if (t == _ifm8n60r.EmailReset) {
      return _ifm8n60r.EmailReset.fromJson(data) as T;
    }
    if (t == _is585jau.GoogleRefreshToken) {
      return _is585jau.GoogleRefreshToken.fromJson(data) as T;
    }
    if (t == _i0mx5j5p.UserImage) {
      return _i0mx5j5p.UserImage.fromJson(data) as T;
    }
    if (t == _iliwsvmu.UserInfo) {
      return _iliwsvmu.UserInfo.fromJson(data) as T;
    }
    if (t == _iabwsxht.UserInfoPublic) {
      return _iabwsxht.UserInfoPublic.fromJson(data) as T;
    }
    if (t == _i5rdiffu.UserSettingsConfig) {
      return _i5rdiffu.UserSettingsConfig.fromJson(data) as T;
    }
    if (t == _isc.getType<_iy492fk4.AppleAuthInfo?>()) {
      return (data != null ? _iy492fk4.AppleAuthInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8lzboul.AuthKey?>()) {
      return (data != null ? _i8lzboul.AuthKey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ika0ufek.AuthenticationFailReason?>()) {
      return (data != null
              ? _ika0ufek.AuthenticationFailReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6gspdjt.AuthenticationResponse?>()) {
      return (data != null
              ? _i6gspdjt.AuthenticationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_il95bqq6.EmailAuth?>()) {
      return (data != null ? _il95bqq6.EmailAuth.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilnsxyj8.EmailCreateAccountRequest?>()) {
      return (data != null
              ? _ilnsxyj8.EmailCreateAccountRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iaz0raab.EmailFailedSignIn?>()) {
      return (data != null ? _iaz0raab.EmailFailedSignIn.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iiusgova.EmailPasswordReset?>()) {
      return (data != null ? _iiusgova.EmailPasswordReset.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifm8n60r.EmailReset?>()) {
      return (data != null ? _ifm8n60r.EmailReset.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is585jau.GoogleRefreshToken?>()) {
      return (data != null ? _is585jau.GoogleRefreshToken.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0mx5j5p.UserImage?>()) {
      return (data != null ? _i0mx5j5p.UserImage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iliwsvmu.UserInfo?>()) {
      return (data != null ? _iliwsvmu.UserInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iabwsxht.UserInfoPublic?>()) {
      return (data != null ? _iabwsxht.UserInfoPublic.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i5rdiffu.UserSettingsConfig?>()) {
      return (data != null ? _i5rdiffu.UserSettingsConfig.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iy492fk4.AppleAuthInfo => 'AppleAuthInfo',
      _i8lzboul.AuthKey => 'AuthKey',
      _ika0ufek.AuthenticationFailReason => 'AuthenticationFailReason',
      _i6gspdjt.AuthenticationResponse => 'AuthenticationResponse',
      _il95bqq6.EmailAuth => 'EmailAuth',
      _ilnsxyj8.EmailCreateAccountRequest => 'EmailCreateAccountRequest',
      _iaz0raab.EmailFailedSignIn => 'EmailFailedSignIn',
      _iiusgova.EmailPasswordReset => 'EmailPasswordReset',
      _ifm8n60r.EmailReset => 'EmailReset',
      _is585jau.GoogleRefreshToken => 'GoogleRefreshToken',
      _i0mx5j5p.UserImage => 'UserImage',
      _iliwsvmu.UserInfo => 'UserInfo',
      _iabwsxht.UserInfoPublic => 'UserInfoPublic',
      _i5rdiffu.UserSettingsConfig => 'UserSettingsConfig',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_auth.',
        '',
      );
    }

    switch (data) {
      case _iy492fk4.AppleAuthInfo():
        return 'AppleAuthInfo';
      case _i8lzboul.AuthKey():
        return 'AuthKey';
      case _ika0ufek.AuthenticationFailReason():
        return 'AuthenticationFailReason';
      case _i6gspdjt.AuthenticationResponse():
        return 'AuthenticationResponse';
      case _il95bqq6.EmailAuth():
        return 'EmailAuth';
      case _ilnsxyj8.EmailCreateAccountRequest():
        return 'EmailCreateAccountRequest';
      case _iaz0raab.EmailFailedSignIn():
        return 'EmailFailedSignIn';
      case _iiusgova.EmailPasswordReset():
        return 'EmailPasswordReset';
      case _ifm8n60r.EmailReset():
        return 'EmailReset';
      case _is585jau.GoogleRefreshToken():
        return 'GoogleRefreshToken';
      case _i0mx5j5p.UserImage():
        return 'UserImage';
      case _iliwsvmu.UserInfo():
        return 'UserInfo';
      case _iabwsxht.UserInfoPublic():
        return 'UserInfoPublic';
      case _i5rdiffu.UserSettingsConfig():
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
      return deserialize<_iy492fk4.AppleAuthInfo>(data['data']);
    }
    if (dataClassName == 'AuthKey') {
      return deserialize<_i8lzboul.AuthKey>(data['data']);
    }
    if (dataClassName == 'AuthenticationFailReason') {
      return deserialize<_ika0ufek.AuthenticationFailReason>(data['data']);
    }
    if (dataClassName == 'AuthenticationResponse') {
      return deserialize<_i6gspdjt.AuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'EmailAuth') {
      return deserialize<_il95bqq6.EmailAuth>(data['data']);
    }
    if (dataClassName == 'EmailCreateAccountRequest') {
      return deserialize<_ilnsxyj8.EmailCreateAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailFailedSignIn') {
      return deserialize<_iaz0raab.EmailFailedSignIn>(data['data']);
    }
    if (dataClassName == 'EmailPasswordReset') {
      return deserialize<_iiusgova.EmailPasswordReset>(data['data']);
    }
    if (dataClassName == 'EmailReset') {
      return deserialize<_ifm8n60r.EmailReset>(data['data']);
    }
    if (dataClassName == 'GoogleRefreshToken') {
      return deserialize<_is585jau.GoogleRefreshToken>(data['data']);
    }
    if (dataClassName == 'UserImage') {
      return deserialize<_i0mx5j5p.UserImage>(data['data']);
    }
    if (dataClassName == 'UserInfo') {
      return deserialize<_iliwsvmu.UserInfo>(data['data']);
    }
    if (dataClassName == 'UserInfoPublic') {
      return deserialize<_iabwsxht.UserInfoPublic>(data['data']);
    }
    if (dataClassName == 'UserSettingsConfig') {
      return deserialize<_i5rdiffu.UserSettingsConfig>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _isc.SerializationManager.toEncodableForProtocol(wrapped)
          : _isc.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on _isc.DeserializationClassNameNotFoundException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  String getModuleName() => 'serverpod_auth';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
