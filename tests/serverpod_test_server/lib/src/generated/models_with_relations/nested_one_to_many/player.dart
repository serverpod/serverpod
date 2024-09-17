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
import '../../protocol.dart' as _i2;

abstract class Player extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  Player._({
    int? id,
    required this.name,
    this.teamId,
    this.team,
  }) : super(id);

  factory Player({
    int? id,
    required String name,
    int? teamId,
    _i2.Team? team,
  }) = _PlayerImpl;

  factory Player.fromJson(Map<String, dynamic> jsonSerialization) {
    return Player(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      teamId: jsonSerialization['teamId'] as int?,
      team: jsonSerialization['team'] == null
          ? null
          : _i2.Team.fromJson(
              (jsonSerialization['team'] as Map<String, dynamic>)),
    );
  }

  static final t = PlayerTable();

  static const db = PlayerRepository._();

  String name;

  int? teamId;

  _i2.Team? team;

  @override
  _i1.Table get table => t;

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
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  static PlayerInclude include({_i2.TeamInclude? team}) {
    return PlayerInclude._(team: team);
  }

  static PlayerIncludeList includeList({
    _i1.WhereExpressionBuilder<PlayerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlayerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerTable>? orderByList,
    PlayerInclude? include,
  }) {
    return PlayerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Player.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Player.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

class PlayerTable extends _i1.Table {
  PlayerTable({super.tableRelation}) : super(tableName: 'player') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    teamId = _i1.ColumnInt(
      'teamId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt teamId;

  _i2.TeamTable? _team;

  _i2.TeamTable get team {
    if (_team != null) return _team!;
    _team = _i1.createRelationTable(
      relationFieldName: 'team',
      field: Player.t.teamId,
      foreignField: _i2.Team.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TeamTable(tableRelation: foreignTableRelation),
    );
    return _team!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        teamId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'team') {
      return team;
    }
    return null;
  }
}

class PlayerInclude extends _i1.IncludeObject {
  PlayerInclude._({_i2.TeamInclude? team}) {
    _team = team;
  }

  _i2.TeamInclude? _team;

  @override
  Map<String, _i1.Include?> get includes => {'team': _team};

  @override
  _i1.Table get table => Player.t;
}

class PlayerIncludeList extends _i1.IncludeList {
  PlayerIncludeList._({
    _i1.WhereExpressionBuilder<PlayerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Player.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Player.t;
}

class PlayerRepository {
  const PlayerRepository._();

  final attachRow = const PlayerAttachRowRepository._();

  final detachRow = const PlayerDetachRowRepository._();

  Future<List<Player>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PlayerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlayerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerTable>? orderByList,
    _i1.Transaction? transaction,
    PlayerInclude? include,
  }) async {
    return databaseAccessor.db.find<Player>(
      where: where?.call(Player.t),
      orderBy: orderBy?.call(Player.t),
      orderByList: orderByList?.call(Player.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Player?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PlayerTable>? where,
    int? offset,
    _i1.OrderByBuilder<PlayerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerTable>? orderByList,
    _i1.Transaction? transaction,
    PlayerInclude? include,
  }) async {
    return databaseAccessor.db.findFirstRow<Player>(
      where: where?.call(Player.t),
      orderBy: orderBy?.call(Player.t),
      orderByList: orderByList?.call(Player.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Player?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
    PlayerInclude? include,
  }) async {
    return databaseAccessor.db.findById<Player>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<List<Player>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<Player> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<Player>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Player> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    Player row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<Player>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Player>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<Player> rows, {
    _i1.ColumnSelections<PlayerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<Player>(
      rows,
      columns: columns?.call(Player.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Player> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    Player row, {
    _i1.ColumnSelections<PlayerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<Player>(
      row,
      columns: columns?.call(Player.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Player>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<Player> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<Player>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Player> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    Player row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<Player>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Player>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<PlayerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<Player>(
      where: where(Player.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PlayerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<Player>(
      where: where?.call(Player.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class PlayerAttachRowRepository {
  const PlayerAttachRowRepository._();

  Future<void> team(
    _i1.DatabaseAccessor databaseAccessor,
    Player player,
    _i2.Team team, {
    _i1.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.copyWith(teamId: team.id);
    await databaseAccessor.db.updateRow<Player>(
      $player,
      columns: [Player.t.teamId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class PlayerDetachRowRepository {
  const PlayerDetachRowRepository._();

  Future<void> team(
    _i1.DatabaseAccessor databaseAccessor,
    Player player, {
    _i1.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.copyWith(teamId: null);
    await databaseAccessor.db.updateRow<Player>(
      $player,
      columns: [Player.t.teamId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
