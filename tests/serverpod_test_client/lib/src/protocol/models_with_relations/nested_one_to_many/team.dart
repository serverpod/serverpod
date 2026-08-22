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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../../models_with_relations/nested_one_to_many/arena.dart' as _iv085ahk;
import '../../models_with_relations/nested_one_to_many/player.dart'
    as _i9mhudyy;

abstract class Team
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  }) = _TeamImpl;

  factory Team.fromJson(Map<String, dynamic> jsonSerialization) {
    return Team(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] as int?,
      arena: jsonSerialization['arena'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iv085ahk.Arena>(
              jsonSerialization['arena'],
            ),
      players: jsonSerialization['players'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_i9mhudyy.Player>>(
              jsonSerialization['players'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? arenaId;

  _iv085ahk.Arena? arena;

  List<_i9mhudyy.Player>? players;

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Team copyWith({
    int? id,
    String? name,
    int? arenaId,
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Team',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.toJson(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Team',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.toJsonForProtocol(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeamImpl extends Team {
  _TeamImpl({
    int? id,
    required String name,
    int? arenaId,
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  }) : super._(
         id: id,
         name: name,
         arenaId: arenaId,
         arena: arena,
         players: players,
       );

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      arena: arena is _iv085ahk.Arena? ? arena : this.arena?.copyWith(),
      players: players is List<_i9mhudyy.Player>?
          ? players
          : this.players?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
