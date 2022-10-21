/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
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
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i13;
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_enum.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'test_enum.dart';
export 'types.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.Nullability:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i2.Nullability.fromJson(jsonSerialization, serializationManager),
    _i3.ObjectFieldScopes: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i3.ObjectFieldScopes.fromJson(jsonSerialization, serializationManager),
    _i4.ObjectWithEnum: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i4.ObjectWithEnum.fromJson(jsonSerialization, serializationManager),
    _i5.ObjectWithMaps: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i5.ObjectWithMaps.fromJson(jsonSerialization, serializationManager),
    _i6.ObjectWithObject: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i6.ObjectWithObject.fromJson(jsonSerialization, serializationManager),
    _i7.SimpleData:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i7.SimpleData.fromJson(jsonSerialization, serializationManager),
    _i8.SimpleDataList: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i8.SimpleDataList.fromJson(jsonSerialization, serializationManager),
    _i9.TestEnum:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i9.TestEnum.fromJson(jsonSerialization),
    _i10.Types:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i10.Types.fromJson(jsonSerialization, serializationManager),
    _i1.getType<_i2.Nullability?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i2.Nullability.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i3.ObjectFieldScopes?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i3.ObjectFieldScopes.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i4.ObjectWithEnum?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i4.ObjectWithEnum.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i5.ObjectWithMaps?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i5.ObjectWithMaps.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i6.ObjectWithObject?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i6.ObjectWithObject.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i7.SimpleData?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i7.SimpleData.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i8.SimpleDataList?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i8.SimpleDataList.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i9.TestEnum?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i9.TestEnum.fromJson(jsonSerialization)
                : null,
    _i1.getType<_i10.Types?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i10.Types.fromJson(jsonSerialization, serializationManager)
                : null,
    List<int>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<int>(e))
                .toList(),
    _i1.getType<List<int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int>(e))
                    .toList()
                : null,
    List<int?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<int?>(e))
                .toList(),
    _i1.getType<List<int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int?>(e))
                    .toList()
                : null,
    List<_i11.SimpleData>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map(
                (e) => serializationManager.deserializeJson<_i11.SimpleData>(e))
            .toList(),
    _i1.getType<List<_i11.SimpleData>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i11.SimpleData>(e))
                .toList()
            : null,
    List<_i11.SimpleData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i11.SimpleData?>(e))
                .toList(),
    _i1.getType<List<_i11.SimpleData?>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i11.SimpleData?>(e))
                .toList()
            : null,
    List<DateTime>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime>(e))
                .toList(),
    _i1.getType<List<DateTime>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime>(e))
                .toList()
            : null,
    List<DateTime?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime?>(e))
                .toList(),
    _i1.getType<List<DateTime?>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime?>(e))
                .toList()
            : null,
    List<_i12.ByteData>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i12.ByteData>(e))
            .toList(),
    _i1.getType<List<_i12.ByteData>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) =>
                        serializationManager.deserializeJson<_i12.ByteData>(e))
                    .toList()
                : null,
    List<_i12.ByteData?>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i12.ByteData?>(e))
            .toList(),
    _i1.getType<List<_i12.ByteData?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) =>
                        serializationManager.deserializeJson<_i12.ByteData?>(e))
                    .toList()
                : null,
    Map<String, int>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<int>(v))),
    _i1.getType<Map<String, int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int>(v)))
                : null,
    Map<String, int?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<int?>(v))),
    _i1.getType<Map<String, int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int?>(v)))
                : null,
    List<_i11.TestEnum>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i11.TestEnum>(e))
            .toList(),
    List<_i11.TestEnum?>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i11.TestEnum?>(e))
            .toList(),
    Map<String, _i11.SimpleData>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i11.SimpleData>(v))),
    Map<String, String>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<String>(v))),
    Map<String, DateTime>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<DateTime>(v))),
    Map<String, _i12.ByteData>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i12.ByteData>(v))),
    Map<String, _i11.SimpleData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i11.SimpleData?>(v))),
    Map<String, String?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<String?>(v))),
    Map<String, DateTime?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<DateTime?>(v))),
    Map<String, _i12.ByteData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i12.ByteData?>(v))),
    _i1.getType<List<_i11.SimpleData>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i11.SimpleData>(e))
                .toList()
            : null,
    _i1.getType<List<_i11.SimpleData?>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i11.SimpleData?>(e))
                .toList()
            : null,
    List<int>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<int>(e))
                .toList(),
    _i1.getType<List<int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int>(e))
                    .toList()
                : null,
    _i1.getType<List<int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int>(e))
                    .toList()
                : null,
    List<int?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<int?>(e))
                .toList(),
    _i1.getType<List<int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int?>(e))
                    .toList()
                : null,
    _i1.getType<List<int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager.deserializeJson<int?>(e))
                    .toList()
                : null,
    List<double>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<double>(e))
                .toList(),
    List<double?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<double?>(e))
                .toList(),
    List<bool>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<bool>(e))
                .toList(),
    List<bool?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<bool?>(e))
                .toList(),
    List<String>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<String>(e))
                .toList(),
    List<String?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<String?>(e))
                .toList(),
    List<DateTime>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime>(e))
                .toList(),
    List<DateTime?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) => serializationManager.deserializeJson<DateTime?>(e))
                .toList(),
    List<_i12.ByteData>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i12.ByteData>(e))
            .toList(),
    List<_i12.ByteData?>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i12.ByteData?>(e))
            .toList(),
    List<_i13.SimpleData>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map(
                (e) => serializationManager.deserializeJson<_i13.SimpleData>(e))
            .toList(),
    List<_i13.SimpleData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.SimpleData?>(e))
                .toList(),
    _i1.getType<List<_i13.SimpleData>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.SimpleData>(e))
                .toList()
            : null,
    _i1.getType<List<_i13.SimpleData>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.SimpleData>(e))
                .toList()
            : null,
    _i1.getType<List<_i13.SimpleData?>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.SimpleData?>(e))
                .toList()
            : null,
    _i1.getType<List<_i13.SimpleData?>?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.SimpleData?>(e))
                .toList()
            : null,
    Map<String, int>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<int>(v))),
    _i1.getType<Map<String, int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int>(v)))
                : null,
    _i1.getType<Map<String, int>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int>(v)))
                : null,
    Map<String, int?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<int?>(v))),
    _i1.getType<Map<String, int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int?>(v)))
                : null,
    _i1.getType<Map<String, int?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<int?>(v)))
                : null,
    Map<String, double>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<double>(v))),
    Map<String, double?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<double?>(v))),
    Map<String, bool>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<bool>(v))),
    Map<String, bool?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<bool?>(v))),
    Map<String, String>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<String>(v))),
    Map<String, String?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<String?>(v))),
    Map<String, DateTime>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<DateTime>(v))),
    Map<String, DateTime?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<DateTime?>(v))),
    Map<String, _i12.ByteData>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i12.ByteData>(v))),
    Map<String, _i12.ByteData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i12.ByteData?>(v))),
    Map<String, _i13.SimpleData>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i13.SimpleData>(v))),
    Map<String, _i13.SimpleData?>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as Map).map((k, v) => MapEntry(
                serializationManager.deserializeJson<String>(k),
                serializationManager.deserializeJson<_i13.SimpleData?>(v))),
    _i1.getType<Map<String, _i13.SimpleData>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<_i13.SimpleData>(v)))
                : null,
    _i1.getType<Map<String, _i13.SimpleData>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<_i13.SimpleData>(v)))
                : null,
    _i1.getType<Map<String, _i13.SimpleData?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<_i13.SimpleData?>(v)))
                : null,
    _i1.getType<Map<String, _i13.SimpleData?>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as Map).map((k, v) => MapEntry(
                    serializationManager.deserializeJson<String>(k),
                    serializationManager.deserializeJson<_i13.SimpleData?>(v)))
                : null,
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};

  final Map<Type, _i1.Table> _typeTableMapping = {
    _i3.ObjectFieldScopes: _i3.ObjectFieldScopes.t,
    _i4.ObjectWithEnum: _i4.ObjectWithEnum.t,
    _i6.ObjectWithObject: _i6.ObjectWithObject.t,
    _i7.SimpleData: _i7.SimpleData.t,
    _i10.Types: _i10.Types.t,
  };

  @override
  Map<Type, _i1.Table> get typeTableMapping {
    return _typeTableMapping;
  }
}
