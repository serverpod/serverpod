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

abstract class IntDefaultMix implements _i1.SerializableModel {
  IntDefaultMix._({
    this.id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  })  : intDefaultAndDefaultModel = intDefaultAndDefaultModel ?? 20,
        intDefaultAndDefaultPersist = intDefaultAndDefaultPersist ?? 10,
        intDefaultModelAndDefaultPersist =
            intDefaultModelAndDefaultPersist ?? 10;

  factory IntDefaultMix({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) = _IntDefaultMixImpl;

  factory IntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultMix(
      id: jsonSerialization['id'] as int?,
      intDefaultAndDefaultModel:
          jsonSerialization['intDefaultAndDefaultModel'] as int,
      intDefaultAndDefaultPersist:
          jsonSerialization['intDefaultAndDefaultPersist'] as int,
      intDefaultModelAndDefaultPersist:
          jsonSerialization['intDefaultModelAndDefaultPersist'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int intDefaultAndDefaultModel;

  int intDefaultAndDefaultPersist;

  int intDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [IntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefaultMix copyWith({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefaultAndDefaultModel': intDefaultAndDefaultModel,
      'intDefaultAndDefaultPersist': intDefaultAndDefaultPersist,
      'intDefaultModelAndDefaultPersist': intDefaultModelAndDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultMixImpl extends IntDefaultMix {
  _IntDefaultMixImpl({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          intDefaultAndDefaultModel: intDefaultAndDefaultModel,
          intDefaultAndDefaultPersist: intDefaultAndDefaultPersist,
          intDefaultModelAndDefaultPersist: intDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [IntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefaultMix copyWith({
    Object? id = _Undefined,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) {
    return IntDefaultMix(
      id: id is int? ? id : this.id,
      intDefaultAndDefaultModel:
          intDefaultAndDefaultModel ?? this.intDefaultAndDefaultModel,
      intDefaultAndDefaultPersist:
          intDefaultAndDefaultPersist ?? this.intDefaultAndDefaultPersist,
      intDefaultModelAndDefaultPersist: intDefaultModelAndDefaultPersist ??
          this.intDefaultModelAndDefaultPersist,
    );
  }
}
