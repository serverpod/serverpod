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

abstract class DurationDefault implements _i1.SerializableModel {
  DurationDefault._({
    this.id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  })  : durationDefault = durationDefault ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultNull = durationDefaultNull ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            );

  factory DurationDefault({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  }) = _DurationDefaultImpl;

  factory DurationDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DurationDefault(
      id: jsonSerialization['id'] as int?,
      durationDefault: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefault']),
      durationDefaultNull: jsonSerialization['durationDefaultNull'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(
              jsonSerialization['durationDefaultNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Duration durationDefault;

  Duration? durationDefaultNull;

  /// Returns a shallow copy of this [DurationDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefault copyWith({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefault': durationDefault.toJson(),
      if (durationDefaultNull != null)
        'durationDefaultNull': durationDefaultNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultImpl extends DurationDefault {
  _DurationDefaultImpl({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  }) : super._(
          id: id,
          durationDefault: durationDefault,
          durationDefaultNull: durationDefaultNull,
        );

  /// Returns a shallow copy of this [DurationDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefault copyWith({
    Object? id = _Undefined,
    Duration? durationDefault,
    Object? durationDefaultNull = _Undefined,
  }) {
    return DurationDefault(
      id: id is int? ? id : this.id,
      durationDefault: durationDefault ?? this.durationDefault,
      durationDefaultNull: durationDefaultNull is Duration?
          ? durationDefaultNull
          : this.durationDefaultNull,
    );
  }
}
