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
import 'auth_user.dart' as _i3;
import 'auth_user_blocked_exception.dart' as _i4;
import 'auth_user_model.dart' as _i5;
import 'auth_user_not_found_exception.dart' as _i6;
export 'auth_user.dart';
export 'auth_user_blocked_exception.dart';
export 'auth_user_model.dart';
export 'auth_user_not_found_exception.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_user',
      dartName: 'AuthUser',
      schema: 'public',
      module: 'serverpod_auth_user',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'created',
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
          indexName: 'serverpod_auth_user_pkey',
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
    )
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
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_user';
}
