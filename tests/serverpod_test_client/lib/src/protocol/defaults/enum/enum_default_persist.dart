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

abstract class EnumDefaultPersist implements _i1.SerializableModel {
  EnumDefaultPersist._({
    this.id,
    this.byNameEnumDefaultPersist,
    this.byIndexEnumDefaultPersist,
  });

  factory EnumDefaultPersist({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  }) = _EnumDefaultPersistImpl;

  factory EnumDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultPersist(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultPersist:
          jsonSerialization['byNameEnumDefaultPersist'] == null
              ? null
              : _i2.ByNameEnum.fromJson(
                  (jsonSerialization['byNameEnumDefaultPersist'] as String)),
      byIndexEnumDefaultPersist:
          jsonSerialization['byIndexEnumDefaultPersist'] == null
              ? null
              : _i3.ByIndexEnum.fromJson(
                  (jsonSerialization['byIndexEnumDefaultPersist'] as int)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ByNameEnum? byNameEnumDefaultPersist;

  _i3.ByIndexEnum? byIndexEnumDefaultPersist;

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefaultPersist copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (byNameEnumDefaultPersist != null)
        'byNameEnumDefaultPersist': byNameEnumDefaultPersist?.toJson(),
      if (byIndexEnumDefaultPersist != null)
        'byIndexEnumDefaultPersist': byIndexEnumDefaultPersist?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultPersistImpl extends EnumDefaultPersist {
  _EnumDefaultPersistImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultPersist,
    _i3.ByIndexEnum? byIndexEnumDefaultPersist,
  }) : super._(
          id: id,
          byNameEnumDefaultPersist: byNameEnumDefaultPersist,
          byIndexEnumDefaultPersist: byIndexEnumDefaultPersist,
        );

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? byNameEnumDefaultPersist = _Undefined,
    Object? byIndexEnumDefaultPersist = _Undefined,
  }) {
    return EnumDefaultPersist(
      id: id is int? ? id : this.id,
      byNameEnumDefaultPersist: byNameEnumDefaultPersist is _i2.ByNameEnum?
          ? byNameEnumDefaultPersist
          : this.byNameEnumDefaultPersist,
      byIndexEnumDefaultPersist: byIndexEnumDefaultPersist is _i3.ByIndexEnum?
          ? byIndexEnumDefaultPersist
          : this.byIndexEnumDefaultPersist,
    );
  }
}
