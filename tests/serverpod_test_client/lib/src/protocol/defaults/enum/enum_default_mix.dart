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

abstract class EnumDefaultMix implements _i1.SerializableModel {
  EnumDefaultMix._({
    this.id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  })  : byNameEnumDefaultAndDefaultModel =
            byNameEnumDefaultAndDefaultModel ?? _i2.ByNameEnum.byName2,
        byNameEnumDefaultAndDefaultPersist =
            byNameEnumDefaultAndDefaultPersist ?? _i2.ByNameEnum.byName1,
        byNameEnumDefaultModelAndDefaultPersist =
            byNameEnumDefaultModelAndDefaultPersist ?? _i2.ByNameEnum.byName1;

  factory EnumDefaultMix({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) = _EnumDefaultMixImpl;

  factory EnumDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultMix(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultAndDefaultModel: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultAndDefaultModel'] as String)),
      byNameEnumDefaultAndDefaultPersist: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultAndDefaultPersist'] as String)),
      byNameEnumDefaultModelAndDefaultPersist: _i2.ByNameEnum.fromJson(
          (jsonSerialization['byNameEnumDefaultModelAndDefaultPersist']
              as String)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ByNameEnum byNameEnumDefaultAndDefaultModel;

  _i2.ByNameEnum byNameEnumDefaultAndDefaultPersist;

  _i2.ByNameEnum byNameEnumDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnumDefaultMix copyWith({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byNameEnumDefaultAndDefaultModel':
          byNameEnumDefaultAndDefaultModel.toJson(),
      'byNameEnumDefaultAndDefaultPersist':
          byNameEnumDefaultAndDefaultPersist.toJson(),
      'byNameEnumDefaultModelAndDefaultPersist':
          byNameEnumDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultMixImpl extends EnumDefaultMix {
  _EnumDefaultMixImpl({
    int? id,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          byNameEnumDefaultAndDefaultModel: byNameEnumDefaultAndDefaultModel,
          byNameEnumDefaultAndDefaultPersist:
              byNameEnumDefaultAndDefaultPersist,
          byNameEnumDefaultModelAndDefaultPersist:
              byNameEnumDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnumDefaultMix copyWith({
    Object? id = _Undefined,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _i2.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _i2.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) {
    return EnumDefaultMix(
      id: id is int? ? id : this.id,
      byNameEnumDefaultAndDefaultModel: byNameEnumDefaultAndDefaultModel ??
          this.byNameEnumDefaultAndDefaultModel,
      byNameEnumDefaultAndDefaultPersist: byNameEnumDefaultAndDefaultPersist ??
          this.byNameEnumDefaultAndDefaultPersist,
      byNameEnumDefaultModelAndDefaultPersist:
          byNameEnumDefaultModelAndDefaultPersist ??
              this.byNameEnumDefaultModelAndDefaultPersist,
    );
  }
}
