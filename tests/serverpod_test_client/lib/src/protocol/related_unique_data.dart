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

abstract class RelatedUniqueData extends _i1.SerializableEntity {
  RelatedUniqueData._({
    this.id,
    required this.uniqueDataId,
    this.uniqueData,
    required this.number,
  });

  factory RelatedUniqueData({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) = _RelatedUniqueDataImpl;

  factory RelatedUniqueData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RelatedUniqueData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      uniqueDataId: serializationManager
          .deserialize<int>(jsonSerialization['uniqueDataId']),
      uniqueData: serializationManager
          .deserialize<_i2.UniqueData?>(jsonSerialization['uniqueData']),
      number:
          serializationManager.deserialize<int>(jsonSerialization['number']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int uniqueDataId;

  _i2.UniqueData? uniqueData;

  int number;

  RelatedUniqueData copyWith({
    int? id,
    int? uniqueDataId,
    _i2.UniqueData? uniqueData,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uniqueDataId': uniqueDataId,
      'uniqueData': uniqueData,
      'number': number,
    };
  }
}

class _Undefined {}

class _RelatedUniqueDataImpl extends RelatedUniqueData {
  _RelatedUniqueDataImpl({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) : super._(
          id: id,
          uniqueDataId: uniqueDataId,
          uniqueData: uniqueData,
          number: number,
        );

  @override
  RelatedUniqueData copyWith({
    Object? id = _Undefined,
    int? uniqueDataId,
    Object? uniqueData = _Undefined,
    int? number,
  }) {
    return RelatedUniqueData(
      id: id is int? ? id : this.id,
      uniqueDataId: uniqueDataId ?? this.uniqueDataId,
      uniqueData: uniqueData is _i2.UniqueData?
          ? uniqueData
          : this.uniqueData?.copyWith(),
      number: number ?? this.number,
    );
  }
}
