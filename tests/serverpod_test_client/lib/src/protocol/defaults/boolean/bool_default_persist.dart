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

abstract class BoolDefaultPersist implements _i1.SerializableModel {
  BoolDefaultPersist._({
    this.id,
    this.boolDefaultPersistTrue,
    this.boolDefaultPersistFalse,
  });

  factory BoolDefaultPersist({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  }) = _BoolDefaultPersistImpl;

  factory BoolDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultPersist(
      id: jsonSerialization['id'] as int?,
      boolDefaultPersistTrue:
          jsonSerialization['boolDefaultPersistTrue'] as bool?,
      boolDefaultPersistFalse:
          jsonSerialization['boolDefaultPersistFalse'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool? boolDefaultPersistTrue;

  bool? boolDefaultPersistFalse;

  /// Returns a shallow copy of this [BoolDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultPersist copyWith({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (boolDefaultPersistTrue != null)
        'boolDefaultPersistTrue': boolDefaultPersistTrue,
      if (boolDefaultPersistFalse != null)
        'boolDefaultPersistFalse': boolDefaultPersistFalse,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultPersistImpl extends BoolDefaultPersist {
  _BoolDefaultPersistImpl({
    int? id,
    bool? boolDefaultPersistTrue,
    bool? boolDefaultPersistFalse,
  }) : super._(
          id: id,
          boolDefaultPersistTrue: boolDefaultPersistTrue,
          boolDefaultPersistFalse: boolDefaultPersistFalse,
        );

  /// Returns a shallow copy of this [BoolDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? boolDefaultPersistTrue = _Undefined,
    Object? boolDefaultPersistFalse = _Undefined,
  }) {
    return BoolDefaultPersist(
      id: id is int? ? id : this.id,
      boolDefaultPersistTrue: boolDefaultPersistTrue is bool?
          ? boolDefaultPersistTrue
          : this.boolDefaultPersistTrue,
      boolDefaultPersistFalse: boolDefaultPersistFalse is bool?
          ? boolDefaultPersistFalse
          : this.boolDefaultPersistFalse,
    );
  }
}
