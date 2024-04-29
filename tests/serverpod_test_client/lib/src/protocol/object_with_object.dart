/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

abstract class ObjectWithObject extends _i1.SerializableEntity {
  ObjectWithObject._({
    this.id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  });

  factory ObjectWithObject({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithObject(
      id: jsonSerialization['id'] as int?,
      data: _i2.SimpleData.fromJson(
          (jsonSerialization['data'] as Map<String, dynamic>)),
      nullableData: jsonSerialization['nullableData'] == null
          ? null
          : _i2.SimpleData.fromJson(
              (jsonSerialization['nullableData'] as Map<String, dynamic>)),
      dataList: (jsonSerialization['dataList'] as List)
          .map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      nullableDataList: (jsonSerialization['nullableDataList'] as List?)
          ?.map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      listWithNullableData: (jsonSerialization['listWithNullableData'] as List)
          .map((e) => e == null
              ? null
              : _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      nullableListWithNullableData:
          (jsonSerialization['nullableListWithNullableData'] as List?)
              ?.map((e) => e == null
                  ? null
                  : _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.SimpleData data;

  _i2.SimpleData? nullableData;

  List<_i2.SimpleData> dataList;

  List<_i2.SimpleData>? nullableDataList;

  List<_i2.SimpleData?> listWithNullableData;

  List<_i2.SimpleData?>? nullableListWithNullableData;

  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'data': data.toJson(),
      if (nullableData != null) 'nullableData': nullableData?.toJson(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJson()),
      if (nullableDataList != null)
        'nullableDataList':
            nullableDataList?.toJson(valueToJson: (v) => v.toJson()),
      'listWithNullableData':
          listWithNullableData.toJson(valueToJson: (v) => v?.toJson()),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
            valueToJson: (v) => v?.toJson()),
    };
  }
}

class _Undefined {}

class _ObjectWithObjectImpl extends ObjectWithObject {
  _ObjectWithObjectImpl({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) : super._(
          id: id,
          data: data,
          nullableData: nullableData,
          dataList: dataList,
          nullableDataList: nullableDataList,
          listWithNullableData: listWithNullableData,
          nullableListWithNullableData: nullableListWithNullableData,
        );

  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i2.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i2.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i2.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i2.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.clone(),
      nullableDataList: nullableDataList is List<_i2.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.clone(),
      listWithNullableData:
          listWithNullableData ?? this.listWithNullableData.clone(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i2.SimpleData?>?
              ? nullableListWithNullableData
              : this.nullableListWithNullableData?.clone(),
    );
  }
}
