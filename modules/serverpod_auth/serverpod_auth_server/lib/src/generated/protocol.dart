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
import 'email_auth.dart' as _i7;
import 'email_create_account_request.dart' as _i8;
import 'email_failed_sign_in.dart' as _i9;
import 'email_password_reset.dart' as _i10;
import 'email_reset.dart' as _i11;
import 'google_refresh_token.dart' as _i12;
import 'user_image.dart' as _i13;
import 'user_info.dart' as _i14;
import 'user_info_public.dart' as _i15;
import 'user_settings_config.dart' as _i16;
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
    if (t == _i7.EmailAuth) {
      return _i7.EmailAuth.fromJson(data) as T;
    }
    if (t == _i8.EmailCreateAccountRequest) {
      return _i8.EmailCreateAccountRequest.fromJson(data) as T;
    }
    if (t == _i9.EmailFailedSignIn) {
      return _i9.EmailFailedSignIn.fromJson(data) as T;
    }
    if (t == _i10.EmailPasswordReset) {
      return _i10.EmailPasswordReset.fromJson(data) as T;
    }
    if (t == _i11.EmailReset) {
      return _i11.EmailReset.fromJson(data) as T;
    }
    if (t == _i12.GoogleRefreshToken) {
      return _i12.GoogleRefreshToken.fromJson(data) as T;
    }
    if (t == _i13.UserImage) {
      return _i13.UserImage.fromJson(data) as T;
    }
    if (t == _i14.UserInfo) {
      return _i14.UserInfo.fromJson(data) as T;
    }
    if (t == _i15.UserInfoPublic) {
      return _i15.UserInfoPublic.fromJson(data) as T;
    }
    if (t == _i16.UserSettingsConfig) {
      return _i16.UserSettingsConfig.fromJson(data) as T;
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
    if (t == _i1.getType<_i7.EmailAuth?>()) {
      return (data != null ? _i7.EmailAuth.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EmailCreateAccountRequest?>()) {
      return (data != null
          ? _i8.EmailCreateAccountRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.EmailFailedSignIn?>()) {
      return (data != null ? _i9.EmailFailedSignIn.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.EmailPasswordReset?>()) {
      return (data != null ? _i10.EmailPasswordReset.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.EmailReset?>()) {
      return (data != null ? _i11.EmailReset.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.GoogleRefreshToken?>()) {
      return (data != null ? _i12.GoogleRefreshToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.UserImage?>()) {
      return (data != null ? _i13.UserImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserInfo?>()) {
      return (data != null ? _i14.UserInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.UserInfoPublic?>()) {
      return (data != null ? _i15.UserInfoPublic.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserSettingsConfig?>()) {
      return (data != null ? _i16.UserSettingsConfig.fromJson(data) : null)
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
    switch (data) {
      case _i3.AppleAuthInfo():
        return 'AppleAuthInfo';
      case _i4.AuthKey():
        return 'AuthKey';
      case _i5.AuthenticationFailReason():
        return 'AuthenticationFailReason';
      case _i6.AuthenticationResponse():
        return 'AuthenticationResponse';
      case _i7.EmailAuth():
        return 'EmailAuth';
      case _i8.EmailCreateAccountRequest():
        return 'EmailCreateAccountRequest';
      case _i9.EmailFailedSignIn():
        return 'EmailFailedSignIn';
      case _i10.EmailPasswordReset():
        return 'EmailPasswordReset';
      case _i11.EmailReset():
        return 'EmailReset';
      case _i12.GoogleRefreshToken():
        return 'GoogleRefreshToken';
      case _i13.UserImage():
        return 'UserImage';
      case _i14.UserInfo():
        return 'UserInfo';
      case _i15.UserInfoPublic():
        return 'UserInfoPublic';
      case _i16.UserSettingsConfig():
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
    if (dataClassName == 'EmailAuth') {
      return deserialize<_i7.EmailAuth>(data['data']);
    }
    if (dataClassName == 'EmailCreateAccountRequest') {
      return deserialize<_i8.EmailCreateAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailFailedSignIn') {
      return deserialize<_i9.EmailFailedSignIn>(data['data']);
    }
    if (dataClassName == 'EmailPasswordReset') {
      return deserialize<_i10.EmailPasswordReset>(data['data']);
    }
    if (dataClassName == 'EmailReset') {
      return deserialize<_i11.EmailReset>(data['data']);
    }
    if (dataClassName == 'GoogleRefreshToken') {
      return deserialize<_i12.GoogleRefreshToken>(data['data']);
    }
    if (dataClassName == 'UserImage') {
      return deserialize<_i13.UserImage>(data['data']);
    }
    if (dataClassName == 'UserInfo') {
      return deserialize<_i14.UserInfo>(data['data']);
    }
    if (dataClassName == 'UserInfoPublic') {
      return deserialize<_i15.UserInfoPublic>(data['data']);
    }
    if (dataClassName == 'UserSettingsConfig') {
      return deserialize<_i16.UserSettingsConfig>(data['data']);
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
      case _i7.EmailAuth:
        return _i7.EmailAuth.t;
      case _i8.EmailCreateAccountRequest:
        return _i8.EmailCreateAccountRequest.t;
      case _i9.EmailFailedSignIn:
        return _i9.EmailFailedSignIn.t;
      case _i11.EmailReset:
        return _i11.EmailReset.t;
      case _i12.GoogleRefreshToken:
        return _i12.GoogleRefreshToken.t;
      case _i13.UserImage:
        return _i13.UserImage.t;
      case _i14.UserInfo:
        return _i14.UserInfo.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth';
}
