/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'apple_auth_info.dart' as _i3;
import 'auth_key.dart' as _i4;
import 'authentication_fail_reason.dart' as _i5;
import 'authentication_response.dart' as _i6;
import 'google_refresh_token.dart' as _i7;
import 'user_image.dart' as _i8;
import 'user_info.dart' as _i9;
import 'user_info_public.dart' as _i10;
import 'user_settings_config.dart' as _i11;
export 'apple_auth_info.dart';
export 'auth_key.dart';
export 'authentication_fail_reason.dart';
export 'authentication_response.dart';
export 'google_refresh_token.dart';
export 'user_image.dart';
export 'user_info.dart';
export 'user_info_public.dart';
export 'user_settings_config.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_key',
      dartName: 'AuthKey',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_auth_key_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'hash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scopeNames',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_key_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_key_userId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_google_refresh_token',
      dartName: 'GoogleRefreshToken',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_google_refresh_token_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'refreshToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_google_refresh_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_google_refresh_token_userId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_user_image',
      dartName: 'UserImage',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_user_image_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_user_image_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_user_image_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'version',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_user_info',
      dartName: 'UserInfo',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_user_info_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fullName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'created',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'scopeNames',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'blocked',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_user_info_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_user_info_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_user_info_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.AppleAuthInfo) {
      return _i3.AppleAuthInfo.fromJson(data) as T;
    }
    if (t == _i4.AuthKey) {
      return _i4.AuthKey.fromJson(data) as T;
    }
    if (t == _i5.AuthenticationFailReason) {
      return _i5.AuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i6.AuthenticationResponse) {
      return _i6.AuthenticationResponse.fromJson(data) as T;
    }
    if (t == _i7.GoogleRefreshToken) {
      return _i7.GoogleRefreshToken.fromJson(data) as T;
    }
    if (t == _i8.UserImage) {
      return _i8.UserImage.fromJson(data) as T;
    }
    if (t == _i9.UserInfo) {
      return _i9.UserInfo.fromJson(data) as T;
    }
    if (t == _i10.UserInfoPublic) {
      return _i10.UserInfoPublic.fromJson(data) as T;
    }
    if (t == _i11.UserSettingsConfig) {
      return _i11.UserSettingsConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.AppleAuthInfo?>()) {
      return (data != null ? _i3.AppleAuthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthKey?>()) {
      return (data != null ? _i4.AuthKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthenticationFailReason?>()) {
      return (data != null ? _i5.AuthenticationFailReason.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.AuthenticationResponse?>()) {
      return (data != null ? _i6.AuthenticationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.GoogleRefreshToken?>()) {
      return (data != null ? _i7.GoogleRefreshToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.UserImage?>()) {
      return (data != null ? _i8.UserImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserInfo?>()) {
      return (data != null ? _i9.UserInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UserInfoPublic?>()) {
      return (data != null ? _i10.UserInfoPublic.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.UserSettingsConfig?>()) {
      return (data != null ? _i11.UserSettingsConfig.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.AppleAuthInfo) {
      return 'AppleAuthInfo';
    }
    if (data is _i4.AuthKey) {
      return 'AuthKey';
    }
    if (data is _i5.AuthenticationFailReason) {
      return 'AuthenticationFailReason';
    }
    if (data is _i6.AuthenticationResponse) {
      return 'AuthenticationResponse';
    }
    if (data is _i7.GoogleRefreshToken) {
      return 'GoogleRefreshToken';
    }
    if (data is _i8.UserImage) {
      return 'UserImage';
    }
    if (data is _i9.UserInfo) {
      return 'UserInfo';
    }
    if (data is _i10.UserInfoPublic) {
      return 'UserInfoPublic';
    }
    if (data is _i11.UserSettingsConfig) {
      return 'UserSettingsConfig';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.AppleAuthInfo>(data['data']);
    }
    if (dataClassName == 'AuthKey') {
      return deserialize<_i4.AuthKey>(data['data']);
    }
    if (dataClassName == 'AuthenticationFailReason') {
      return deserialize<_i5.AuthenticationFailReason>(data['data']);
    }
    if (dataClassName == 'AuthenticationResponse') {
      return deserialize<_i6.AuthenticationResponse>(data['data']);
    }
    if (dataClassName == 'GoogleRefreshToken') {
      return deserialize<_i7.GoogleRefreshToken>(data['data']);
    }
    if (dataClassName == 'UserImage') {
      return deserialize<_i8.UserImage>(data['data']);
    }
    if (dataClassName == 'UserInfo') {
      return deserialize<_i9.UserInfo>(data['data']);
    }
    if (dataClassName == 'UserInfoPublic') {
      return deserialize<_i10.UserInfoPublic>(data['data']);
    }
    if (dataClassName == 'UserSettingsConfig') {
      return deserialize<_i11.UserSettingsConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.AuthKey:
        return _i4.AuthKey.t;
      case _i7.GoogleRefreshToken:
        return _i7.GoogleRefreshToken.t;
      case _i8.UserImage:
        return _i8.UserImage.t;
      case _i9.UserInfo:
        return _i9.UserInfo.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth';
}
