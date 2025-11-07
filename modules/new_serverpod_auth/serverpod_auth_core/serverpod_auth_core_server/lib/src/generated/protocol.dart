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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'auth_user/models/auth_user.dart' as _i3;
import 'auth_user/models/auth_user_blocked_exception.dart' as _i4;
import 'auth_user/models/auth_user_model.dart' as _i5;
import 'auth_user/models/auth_user_not_found_exception.dart' as _i6;
import 'common/models/auth_strategy.dart' as _i7;
import 'common/models/auth_success.dart' as _i8;
import 'jwt/models/authentication_token_info.dart' as _i9;
import 'jwt/models/refresh_token.dart' as _i10;
import 'jwt/models/refresh_token_expired_exception.dart' as _i11;
import 'jwt/models/refresh_token_invalid_secret_exception.dart' as _i12;
import 'jwt/models/refresh_token_malformed_exception.dart' as _i13;
import 'jwt/models/refresh_token_not_found_exception.dart' as _i14;
import 'jwt/models/token_pair.dart' as _i15;
import 'profile/models/user_profile.dart' as _i16;
import 'profile/models/user_profile_data.dart' as _i17;
import 'profile/models/user_profile_image.dart' as _i18;
import 'profile/models/user_profile_model.dart' as _i19;
import 'session/models/auth_session.dart' as _i20;
import 'session/models/auth_session_info.dart' as _i21;
export 'auth_user/models/auth_user.dart';
export 'auth_user/models/auth_user_blocked_exception.dart';
export 'auth_user/models/auth_user_model.dart';
export 'auth_user/models/auth_user_not_found_exception.dart';
export 'common/models/auth_strategy.dart';
export 'common/models/auth_success.dart';
export 'jwt/models/authentication_token_info.dart';
export 'jwt/models/refresh_token.dart';
export 'jwt/models/refresh_token_expired_exception.dart';
export 'jwt/models/refresh_token_invalid_secret_exception.dart';
export 'jwt/models/refresh_token_malformed_exception.dart';
export 'jwt/models/refresh_token_not_found_exception.dart';
export 'jwt/models/token_pair.dart';
export 'profile/models/user_profile.dart';
export 'profile/models/user_profile_data.dart';
export 'profile/models/user_profile_image.dart';
export 'profile/models/user_profile_model.dart';
export 'session/models/auth_session.dart';
export 'session/models/auth_session_info.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_core_jwt_refresh_token',
      dartName: 'RefreshToken',
      schema: 'public',
      module: 'serverpod_auth_core',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'scopeNames',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<String>',
        ),
        _i2.ColumnDefinition(
          name: 'extraClaims',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fixedSecret',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'rotatingSecretHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'rotatingSecretSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_core_jwt_refresh_token_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_core_jwt_refresh_token_pkey',
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
          indexName: 'serverpod_auth_core_jwt_refresh_token_last_updated_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'lastUpdatedAt',
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
      name: 'serverpod_auth_core_profile',
      dartName: 'UserProfile',
      schema: 'public',
      module: 'serverpod_auth_core',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
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
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'imageId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_core_profile_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_core_profile_fk_1',
          columns: ['imageId'],
          referenceTable: 'serverpod_auth_core_profile_image',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_core_profile_pkey',
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
          indexName: 'serverpod_auth_profile_user_profile_email_auth_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
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
      name: 'serverpod_auth_core_profile_image',
      dartName: 'UserProfileImage',
      schema: 'public',
      module: 'serverpod_auth_core',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'storageId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'path',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_core_profile_image_fk_0',
          columns: ['userProfileId'],
          referenceTable: 'serverpod_auth_core_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_core_profile_image_pkey',
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
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_auth_core_session',
      dartName: 'AuthSession',
      schema: 'public',
      module: 'serverpod_auth_core',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'scopeNames',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<String>',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'lastUsedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'expireAfterUnusedFor',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _i2.ColumnDefinition(
          name: 'sessionKeyHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'sessionKeySalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_core_session_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_core_session_pkey',
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
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_auth_core_user',
      dartName: 'AuthUser',
      schema: 'public',
      module: 'serverpod_auth_core',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'scopeNames',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<String>',
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
          indexName: 'serverpod_auth_core_user_pkey',
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
        )
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
    if (t == _i3.AuthUser) {
      return _i3.AuthUser.fromJson(data) as T;
    }
    if (t == _i4.AuthUserBlockedException) {
      return _i4.AuthUserBlockedException.fromJson(data) as T;
    }
    if (t == _i5.AuthUserModel) {
      return _i5.AuthUserModel.fromJson(data) as T;
    }
    if (t == _i6.AuthUserNotFoundException) {
      return _i6.AuthUserNotFoundException.fromJson(data) as T;
    }
    if (t == _i7.AuthStrategy) {
      return _i7.AuthStrategy.fromJson(data) as T;
    }
    if (t == _i8.AuthSuccess) {
      return _i8.AuthSuccess.fromJson(data) as T;
    }
    if (t == _i9.AuthenticationTokenInfo) {
      return _i9.AuthenticationTokenInfo.fromJson(data) as T;
    }
    if (t == _i10.RefreshToken) {
      return _i10.RefreshToken.fromJson(data) as T;
    }
    if (t == _i11.RefreshTokenExpiredException) {
      return _i11.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i12.RefreshTokenInvalidSecretException) {
      return _i12.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i13.RefreshTokenMalformedException) {
      return _i13.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i14.RefreshTokenNotFoundException) {
      return _i14.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i15.TokenPair) {
      return _i15.TokenPair.fromJson(data) as T;
    }
    if (t == _i16.UserProfile) {
      return _i16.UserProfile.fromJson(data) as T;
    }
    if (t == _i17.UserProfileData) {
      return _i17.UserProfileData.fromJson(data) as T;
    }
    if (t == _i18.UserProfileImage) {
      return _i18.UserProfileImage.fromJson(data) as T;
    }
    if (t == _i19.UserProfileModel) {
      return _i19.UserProfileModel.fromJson(data) as T;
    }
    if (t == _i20.AuthSession) {
      return _i20.AuthSession.fromJson(data) as T;
    }
    if (t == _i21.AuthSessionInfo) {
      return _i21.AuthSessionInfo.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.AuthUser?>()) {
      return (data != null ? _i3.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthUserBlockedException?>()) {
      return (data != null ? _i4.AuthUserBlockedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AuthUserModel?>()) {
      return (data != null ? _i5.AuthUserModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AuthUserNotFoundException?>()) {
      return (data != null
          ? _i6.AuthUserNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.AuthStrategy?>()) {
      return (data != null ? _i7.AuthStrategy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AuthSuccess?>()) {
      return (data != null ? _i8.AuthSuccess.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AuthenticationTokenInfo?>()) {
      return (data != null ? _i9.AuthenticationTokenInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.RefreshToken?>()) {
      return (data != null ? _i10.RefreshToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.RefreshTokenExpiredException?>()) {
      return (data != null
          ? _i11.RefreshTokenExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.RefreshTokenInvalidSecretException?>()) {
      return (data != null
          ? _i12.RefreshTokenInvalidSecretException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.RefreshTokenMalformedException?>()) {
      return (data != null
          ? _i13.RefreshTokenMalformedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.RefreshTokenNotFoundException?>()) {
      return (data != null
          ? _i14.RefreshTokenNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.TokenPair?>()) {
      return (data != null ? _i15.TokenPair.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserProfile?>()) {
      return (data != null ? _i16.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserProfileData?>()) {
      return (data != null ? _i17.UserProfileData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.UserProfileImage?>()) {
      return (data != null ? _i18.UserProfileImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.UserProfileModel?>()) {
      return (data != null ? _i19.UserProfileModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.AuthSession?>()) {
      return (data != null ? _i20.AuthSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.AuthSessionInfo?>()) {
      return (data != null ? _i21.AuthSessionInfo.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
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
      case _i3.AuthUser():
        return 'AuthUser';
      case _i4.AuthUserBlockedException():
        return 'AuthUserBlockedException';
      case _i5.AuthUserModel():
        return 'AuthUserModel';
      case _i6.AuthUserNotFoundException():
        return 'AuthUserNotFoundException';
      case _i7.AuthStrategy():
        return 'AuthStrategy';
      case _i8.AuthSuccess():
        return 'AuthSuccess';
      case _i9.AuthenticationTokenInfo():
        return 'AuthenticationTokenInfo';
      case _i10.RefreshToken():
        return 'RefreshToken';
      case _i11.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _i12.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i13.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _i14.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i15.TokenPair():
        return 'TokenPair';
      case _i16.UserProfile():
        return 'UserProfile';
      case _i17.UserProfileData():
        return 'UserProfileData';
      case _i18.UserProfileImage():
        return 'UserProfileImage';
      case _i19.UserProfileModel():
        return 'UserProfileModel';
      case _i20.AuthSession():
        return 'AuthSession';
      case _i21.AuthSessionInfo():
        return 'AuthSessionInfo';
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
    if (dataClassName == 'AuthUser') {
      return deserialize<_i3.AuthUser>(data['data']);
    }
    if (dataClassName == 'AuthUserBlockedException') {
      return deserialize<_i4.AuthUserBlockedException>(data['data']);
    }
    if (dataClassName == 'AuthUserModel') {
      return deserialize<_i5.AuthUserModel>(data['data']);
    }
    if (dataClassName == 'AuthUserNotFoundException') {
      return deserialize<_i6.AuthUserNotFoundException>(data['data']);
    }
    if (dataClassName == 'AuthStrategy') {
      return deserialize<_i7.AuthStrategy>(data['data']);
    }
    if (dataClassName == 'AuthSuccess') {
      return deserialize<_i8.AuthSuccess>(data['data']);
    }
    if (dataClassName == 'AuthenticationTokenInfo') {
      return deserialize<_i9.AuthenticationTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshToken') {
      return deserialize<_i10.RefreshToken>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i11.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i12.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i13.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i14.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i15.TokenPair>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i16.UserProfile>(data['data']);
    }
    if (dataClassName == 'UserProfileData') {
      return deserialize<_i17.UserProfileData>(data['data']);
    }
    if (dataClassName == 'UserProfileImage') {
      return deserialize<_i18.UserProfileImage>(data['data']);
    }
    if (dataClassName == 'UserProfileModel') {
      return deserialize<_i19.UserProfileModel>(data['data']);
    }
    if (dataClassName == 'AuthSession') {
      return deserialize<_i20.AuthSession>(data['data']);
    }
    if (dataClassName == 'AuthSessionInfo') {
      return deserialize<_i21.AuthSessionInfo>(data['data']);
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
      case _i3.AuthUser:
        return _i3.AuthUser.t;
      case _i10.RefreshToken:
        return _i10.RefreshToken.t;
      case _i16.UserProfile:
        return _i16.UserProfile.t;
      case _i18.UserProfileImage:
        return _i18.UserProfileImage.t;
      case _i20.AuthSession:
        return _i20.AuthSession.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_core';
}
