/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

class ObjectWithByteData extends _i1.SerializableEntity {
  ObjectWithByteData({
    this.id,
    required this.byteData,
  });

  factory ObjectWithByteData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithByteData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      byteData: serializationManager
          .deserialize<_i2.ByteData>(jsonSerialization['byteData']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ByteData byteData;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'byteData': byteData,
    };
  }
}
