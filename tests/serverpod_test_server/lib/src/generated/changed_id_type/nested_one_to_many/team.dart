/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/nested_one_to_many/arena.dart' as _i2;
import '../../changed_id_type/nested_one_to_many/player.dart' as _i3;

abstract class TeamInt implements _i1.TableRow<int>, _i1.ProtocolSerialization {
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
    _i1.UuidValue? arenaId,
    _i2.ArenaUuid? arena,
    List<_i3.PlayerUuid>? players,
  }) = _TeamIntImpl;

  factory TeamInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeamInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['arenaId']),
      arena: jsonSerialization['arena'] == null
          ? null
          : _i2.ArenaUuid.fromJson(
              (jsonSerialization['arena'] as Map<String, dynamic>)),
      players: (jsonSerialization['players'] as List?)
          ?.map((e) => _i3.PlayerUuid.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = TeamIntTable();

  static const db = TeamIntRepository._();

  @override
  int? id;

  String name;

  _i1.UuidValue? arenaId;

  _i2.ArenaUuid? arena;

  List<_i3.PlayerUuid>? players;

  @override
  _i1.Table<int> get table => t;

  TeamInt copyWith({
    int? id,
    String? name,
    _i1.UuidValue? arenaId,
    _i2.ArenaUuid? arena,
    List<_i3.PlayerUuid>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId?.toJson(),
      if (arena != null) 'arena': arena?.toJsonForProtocol(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static TeamIntInclude include({
    _i2.ArenaUuidInclude? arena,
    _i3.PlayerUuidIncludeList? players,
  }) {
    return TeamIntInclude._(
      arena: arena,
      players: players,
    );
  }

  static TeamIntIncludeList includeList({
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeamIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamIntTable>? orderByList,
    TeamIntInclude? include,
  }) {
    return TeamIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeamInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TeamInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeamIntImpl extends TeamInt {
  _TeamIntImpl({
    int? id,
    required String name,
    _i1.UuidValue? arenaId,
    _i2.ArenaUuid? arena,
    List<_i3.PlayerUuid>? players,
  }) : super._(
          id: id,
          name: name,
          arenaId: arenaId,
          arena: arena,
          players: players,
        );

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
      arenaId: arenaId is _i1.UuidValue? ? arenaId : this.arenaId,
      arena: arena is _i2.ArenaUuid? ? arena : this.arena?.copyWith(),
      players: players is List<_i3.PlayerUuid>?
          ? players
          : this.players?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TeamIntTable extends _i1.Table<int> {
  TeamIntTable({super.tableRelation}) : super(tableName: 'team_int') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    arenaId = _i1.ColumnUuid(
      'arenaId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnUuid arenaId;

  _i2.ArenaUuidTable? _arena;

  _i3.PlayerUuidTable? ___players;

  _i1.ManyRelation<_i3.PlayerUuidTable>? _players;

  _i2.ArenaUuidTable get arena {
    if (_arena != null) return _arena!;
    _arena = _i1.createRelationTable(
      relationFieldName: 'arena',
      field: TeamInt.t.arenaId,
      foreignField: _i2.ArenaUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ArenaUuidTable(tableRelation: foreignTableRelation),
    );
    return _arena!;
  }

  _i3.PlayerUuidTable get __players {
    if (___players != null) return ___players!;
    ___players = _i1.createRelationTable(
      relationFieldName: '__players',
      field: TeamInt.t.id,
      foreignField: _i3.PlayerUuid.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PlayerUuidTable(tableRelation: foreignTableRelation),
    );
    return ___players!;
  }

  _i1.ManyRelation<_i3.PlayerUuidTable> get players {
    if (_players != null) return _players!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'players',
      field: TeamInt.t.id,
      foreignField: _i3.PlayerUuid.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PlayerUuidTable(tableRelation: foreignTableRelation),
    );
    _players = _i1.ManyRelation<_i3.PlayerUuidTable>(
      tableWithRelations: relationTable,
      table: _i3.PlayerUuidTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _players!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        arenaId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'arena') {
      return arena;
    }
    if (relationField == 'players') {
      return __players;
    }
    return null;
  }
}

class TeamIntInclude extends _i1.IncludeObject {
  TeamIntInclude._({
    _i2.ArenaUuidInclude? arena,
    _i3.PlayerUuidIncludeList? players,
  }) {
    _arena = arena;
    _players = players;
  }

  _i2.ArenaUuidInclude? _arena;

  _i3.PlayerUuidIncludeList? _players;

  @override
  Map<String, _i1.Include?> get includes => {
        'arena': _arena,
        'players': _players,
      };

  @override
  _i1.Table<int> get table => TeamInt.t;
}

class TeamIntIncludeList extends _i1.IncludeList {
  TeamIntIncludeList._({
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeamInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => TeamInt.t;
}

class TeamIntRepository {
  const TeamIntRepository._();

  final attach = const TeamIntAttachRepository._();

  final attachRow = const TeamIntAttachRowRepository._();

  final detach = const TeamIntDetachRepository._();

  final detachRow = const TeamIntDetachRowRepository._();

  Future<List<TeamInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeamIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamIntTable>? orderByList,
    _i1.Transaction? transaction,
    TeamIntInclude? include,
  }) async {
    return session.db.find<int, TeamInt>(
      where: where?.call(TeamInt.t),
      orderBy: orderBy?.call(TeamInt.t),
      orderByList: orderByList?.call(TeamInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<TeamInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<TeamIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamIntTable>? orderByList,
    _i1.Transaction? transaction,
    TeamIntInclude? include,
  }) async {
    return session.db.findFirstRow<int, TeamInt>(
      where: where?.call(TeamInt.t),
      orderBy: orderBy?.call(TeamInt.t),
      orderByList: orderByList?.call(TeamInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<TeamInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TeamIntInclude? include,
  }) async {
    return session.db.findById<int, TeamInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<TeamInt>> insert(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<int, TeamInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<TeamInt> insertRow(
    _i1.Session session,
    TeamInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<int, TeamInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<TeamInt>> update(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.ColumnSelections<TeamIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<int, TeamInt>(
      rows,
      columns: columns?.call(TeamInt.t),
      transaction: transaction,
    );
  }

  Future<TeamInt> updateRow(
    _i1.Session session,
    TeamInt row, {
    _i1.ColumnSelections<TeamIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<int, TeamInt>(
      row,
      columns: columns?.call(TeamInt.t),
      transaction: transaction,
    );
  }

  Future<List<TeamInt>> delete(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<int, TeamInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<TeamInt> deleteRow(
    _i1.Session session,
    TeamInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<int, TeamInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<TeamInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TeamIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<int, TeamInt>(
      where: where(TeamInt.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<int, TeamInt>(
      where: where?.call(TeamInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TeamIntAttachRepository {
  const TeamIntAttachRepository._();

  Future<void> players(
    _i1.Session session,
    TeamInt teamInt,
    List<_i3.PlayerUuid> playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('playerUuid.id');
    }
    if (teamInt.id == null) {
      throw ArgumentError.notNull('teamInt.id');
    }

    var $playerUuid =
        playerUuid.map((e) => e.copyWith(teamId: teamInt.id)).toList();
    await session.db.update<_i1.UuidValue, _i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntAttachRowRepository {
  const TeamIntAttachRowRepository._();

  Future<void> arena(
    _i1.Session session,
    TeamInt teamInt,
    _i2.ArenaUuid arena, {
    _i1.Transaction? transaction,
  }) async {
    if (teamInt.id == null) {
      throw ArgumentError.notNull('teamInt.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $teamInt = teamInt.copyWith(arenaId: arena.id);
    await session.db.updateRow<int, TeamInt>(
      $teamInt,
      columns: [TeamInt.t.arenaId],
      transaction: transaction,
    );
  }

  Future<void> players(
    _i1.Session session,
    TeamInt teamInt,
    _i3.PlayerUuid playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.id == null) {
      throw ArgumentError.notNull('playerUuid.id');
    }
    if (teamInt.id == null) {
      throw ArgumentError.notNull('teamInt.id');
    }

    var $playerUuid = playerUuid.copyWith(teamId: teamInt.id);
    await session.db.updateRow<_i1.UuidValue, _i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntDetachRepository {
  const TeamIntDetachRepository._();

  Future<void> players(
    _i1.Session session,
    List<_i3.PlayerUuid> playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('playerUuid.id');
    }

    var $playerUuid = playerUuid.map((e) => e.copyWith(teamId: null)).toList();
    await session.db.update<_i1.UuidValue, _i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntDetachRowRepository {
  const TeamIntDetachRowRepository._();

  Future<void> arena(
    _i1.Session session,
    TeamInt teamint, {
    _i1.Transaction? transaction,
  }) async {
    if (teamint.id == null) {
      throw ArgumentError.notNull('teamint.id');
    }

    var $teamint = teamint.copyWith(arenaId: null);
    await session.db.updateRow<int, TeamInt>(
      $teamint,
      columns: [TeamInt.t.arenaId],
      transaction: transaction,
    );
  }

  Future<void> players(
    _i1.Session session,
    _i3.PlayerUuid playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.id == null) {
      throw ArgumentError.notNull('playerUuid.id');
    }

    var $playerUuid = playerUuid.copyWith(teamId: null);
    await session.db.updateRow<_i1.UuidValue, _i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}
