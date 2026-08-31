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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../changed_id_type/nested_one_to_many/team.dart' as _i9bz1am4;

abstract class PlayerUuid
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlayerUuid._({
    this.id,
    required this.name,
    this.teamId,
    this.team,
  });

  factory PlayerUuid({
    _isc.UuidValue? id,
    required String name,
    int? teamId,
    _i9bz1am4.TeamInt? team,
  }) = _PlayerUuidImpl;

  factory PlayerUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      teamId: jsonSerialization['teamId'] as int?,
      team: jsonSerialization['team'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i9bz1am4.TeamInt>(
              jsonSerialization['team'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  int? teamId;

  _i9bz1am4.TeamInt? team;

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlayerUuid copyWith({
    _isc.UuidValue? id,
    String? name,
    int? teamId,
    _i9bz1am4.TeamInt? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerUuidImpl extends PlayerUuid {
  _PlayerUuidImpl({
    _isc.UuidValue? id,
    required String name,
    int? teamId,
    _i9bz1am4.TeamInt? team,
  }) : super._(
         id: id,
         name: name,
         teamId: teamId,
         team: team,
       );

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlayerUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? teamId = _Undefined,
    Object? team = _Undefined,
  }) {
    return PlayerUuid(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      teamId: teamId is int? ? teamId : this.teamId,
      team: team is _i9bz1am4.TeamInt? ? team : this.team?.copyWith(),
    );
  }
}
