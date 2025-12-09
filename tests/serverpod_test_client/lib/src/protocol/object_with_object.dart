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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'simple_data.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ObjectWithObject implements _i1.SerializableModel {
  ObjectWithObject._({
    this.id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
    this.nestedDataList,
    this.nestedDataListInMap,
    this.nestedDataMap,
  });

  factory ObjectWithObject({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithObject(
      id: jsonSerialization['id'] as int?,
      data: _i3.Protocol().deserialize<_i2.SimpleData>(
        jsonSerialization['data'],
      ),
      nullableData: jsonSerialization['nullableData'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SimpleData>(
              jsonSerialization['nullableData'],
            ),
      dataList: _i3.Protocol().deserialize<List<_i2.SimpleData>>(
        jsonSerialization['dataList'],
      ),
      nullableDataList: jsonSerialization['nullableDataList'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.SimpleData>>(
              jsonSerialization['nullableDataList'],
            ),
      listWithNullableData: _i3.Protocol().deserialize<List<_i2.SimpleData?>>(
        jsonSerialization['listWithNullableData'],
      ),
      nullableListWithNullableData:
          jsonSerialization['nullableListWithNullableData'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.SimpleData?>>(
              jsonSerialization['nullableListWithNullableData'],
            ),
      nestedDataList: jsonSerialization['nestedDataList'] == null
          ? null
          : _i3.Protocol().deserialize<List<List<_i2.SimpleData>>>(
              jsonSerialization['nestedDataList'],
            ),
      nestedDataListInMap: jsonSerialization['nestedDataListInMap'] == null
          ? null
          : _i3.Protocol().deserialize<
              Map<String, List<List<Map<int, _i2.SimpleData>>?>>
            >(jsonSerialization['nestedDataListInMap']),
      nestedDataMap: jsonSerialization['nestedDataMap'] == null
          ? null
          : _i3.Protocol().deserialize<Map<String, Map<int, _i2.SimpleData>>>(
              jsonSerialization['nestedDataMap'],
            ),
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

  List<List<_i2.SimpleData>>? nestedDataList;

  Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap;

  Map<String, Map<int, _i2.SimpleData>>? nestedDataMap;

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithObject',
      if (id != null) 'id': id,
      'data': data.toJson(),
      if (nullableData != null) 'nullableData': nullableData?.toJson(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJson()),
      if (nullableDataList != null)
        'nullableDataList': nullableDataList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'listWithNullableData': listWithNullableData.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
          valueToJson: (v) => v?.toJson(),
        ),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
          valueToJson: (v) => v.toJson(
            valueToJson: (v) => v?.toJson(
              valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
            ),
          ),
        ),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
  }) : super._(
         id: id,
         data: data,
         nullableData: nullableData,
         dataList: dataList,
         nullableDataList: nullableDataList,
         listWithNullableData: listWithNullableData,
         nullableListWithNullableData: nullableListWithNullableData,
         nestedDataList: nestedDataList,
         nestedDataListInMap: nestedDataListInMap,
         nestedDataMap: nestedDataMap,
       );

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i2.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i2.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i2.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
    Object? nestedDataList = _Undefined,
    Object? nestedDataListInMap = _Undefined,
    Object? nestedDataMap = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i2.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.map((e0) => e0.copyWith()).toList(),
      nullableDataList: nullableDataList is List<_i2.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.map((e0) => e0.copyWith()).toList(),
      listWithNullableData:
          listWithNullableData ??
          this.listWithNullableData.map((e0) => e0?.copyWith()).toList(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i2.SimpleData?>?
          ? nullableListWithNullableData
          : this.nullableListWithNullableData
                ?.map((e0) => e0?.copyWith())
                .toList(),
      nestedDataList: nestedDataList is List<List<_i2.SimpleData>>?
          ? nestedDataList
          : this.nestedDataList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toList(),
      nestedDataListInMap:
          nestedDataListInMap
              is Map<String, List<List<Map<int, _i2.SimpleData>>?>>?
          ? nestedDataListInMap
          : this.nestedDataListInMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0
                    .map(
                      (e1) => e1
                          ?.map(
                            (e2) => e2.map(
                              (
                                key3,
                                value3,
                              ) => MapEntry(
                                key3,
                                value3.copyWith(),
                              ),
                            ),
                          )
                          .toList(),
                    )
                    .toList(),
              ),
            ),
      nestedDataMap: nestedDataMap is Map<String, Map<int, _i2.SimpleData>>?
          ? nestedDataMap
          : this.nestedDataMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.map(
                  (
                    key1,
                    value1,
                  ) => MapEntry(
                    key1,
                    value1.copyWith(),
                  ),
                ),
              ),
            ),
    );
  }
}
