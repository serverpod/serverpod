/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import 'simple_data.dart' as _i0zisc0t;

abstract class ObjectWithObject
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _i0zisc0t.SimpleData data,
    _i0zisc0t.SimpleData? nullableData,
    required List<_i0zisc0t.SimpleData> dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList,
    required List<_i0zisc0t.SimpleData?> listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData,
    List<List<_i0zisc0t.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
    nestedDataListInMap,
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithObject(
      id: jsonSerialization['id'] as int?,
      data: _i0ntutnq.Protocol().deserialize<_i0zisc0t.SimpleData>(
        jsonSerialization['data'],
      ),
      nullableData: jsonSerialization['nullableData'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i0zisc0t.SimpleData>(
              jsonSerialization['nullableData'],
            ),
      dataList: _i0ntutnq.Protocol().deserialize<List<_i0zisc0t.SimpleData>>(
        jsonSerialization['dataList'],
      ),
      nullableDataList: jsonSerialization['nullableDataList'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_i0zisc0t.SimpleData>>(
              jsonSerialization['nullableDataList'],
            ),
      listWithNullableData: _i0ntutnq.Protocol()
          .deserialize<List<_i0zisc0t.SimpleData?>>(
            jsonSerialization['listWithNullableData'],
          ),
      nullableListWithNullableData:
          jsonSerialization['nullableListWithNullableData'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_i0zisc0t.SimpleData?>>(
              jsonSerialization['nullableListWithNullableData'],
            ),
      nestedDataList: jsonSerialization['nestedDataList'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<List<_i0zisc0t.SimpleData>>>(
              jsonSerialization['nestedDataList'],
            ),
      nestedDataListInMap: jsonSerialization['nestedDataListInMap'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<
              Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>
            >(jsonSerialization['nestedDataListInMap']),
      nestedDataMap: jsonSerialization['nestedDataMap'] == null
          ? null
          : _i0ntutnq.Protocol()
                .deserialize<Map<String, Map<int, _i0zisc0t.SimpleData>>>(
                  jsonSerialization['nestedDataMap'],
                ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i0zisc0t.SimpleData data;

  _i0zisc0t.SimpleData? nullableData;

  List<_i0zisc0t.SimpleData> dataList;

  List<_i0zisc0t.SimpleData>? nullableDataList;

  List<_i0zisc0t.SimpleData?> listWithNullableData;

  List<_i0zisc0t.SimpleData?>? nullableListWithNullableData;

  List<List<_i0zisc0t.SimpleData>>? nestedDataList;

  Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>? nestedDataListInMap;

  Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap;

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithObject copyWith({
    int? id,
    _i0zisc0t.SimpleData? data,
    _i0zisc0t.SimpleData? nullableData =
        const _UndefinedObjectWithObject$nullableData(),
    List<_i0zisc0t.SimpleData>? dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList =
        const _issu.$UndefinedList<_i0zisc0t.SimpleData>(),
    List<_i0zisc0t.SimpleData?>? listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData =
        const _issu.$UndefinedList<_i0zisc0t.SimpleData?>(),
    List<List<_i0zisc0t.SimpleData>>? nestedDataList =
        const _issu.$UndefinedList<List<_i0zisc0t.SimpleData>>(),
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
        nestedDataListInMap =
        const _issu.$UndefinedMap<
          String,
          List<List<Map<int, _i0zisc0t.SimpleData>>?>
        >(),
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap =
        const _issu.$UndefinedMap<String, Map<int, _i0zisc0t.SimpleData>>(),
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithObject',
      if (id != null) 'id': id,
      'data': data.toJsonForProtocol(),
      if (nullableData != null)
        'nullableData': nullableData?.toJsonForProtocol(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nullableDataList != null)
        'nullableDataList': nullableDataList?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'listWithNullableData': listWithNullableData.toJson(
        valueToJson: (v) => v?.toJsonForProtocol(),
      ),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
          valueToJson: (v) => v?.toJsonForProtocol(),
        ),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
          valueToJson: (v) => v.toJson(
            valueToJson: (v) => v?.toJson(
              valueToJson: (v) =>
                  v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
            ),
          ),
        ),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedObjectWithObject$nullableData extends _issu.UndefinedSentinel
    implements _i0zisc0t.SimpleData {
  const _UndefinedObjectWithObject$nullableData();
}

class _ObjectWithObjectImpl extends ObjectWithObject {
  _ObjectWithObjectImpl({
    int? id,
    required _i0zisc0t.SimpleData data,
    _i0zisc0t.SimpleData? nullableData,
    required List<_i0zisc0t.SimpleData> dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList,
    required List<_i0zisc0t.SimpleData?> listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData,
    List<List<_i0zisc0t.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
    nestedDataListInMap,
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap,
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
  @_isc.useResult
  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i0zisc0t.SimpleData? data,
    _i0zisc0t.SimpleData? nullableData =
        const _UndefinedObjectWithObject$nullableData(),
    List<_i0zisc0t.SimpleData>? dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList =
        const _issu.$UndefinedList<_i0zisc0t.SimpleData>(),
    List<_i0zisc0t.SimpleData?>? listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData =
        const _issu.$UndefinedList<_i0zisc0t.SimpleData?>(),
    List<List<_i0zisc0t.SimpleData>>? nestedDataList =
        const _issu.$UndefinedList<List<_i0zisc0t.SimpleData>>(),
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
        nestedDataListInMap =
        const _issu.$UndefinedMap<
          String,
          List<List<Map<int, _i0zisc0t.SimpleData>>?>
        >(),
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap =
        const _issu.$UndefinedMap<String, Map<int, _i0zisc0t.SimpleData>>(),
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _issu.UndefinedSentinel
          ? this.nullableData?.copyWith()
          : nullableData,
      dataList: dataList ?? this.dataList.map((e0) => e0.copyWith()).toList(),
      nullableDataList: nullableDataList is _issu.UndefinedSentinel
          ? this.nullableDataList?.map((e0) => e0.copyWith()).toList()
          : nullableDataList,
      listWithNullableData:
          listWithNullableData ??
          this.listWithNullableData.map((e0) => e0?.copyWith()).toList(),
      nullableListWithNullableData:
          nullableListWithNullableData is _issu.UndefinedSentinel
          ? this.nullableListWithNullableData
                ?.map((e0) => e0?.copyWith())
                .toList()
          : nullableListWithNullableData,
      nestedDataList: nestedDataList is _issu.UndefinedSentinel
          ? this.nestedDataList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toList()
          : nestedDataList,
      nestedDataListInMap: nestedDataListInMap is _issu.UndefinedSentinel
          ? this.nestedDataListInMap?.map(
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
            )
          : nestedDataListInMap,
      nestedDataMap: nestedDataMap is _issu.UndefinedSentinel
          ? this.nestedDataMap?.map(
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
            )
          : nestedDataMap,
    );
  }
}
