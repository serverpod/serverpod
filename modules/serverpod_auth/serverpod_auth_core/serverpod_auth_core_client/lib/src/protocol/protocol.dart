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
import 'auth_user/models/auth_user.dart' as _iwlenhk6;
import 'auth_user/models/auth_user_blocked_exception.dart' as _idjlnenv;
import 'auth_user/models/auth_user_model.dart' as _ievhec41;
import 'auth_user/models/auth_user_not_found_exception.dart' as _ihi15zs1;
import 'common/models/auth_strategy.dart' as _i52qy4mw;
import 'common/models/auth_success.dart' as _ioaqzt9u;
import 'common/models/sign_in_while_authenticated_exception.dart' as _iymqi1d6;
import 'jwt/models/jwt_token_info.dart' as _i8d4wdsw;
import 'jwt/models/refresh_token_expired_exception.dart' as _i35co9vj;
import 'jwt/models/refresh_token_invalid_secret_exception.dart' as _ik27atqz;
import 'jwt/models/refresh_token_malformed_exception.dart' as _i20y3j39;
import 'jwt/models/refresh_token_not_found_exception.dart' as _in48f3pc;
import 'jwt/models/token_pair.dart' as _i6w0tdii;
import 'profile/models/user_profile.dart' as _ichiyqlu;
import 'profile/models/user_profile_data.dart' as _isbbac0p;
import 'profile/models/user_profile_image.dart' as _iu5nhigv;
import 'profile/models/user_profile_model.dart' as _iw6ug6lb;
import 'session/models/server_side_session_info.dart' as _izgso6n0;
export 'auth_user/models/auth_user.dart';
export 'auth_user/models/auth_user_blocked_exception.dart';
export 'auth_user/models/auth_user_model.dart';
export 'auth_user/models/auth_user_not_found_exception.dart';
export 'common/models/auth_strategy.dart';
export 'common/models/auth_success.dart';
export 'common/models/sign_in_while_authenticated_exception.dart';
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

    if (t == _iwlenhk6.AuthUser) {
      return _iwlenhk6.AuthUser.fromJson(data) as T;
    }
    if (t == _idjlnenv.AuthUserBlockedException) {
      return _idjlnenv.AuthUserBlockedException.fromJson(data) as T;
    }
    if (t == _ievhec41.AuthUserModel) {
      return _ievhec41.AuthUserModel.fromJson(data) as T;
    }
    if (t == _ihi15zs1.AuthUserNotFoundException) {
      return _ihi15zs1.AuthUserNotFoundException.fromJson(data) as T;
    }
    if (t == _i52qy4mw.AuthStrategy) {
      return _i52qy4mw.AuthStrategy.fromJson(data) as T;
    }
    if (t == _ioaqzt9u.AuthSuccess) {
      return _ioaqzt9u.AuthSuccess.fromJson(data) as T;
    }
    if (t == _iymqi1d6.SignInWhileAuthenticatedException) {
      return _iymqi1d6.SignInWhileAuthenticatedException.fromJson(data) as T;
    }
    if (t == _i8d4wdsw.JwtTokenInfo) {
      return _i8d4wdsw.JwtTokenInfo.fromJson(data) as T;
    }
    if (t == _i35co9vj.RefreshTokenExpiredException) {
      return _i35co9vj.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _ik27atqz.RefreshTokenInvalidSecretException) {
      return _ik27atqz.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i20y3j39.RefreshTokenMalformedException) {
      return _i20y3j39.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _in48f3pc.RefreshTokenNotFoundException) {
      return _in48f3pc.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i6w0tdii.TokenPair) {
      return _i6w0tdii.TokenPair.fromJson(data) as T;
    }
    if (t == _ichiyqlu.UserProfile) {
      return _ichiyqlu.UserProfile.fromJson(data) as T;
    }
    if (t == _isbbac0p.UserProfileData) {
      return _isbbac0p.UserProfileData.fromJson(data) as T;
    }
    if (t == _iu5nhigv.UserProfileImage) {
      return _iu5nhigv.UserProfileImage.fromJson(data) as T;
    }
    if (t == _iw6ug6lb.UserProfileModel) {
      return _iw6ug6lb.UserProfileModel.fromJson(data) as T;
    }
    if (t == _izgso6n0.ServerSideSessionInfo) {
      return _izgso6n0.ServerSideSessionInfo.fromJson(data) as T;
    }
    if (t == _isc.getType<_iwlenhk6.AuthUser?>()) {
      return (data != null ? _iwlenhk6.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idjlnenv.AuthUserBlockedException?>()) {
      return (data != null
              ? _idjlnenv.AuthUserBlockedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ievhec41.AuthUserModel?>()) {
      return (data != null ? _ievhec41.AuthUserModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihi15zs1.AuthUserNotFoundException?>()) {
      return (data != null
              ? _ihi15zs1.AuthUserNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i52qy4mw.AuthStrategy?>()) {
      return (data != null ? _i52qy4mw.AuthStrategy.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioaqzt9u.AuthSuccess?>()) {
      return (data != null ? _ioaqzt9u.AuthSuccess.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iymqi1d6.SignInWhileAuthenticatedException?>()) {
      return (data != null
              ? _iymqi1d6.SignInWhileAuthenticatedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i8d4wdsw.JwtTokenInfo?>()) {
      return (data != null ? _i8d4wdsw.JwtTokenInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i35co9vj.RefreshTokenExpiredException?>()) {
      return (data != null
              ? _i35co9vj.RefreshTokenExpiredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ik27atqz.RefreshTokenInvalidSecretException?>()) {
      return (data != null
              ? _ik27atqz.RefreshTokenInvalidSecretException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i20y3j39.RefreshTokenMalformedException?>()) {
      return (data != null
              ? _i20y3j39.RefreshTokenMalformedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_in48f3pc.RefreshTokenNotFoundException?>()) {
      return (data != null
              ? _in48f3pc.RefreshTokenNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6w0tdii.TokenPair?>()) {
      return (data != null ? _i6w0tdii.TokenPair.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ichiyqlu.UserProfile?>()) {
      return (data != null ? _ichiyqlu.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isbbac0p.UserProfileData?>()) {
      return (data != null ? _isbbac0p.UserProfileData.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu5nhigv.UserProfileImage?>()) {
      return (data != null ? _iu5nhigv.UserProfileImage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iw6ug6lb.UserProfileModel?>()) {
      return (data != null ? _iw6ug6lb.UserProfileModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izgso6n0.ServerSideSessionInfo?>()) {
      return (data != null
              ? _izgso6n0.ServerSideSessionInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iwlenhk6.AuthUser => 'AuthUser',
      _idjlnenv.AuthUserBlockedException => 'AuthUserBlockedException',
      _ievhec41.AuthUserModel => 'AuthUserModel',
      _ihi15zs1.AuthUserNotFoundException => 'AuthUserNotFoundException',
      _i52qy4mw.AuthStrategy => 'AuthStrategy',
      _ioaqzt9u.AuthSuccess => 'AuthSuccess',
      _iymqi1d6.SignInWhileAuthenticatedException =>
        'SignInWhileAuthenticatedException',
      _i8d4wdsw.JwtTokenInfo => 'JwtTokenInfo',
      _i35co9vj.RefreshTokenExpiredException => 'RefreshTokenExpiredException',
      _ik27atqz.RefreshTokenInvalidSecretException =>
        'RefreshTokenInvalidSecretException',
      _i20y3j39.RefreshTokenMalformedException =>
        'RefreshTokenMalformedException',
      _in48f3pc.RefreshTokenNotFoundException =>
        'RefreshTokenNotFoundException',
      _i6w0tdii.TokenPair => 'TokenPair',
      _ichiyqlu.UserProfile => 'UserProfile',
      _isbbac0p.UserProfileData => 'UserProfileData',
      _iu5nhigv.UserProfileImage => 'UserProfileImage',
      _iw6ug6lb.UserProfileModel => 'UserProfileModel',
      _izgso6n0.ServerSideSessionInfo => 'ServerSideSessionInfo',
      _ => null,
    };
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
      case _iwlenhk6.AuthUser():
        return 'AuthUser';
      case _idjlnenv.AuthUserBlockedException():
        return 'AuthUserBlockedException';
      case _ievhec41.AuthUserModel():
        return 'AuthUserModel';
      case _ihi15zs1.AuthUserNotFoundException():
        return 'AuthUserNotFoundException';
      case _i52qy4mw.AuthStrategy():
        return 'AuthStrategy';
      case _ioaqzt9u.AuthSuccess():
        return 'AuthSuccess';
      case _iymqi1d6.SignInWhileAuthenticatedException():
        return 'SignInWhileAuthenticatedException';
      case _i8d4wdsw.JwtTokenInfo():
        return 'JwtTokenInfo';
      case _i35co9vj.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _ik27atqz.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i20y3j39.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _in48f3pc.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i6w0tdii.TokenPair():
        return 'TokenPair';
      case _ichiyqlu.UserProfile():
        return 'UserProfile';
      case _isbbac0p.UserProfileData():
        return 'UserProfileData';
      case _iu5nhigv.UserProfileImage():
        return 'UserProfileImage';
      case _iw6ug6lb.UserProfileModel():
        return 'UserProfileModel';
      case _izgso6n0.ServerSideSessionInfo():
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
      return deserialize<_iwlenhk6.AuthUser>(data['data']);
    }
    if (dataClassName == 'AuthUserBlockedException') {
      return deserialize<_idjlnenv.AuthUserBlockedException>(data['data']);
    }
    if (dataClassName == 'AuthUserModel') {
      return deserialize<_ievhec41.AuthUserModel>(data['data']);
    }
    if (dataClassName == 'AuthUserNotFoundException') {
      return deserialize<_ihi15zs1.AuthUserNotFoundException>(data['data']);
    }
    if (dataClassName == 'AuthStrategy') {
      return deserialize<_i52qy4mw.AuthStrategy>(data['data']);
    }
    if (dataClassName == 'AuthSuccess') {
      return deserialize<_ioaqzt9u.AuthSuccess>(data['data']);
    }
    if (dataClassName == 'SignInWhileAuthenticatedException') {
      return deserialize<_iymqi1d6.SignInWhileAuthenticatedException>(
        data['data'],
      );
    }
    if (dataClassName == 'JwtTokenInfo') {
      return deserialize<_i8d4wdsw.JwtTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i35co9vj.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_ik27atqz.RefreshTokenInvalidSecretException>(
        data['data'],
      );
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i20y3j39.RefreshTokenMalformedException>(
        data['data'],
      );
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_in48f3pc.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i6w0tdii.TokenPair>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_ichiyqlu.UserProfile>(data['data']);
    }
    if (dataClassName == 'UserProfileData') {
      return deserialize<_isbbac0p.UserProfileData>(data['data']);
    }
    if (dataClassName == 'UserProfileImage') {
      return deserialize<_iu5nhigv.UserProfileImage>(data['data']);
    }
    if (dataClassName == 'UserProfileModel') {
      return deserialize<_iw6ug6lb.UserProfileModel>(data['data']);
    }
    if (dataClassName == 'ServerSideSessionInfo') {
      return deserialize<_izgso6n0.ServerSideSessionInfo>(data['data']);
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
  String getModuleName() => 'serverpod_auth_core';

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
