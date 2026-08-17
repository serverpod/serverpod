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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i2;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i3;
import 'legacy_authentication_fail_reason.dart' as _i4;
import 'legacy_authentication_response.dart' as _i5;
import 'legacy_user_info.dart' as _i6;
import 'legacy_user_settings_config.dart' as _i7;
export 'legacy_authentication_fail_reason.dart';
export 'legacy_authentication_response.dart';
export 'legacy_user_info.dart';
export 'legacy_user_settings_config.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_i1.SerializationManager> _hostProtocols = {};

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

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

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i4.LegacyAuthenticationFailReason => 'LegacyAuthenticationFailReason',
      _i5.LegacyAuthenticationResponse => 'LegacyAuthenticationResponse',
      _i6.LegacyUserInfo => 'LegacyUserInfo',
      _i7.LegacyUserSettingsConfig => 'LegacyUserSettingsConfig',
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
      case _i4.LegacyAuthenticationFailReason():
        return 'LegacyAuthenticationFailReason';
      case _i5.LegacyAuthenticationResponse():
        return 'LegacyAuthenticationResponse';
      case _i6.LegacyUserInfo():
        return 'LegacyUserInfo';
      case _i7.LegacyUserSettingsConfig():
        return 'LegacyUserSettingsConfig';
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
      return deserialize<_i4.LegacyAuthenticationFailReason>(data['data']);
    }
    if (dataClassName == 'LegacyAuthenticationResponse') {
      return deserialize<_i5.LegacyAuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'LegacyUserInfo') {
      return deserialize<_i6.LegacyUserInfo>(data['data']);
    }
    if (dataClassName == 'LegacyUserSettingsConfig') {
      return deserialize<_i7.LegacyUserSettingsConfig>(data['data']);
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
  String getModuleName() => 'serverpod_auth_bridge';

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
      return _i2.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i4.LegacyAuthenticationFailReason] = (data, protocol) =>
        _i4.LegacyAuthenticationFailReason.fromJson(data);
    map[_i5.LegacyAuthenticationResponse] = (data, protocol) =>
        _i5.LegacyAuthenticationResponse.fromJson(data);
    map[_i6.LegacyUserInfo] = (data, protocol) =>
        _i6.LegacyUserInfo.fromJson(data);
    map[_i7.LegacyUserSettingsConfig] = (data, protocol) =>
        _i7.LegacyUserSettingsConfig.fromJson(data);
    map[_i1
        .getType<_i4.LegacyAuthenticationFailReason?>()] = (data, protocol) =>
        (data != null
        ? _i4.LegacyAuthenticationFailReason.fromJson(data)
        : null);
    map[_i1.getType<_i5.LegacyAuthenticationResponse?>()] = (data, protocol) =>
        (data != null ? _i5.LegacyAuthenticationResponse.fromJson(data) : null);
    map[_i1.getType<_i6.LegacyUserInfo?>()] = (data, protocol) =>
        (data != null ? _i6.LegacyUserInfo.fromJson(data) : null);
    map[_i1.getType<_i7.LegacyUserSettingsConfig?>()] = (data, protocol) =>
        (data != null ? _i7.LegacyUserSettingsConfig.fromJson(data) : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    return map;
  }
}
