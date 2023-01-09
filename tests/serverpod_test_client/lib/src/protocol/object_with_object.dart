/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class ObjectWithObject extends _i1.SerializableEntity {
  ObjectWithObject({
    /// The database ID.
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

  /// The database ID.
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
}
