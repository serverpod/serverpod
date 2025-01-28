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
import '../../defaults/enum/enums/by_name_enum.dart' as _i2;
import '../../defaults/enum/enums/by_index_enum.dart' as _i3;

abstract class EnumDefault implements _i1.SerializableModel {
  EnumDefault._({
    this.id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i3.ByIndexEnum? byIndexEnumDefault,
    _i3.ByIndexEnum? byIndexEnumDefaultNull,
  })  : byNameEnumDefault = byNameEnumDefault ?? _i2.ByNameEnum.byName1,
        byNameEnumDefaultNull = byNameEnumDefaultNull ?? _i2.ByNameEnum.byName2,
        byIndexEnumDefault = byIndexEnumDefault ?? _i3.ByIndexEnum.byIndex1,
        byIndexEnumDefaultNull =
            byIndexEnumDefaultNull ?? _i3.ByIndexEnum.byIndex2;

  factory EnumDefault({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i3.ByIndexEnum? byIndexEnumDefault,
    _i3.ByIndexEnum? byIndexEnumDefaultNull,
  }) = _EnumDefaultImpl;

  factory EnumDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefault(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefault: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefault'] as String)),
      byNameEnumDefaultNull: jsonSerialization['byNameEnumDefaultNull'] == null
          ? null
          : _i2.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultNull'] as String)),
      byIndexEnumDefault: _i3.ByIndexEnum.fromJson(
          (jsonSerialization['byIndexEnumDefault'] as int)),
      byIndexEnumDefaultNull:
          jsonSerialization['byIndexEnumDefaultNull'] == null
              ? null
              : _i3.ByIndexEnum.fromJson(
                  (jsonSerialization['byIndexEnumDefaultNull'] as int)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ByNameEnum byNameEnumDefault;

  _i2.ByNameEnum? byNameEnumDefaultNull;

  _i3.ByIndexEnum byIndexEnumDefault;

  _i3.ByIndexEnum? byIndexEnumDefaultNull;

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefault copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i3.ByIndexEnum? byIndexEnumDefault,
    _i3.ByIndexEnum? byIndexEnumDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultImpl extends EnumDefault {
  _EnumDefaultImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefault,
    _i2.ByNameEnum? byNameEnumDefaultNull,
    _i3.ByIndexEnum? byIndexEnumDefault,
    _i3.ByIndexEnum? byIndexEnumDefaultNull,
  }) : super._(
          id: id,
          byNameEnumDefault: byNameEnumDefault,
          byNameEnumDefaultNull: byNameEnumDefaultNull,
          byIndexEnumDefault: byIndexEnumDefault,
          byIndexEnumDefaultNull: byIndexEnumDefaultNull,
        );

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefault copyWith({
    Object? id = _Undefined,
    _i2.ByNameEnum? byNameEnumDefault,
    Object? byNameEnumDefaultNull = _Undefined,
    _i3.ByIndexEnum? byIndexEnumDefault,
    Object? byIndexEnumDefaultNull = _Undefined,
  }) {
    return EnumDefault(
      id: id is int? ? id : this.id,
      byNameEnumDefault: byNameEnumDefault ?? this.byNameEnumDefault,
      byNameEnumDefaultNull: byNameEnumDefaultNull is _i2.ByNameEnum?
          ? byNameEnumDefaultNull
          : this.byNameEnumDefaultNull,
      byIndexEnumDefault: byIndexEnumDefault ?? this.byIndexEnumDefault,
      byIndexEnumDefaultNull: byIndexEnumDefaultNull is _i3.ByIndexEnum?
          ? byIndexEnumDefaultNull
          : this.byIndexEnumDefaultNull,
    );
  }
}
