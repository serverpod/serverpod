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

abstract class Team extends _i1.SerializableEntity {
  Team._({
    this.id,
    required this.name,
    this.arenaId,
    this.arena,
    this.players,
  });

  factory Team({
    int? id,
    required String name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
  }) = _TeamImpl;

  factory Team.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Team(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      arenaId:
          serializationManager.deserialize<int?>(jsonSerialization['arenaId']),
      arena: serializationManager
          .deserialize<_i2.Arena?>(jsonSerialization['arena']),
      players: serializationManager
          .deserialize<List<_i2.Player>?>(jsonSerialization['players']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? arenaId;

  _i2.Arena? arena;

  List<_i2.Player>? players;

  Team copyWith({
    int? id,
    String? name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena,
      if (players != null) 'players': players,
    };
  }
}

class _Undefined {}

class _TeamImpl extends Team {
  _TeamImpl({
    int? id,
    required String name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
  }) : super._(
          id: id,
          name: name,
          arenaId: arenaId,
          arena: arena,
          players: players,
        );

  @override
  Team copyWith({
    Object? id = _Undefined,
    String? name,
    Object? arenaId = _Undefined,
    Object? arena = _Undefined,
    Object? players = _Undefined,
  }) {
    return Team(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      arenaId: arenaId is int? ? arenaId : this.arenaId,
      arena: arena is _i2.Arena? ? arena : this.arena?.copyWith(),
      players: players is List<_i2.Player>? ? players : this.players?.clone(),
    );
  }
}
