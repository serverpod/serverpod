/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class ObjectWithObject extends _i1.SerializableEntity {
  ObjectWithObject({
    this.id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  });

  factory ObjectWithObject.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithObject(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      data: serializationManager
          .deserialize<_i2.SimpleData>(jsonSerialization['data']),
      nullableData: serializationManager
          .deserialize<_i2.SimpleData?>(jsonSerialization['nullableData']),
      dataList: serializationManager
          .deserialize<List<_i2.SimpleData>>(jsonSerialization['dataList']),
      nullableDataList: serializationManager.deserialize<List<_i2.SimpleData>?>(
          jsonSerialization['nullableDataList']),
      listWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>>(
              jsonSerialization['listWithNullableData']),
      nullableListWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>?>(
              jsonSerialization['nullableListWithNullableData']),
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ObjectWithObject &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.data,
                  data,
                ) ||
                other.data == data) &&
            (identical(
                  other.nullableData,
                  nullableData,
                ) ||
                other.nullableData == nullableData) &&
            const _i3.DeepCollectionEquality().equals(
              dataList,
              other.dataList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableDataList,
              other.nullableDataList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              listWithNullableData,
              other.listWithNullableData,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableListWithNullableData,
              other.nullableListWithNullableData,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        data,
        nullableData,
        const _i3.DeepCollectionEquality().hash(dataList),
        const _i3.DeepCollectionEquality().hash(nullableDataList),
        const _i3.DeepCollectionEquality().hash(listWithNullableData),
        const _i3.DeepCollectionEquality().hash(nullableListWithNullableData),
      );

  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) {
    return ObjectWithObject(
      id: id ?? this.id,
      data: data ?? this.data,
      nullableData: nullableData ?? this.nullableData,
      dataList: dataList ?? this.dataList,
      nullableDataList: nullableDataList ?? this.nullableDataList,
      listWithNullableData: listWithNullableData ?? this.listWithNullableData,
      nullableListWithNullableData:
          nullableListWithNullableData ?? this.nullableListWithNullableData,
    );
  }
}
