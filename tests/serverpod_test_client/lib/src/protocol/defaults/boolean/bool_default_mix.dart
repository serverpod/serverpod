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

abstract class BoolDefaultMix implements _i1.SerializableModel {
  BoolDefaultMix._({
    this.id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  })  : boolDefaultAndDefaultModel = boolDefaultAndDefaultModel ?? false,
        boolDefaultAndDefaultPersist = boolDefaultAndDefaultPersist ?? true,
        boolDefaultModelAndDefaultPersist =
            boolDefaultModelAndDefaultPersist ?? true;

  factory BoolDefaultMix({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) = _BoolDefaultMixImpl;

  factory BoolDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultMix(
      id: jsonSerialization['id'] as int?,
      boolDefaultAndDefaultModel:
          jsonSerialization['boolDefaultAndDefaultModel'] as bool,
      boolDefaultAndDefaultPersist:
          jsonSerialization['boolDefaultAndDefaultPersist'] as bool,
      boolDefaultModelAndDefaultPersist:
          jsonSerialization['boolDefaultModelAndDefaultPersist'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool boolDefaultAndDefaultModel;

  bool boolDefaultAndDefaultPersist;

  bool boolDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultMix copyWith({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultMixImpl extends BoolDefaultMix {
  _BoolDefaultMixImpl({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          boolDefaultAndDefaultModel: boolDefaultAndDefaultModel,
          boolDefaultAndDefaultPersist: boolDefaultAndDefaultPersist,
          boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultMix copyWith({
    Object? id = _Undefined,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) {
    return BoolDefaultMix(
      id: id is int? ? id : this.id,
      boolDefaultAndDefaultModel:
          boolDefaultAndDefaultModel ?? this.boolDefaultAndDefaultModel,
      boolDefaultAndDefaultPersist:
          boolDefaultAndDefaultPersist ?? this.boolDefaultAndDefaultPersist,
      boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist ??
          this.boolDefaultModelAndDefaultPersist,
    );
  }
}
