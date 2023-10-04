/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'entities_with_relations/address.dart' as _i2;
import 'entities_with_relations/citizen.dart' as _i3;
import 'entities_with_relations/company.dart' as _i4;
import 'entities_with_relations/post.dart' as _i5;
import 'entities_with_relations/town.dart' as _i6;
import 'exception_with_data.dart' as _i7;
import 'module_datatype.dart' as _i8;
import 'nullability.dart' as _i9;
import 'object_field_scopes.dart' as _i10;
import 'object_with_bytedata.dart' as _i11;
import 'object_with_duration.dart' as _i12;
import 'object_with_enum.dart' as _i13;
import 'object_with_index.dart' as _i14;
import 'object_with_maps.dart' as _i15;
import 'object_with_object.dart' as _i16;
import 'object_with_parent.dart' as _i17;
import 'object_with_self_parent.dart' as _i18;
import 'object_with_uuid.dart' as _i19;
import 'related_unique_data.dart' as _i20;
import 'serverOnly/default_server_only_class.dart' as _i21;
import 'serverOnly/default_server_only_enum.dart' as _i22;
import 'serverOnly/not_server_only_class.dart' as _i23;
import 'serverOnly/not_server_only_enum.dart' as _i24;
import 'simple_data.dart' as _i25;
import 'simple_data_list.dart' as _i26;
import 'simple_data_map.dart' as _i27;
import 'simple_date_time.dart' as _i28;
import 'test_enum.dart' as _i29;
import 'types.dart' as _i30;
import 'unique_data.dart' as _i31;
import 'protocol.dart' as _i32;
import 'package:serverpod_test_module_client/module.dart' as _i33;
import 'dart:typed_data' as _i34;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i35;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i36;
import 'package:uuid/uuid.dart' as _i37;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i38;
import 'package:serverpod_test_client/src/protocol/unique_data.dart' as _i39;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/citizen.dart'
    as _i40;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/address.dart'
    as _i41;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/post.dart'
    as _i42;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/company.dart'
    as _i43;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i44;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i45;
import 'package:serverpod_auth_client/module.dart' as _i46;
export 'entities_with_relations/address.dart';
export 'entities_with_relations/citizen.dart';
export 'entities_with_relations/company.dart';
export 'entities_with_relations/post.dart';
export 'entities_with_relations/town.dart';
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
export 'related_unique_data.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'simple_data_map.dart';
export 'simple_date_time.dart';
export 'test_enum.dart';
export 'types.dart';
export 'unique_data.dart';
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
    if (t == _i2.Address) {
      return _i2.Address.fromJson(data, this) as T;
    }
    if (t == _i3.Citizen) {
      return _i3.Citizen.fromJson(data, this) as T;
    }
    if (t == _i4.Company) {
      return _i4.Company.fromJson(data, this) as T;
    }
    if (t == _i5.Post) {
      return _i5.Post.fromJson(data, this) as T;
    }
    if (t == _i6.Town) {
      return _i6.Town.fromJson(data, this) as T;
    }
    if (t == _i7.ExceptionWithData) {
      return _i7.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i8.ModuleDatatype) {
      return _i8.ModuleDatatype.fromJson(data, this) as T;
    }
    if (t == _i9.Nullability) {
      return _i9.Nullability.fromJson(data, this) as T;
    }
    if (t == _i10.ObjectFieldScopes) {
      return _i10.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i11.ObjectWithByteData) {
      return _i11.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i12.ObjectWithDuration) {
      return _i12.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i13.ObjectWithEnum) {
      return _i13.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i14.ObjectWithIndex) {
      return _i14.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i15.ObjectWithMaps) {
      return _i15.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i16.ObjectWithObject) {
      return _i16.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i17.ObjectWithParent) {
      return _i17.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i18.ObjectWithSelfParent) {
      return _i18.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i19.ObjectWithUuid) {
      return _i19.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i20.RelatedUniqueData) {
      return _i20.RelatedUniqueData.fromJson(data, this) as T;
    }
    if (t == _i21.DefaultServerOnlyClass) {
      return _i21.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i22.DefaultServerOnlyEnum) {
      return _i22.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i23.NotServerOnlyClass) {
      return _i23.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i24.NotServerOnlyEnum) {
      return _i24.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i25.SimpleData) {
      return _i25.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i26.SimpleDataList) {
      return _i26.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i27.SimpleDataMap) {
      return _i27.SimpleDataMap.fromJson(data, this) as T;
    }
    if (t == _i28.SimpleDateTime) {
      return _i28.SimpleDateTime.fromJson(data, this) as T;
    }
    if (t == _i29.TestEnum) {
      return _i29.TestEnum.fromJson(data) as T;
    }
    if (t == _i30.Types) {
      return _i30.Types.fromJson(data, this) as T;
    }
    if (t == _i31.UniqueData) {
      return _i31.UniqueData.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Address?>()) {
      return (data != null ? _i2.Address.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.Citizen?>()) {
      return (data != null ? _i3.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.Company?>()) {
      return (data != null ? _i4.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.Post?>()) {
      return (data != null ? _i5.Post.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.Town?>()) {
      return (data != null ? _i6.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.ExceptionWithData?>()) {
      return (data != null ? _i7.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ModuleDatatype?>()) {
      return (data != null ? _i8.ModuleDatatype.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.Nullability?>()) {
      return (data != null ? _i9.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i10.ObjectFieldScopes?>()) {
      return (data != null ? _i10.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i11.ObjectWithByteData?>()) {
      return (data != null
          ? _i11.ObjectWithByteData.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i12.ObjectWithDuration?>()) {
      return (data != null
          ? _i12.ObjectWithDuration.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i13.ObjectWithEnum?>()) {
      return (data != null ? _i13.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ObjectWithIndex?>()) {
      return (data != null ? _i14.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ObjectWithMaps?>()) {
      return (data != null ? _i15.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i16.ObjectWithObject?>()) {
      return (data != null ? _i16.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.ObjectWithParent?>()) {
      return (data != null ? _i17.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i18.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i18.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i19.ObjectWithUuid?>()) {
      return (data != null ? _i19.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i20.RelatedUniqueData?>()) {
      return (data != null ? _i20.RelatedUniqueData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i21.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i21.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i22.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i22.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.NotServerOnlyClass?>()) {
      return (data != null
          ? _i23.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i24.NotServerOnlyEnum?>()) {
      return (data != null ? _i24.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.SimpleData?>()) {
      return (data != null ? _i25.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i26.SimpleDataList?>()) {
      return (data != null ? _i26.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i27.SimpleDataMap?>()) {
      return (data != null ? _i27.SimpleDataMap.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i28.SimpleDateTime?>()) {
      return (data != null ? _i28.SimpleDateTime.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i29.TestEnum?>()) {
      return (data != null ? _i29.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Types?>()) {
      return (data != null ? _i30.Types.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i31.UniqueData?>()) {
      return (data != null ? _i31.UniqueData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<List<_i32.Citizen>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i32.Citizen>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i33.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i33.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i33.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i33.ModuleClass>(v))) as dynamic;
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
    if (t == List<_i32.SimpleData>) {
      return (data as List).map((e) => deserialize<_i32.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i32.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i32.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i32.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i32.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i32.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i32.SimpleData?>(e)).toList()
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
    if (t == List<_i34.ByteData>) {
      return (data as List).map((e) => deserialize<_i34.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i34.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i34.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i34.ByteData?>) {
      return (data as List).map((e) => deserialize<_i34.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i34.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i34.ByteData?>(e)).toList()
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
    if (t == List<_i32.TestEnum>) {
      return (data as List).map((e) => deserialize<_i32.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i32.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i32.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i32.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i32.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i32.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i32.SimpleData>(v)))
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
    if (t == Map<String, _i34.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i34.ByteData>(v)))
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
    if (t == Map<String, _i32.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i32.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i34.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i34.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i32.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i32.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i32.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i32.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i35.Types>) {
      return (data as List).map((e) => deserialize<_i35.Types>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == List<_i36.TestEnum>) {
      return (data as List).map((e) => deserialize<_i36.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i37.UuidValue>) {
      return (data as List).map((e) => deserialize<_i37.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == List<_i38.SimpleData>) {
      return (data as List).map((e) => deserialize<_i38.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i39.UniqueData>) {
      return (data as List).map((e) => deserialize<_i39.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i40.Citizen>) {
      return (data as List).map((e) => deserialize<_i40.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i41.Address>) {
      return (data as List).map((e) => deserialize<_i41.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i42.Post>) {
      return (data as List).map((e) => deserialize<_i42.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i43.Company>) {
      return (data as List).map((e) => deserialize<_i43.Company>(e)).toList()
          as dynamic;
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
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i34.ByteData>) {
      return (data as List).map((e) => deserialize<_i34.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i34.ByteData?>) {
      return (data as List).map((e) => deserialize<_i34.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i38.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i38.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i38.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i38.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i38.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i38.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i38.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i38.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i38.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i38.SimpleData?>(e)).toList()
          : null) as dynamic;
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
    if (t == Map<_i36.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i36.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i36.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i36.TestEnum>(v)))
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
    if (t == Map<String, _i34.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i34.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i34.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i34.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i38.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i38.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i38.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i38.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i38.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i38.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i38.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i38.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i38.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i38.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i38.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i38.SimpleData?>(v)))
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
    if (t == _i44.CustomClass) {
      return _i44.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i45.ExternalCustomClass) {
      return _i45.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i45.FreezedCustomClass) {
      return _i45.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i44.CustomClass?>()) {
      return (data != null ? _i44.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i45.ExternalCustomClass?>()) {
      return (data != null
          ? _i45.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i45.FreezedCustomClass?>()) {
      return (data != null
          ? _i45.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i33.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i46.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i33.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i46.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i44.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i45.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i45.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.Address) {
      return 'Address';
    }
    if (data is _i3.Citizen) {
      return 'Citizen';
    }
    if (data is _i4.Company) {
      return 'Company';
    }
    if (data is _i5.Post) {
      return 'Post';
    }
    if (data is _i6.Town) {
      return 'Town';
    }
    if (data is _i7.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i8.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i9.Nullability) {
      return 'Nullability';
    }
    if (data is _i10.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i11.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i12.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i13.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i14.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i15.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i16.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i17.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i18.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i19.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i20.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i21.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i22.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i23.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i24.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i25.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i26.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i27.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i28.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i29.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i30.Types) {
      return 'Types';
    }
    if (data is _i31.UniqueData) {
      return 'UniqueData';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i33.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i46.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i44.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i45.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i45.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i2.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i3.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i4.Company>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i5.Post>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i6.Town>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i7.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i8.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i9.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i10.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i11.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i12.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i13.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i14.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i15.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i16.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i17.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i18.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i19.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i20.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i21.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i22.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i23.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i24.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i25.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i26.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i27.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i28.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i29.TestEnum>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i30.Types>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i31.UniqueData>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
