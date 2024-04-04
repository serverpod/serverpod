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

  factory Team.fromJson(Map<String, dynamic> jsonSerialization) {
    return Team(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] as int?,
      arena: jsonSerialization.containsKey('arena')
          ? _i2.Arena.fromJson(
              jsonSerialization['arena'] as Map<String, dynamic>)
          : null,
      players: (jsonSerialization['players'] as List<dynamic>?)
          ?.map((e) => _i2.Player.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      if (arena != null) 'arena': arena?.toJson(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJson()),
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
