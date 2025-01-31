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

abstract class DurationDefaultMix implements _i1.SerializableModel {
  DurationDefaultMix._({
    this.id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  })  : durationDefaultAndDefaultModel = durationDefaultAndDefaultModel ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            ),
        durationDefaultAndDefaultPersist = durationDefaultAndDefaultPersist ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultModelAndDefaultPersist =
            durationDefaultModelAndDefaultPersist ??
                Duration(
                  days: 1,
                  hours: 2,
                  minutes: 10,
                  seconds: 30,
                  milliseconds: 100,
                );

  factory DurationDefaultMix({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) = _DurationDefaultMixImpl;

  factory DurationDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DurationDefaultMix(
      id: jsonSerialization['id'] as int?,
      durationDefaultAndDefaultModel: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultModel']),
      durationDefaultAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultPersist']),
      durationDefaultModelAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultModelAndDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Duration durationDefaultAndDefaultModel;

  Duration durationDefaultAndDefaultPersist;

  Duration durationDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultMix copyWith({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefaultAndDefaultModel': durationDefaultAndDefaultModel.toJson(),
      'durationDefaultAndDefaultPersist':
          durationDefaultAndDefaultPersist.toJson(),
      'durationDefaultModelAndDefaultPersist':
          durationDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultMixImpl extends DurationDefaultMix {
  _DurationDefaultMixImpl({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          durationDefaultAndDefaultModel: durationDefaultAndDefaultModel,
          durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist,
          durationDefaultModelAndDefaultPersist:
              durationDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultMix copyWith({
    Object? id = _Undefined,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) {
    return DurationDefaultMix(
      id: id is int? ? id : this.id,
      durationDefaultAndDefaultModel:
          durationDefaultAndDefaultModel ?? this.durationDefaultAndDefaultModel,
      durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist ??
          this.durationDefaultAndDefaultPersist,
      durationDefaultModelAndDefaultPersist:
          durationDefaultModelAndDefaultPersist ??
              this.durationDefaultModelAndDefaultPersist,
    );
  }
}
