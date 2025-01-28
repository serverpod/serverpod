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

abstract class DurationDefaultPersist implements _i1.SerializableModel {
  DurationDefaultPersist._({
    this.id,
    this.durationDefaultPersist,
  });

  factory DurationDefaultPersist({
    int? id,
    Duration? durationDefaultPersist,
  }) = _DurationDefaultPersistImpl;

  factory DurationDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DurationDefaultPersist(
      id: jsonSerialization['id'] as int?,
      durationDefaultPersist:
          jsonSerialization['durationDefaultPersist'] == null
              ? null
              : _i1.DurationJsonExtension.fromJson(
                  jsonSerialization['durationDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Duration? durationDefaultPersist;

  /// Returns a shallow copy of this [DurationDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultPersist copyWith({
    int? id,
    Duration? durationDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (durationDefaultPersist != null)
        'durationDefaultPersist': durationDefaultPersist?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultPersistImpl extends DurationDefaultPersist {
  _DurationDefaultPersistImpl({
    int? id,
    Duration? durationDefaultPersist,
  }) : super._(
          id: id,
          durationDefaultPersist: durationDefaultPersist,
        );

  /// Returns a shallow copy of this [DurationDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? durationDefaultPersist = _Undefined,
  }) {
    return DurationDefaultPersist(
      id: id is int? ? id : this.id,
      durationDefaultPersist: durationDefaultPersist is Duration?
          ? durationDefaultPersist
          : this.durationDefaultPersist,
    );
  }
}
