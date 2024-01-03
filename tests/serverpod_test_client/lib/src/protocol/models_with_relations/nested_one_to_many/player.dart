/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Player extends _i1.SerializableEntity {
  Player._({
    this.id,
    required this.name,
    this.teamId,
    this.team,
  });

  factory Player({
    int? id,
    required String name,
    int? teamId,
    _i2.Team? team,
  }) = _PlayerImpl;

  factory Player.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Player(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      teamId:
          serializationManager.deserialize<int?>(jsonSerialization['teamId']),
      team: serializationManager
          .deserialize<_i2.Team?>(jsonSerialization['team']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? teamId;

  _i2.Team? team;

  Player copyWith({
    int? id,
    String? name,
    int? teamId,
    _i2.Team? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team,
    };
  }
}

class _Undefined {}

class _PlayerImpl extends Player {
  _PlayerImpl({
    int? id,
    required String name,
    int? teamId,
    _i2.Team? team,
  }) : super._(
          id: id,
          name: name,
          teamId: teamId,
          team: team,
        );

  @override
  Player copyWith({
    Object? id = _Undefined,
    String? name,
    Object? teamId = _Undefined,
    Object? team = _Undefined,
  }) {
    return Player(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      teamId: teamId is int? ? teamId : this.teamId,
      team: team is _i2.Team? ? team : this.team?.copyWith(),
    );
  }
}
