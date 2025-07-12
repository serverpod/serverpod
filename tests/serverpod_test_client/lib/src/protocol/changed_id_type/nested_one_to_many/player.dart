/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../changed_id_type/nested_one_to_many/team.dart' as _i2;

abstract class PlayerUuid implements _i1.SerializableModel {
  PlayerUuid._({
    this.id,
    required this.name,
    this.teamId,
    this.team,
  });

  factory PlayerUuid({
    _i1.UuidValue? id,
    required String name,
    int? teamId,
    _i2.TeamInt? team,
  }) = _PlayerUuidImpl;

  factory PlayerUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      teamId: jsonSerialization['teamId'] as int?,
      team: jsonSerialization['team'] == null
          ? null
          : _i2.TeamInt.fromJson(
              (jsonSerialization['team'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String name;

  int? teamId;

  _i2.TeamInt? team;

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlayerUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    int? teamId,
    _i2.TeamInt? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerUuidImpl extends PlayerUuid {
  _PlayerUuidImpl({
    _i1.UuidValue? id,
    required String name,
    int? teamId,
    _i2.TeamInt? team,
  }) : super._(
          id: id,
          name: name,
          teamId: teamId,
          team: team,
        );

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlayerUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? teamId = _Undefined,
    Object? team = _Undefined,
  }) {
    return PlayerUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      teamId: teamId is int? ? teamId : this.teamId,
      team: team is _i2.TeamInt? ? team : this.team?.copyWith(),
    );
  }
}
