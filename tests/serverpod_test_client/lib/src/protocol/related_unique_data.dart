/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'unique_data.dart' as _i2;

abstract class RelatedUniqueData implements _i1.SerializableModel {
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

  factory RelatedUniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelatedUniqueData(
      id: jsonSerialization['id'] as int?,
      uniqueDataId: jsonSerialization['uniqueDataId'] as int,
      uniqueData: jsonSerialization['uniqueData'] == null
          ? null
          : _i2.UniqueData.fromJson(
              (jsonSerialization['uniqueData'] as Map<String, dynamic>)),
      number: jsonSerialization['number'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int uniqueDataId;

  _i2.UniqueData? uniqueData;

  int number;

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelatedUniqueData copyWith({
    int? id,
    int? uniqueDataId,
    _i2.UniqueData? uniqueData,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uniqueDataId': uniqueDataId,
      if (uniqueData != null) 'uniqueData': uniqueData?.toJson(),
      'number': number,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
