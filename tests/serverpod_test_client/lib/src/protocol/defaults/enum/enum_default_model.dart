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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../defaults/enum/enums/by_index_enum.dart' as _ido5z594;
import '../../defaults/enum/enums/by_name_enum.dart' as _iwklobdz;

abstract class EnumDefaultModel
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EnumDefaultModel._({
    this.id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) : byNameEnumDefaultModel =
           byNameEnumDefaultModel ?? _iwklobdz.ByNameEnum.byName1,
       byNameEnumDefaultModelNull =
           byNameEnumDefaultModelNull ?? _iwklobdz.ByNameEnum.byName2,
       byIndexEnumDefaultModel =
           byIndexEnumDefaultModel ?? _ido5z594.ByIndexEnum.byIndex1,
       byIndexEnumDefaultModelNull =
           byIndexEnumDefaultModelNull ?? _ido5z594.ByIndexEnum.byIndex2;

  factory EnumDefaultModel({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) = _EnumDefaultModelImpl;

  factory EnumDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultModel(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultModel:
          jsonSerialization['byNameEnumDefaultModel'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultModel'] as String),
            ),
      byNameEnumDefaultModelNull:
          jsonSerialization['byNameEnumDefaultModelNull'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultModelNull'] as String),
            ),
      byIndexEnumDefaultModel:
          jsonSerialization['byIndexEnumDefaultModel'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultModel'] as int),
            ),
      byIndexEnumDefaultModelNull:
          jsonSerialization['byIndexEnumDefaultModelNull'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultModelNull'] as int),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _iwklobdz.ByNameEnum byNameEnumDefaultModel;

  _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull;

  _ido5z594.ByIndexEnum byIndexEnumDefaultModel;

  _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull;

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EnumDefaultModel copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefaultModel',
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefaultModel',
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultModelImpl extends EnumDefaultModel {
  _EnumDefaultModelImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) : super._(
         id: id,
         byNameEnumDefaultModel: byNameEnumDefaultModel,
         byNameEnumDefaultModelNull: byNameEnumDefaultModelNull,
         byIndexEnumDefaultModel: byIndexEnumDefaultModel,
         byIndexEnumDefaultModelNull: byIndexEnumDefaultModelNull,
       );

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EnumDefaultModel copyWith({
    Object? id = _Undefined,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    Object? byNameEnumDefaultModelNull = _Undefined,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    Object? byIndexEnumDefaultModelNull = _Undefined,
  }) {
    return EnumDefaultModel(
      id: id is int? ? id : this.id,
      byNameEnumDefaultModel:
          byNameEnumDefaultModel ?? this.byNameEnumDefaultModel,
      byNameEnumDefaultModelNull:
          byNameEnumDefaultModelNull is _iwklobdz.ByNameEnum?
          ? byNameEnumDefaultModelNull
          : this.byNameEnumDefaultModelNull,
      byIndexEnumDefaultModel:
          byIndexEnumDefaultModel ?? this.byIndexEnumDefaultModel,
      byIndexEnumDefaultModelNull:
          byIndexEnumDefaultModelNull is _ido5z594.ByIndexEnum?
          ? byIndexEnumDefaultModelNull
          : this.byIndexEnumDefaultModelNull,
    );
  }
}
