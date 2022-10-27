/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'nullability.dart' as _i2;
import 'object_field_scopes.dart' as _i3;
import 'object_with_enum.dart' as _i4;
import 'object_with_maps.dart' as _i5;
import 'object_with_object.dart' as _i6;
import 'simple_data.dart' as _i7;
import 'simple_data_list.dart' as _i8;
import 'test_enum.dart' as _i9;
import 'types.dart' as _i10;
import 'protocol.dart' as _i11;
import 'dart:typed_data' as _i12;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i13;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i14;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i15;
import 'package:serverpod_test_module_client/module.dart' as _i16;
import 'package:serverpod_auth_client/module.dart' as _i17;
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_enum.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'test_enum.dart';
export 'types.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserializeJson<T>(
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
    if (t == _i4.ObjectWithEnum) {
      return _i4.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i5.ObjectWithMaps) {
      return _i5.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i6.ObjectWithObject) {
      return _i6.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i7.SimpleData) {
      return _i7.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i8.SimpleDataList) {
      return _i8.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i9.TestEnum) {
      return _i9.TestEnum.fromJson(data) as T;
    }
    if (t == _i10.Types) {
      return _i10.Types.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Nullability?>()) {
      return (data != null ? _i2.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.ObjectFieldScopes?>()) {
      return (data != null ? _i3.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i4.ObjectWithEnum?>()) {
      return (data != null ? _i4.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ObjectWithMaps?>()) {
      return (data != null ? _i5.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ObjectWithObject?>()) {
      return (data != null ? _i6.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i7.SimpleData?>()) {
      return (data != null ? _i7.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.SimpleDataList?>()) {
      return (data != null ? _i8.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.TestEnum?>()) {
      return (data != null ? _i9.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Types?>()) {
      return (data != null ? _i10.Types.fromJson(data, this) : null) as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserializeJson<int>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserializeJson<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i11.SimpleData>) {
      return (data as List)
          .map((e) => deserializeJson<_i11.SimpleData>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i11.SimpleData>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i11.SimpleData>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i11.SimpleData?>) {
      return (data as List)
          .map((e) => deserializeJson<_i11.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i11.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i11.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserializeJson<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<DateTime>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserializeJson<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<DateTime?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i12.ByteData>) {
      return (data as List)
          .map((e) => deserializeJson<_i12.ByteData>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i12.ByteData>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i12.ByteData>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i12.ByteData?>) {
      return (data as List)
          .map((e) => deserializeJson<_i12.ByteData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i12.ByteData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i12.ByteData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int?>(v)))
          : null) as dynamic;
    }
    if (t == List<_i11.TestEnum>) {
      return (data as List)
          .map((e) => deserializeJson<_i11.TestEnum>(e))
          .toList() as dynamic;
    }
    if (t == List<_i11.TestEnum?>) {
      return (data as List)
          .map((e) => deserializeJson<_i11.TestEnum?>(e))
          .toList() as dynamic;
    }
    if (t == List<List<_i11.TestEnum>>) {
      return (data as List)
          .map((e) => deserializeJson<List<_i11.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i11.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i11.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<String>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) => MapEntry(
          deserializeJson<String>(k), deserializeJson<DateTime>(v))) as dynamic;
    }
    if (t == Map<String, _i12.ByteData>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i12.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i11.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i11.SimpleData?>(v)))
          as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<String?>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i12.ByteData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i12.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserializeJson<int>(e['k']), deserializeJson<int>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<List<_i11.SimpleData>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i11.SimpleData>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i11.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i11.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserializeJson<int>(e)).toList()
          as dynamic;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserializeJson<List<int>>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserializeJson<List<int>?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserializeJson<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserializeJson<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserializeJson<double>(e)).toList()
          as dynamic;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserializeJson<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserializeJson<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserializeJson<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserializeJson<String>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserializeJson<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserializeJson<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserializeJson<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i12.ByteData>) {
      return (data as List)
          .map((e) => deserializeJson<_i12.ByteData>(e))
          .toList() as dynamic;
    }
    if (t == List<_i12.ByteData?>) {
      return (data as List)
          .map((e) => deserializeJson<_i12.ByteData?>(e))
          .toList() as dynamic;
    }
    if (t == List<_i13.SimpleData>) {
      return (data as List)
          .map((e) => deserializeJson<_i13.SimpleData>(e))
          .toList() as dynamic;
    }
    if (t == List<_i13.SimpleData?>) {
      return (data as List)
          .map((e) => deserializeJson<_i13.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i13.SimpleData>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.SimpleData>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i13.SimpleData>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.SimpleData>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i13.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i13.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<Map<String, int>>(v)))
          as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<int?>(v)))
          : null) as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserializeJson<int>(e['k']), deserializeJson<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<_i14.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserializeJson<_i14.TestEnum>(e['k']),
          deserializeJson<int>(e['v'])))) as dynamic;
    }
    if (t == Map<String, _i14.TestEnum>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i14.TestEnum>(v)))
          as dynamic;
    }
    if (t == Map<String, double>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<double>(v)))
          as dynamic;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<double?>(v)))
          as dynamic;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<bool>(v)))
          as dynamic;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<bool?>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<String>(v)))
          as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserializeJson<String>(k), deserializeJson<String?>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) => MapEntry(
          deserializeJson<String>(k), deserializeJson<DateTime>(v))) as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i12.ByteData>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i12.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i12.ByteData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i12.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i13.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i13.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, _i13.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i13.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i13.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i13.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserializeJson<String>(k), deserializeJson<_i13.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i15.CustomClass) {
      return _i15.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i15.CustomClass?>()) {
      return (data != null ? _i15.CustomClass.fromJson(data, this) : null) as T;
    }
    try {
      return _i16.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    try {
      return _i17.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    return super.deserializeJson<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i16.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i17.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i15.CustomClass) {
      return 'customClass';
    }
    if (data is _i2.Nullability) {
      return 'Nullability';
    }
    if (data is _i3.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i4.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i5.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i6.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i7.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i8.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i9.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i10.Types) {
      return 'Types';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i16.Protocol().deserializeJsonByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i17.Protocol().deserializeJsonByClassName(data);
    }
    if (data['className'] == 'customClass') {
      return deserializeJson<_i15.CustomClass>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserializeJson<_i2.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserializeJson<_i3.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserializeJson<_i4.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserializeJson<_i5.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserializeJson<_i6.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserializeJson<_i7.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserializeJson<_i8.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserializeJson<_i9.TestEnum>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserializeJson<_i10.Types>(data['data']);
    }
    return super.deserializeJsonByClassName(data);
  }
}
