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
import 'legacy_authentication_fail_reason.dart' as _i2;
import 'legacy_authentication_response.dart' as _i3;
import 'legacy_user_info.dart' as _i4;
import 'legacy_user_settings_config.dart' as _i5;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i6;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i7;
export 'legacy_authentication_fail_reason.dart';
export 'legacy_authentication_response.dart';
export 'legacy_user_info.dart';
export 'legacy_user_settings_config.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_auth_bridge.')) return className;
    return className.substring(22);
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

    if (t == _i2.LegacyAuthenticationFailReason) {
      return _i2.LegacyAuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i3.LegacyAuthenticationResponse) {
      return _i3.LegacyAuthenticationResponse.fromJson(data) as T;
    }
    if (t == _i4.LegacyUserInfo) {
      return _i4.LegacyUserInfo.fromJson(data) as T;
    }
    if (t == _i5.LegacyUserSettingsConfig) {
      return _i5.LegacyUserSettingsConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.LegacyAuthenticationFailReason?>()) {
      return (data != null
              ? _i2.LegacyAuthenticationFailReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i3.LegacyAuthenticationResponse?>()) {
      return (data != null
              ? _i3.LegacyAuthenticationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i4.LegacyUserInfo?>()) {
      return (data != null ? _i4.LegacyUserInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.LegacyUserSettingsConfig?>()) {
      return (data != null ? _i5.LegacyUserSettingsConfig.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    try {
      return _i6.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i7.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.LegacyAuthenticationFailReason => 'LegacyAuthenticationFailReason',
      _i3.LegacyAuthenticationResponse => 'LegacyAuthenticationResponse',
      _i4.LegacyUserInfo => 'LegacyUserInfo',
      _i5.LegacyUserSettingsConfig => 'LegacyUserSettingsConfig',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_auth_bridge.',
        '',
      );
    }

    switch (data) {
      case _i2.LegacyAuthenticationFailReason():
        return 'LegacyAuthenticationFailReason';
      case _i3.LegacyAuthenticationResponse():
        return 'LegacyAuthenticationResponse';
      case _i4.LegacyUserInfo():
        return 'LegacyUserInfo';
      case _i5.LegacyUserSettingsConfig():
        return 'LegacyUserSettingsConfig';
    }
    className = _i6.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i7.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'LegacyAuthenticationFailReason') {
      return deserialize<_i2.LegacyAuthenticationFailReason>(data['data']);
    }
    if (dataClassName == 'LegacyAuthenticationResponse') {
      return deserialize<_i3.LegacyAuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'LegacyUserInfo') {
      return deserialize<_i4.LegacyUserInfo>(data['data']);
    }
    if (dataClassName == 'LegacyUserSettingsConfig') {
      return deserialize<_i5.LegacyUserSettingsConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i6.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i7.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i6.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i7.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
