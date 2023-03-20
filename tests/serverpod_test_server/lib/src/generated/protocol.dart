/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_test_module_server/module.dart' as _i3;
import 'package:serverpod_auth_server/module.dart' as _i4;
import 'exception_with_data.dart' as _i5;
import 'nullability.dart' as _i6;
import 'object_field_scopes.dart' as _i7;
import 'object_with_bytedata.dart' as _i8;
import 'object_with_duration.dart' as _i9;
import 'object_with_enum.dart' as _i10;
import 'object_with_maps.dart' as _i11;
import 'object_with_object.dart' as _i12;
import 'object_with_uuid.dart' as _i13;
import 'serverOnly/default_server_only_class.dart' as _i14;
import 'serverOnly/default_server_only_enum.dart' as _i15;
import 'serverOnly/not_server_only_class.dart' as _i16;
import 'serverOnly/not_server_only_enum.dart' as _i17;
import 'serverOnly/server_only_class.dart' as _i18;
import 'serverOnly/server_only_enum.dart' as _i19;
import 'simple_data.dart' as _i20;
import 'simple_data_list.dart' as _i21;
import 'test_enum.dart' as _i22;
import 'types.dart' as _i23;
import 'protocol.dart' as _i24;
import 'dart:typed_data' as _i25;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i26;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i27;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i28;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i29;
export 'exception_with_data.dart';
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_uuid.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'serverOnly/server_only_class.dart';
export 'serverOnly/server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'test_enum.dart';
export 'types.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final desiredDatabaseStructure = _i2.DatabaseDefinition(tables: [
    _i2.TableDefinition(
      name: 'object_field_scopes',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'normal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'api',
          columnType: _i2.ColumnType.text,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'database',
          columnType: _i2.ColumnType.text,
          isNullable: true,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_field_scopes_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'object_with_bytedata',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'byteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_bytedata_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'object_with_duration',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_duration_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'object_with_enum',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'testEnum',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnum',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'enumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'enumListList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_enum_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'object_with_object',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'data',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'nullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'dataList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'nullableDataList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'listWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'nullableListWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_object_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'object_with_uuid',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
        ),
        _i2.ColumnDefinition(
          name: 'uuidNullable',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_uuid_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'simple_data',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'num',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'simple_data_pkey',
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
    ),
    _i2.TableDefinition(
      name: 'types',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'anInt',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aBool',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aDouble',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aDateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aString',
          columnType: _i2.ColumnType.text,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aByteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aDuration',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
        ),
        _i2.ColumnDefinition(
          name: 'aUuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'types_pkey',
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
    ),
    ..._i3.Protocol.desiredDatabaseStructure.tables,
    ..._i4.Protocol.desiredDatabaseStructure.tables,
    ..._i2.Protocol.desiredDatabaseStructure.tables,
  ]);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i5.ExceptionWithData) {
      return _i5.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i6.Nullability) {
      return _i6.Nullability.fromJson(data, this) as T;
    }
    if (t == _i7.ObjectFieldScopes) {
      return _i7.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i8.ObjectWithByteData) {
      return _i8.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i9.ObjectWithDuration) {
      return _i9.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i10.ObjectWithEnum) {
      return _i10.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i11.ObjectWithMaps) {
      return _i11.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i12.ObjectWithObject) {
      return _i12.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i13.ObjectWithUuid) {
      return _i13.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i14.DefaultServerOnlyClass) {
      return _i14.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i15.DefaultServerOnlyEnum) {
      return _i15.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i16.NotServerOnlyClass) {
      return _i16.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i17.NotServerOnlyEnum) {
      return _i17.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i18.ServerOnlyClass) {
      return _i18.ServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i19.ServerOnlyEnum) {
      return _i19.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i20.SimpleData) {
      return _i20.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i21.SimpleDataList) {
      return _i21.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i22.TestEnum) {
      return _i22.TestEnum.fromJson(data) as T;
    }
    if (t == _i23.Types) {
      return _i23.Types.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i5.ExceptionWithData?>()) {
      return (data != null ? _i5.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.Nullability?>()) {
      return (data != null ? _i6.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.ObjectFieldScopes?>()) {
      return (data != null ? _i7.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ObjectWithByteData?>()) {
      return (data != null ? _i8.ObjectWithByteData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.ObjectWithDuration?>()) {
      return (data != null ? _i9.ObjectWithDuration.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ObjectWithEnum?>()) {
      return (data != null ? _i10.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i11.ObjectWithMaps?>()) {
      return (data != null ? _i11.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.ObjectWithObject?>()) {
      return (data != null ? _i12.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i13.ObjectWithUuid?>()) {
      return (data != null ? _i13.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i14.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i15.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i15.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.NotServerOnlyClass?>()) {
      return (data != null
          ? _i16.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i17.NotServerOnlyEnum?>()) {
      return (data != null ? _i17.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ServerOnlyClass?>()) {
      return (data != null ? _i18.ServerOnlyClass.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ServerOnlyEnum?>()) {
      return (data != null ? _i19.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.SimpleData?>()) {
      return (data != null ? _i20.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i21.SimpleDataList?>()) {
      return (data != null ? _i21.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i22.TestEnum?>()) {
      return (data != null ? _i22.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Types?>()) {
      return (data != null ? _i23.Types.fromJson(data, this) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i24.SimpleData>) {
      return (data as List).map((e) => deserialize<_i24.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i24.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i24.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i24.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i24.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i24.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i24.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i25.ByteData>) {
      return (data as List).map((e) => deserialize<_i25.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i25.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i25.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i25.ByteData?>) {
      return (data as List).map((e) => deserialize<_i25.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i25.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i25.ByteData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue?>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == List<_i24.TestEnum>) {
      return (data as List).map((e) => deserialize<_i24.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i24.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i24.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i24.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i24.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i24.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i24.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
    if (t == Map<String, _i25.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i25.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)))
          as dynamic;
    }
    if (t == Map<String, _i24.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i24.SimpleData?>(v))) as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i25.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i25.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue?>(v)))
          as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<List<_i24.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i24.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i24.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i24.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i25.ByteData>) {
      return (data as List).map((e) => deserialize<_i25.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i25.ByteData?>) {
      return (data as List).map((e) => deserialize<_i25.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i26.SimpleData>) {
      return (data as List).map((e) => deserialize<_i26.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i26.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i26.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i26.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i26.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i26.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i26.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i26.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i26.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i26.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i26.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<Map<String, int>>(v))) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<_i27.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i27.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i27.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i27.TestEnum>(v)))
          as dynamic;
    }
    if (t == Map<String, double>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double>(v))) as dynamic;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double?>(v))) as dynamic;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          as dynamic;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool?>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i25.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i25.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i25.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i25.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i26.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i26.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i26.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i26.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i26.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i26.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i26.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i26.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i26.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i26.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i26.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i26.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == _i28.CustomClass) {
      return _i28.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i29.ExternalCustomClass) {
      return _i29.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i29.FreezedCustomClass) {
      return _i29.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i28.CustomClass?>()) {
      return (data != null ? _i28.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i29.ExternalCustomClass?>()) {
      return (data != null
          ? _i29.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i29.FreezedCustomClass?>()) {
      return (data != null
          ? _i29.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i28.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i29.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i29.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i5.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i6.Nullability) {
      return 'Nullability';
    }
    if (data is _i7.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i8.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i9.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i10.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i11.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i12.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i13.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i14.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i15.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i16.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i17.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i18.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i19.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i20.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i21.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i22.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i23.Types) {
      return 'Types';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i28.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i29.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i29.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i5.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i6.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i7.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i8.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i9.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i10.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i11.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i12.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i13.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i14.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i15.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i16.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i17.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClass') {
      return deserialize<_i18.ServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'ServerOnlyEnum') {
      return deserialize<_i19.ServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i20.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i21.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i22.TestEnum>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i23.Types>(data['data']);
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
      var table = _i4.Protocol().getTableForType(t);
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
      case _i7.ObjectFieldScopes:
        return _i7.ObjectFieldScopes.t;
      case _i8.ObjectWithByteData:
        return _i8.ObjectWithByteData.t;
      case _i9.ObjectWithDuration:
        return _i9.ObjectWithDuration.t;
      case _i10.ObjectWithEnum:
        return _i10.ObjectWithEnum.t;
      case _i12.ObjectWithObject:
        return _i12.ObjectWithObject.t;
      case _i13.ObjectWithUuid:
        return _i13.ObjectWithUuid.t;
      case _i20.SimpleData:
        return _i20.SimpleData.t;
      case _i23.Types:
        return _i23.Types.t;
    }
    return null;
  }
}
