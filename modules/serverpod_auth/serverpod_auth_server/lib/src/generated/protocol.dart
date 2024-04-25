/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'apple_auth_info.dart' as _i3;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_email_auth',
      dartName: 'EmailAuth',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_email_auth_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'hash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_email_auth_pkey',
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
          indexName: 'serverpod_email_auth_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
      name: 'serverpod_email_create_request',
      dartName: 'EmailCreateAccountRequest',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_email_create_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'hash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_email_create_request_pkey',
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
          indexName: 'serverpod_email_auth_create_account_request_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
      name: 'serverpod_email_failed_sign_in',
      dartName: 'EmailFailedSignIn',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_email_failed_sign_in_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'time',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_email_failed_sign_in_pkey',
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
          indexName: 'serverpod_email_failed_sign_in_email_idx',
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
        _i2.IndexDefinition(
          indexName: 'serverpod_email_failed_sign_in_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'time',
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
      name: 'serverpod_email_reset',
      dartName: 'EmailReset',
      schema: 'public',
      module: 'serverpod_auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_email_reset_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiration',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_email_reset_pkey',
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
          indexName: 'serverpod_email_reset_verification_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'verificationCode',
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
          isNullable: false,
          dartType: 'String',
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
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i3.AppleAuthInfo) {
      return _i3.AppleAuthInfo.fromJson(data) as T;
    }
    if (t == _i4.AuthenticationFailReason) {
      return _i4.AuthenticationFailReason.fromJson(data) as T;
    }
    if (t == _i5.AuthenticationResponse) {
      return _i5.AuthenticationResponse.fromJson(data) as T;
    }
    if (t == _i6.EmailAuth) {
      return _i6.EmailAuth.fromJson(data) as T;
    }
    if (t == _i7.EmailCreateAccountRequest) {
      return _i7.EmailCreateAccountRequest.fromJson(data) as T;
    }
    if (t == _i8.EmailFailedSignIn) {
      return _i8.EmailFailedSignIn.fromJson(data) as T;
    }
    if (t == _i9.EmailPasswordReset) {
      return _i9.EmailPasswordReset.fromJson(data) as T;
    }
    if (t == _i10.EmailReset) {
      return _i10.EmailReset.fromJson(data) as T;
    }
    if (t == _i11.GoogleRefreshToken) {
      return _i11.GoogleRefreshToken.fromJson(data) as T;
    }
    if (t == _i12.UserImage) {
      return _i12.UserImage.fromJson(data) as T;
    }
    if (t == _i13.UserInfo) {
      return _i13.UserInfo.fromJson(data) as T;
    }
    if (t == _i14.UserInfoPublic) {
      return _i14.UserInfoPublic.fromJson(data) as T;
    }
    if (t == _i15.UserSettingsConfig) {
      return _i15.UserSettingsConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.AppleAuthInfo?>()) {
      return (data != null ? _i3.AppleAuthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthenticationFailReason?>()) {
      return (data != null ? _i4.AuthenticationFailReason.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AuthenticationResponse?>()) {
      return (data != null ? _i5.AuthenticationResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.EmailAuth?>()) {
      return (data != null ? _i6.EmailAuth.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.EmailCreateAccountRequest?>()) {
      return (data != null
          ? _i7.EmailCreateAccountRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.EmailFailedSignIn?>()) {
      return (data != null ? _i8.EmailFailedSignIn.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.EmailPasswordReset?>()) {
      return (data != null ? _i9.EmailPasswordReset.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.EmailReset?>()) {
      return (data != null ? _i10.EmailReset.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.GoogleRefreshToken?>()) {
      return (data != null ? _i11.GoogleRefreshToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.UserImage?>()) {
      return (data != null ? _i12.UserImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.UserInfo?>()) {
      return (data != null ? _i13.UserInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserInfoPublic?>()) {
      return (data != null ? _i14.UserInfoPublic.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.UserSettingsConfig?>()) {
      return (data != null ? _i15.UserSettingsConfig.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i3.AppleAuthInfo) {
      return 'AppleAuthInfo';
    }
    if (data is _i4.AuthenticationFailReason) {
      return 'AuthenticationFailReason';
    }
    if (data is _i5.AuthenticationResponse) {
      return 'AuthenticationResponse';
    }
    if (data is _i6.EmailAuth) {
      return 'EmailAuth';
    }
    if (data is _i7.EmailCreateAccountRequest) {
      return 'EmailCreateAccountRequest';
    }
    if (data is _i8.EmailFailedSignIn) {
      return 'EmailFailedSignIn';
    }
    if (data is _i9.EmailPasswordReset) {
      return 'EmailPasswordReset';
    }
    if (data is _i10.EmailReset) {
      return 'EmailReset';
    }
    if (data is _i11.GoogleRefreshToken) {
      return 'GoogleRefreshToken';
    }
    if (data is _i12.UserImage) {
      return 'UserImage';
    }
    if (data is _i13.UserInfo) {
      return 'UserInfo';
    }
    if (data is _i14.UserInfoPublic) {
      return 'UserInfoPublic';
    }
    if (data is _i15.UserSettingsConfig) {
      return 'UserSettingsConfig';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'AppleAuthInfo') {
      return deserialize<_i3.AppleAuthInfo>(data['data']);
    }
    if (data['className'] == 'AuthenticationFailReason') {
      return deserialize<_i4.AuthenticationFailReason>(data['data']);
    }
    if (data['className'] == 'AuthenticationResponse') {
      return deserialize<_i5.AuthenticationResponse>(data['data']);
    }
    if (data['className'] == 'EmailAuth') {
      return deserialize<_i6.EmailAuth>(data['data']);
    }
    if (data['className'] == 'EmailCreateAccountRequest') {
      return deserialize<_i7.EmailCreateAccountRequest>(data['data']);
    }
    if (data['className'] == 'EmailFailedSignIn') {
      return deserialize<_i8.EmailFailedSignIn>(data['data']);
    }
    if (data['className'] == 'EmailPasswordReset') {
      return deserialize<_i9.EmailPasswordReset>(data['data']);
    }
    if (data['className'] == 'EmailReset') {
      return deserialize<_i10.EmailReset>(data['data']);
    }
    if (data['className'] == 'GoogleRefreshToken') {
      return deserialize<_i11.GoogleRefreshToken>(data['data']);
    }
    if (data['className'] == 'UserImage') {
      return deserialize<_i12.UserImage>(data['data']);
    }
    if (data['className'] == 'UserInfo') {
      return deserialize<_i13.UserInfo>(data['data']);
    }
    if (data['className'] == 'UserInfoPublic') {
      return deserialize<_i14.UserInfoPublic>(data['data']);
    }
    if (data['className'] == 'UserSettingsConfig') {
      return deserialize<_i15.UserSettingsConfig>(data['data']);
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
      case _i6.EmailAuth:
        return _i6.EmailAuth.t;
      case _i7.EmailCreateAccountRequest:
        return _i7.EmailCreateAccountRequest.t;
      case _i8.EmailFailedSignIn:
        return _i8.EmailFailedSignIn.t;
      case _i10.EmailReset:
        return _i10.EmailReset.t;
      case _i11.GoogleRefreshToken:
        return _i11.GoogleRefreshToken.t;
      case _i12.UserImage:
        return _i12.UserImage.t;
      case _i13.UserInfo:
        return _i13.UserInfo.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth';
}
