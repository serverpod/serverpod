/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

abstract class ObjectWithByteData extends _i1.SerializableEntity {
  const ObjectWithByteData._();

  const factory ObjectWithByteData({
    int? id,
    required _i2.ByteData byteData,
  }) = _ObjectWithByteData;

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

  ObjectWithByteData copyWith({
    int? id,
    _i2.ByteData? byteData,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;
  _i2.ByteData get byteData;
}

class _Undefined {}

class _ObjectWithByteData extends ObjectWithByteData {
  const _ObjectWithByteData({
    this.id,
    required this.byteData,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  @override
  final _i2.ByteData byteData;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'byteData': byteData,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithByteData &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.byteData,
                  byteData,
                ) ||
                other.byteData == byteData));
  }

  @override
  int get hashCode => Object.hash(
        id,
        byteData,
      );

  @override
  ObjectWithByteData copyWith({
    Object? id = _Undefined,
    _i2.ByteData? byteData,
  }) {
    return ObjectWithByteData(
      id: id == _Undefined ? this.id : (id as int?),
      byteData: byteData ?? this.byteData,
    );
  }
}
