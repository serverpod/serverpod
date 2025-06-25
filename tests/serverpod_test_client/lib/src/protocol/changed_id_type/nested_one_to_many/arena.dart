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
import '../../changed_id_type/nested_one_to_many/team.dart' as _i2;

abstract class ArenaUuid implements _i1.SerializableModel {
  ArenaUuid._({
    _i1.UuidValue? id,
    required this.name,
    this.team,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory ArenaUuid({
    _i1.UuidValue? id,
    required String name,
    _i2.TeamInt? team,
  }) = _ArenaUuidImpl;

  factory ArenaUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return ArenaUuid(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      team: jsonSerialization['team'] == null
          ? null
          : _i2.TeamInt.fromJson(
              (jsonSerialization['team'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue id;

  String name;

  _i2.TeamInt? team;

  /// Returns a shallow copy of this [ArenaUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ArenaUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    _i2.TeamInt? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
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

class _ArenaUuidImpl extends ArenaUuid {
  _ArenaUuidImpl({
    _i1.UuidValue? id,
    required String name,
    _i2.TeamInt? team,
  }) : super._(
          id: id,
          name: name,
          team: team,
        );

  /// Returns a shallow copy of this [ArenaUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ArenaUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    Object? team = _Undefined,
  }) {
    return ArenaUuid(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team is _i2.TeamInt? ? team : this.team?.copyWith(),
    );
  }
}
