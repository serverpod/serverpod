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
import 'apple_auth_info.dart' as _i2;
import 'auth_key.dart' as _i3;
import 'authentication_fail_reason.dart' as _i4;
import 'authentication_response.dart' as _i5;
import 'email_auth.dart' as _i6;
import 'email_create_account_request.dart' as _i7;
import 'email_failed_sign_in.dart' as _i8;
import 'email_password_reset.dart' as _i9;
import 'email_reset.dart' as _i10;
import 'google_refresh_token.dart' as _i11;
import 'user_image.dart' as _i12;
import 'user_info.dart' as _i13;
import 'user_info_public.dart' as _i14;
import 'user_settings_config.dart' as _i15;
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

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_i1.SerializationManager> _hostProtocols = {};

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i2.AppleAuthInfo] = (data, protocol) =>
        _i2.AppleAuthInfo.fromJson(data);
    map[_i3.AuthKey] = (data, protocol) => _i3.AuthKey.fromJson(data);
    map[_i4.AuthenticationFailReason] = (data, protocol) =>
        _i4.AuthenticationFailReason.fromJson(data);
    map[_i5.AuthenticationResponse] = (data, protocol) =>
        _i5.AuthenticationResponse.fromJson(data);
    map[_i6.EmailAuth] = (data, protocol) => _i6.EmailAuth.fromJson(data);
    map[_i7.EmailCreateAccountRequest] = (data, protocol) =>
        _i7.EmailCreateAccountRequest.fromJson(data);
    map[_i8.EmailFailedSignIn] = (data, protocol) =>
        _i8.EmailFailedSignIn.fromJson(data);
    map[_i9.EmailPasswordReset] = (data, protocol) =>
        _i9.EmailPasswordReset.fromJson(data);
    map[_i10.EmailReset] = (data, protocol) => _i10.EmailReset.fromJson(data);
    map[_i11.GoogleRefreshToken] = (data, protocol) =>
        _i11.GoogleRefreshToken.fromJson(data);
    map[_i12.UserImage] = (data, protocol) => _i12.UserImage.fromJson(data);
    map[_i13.UserInfo] = (data, protocol) => _i13.UserInfo.fromJson(data);
    map[_i14.UserInfoPublic] = (data, protocol) =>
        _i14.UserInfoPublic.fromJson(data);
    map[_i15.UserSettingsConfig] = (data, protocol) =>
        _i15.UserSettingsConfig.fromJson(data);
    map[_i1.getType<_i2.AppleAuthInfo?>()] = (data, protocol) =>
        (data != null ? _i2.AppleAuthInfo.fromJson(data) : null);
    map[_i1.getType<_i3.AuthKey?>()] = (data, protocol) =>
        (data != null ? _i3.AuthKey.fromJson(data) : null);
    map[_i1.getType<_i4.AuthenticationFailReason?>()] = (data, protocol) =>
        (data != null ? _i4.AuthenticationFailReason.fromJson(data) : null);
    map[_i1.getType<_i5.AuthenticationResponse?>()] = (data, protocol) =>
        (data != null ? _i5.AuthenticationResponse.fromJson(data) : null);
    map[_i1.getType<_i6.EmailAuth?>()] = (data, protocol) =>
        (data != null ? _i6.EmailAuth.fromJson(data) : null);
    map[_i1.getType<_i7.EmailCreateAccountRequest?>()] = (data, protocol) =>
        (data != null ? _i7.EmailCreateAccountRequest.fromJson(data) : null);
    map[_i1.getType<_i8.EmailFailedSignIn?>()] = (data, protocol) =>
        (data != null ? _i8.EmailFailedSignIn.fromJson(data) : null);
    map[_i1.getType<_i9.EmailPasswordReset?>()] = (data, protocol) =>
        (data != null ? _i9.EmailPasswordReset.fromJson(data) : null);
    map[_i1.getType<_i10.EmailReset?>()] = (data, protocol) =>
        (data != null ? _i10.EmailReset.fromJson(data) : null);
    map[_i1.getType<_i11.GoogleRefreshToken?>()] = (data, protocol) =>
        (data != null ? _i11.GoogleRefreshToken.fromJson(data) : null);
    map[_i1.getType<_i12.UserImage?>()] = (data, protocol) =>
        (data != null ? _i12.UserImage.fromJson(data) : null);
    map[_i1.getType<_i13.UserInfo?>()] = (data, protocol) =>
        (data != null ? _i13.UserInfo.fromJson(data) : null);
    map[_i1.getType<_i14.UserInfoPublic?>()] = (data, protocol) =>
        (data != null ? _i14.UserInfoPublic.fromJson(data) : null);
    map[_i1.getType<_i15.UserSettingsConfig?>()] = (data, protocol) =>
        (data != null ? _i15.UserSettingsConfig.fromJson(data) : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    return map;
  }

  void registerHostProtocol(
    String projectName,
    _i1.SerializationManager protocol,
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
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AppleAuthInfo => 'AppleAuthInfo',
      _i3.AuthKey => 'AuthKey',
      _i4.AuthenticationFailReason => 'AuthenticationFailReason',
      _i5.AuthenticationResponse => 'AuthenticationResponse',
      _i6.EmailAuth => 'EmailAuth',
      _i7.EmailCreateAccountRequest => 'EmailCreateAccountRequest',
      _i8.EmailFailedSignIn => 'EmailFailedSignIn',
      _i9.EmailPasswordReset => 'EmailPasswordReset',
      _i10.EmailReset => 'EmailReset',
      _i11.GoogleRefreshToken => 'GoogleRefreshToken',
      _i12.UserImage => 'UserImage',
      _i13.UserInfo => 'UserInfo',
      _i14.UserInfoPublic => 'UserInfoPublic',
      _i15.UserSettingsConfig => 'UserSettingsConfig',
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
      case _i2.AppleAuthInfo():
        return 'AppleAuthInfo';
      case _i3.AuthKey():
        return 'AuthKey';
      case _i4.AuthenticationFailReason():
        return 'AuthenticationFailReason';
      case _i5.AuthenticationResponse():
        return 'AuthenticationResponse';
      case _i6.EmailAuth():
        return 'EmailAuth';
      case _i7.EmailCreateAccountRequest():
        return 'EmailCreateAccountRequest';
      case _i8.EmailFailedSignIn():
        return 'EmailFailedSignIn';
      case _i9.EmailPasswordReset():
        return 'EmailPasswordReset';
      case _i10.EmailReset():
        return 'EmailReset';
      case _i11.GoogleRefreshToken():
        return 'GoogleRefreshToken';
      case _i12.UserImage():
        return 'UserImage';
      case _i13.UserInfo():
        return 'UserInfo';
      case _i14.UserInfoPublic():
        return 'UserInfoPublic';
      case _i15.UserSettingsConfig():
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
    if (dataClassName == 'EmailAuth') {
      return deserialize<_i6.EmailAuth>(data['data']);
    }
    if (dataClassName == 'EmailCreateAccountRequest') {
      return deserialize<_i7.EmailCreateAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailFailedSignIn') {
      return deserialize<_i8.EmailFailedSignIn>(data['data']);
    }
    if (dataClassName == 'EmailPasswordReset') {
      return deserialize<_i9.EmailPasswordReset>(data['data']);
    }
    if (dataClassName == 'EmailReset') {
      return deserialize<_i10.EmailReset>(data['data']);
    }
    if (dataClassName == 'GoogleRefreshToken') {
      return deserialize<_i11.GoogleRefreshToken>(data['data']);
    }
    if (dataClassName == 'UserImage') {
      return deserialize<_i12.UserImage>(data['data']);
    }
    if (dataClassName == 'UserInfo') {
      return deserialize<_i13.UserInfo>(data['data']);
    }
    if (dataClassName == 'UserInfoPublic') {
      return deserialize<_i14.UserInfoPublic>(data['data']);
    }
    if (dataClassName == 'UserSettingsConfig') {
      return deserialize<_i15.UserSettingsConfig>(data['data']);
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
          ? _i1.SerializationManager.toEncodableForProtocol(wrapped)
          : _i1.SerializationManager.toEncodable(wrapped);
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
        } on FormatException catch (_) {}
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
