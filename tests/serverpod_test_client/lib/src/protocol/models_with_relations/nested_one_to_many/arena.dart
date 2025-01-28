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
import '../../models_with_relations/nested_one_to_many/team.dart' as _i2;

abstract class Arena implements _i1.SerializableModel {
  Arena._({
    this.id,
    required this.name,
    this.team,
  });

  factory Arena({
    int? id,
    required String name,
    _i2.Team? team,
  }) = _ArenaImpl;

  factory Arena.fromJson(Map<String, dynamic> jsonSerialization) {
    return Arena(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      team: jsonSerialization['team'] == null
          ? null
          : _i2.Team.fromJson(
              (jsonSerialization['team'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i2.Team? team;

  /// Returns a shallow copy of this [Arena]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Arena copyWith({
    int? id,
    String? name,
    _i2.Team? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ArenaImpl extends Arena {
  _ArenaImpl({
    int? id,
    required String name,
    _i2.Team? team,
  }) : super._(
          id: id,
          name: name,
          team: team,
        );

  /// Returns a shallow copy of this [Arena]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Arena copyWith({
    Object? id = _Undefined,
    String? name,
    Object? team = _Undefined,
  }) {
    return Arena(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      team: team is _i2.Team? ? team : this.team?.copyWith(),
    );
  }
}
