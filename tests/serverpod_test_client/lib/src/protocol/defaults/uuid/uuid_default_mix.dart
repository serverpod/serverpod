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

abstract class UuidDefaultMix implements _i1.SerializableModel {
  UuidDefaultMix._({
    this.id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  })  : uuidDefaultAndDefaultModel = uuidDefaultAndDefaultModel ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultAndDefaultPersist = uuidDefaultAndDefaultPersist ??
            _i1.UuidValue.fromString('6fa459ea-ee8a-3ca4-894e-db77e160355e'),
        uuidDefaultModelAndDefaultPersist = uuidDefaultModelAndDefaultPersist ??
            _i1.UuidValue.fromString('d9428888-122b-11e1-b85c-61cd3cbb3210');

  factory UuidDefaultMix({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) = _UuidDefaultMixImpl;

  factory UuidDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultMix(
      id: jsonSerialization['id'] as int?,
      uuidDefaultAndDefaultModel: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultAndDefaultModel']),
      uuidDefaultAndDefaultPersist: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultAndDefaultPersist']),
      uuidDefaultModelAndDefaultPersist: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelAndDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuidDefaultAndDefaultModel;

  _i1.UuidValue uuidDefaultAndDefaultPersist;

  _i1.UuidValue uuidDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [UuidDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultMix copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultAndDefaultModel': uuidDefaultAndDefaultModel.toJson(),
      'uuidDefaultAndDefaultPersist': uuidDefaultAndDefaultPersist.toJson(),
      'uuidDefaultModelAndDefaultPersist':
          uuidDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultMixImpl extends UuidDefaultMix {
  _UuidDefaultMixImpl({
    int? id,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          uuidDefaultAndDefaultModel: uuidDefaultAndDefaultModel,
          uuidDefaultAndDefaultPersist: uuidDefaultAndDefaultPersist,
          uuidDefaultModelAndDefaultPersist: uuidDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [UuidDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultMix copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultAndDefaultModel,
    _i1.UuidValue? uuidDefaultAndDefaultPersist,
    _i1.UuidValue? uuidDefaultModelAndDefaultPersist,
  }) {
    return UuidDefaultMix(
      id: id is int? ? id : this.id,
      uuidDefaultAndDefaultModel:
          uuidDefaultAndDefaultModel ?? this.uuidDefaultAndDefaultModel,
      uuidDefaultAndDefaultPersist:
          uuidDefaultAndDefaultPersist ?? this.uuidDefaultAndDefaultPersist,
      uuidDefaultModelAndDefaultPersist: uuidDefaultModelAndDefaultPersist ??
          this.uuidDefaultModelAndDefaultPersist,
    );
  }
}
