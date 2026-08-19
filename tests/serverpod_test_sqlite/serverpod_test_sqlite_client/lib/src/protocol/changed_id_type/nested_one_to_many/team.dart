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
import '../../changed_id_type/nested_one_to_many/arena.dart' as _izqzqdtt;
import '../../changed_id_type/nested_one_to_many/player.dart' as _igtph8zx;

abstract class TeamInt
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeamInt._({
    this.id,
    required this.name,
    this.arenaId,
    this.arena,
    this.players,
  });

  factory TeamInt({
    int? id,
    required String name,
    _isc.UuidValue? arenaId,
    _izqzqdtt.ArenaUuid? arena,
    List<_igtph8zx.PlayerUuid>? players,
  }) = _TeamIntImpl;

  factory TeamInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeamInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['arenaId']),
      arena: jsonSerialization['arena'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_izqzqdtt.ArenaUuid>(
              jsonSerialization['arena'],
            ),
      players: jsonSerialization['players'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_igtph8zx.PlayerUuid>>(
              jsonSerialization['players'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _isc.UuidValue? arenaId;

  _izqzqdtt.ArenaUuid? arena;

  List<_igtph8zx.PlayerUuid>? players;

  /// Returns a shallow copy of this [TeamInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeamInt copyWith({
    int? id,
    String? name,
    _isc.UuidValue? arenaId,
    _izqzqdtt.ArenaUuid? arena,
    List<_igtph8zx.PlayerUuid>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeamInt',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId?.toJson(),
      if (arena != null) 'arena': arena?.toJson(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeamInt',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId?.toJson(),
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

class _TeamIntImpl extends TeamInt {
  _TeamIntImpl({
    int? id,
    required String name,
    _isc.UuidValue? arenaId,
    _izqzqdtt.ArenaUuid? arena,
    List<_igtph8zx.PlayerUuid>? players,
  }) : super._(
         id: id,
         name: name,
         arenaId: arenaId,
         arena: arena,
         players: players,
       );

  /// Returns a shallow copy of this [TeamInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeamInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? arenaId = _Undefined,
    Object? arena = _Undefined,
    Object? players = _Undefined,
  }) {
    return TeamInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      arenaId: arenaId is _isc.UuidValue? ? arenaId : this.arenaId,
      arena: arena is _izqzqdtt.ArenaUuid? ? arena : this.arena?.copyWith(),
      players: players is List<_igtph8zx.PlayerUuid>?
          ? players
          : this.players?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
