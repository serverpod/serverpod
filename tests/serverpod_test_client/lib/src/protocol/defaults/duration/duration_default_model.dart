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

abstract class DurationDefaultModel implements _i1.SerializableModel {
  DurationDefaultModel._({
    this.id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  })  : durationDefaultModel = durationDefaultModel ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultModelNull = durationDefaultModelNull ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            );

  factory DurationDefaultModel({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  }) = _DurationDefaultModelImpl;

  factory DurationDefaultModel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DurationDefaultModel(
      id: jsonSerialization['id'] as int?,
      durationDefaultModel: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultModel']),
      durationDefaultModelNull:
          jsonSerialization['durationDefaultModelNull'] == null
              ? null
              : _i1.DurationJsonExtension.fromJson(
                  jsonSerialization['durationDefaultModelNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Duration durationDefaultModel;

  Duration? durationDefaultModelNull;

  /// Returns a shallow copy of this [DurationDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultModel copyWith({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefaultModel': durationDefaultModel.toJson(),
      if (durationDefaultModelNull != null)
        'durationDefaultModelNull': durationDefaultModelNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultModelImpl extends DurationDefaultModel {
  _DurationDefaultModelImpl({
    int? id,
    Duration? durationDefaultModel,
    Duration? durationDefaultModelNull,
  }) : super._(
          id: id,
          durationDefaultModel: durationDefaultModel,
          durationDefaultModelNull: durationDefaultModelNull,
        );

  /// Returns a shallow copy of this [DurationDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultModel copyWith({
    Object? id = _Undefined,
    Duration? durationDefaultModel,
    Object? durationDefaultModelNull = _Undefined,
  }) {
    return DurationDefaultModel(
      id: id is int? ? id : this.id,
      durationDefaultModel: durationDefaultModel ?? this.durationDefaultModel,
      durationDefaultModelNull: durationDefaultModelNull is Duration?
          ? durationDefaultModelNull
          : this.durationDefaultModelNull,
    );
  }
}
