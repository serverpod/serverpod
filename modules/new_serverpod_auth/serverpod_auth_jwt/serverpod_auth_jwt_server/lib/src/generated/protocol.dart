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
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i3;
import 'authentication_token_info.dart' as _i4;
import 'refresh_token.dart' as _i5;
import 'refresh_token_expired_exception.dart' as _i6;
import 'refresh_token_invalid_secret_exception.dart' as _i7;
import 'refresh_token_malformed_exception.dart' as _i8;
import 'refresh_token_not_found_exception.dart' as _i9;
import 'token_pair.dart' as _i10;
export 'authentication_token_info.dart';
export 'refresh_token.dart';
export 'refresh_token_expired_exception.dart';
export 'refresh_token_invalid_secret_exception.dart';
export 'refresh_token_malformed_exception.dart';
export 'refresh_token_not_found_exception.dart';
export 'token_pair.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_jwt_refresh_token',
      dartName: 'RefreshToken',
      schema: 'public',
      module: 'serverpod_auth_jwt',
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
          name: 'lastUpdated',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'created',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_jwt_refresh_token_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_jwt_refresh_token_pkey',
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
          indexName: 'serverpod_auth_jwt_refresh_token_last_updated',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'lastUpdated',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.AuthenticationTokenInfo) {
      return _i4.AuthenticationTokenInfo.fromJson(data) as T;
    }
    if (t == _i5.RefreshToken) {
      return _i5.RefreshToken.fromJson(data) as T;
    }
    if (t == _i6.RefreshTokenExpiredException) {
      return _i6.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i7.RefreshTokenInvalidSecretException) {
      return _i7.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i8.RefreshTokenMalformedException) {
      return _i8.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i9.RefreshTokenNotFoundException) {
      return _i9.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i10.TokenPair) {
      return _i10.TokenPair.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.AuthenticationTokenInfo?>()) {
      return (data != null ? _i4.AuthenticationTokenInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.RefreshToken?>()) {
      return (data != null ? _i5.RefreshToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.RefreshTokenExpiredException?>()) {
      return (data != null
          ? _i6.RefreshTokenExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.RefreshTokenInvalidSecretException?>()) {
      return (data != null
          ? _i7.RefreshTokenInvalidSecretException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.RefreshTokenMalformedException?>()) {
      return (data != null
          ? _i8.RefreshTokenMalformedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.RefreshTokenNotFoundException?>()) {
      return (data != null
          ? _i9.RefreshTokenNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.TokenPair?>()) {
      return (data != null ? _i10.TokenPair.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
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
      case _i4.AuthenticationTokenInfo():
        return 'AuthenticationTokenInfo';
      case _i5.RefreshToken():
        return 'RefreshToken';
      case _i6.RefreshTokenExpiredException():
        return 'RefreshTokenExpiredException';
      case _i7.RefreshTokenInvalidSecretException():
        return 'RefreshTokenInvalidSecretException';
      case _i8.RefreshTokenMalformedException():
        return 'RefreshTokenMalformedException';
      case _i9.RefreshTokenNotFoundException():
        return 'RefreshTokenNotFoundException';
      case _i10.TokenPair():
        return 'TokenPair';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_user.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthenticationTokenInfo') {
      return deserialize<_i4.AuthenticationTokenInfo>(data['data']);
    }
    if (dataClassName == 'RefreshToken') {
      return deserialize<_i5.RefreshToken>(data['data']);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i6.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i7.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i8.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i9.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i10.TokenPair>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.RefreshToken:
        return _i5.RefreshToken.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_jwt';
}
