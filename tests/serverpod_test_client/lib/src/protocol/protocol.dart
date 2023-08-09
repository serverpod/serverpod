/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'citizen.dart' as _i2;
import 'company.dart' as _i3;
import 'exception_with_data.dart' as _i4;
import 'module_datatype.dart' as _i5;
import 'nullability.dart' as _i6;
import 'object_field_scopes.dart' as _i7;
import 'object_with_bytedata.dart' as _i8;
import 'object_with_duration.dart' as _i9;
import 'object_with_enum.dart' as _i10;
import 'object_with_index.dart' as _i11;
import 'object_with_maps.dart' as _i12;
import 'object_with_object.dart' as _i13;
import 'object_with_parent.dart' as _i14;
import 'object_with_self_parent.dart' as _i15;
import 'object_with_uuid.dart' as _i16;
import 'serverOnly/default_server_only_class.dart' as _i17;
import 'serverOnly/default_server_only_enum.dart' as _i18;
import 'serverOnly/not_server_only_class.dart' as _i19;
import 'serverOnly/not_server_only_enum.dart' as _i20;
import 'simple_data.dart' as _i21;
import 'simple_data_list.dart' as _i22;
import 'test_enum.dart' as _i23;
import 'town.dart' as _i24;
import 'types.dart' as _i25;
import 'package:serverpod_test_module_client/module.dart' as _i26;
import 'protocol.dart' as _i27;
import 'dart:typed_data' as _i28;
import 'package:serverpod_test_client/src/protocol/citizen.dart' as _i29;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i30;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i31;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i32;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i33;
import 'package:serverpod_auth_client/module.dart' as _i34;
export 'citizen.dart';
export 'company.dart';
export 'exception_with_data.dart';
export 'module_datatype.dart';
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_index.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_self_parent.dart';
export 'object_with_uuid.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'test_enum.dart';
export 'town.dart';
export 'types.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
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
    if (t == _i2.Citizen) {
      return _i2.Citizen.fromJson(data, this) as T;
    }
    if (t == _i3.Company) {
      return _i3.Company.fromJson(data, this) as T;
    }
    if (t == _i4.ExceptionWithData) {
      return _i4.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i5.ModuleDatatype) {
      return _i5.ModuleDatatype.fromJson(data, this) as T;
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
    if (t == _i11.ObjectWithIndex) {
      return _i11.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i12.ObjectWithMaps) {
      return _i12.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i13.ObjectWithObject) {
      return _i13.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i14.ObjectWithParent) {
      return _i14.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i15.ObjectWithSelfParent) {
      return _i15.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i16.ObjectWithUuid) {
      return _i16.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i17.DefaultServerOnlyClass) {
      return _i17.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i18.DefaultServerOnlyEnum) {
      return _i18.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i19.NotServerOnlyClass) {
      return _i19.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i20.NotServerOnlyEnum) {
      return _i20.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i21.SimpleData) {
      return _i21.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i22.SimpleDataList) {
      return _i22.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i23.TestEnum) {
      return _i23.TestEnum.fromJson(data) as T;
    }
    if (t == _i24.Town) {
      return _i24.Town.fromJson(data, this) as T;
    }
    if (t == _i25.Types) {
      return _i25.Types.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Citizen?>()) {
      return (data != null ? _i2.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.Company?>()) {
      return (data != null ? _i3.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.ExceptionWithData?>()) {
      return (data != null ? _i4.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ModuleDatatype?>()) {
      return (data != null ? _i5.ModuleDatatype.fromJson(data, this) : null)
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
    if (t == _i1.getType<_i11.ObjectWithIndex?>()) {
      return (data != null ? _i11.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.ObjectWithMaps?>()) {
      return (data != null ? _i12.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i13.ObjectWithObject?>()) {
      return (data != null ? _i13.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ObjectWithParent?>()) {
      return (data != null ? _i14.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i15.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i16.ObjectWithUuid?>()) {
      return (data != null ? _i16.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i17.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i18.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i18.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.NotServerOnlyClass?>()) {
      return (data != null
          ? _i19.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i20.NotServerOnlyEnum?>()) {
      return (data != null ? _i20.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.SimpleData?>()) {
      return (data != null ? _i21.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i22.SimpleDataList?>()) {
      return (data != null ? _i22.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i23.TestEnum?>()) {
      return (data != null ? _i23.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Town?>()) {
      return (data != null ? _i24.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i25.Types?>()) {
      return (data != null ? _i25.Types.fromJson(data, this) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i26.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i26.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i26.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i26.ModuleClass>(v))) as dynamic;
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
    if (t == List<_i27.SimpleData>) {
      return (data as List).map((e) => deserialize<_i27.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i27.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i27.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i27.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i27.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i27.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i27.SimpleData?>(e)).toList()
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
    if (t == List<_i28.ByteData>) {
      return (data as List).map((e) => deserialize<_i28.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i28.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i28.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i28.ByteData?>) {
      return (data as List).map((e) => deserialize<_i28.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i28.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i28.ByteData?>(e)).toList()
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
    if (t == List<_i27.TestEnum>) {
      return (data as List).map((e) => deserialize<_i27.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i27.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i27.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i27.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i27.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i27.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i27.SimpleData>(v)))
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
    if (t == Map<String, _i28.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i28.ByteData>(v)))
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
    if (t == Map<String, _i27.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i27.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i28.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i28.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i27.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i27.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i27.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i27.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i29.Citizen>) {
      return (data as List).map((e) => deserialize<_i29.Citizen>(e)).toList()
          as dynamic;
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
    if (t == List<_i28.ByteData>) {
      return (data as List).map((e) => deserialize<_i28.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i28.ByteData?>) {
      return (data as List).map((e) => deserialize<_i28.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i30.SimpleData>) {
      return (data as List).map((e) => deserialize<_i30.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i30.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i30.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i30.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i30.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i30.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i30.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i30.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i30.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i30.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i30.SimpleData?>(e)).toList()
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
    if (t == Map<_i31.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i31.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i31.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i31.TestEnum>(v)))
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
    if (t == Map<String, _i28.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i28.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i28.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i28.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i30.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i30.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i30.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i30.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i30.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i30.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i30.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i30.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i30.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i30.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i30.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i30.SimpleData?>(v)))
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
    if (t == _i32.CustomClass) {
      return _i32.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i33.ExternalCustomClass) {
      return _i33.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i33.FreezedCustomClass) {
      return _i33.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i32.CustomClass?>()) {
      return (data != null ? _i32.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i33.ExternalCustomClass?>()) {
      return (data != null
          ? _i33.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i33.FreezedCustomClass?>()) {
      return (data != null
          ? _i33.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i34.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i26.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i34.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i32.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i33.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i33.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.Citizen) {
      return 'Citizen';
    }
    if (data is _i3.Company) {
      return 'Company';
    }
    if (data is _i4.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i5.ModuleDatatype) {
      return 'ModuleDatatype';
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
    if (data is _i11.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i12.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i13.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i14.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i15.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i16.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i17.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i18.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i19.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i20.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i21.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i22.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i23.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i24.Town) {
      return 'Town';
    }
    if (data is _i25.Types) {
      return 'Types';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i26.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i34.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i32.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i33.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i33.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i2.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i3.Company>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i4.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i5.ModuleDatatype>(data['data']);
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
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i11.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i12.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i13.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i14.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i15.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i16.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i17.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i18.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i19.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i20.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i21.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i22.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i23.TestEnum>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i24.Town>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i25.Types>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
