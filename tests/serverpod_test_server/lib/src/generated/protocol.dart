/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'nullability.dart' as _i2;
import 'object_field_scopes.dart' as _i3;
import 'object_with_bytedata.dart' as _i4;
import 'object_with_duration.dart' as _i5;
import 'object_with_enum.dart' as _i6;
import 'object_with_maps.dart' as _i7;
import 'object_with_object.dart' as _i8;
import 'serverOnly/default_server_only_class.dart' as _i9;
import 'default_server_only_enum.dart' as _i10;
import 'serverOnly/not_server_only_class.dart' as _i11;
import 'not_server_only_enum.dart' as _i12;
import 'serverOnly/server_only_class.dart' as _i13;
import 'server_only_enum.dart' as _i14;
import 'simple_data.dart' as _i15;
import 'simple_data_list.dart' as _i16;
import 'test_enum.dart' as _i17;
import 'types.dart' as _i18;
import 'protocol.dart' as _i19;
import 'dart:typed_data' as _i20;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i21;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i22;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i23;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i24;
import 'package:serverpod_test_module_server/module.dart' as _i25;
import 'package:serverpod_auth_server/module.dart' as _i26;
import 'package:serverpod/protocol.dart' as _i27;
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'serverOnly/default_server_only_class.dart';
export 'default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'not_server_only_enum.dart';
export 'serverOnly/server_only_class.dart';
export 'server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'test_enum.dart';
export 'types.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.Nullability) {
      return _i2.Nullability.fromJson(data, this) as T;
    }
    if (t == _i3.ObjectFieldScopes) {
      return _i3.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i4.ObjectWithByteData) {
      return _i4.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i5.ObjectWithDuration) {
      return _i5.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i6.ObjectWithEnum) {
      return _i6.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i7.ObjectWithMaps) {
      return _i7.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i8.ObjectWithObject) {
      return _i8.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i9.DefaultServerOnlyClass) {
      return _i9.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i10.DefaultServerOnlyEnum) {
      return _i10.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i11.NotServerOnlyClass) {
      return _i11.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i12.NotServerOnlyEnum) {
      return _i12.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i13.ServerOnlyClass) {
      return _i13.ServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i14.ServerOnlyEnum) {
      return _i14.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i15.SimpleData) {
      return _i15.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i16.SimpleDataList) {
      return _i16.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i17.TestEnum) {
      return _i17.TestEnum.fromJson(data) as T;
    }
    if (t == _i18.Types) {
      return _i18.Types.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Nullability?>()) {
      return (data != null ? _i2.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.ObjectFieldScopes?>()) {
      return (data != null ? _i3.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i4.ObjectWithByteData?>()) {
      return (data != null ? _i4.ObjectWithByteData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ObjectWithDuration?>()) {
      return (data != null ? _i5.ObjectWithDuration.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ObjectWithEnum?>()) {
      return (data != null ? _i6.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ObjectWithMaps?>()) {
      return (data != null ? _i7.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ObjectWithObject?>()) {
      return (data != null ? _i8.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i9.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i10.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i10.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.NotServerOnlyClass?>()) {
      return (data != null
          ? _i11.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i12.NotServerOnlyEnum?>()) {
      return (data != null ? _i12.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ServerOnlyClass?>()) {
      return (data != null ? _i13.ServerOnlyClass.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ServerOnlyEnum?>()) {
      return (data != null ? _i14.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.SimpleData?>()) {
      return (data != null ? _i15.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i16.SimpleDataList?>()) {
      return (data != null ? _i16.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.TestEnum?>()) {
      return (data != null ? _i17.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Types?>()) {
      return (data != null ? _i18.Types.fromJson(data, this) : null) as T;
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
    if (t == List<_i19.SimpleData>) {
      return (data as List).map((e) => deserialize<_i19.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i19.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i19.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i19.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i19.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i19.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i19.SimpleData?>(e)).toList()
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
    if (t == List<_i20.ByteData>) {
      return (data as List).map((e) => deserialize<_i20.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i20.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i20.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i20.ByteData?>) {
      return (data as List).map((e) => deserialize<_i20.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i20.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i20.ByteData?>(e)).toList()
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
    if (t == List<_i19.TestEnum>) {
      return (data as List).map((e) => deserialize<_i19.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i19.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i19.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i19.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i19.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i19.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i19.SimpleData>(v)))
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
    if (t == Map<String, _i20.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i20.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, _i19.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i19.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i20.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i20.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<List<_i19.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i19.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i19.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i19.SimpleData?>(e)).toList()
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
    if (t == List<_i20.ByteData>) {
      return (data as List).map((e) => deserialize<_i20.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i20.ByteData?>) {
      return (data as List).map((e) => deserialize<_i20.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i21.SimpleData>) {
      return (data as List).map((e) => deserialize<_i21.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i21.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i21.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i21.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i21.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i21.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i21.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i21.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i21.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i21.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i21.SimpleData?>(e)).toList()
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
    if (t == Map<_i22.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i22.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i22.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i22.TestEnum>(v)))
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
    if (t == Map<String, _i20.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i20.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i20.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i20.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i21.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i21.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i21.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i21.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i21.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i21.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i21.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i21.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i21.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i21.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i21.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i21.SimpleData?>(v)))
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
    if (t == _i23.CustomClass) {
      return _i23.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i24.ExternalCustomClass) {
      return _i24.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i24.FreezedCustomClass) {
      return _i24.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i23.CustomClass?>()) {
      return (data != null ? _i23.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i24.ExternalCustomClass?>()) {
      return (data != null
          ? _i24.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i24.FreezedCustomClass?>()) {
      return (data != null
          ? _i24.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i27.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i26.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i23.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i24.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i24.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.Nullability) {
      return 'Nullability';
    }
    if (data is _i3.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i4.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i5.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i6.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i7.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i8.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i9.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i10.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i11.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i12.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i13.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i14.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i15.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i16.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i17.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i18.Types) {
      return 'Types';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i25.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i26.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i23.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i24.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i24.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i2.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i3.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i4.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i5.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i6.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i7.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i8.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i9.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i10.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i11.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i12.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClass') {
      return deserialize<_i13.ServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'ServerOnlyEnum') {
      return deserialize<_i14.ServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i15.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i16.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i17.TestEnum>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i18.Types>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i25.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i26.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i27.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.ObjectFieldScopes:
        return _i3.ObjectFieldScopes.t;
      case _i4.ObjectWithByteData:
        return _i4.ObjectWithByteData.t;
      case _i5.ObjectWithDuration:
        return _i5.ObjectWithDuration.t;
      case _i6.ObjectWithEnum:
        return _i6.ObjectWithEnum.t;
      case _i8.ObjectWithObject:
        return _i8.ObjectWithObject.t;
      case _i15.SimpleData:
        return _i15.SimpleData.t;
      case _i18.Types:
        return _i18.Types.t;
    }
    return null;
  }
}
