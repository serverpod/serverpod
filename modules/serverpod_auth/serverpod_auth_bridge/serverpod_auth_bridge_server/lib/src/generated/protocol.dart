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
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'legacy_authentication_fail_reason.dart' as _ijl7odiy;
import 'legacy_authentication_response.dart' as _i1vkno9i;
import 'legacy_email_password.dart' as _isu9lcrg;
import 'legacy_external_user_identifier.dart' as _i552shl7;
import 'legacy_session.dart' as _i4848vr5;
import 'legacy_user_info.dart' as _izh8x5we;
import 'legacy_user_settings_config.dart' as _iivi3sn7;
export 'legacy_authentication_fail_reason.dart';
export 'legacy_authentication_response.dart';
export 'legacy_email_password.dart';
export 'legacy_external_user_identifier.dart';
export 'legacy_session.dart';
export 'legacy_user_info.dart';
export 'legacy_user_settings_config.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_is.SerializationManager> _hostProtocols = {};

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'serverpod_auth_bridge_email_password',
      dartName: 'LegacyEmailPassword',
      schema: 'public',
      module: 'serverpod_auth_bridge',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'emailAccountId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'hash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_bridge_email_password_fk_0',
          columns: ['emailAccountId'],
          referenceTable: 'serverpod_auth_idp_email_account',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_bridge_email_password_account',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'emailAccountId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_auth_bridge_external_user_id',
      dartName: 'LegacyExternalUserIdentifier',
      schema: 'public',
      module: 'serverpod_auth_bridge',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_bridge_external_user_id_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_bridge_external_user_id_id',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_auth_bridge_session',
      dartName: 'LegacySession',
      schema: 'public',
      module: 'serverpod_auth_bridge',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'scopeNames',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Set<String>',
        ),
        _isp.ColumnDefinition(
          name: 'hash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'method',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_bridge_session_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    ..._iacs.Protocol.targetTableDefinitions,
    ..._iais.Protocol.targetTableDefinitions,
  ];

  void registerHostProtocol(
    String projectName,
    _is.SerializationManager protocol,
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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ijl7odiy.LegacyAuthenticationFailReason) {
      return _ijl7odiy.LegacyAuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i1vkno9i.LegacyAuthenticationResponse) {
      return _i1vkno9i.LegacyAuthenticationResponse.fromJson(data) as T;
    }
    if (t == _isu9lcrg.LegacyEmailPassword) {
      return _isu9lcrg.LegacyEmailPassword.fromJson(data) as T;
    }
    if (t == _i552shl7.LegacyExternalUserIdentifier) {
      return _i552shl7.LegacyExternalUserIdentifier.fromJson(data) as T;
    }
    if (t == _i4848vr5.LegacySession) {
      return _i4848vr5.LegacySession.fromJson(data) as T;
    }
    if (t == _izh8x5we.LegacyUserInfo) {
      return _izh8x5we.LegacyUserInfo.fromJson(data) as T;
    }
    if (t == _iivi3sn7.LegacyUserSettingsConfig) {
      return _iivi3sn7.LegacyUserSettingsConfig.fromJson(data) as T;
    }
    if (t == _is.getType<_ijl7odiy.LegacyAuthenticationFailReason?>()) {
      return (data != null
              ? _ijl7odiy.LegacyAuthenticationFailReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1vkno9i.LegacyAuthenticationResponse?>()) {
      return (data != null
              ? _i1vkno9i.LegacyAuthenticationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isu9lcrg.LegacyEmailPassword?>()) {
      return (data != null
              ? _isu9lcrg.LegacyEmailPassword.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i552shl7.LegacyExternalUserIdentifier?>()) {
      return (data != null
              ? _i552shl7.LegacyExternalUserIdentifier.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i4848vr5.LegacySession?>()) {
      return (data != null ? _i4848vr5.LegacySession.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izh8x5we.LegacyUserInfo?>()) {
      return (data != null ? _izh8x5we.LegacyUserInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iivi3sn7.LegacyUserSettingsConfig?>()) {
      return (data != null
              ? _iivi3sn7.LegacyUserSettingsConfig.fromJson(data)
              : null)
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ijl7odiy.LegacyAuthenticationFailReason =>
        'LegacyAuthenticationFailReason',
      _i1vkno9i.LegacyAuthenticationResponse => 'LegacyAuthenticationResponse',
      _isu9lcrg.LegacyEmailPassword => 'LegacyEmailPassword',
      _i552shl7.LegacyExternalUserIdentifier => 'LegacyExternalUserIdentifier',
      _i4848vr5.LegacySession => 'LegacySession',
      _izh8x5we.LegacyUserInfo => 'LegacyUserInfo',
      _iivi3sn7.LegacyUserSettingsConfig => 'LegacyUserSettingsConfig',
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
      case _ijl7odiy.LegacyAuthenticationFailReason():
        return 'LegacyAuthenticationFailReason';
      case _i1vkno9i.LegacyAuthenticationResponse():
        return 'LegacyAuthenticationResponse';
      case _isu9lcrg.LegacyEmailPassword():
        return 'LegacyEmailPassword';
      case _i552shl7.LegacyExternalUserIdentifier():
        return 'LegacyExternalUserIdentifier';
      case _i4848vr5.LegacySession():
        return 'LegacySession';
      case _izh8x5we.LegacyUserInfo():
        return 'LegacyUserInfo';
      case _iivi3sn7.LegacyUserSettingsConfig():
        return 'LegacyUserSettingsConfig';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return deserialize<_ijl7odiy.LegacyAuthenticationFailReason>(
        data['data'],
      );
    }
    if (dataClassName == 'LegacyAuthenticationResponse') {
      return deserialize<_i1vkno9i.LegacyAuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'LegacyEmailPassword') {
      return deserialize<_isu9lcrg.LegacyEmailPassword>(data['data']);
    }
    if (dataClassName == 'LegacyExternalUserIdentifier') {
      return deserialize<_i552shl7.LegacyExternalUserIdentifier>(data['data']);
    }
    if (dataClassName == 'LegacySession') {
      return deserialize<_i4848vr5.LegacySession>(data['data']);
    }
    if (dataClassName == 'LegacyUserInfo') {
      return deserialize<_izh8x5we.LegacyUserInfo>(data['data']);
    }
    if (dataClassName == 'LegacyUserSettingsConfig') {
      return deserialize<_iivi3sn7.LegacyUserSettingsConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
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
          ? _is.SerializationManager.toEncodableForProtocol(wrapped)
          : _is.SerializationManager.toEncodable(wrapped);
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
        } on _is.DeserializationClassNameNotFoundException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _isu9lcrg.LegacyEmailPassword:
        return _isu9lcrg.LegacyEmailPassword.t;
      case _i552shl7.LegacyExternalUserIdentifier:
        return _i552shl7.LegacyExternalUserIdentifier.t;
      case _i4848vr5.LegacySession:
        return _i4848vr5.LegacySession.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
