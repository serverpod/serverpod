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

abstract class EnumDefault
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EnumDefault._({
    this.id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) : byNameEnumDefault = byNameEnumDefault ?? _iwklobdz.ByNameEnum.byName1,
       byNameEnumDefaultNull =
           byNameEnumDefaultNull ?? _iwklobdz.ByNameEnum.byName2,
       byIndexEnumDefault =
           byIndexEnumDefault ?? _ido5z594.ByIndexEnum.byIndex1,
       byIndexEnumDefaultNull =
           byIndexEnumDefaultNull ?? _ido5z594.ByIndexEnum.byIndex2;

  factory EnumDefault({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) = _EnumDefaultImpl;

  factory EnumDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefault(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefault: jsonSerialization['byNameEnumDefault'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefault'] as String),
            ),
      byNameEnumDefaultNull: jsonSerialization['byNameEnumDefaultNull'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultNull'] as String),
            ),
      byIndexEnumDefault: jsonSerialization['byIndexEnumDefault'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefault'] as int),
            ),
      byIndexEnumDefaultNull:
          jsonSerialization['byIndexEnumDefaultNull'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultNull'] as int),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _iwklobdz.ByNameEnum byNameEnumDefault;

  _iwklobdz.ByNameEnum? byNameEnumDefaultNull;

  _ido5z594.ByIndexEnum byIndexEnumDefault;

  _ido5z594.ByIndexEnum? byIndexEnumDefaultNull;

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EnumDefault copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefault',
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefault',
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultImpl extends EnumDefault {
  _EnumDefaultImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) : super._(
         id: id,
         byNameEnumDefault: byNameEnumDefault,
         byNameEnumDefaultNull: byNameEnumDefaultNull,
         byIndexEnumDefault: byIndexEnumDefault,
         byIndexEnumDefaultNull: byIndexEnumDefaultNull,
       );

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EnumDefault copyWith({
    Object? id = _Undefined,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    Object? byNameEnumDefaultNull = _Undefined,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    Object? byIndexEnumDefaultNull = _Undefined,
  }) {
    return EnumDefault(
      id: id is int? ? id : this.id,
      byNameEnumDefault: byNameEnumDefault ?? this.byNameEnumDefault,
      byNameEnumDefaultNull: byNameEnumDefaultNull is _iwklobdz.ByNameEnum?
          ? byNameEnumDefaultNull
          : this.byNameEnumDefaultNull,
      byIndexEnumDefault: byIndexEnumDefault ?? this.byIndexEnumDefault,
      byIndexEnumDefaultNull: byIndexEnumDefaultNull is _ido5z594.ByIndexEnum?
          ? byIndexEnumDefaultNull
          : this.byIndexEnumDefaultNull,
    );
  }
}
