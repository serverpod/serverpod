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
import '../../changed_id_type/nested_one_to_many/team.dart' as _i2;

abstract class PlayerUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  PlayerUuid._({
    this.id,
    required this.name,
    this.teamId,
    this.team,
  });

  factory PlayerUuid({
    _i1.UuidValue? id,
    required String name,
    int? teamId,
    _i2.TeamInt? team,
  }) = _PlayerUuidImpl;

  factory PlayerUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      teamId: jsonSerialization['teamId'] as int?,
      team: jsonSerialization['team'] == null
          ? null
          : _i2.TeamInt.fromJson(
              (jsonSerialization['team'] as Map<String, dynamic>)),
    );
  }

  static final t = PlayerUuidTable();

  static const db = PlayerUuidRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  int? teamId;

  _i2.TeamInt? team;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  PlayerUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    int? teamId,
    _i2.TeamInt? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (teamId != null) 'teamId': teamId,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  static PlayerUuidInclude include({_i2.TeamIntInclude? team}) {
    return PlayerUuidInclude._(team: team);
  }

  static PlayerUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlayerUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerUuidTable>? orderByList,
    PlayerUuidInclude? include,
  }) {
    return PlayerUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PlayerUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerUuidImpl extends PlayerUuid {
  _PlayerUuidImpl({
    _i1.UuidValue? id,
    required String name,
    int? teamId,
    _i2.TeamInt? team,
  }) : super._(
          id: id,
          name: name,
          teamId: teamId,
          team: team,
        );

  @override
  PlayerUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? teamId = _Undefined,
    Object? team = _Undefined,
  }) {
    return PlayerUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      teamId: teamId is int? ? teamId : this.teamId,
      team: team is _i2.TeamInt? ? team : this.team?.copyWith(),
    );
  }
}

class PlayerUuidTable extends _i1.Table<_i1.UuidValue> {
  PlayerUuidTable({super.tableRelation}) : super(tableName: 'player_uuid') {
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

  _i2.TeamIntTable? _team;

  _i2.TeamIntTable get team {
    if (_team != null) return _team!;
    _team = _i1.createRelationTable(
      relationFieldName: 'team',
      field: PlayerUuid.t.teamId,
      foreignField: _i2.TeamInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TeamIntTable(tableRelation: foreignTableRelation),
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

class PlayerUuidInclude extends _i1.IncludeObject {
  PlayerUuidInclude._({_i2.TeamIntInclude? team}) {
    _team = team;
  }

  _i2.TeamIntInclude? _team;

  @override
  Map<String, _i1.Include?> get includes => {'team': _team};

  @override
  _i1.Table<_i1.UuidValue> get table => PlayerUuid.t;
}

class PlayerUuidIncludeList extends _i1.IncludeList {
  PlayerUuidIncludeList._({
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlayerUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => PlayerUuid.t;
}

class PlayerUuidRepository {
  const PlayerUuidRepository._();

  final attachRow = const PlayerUuidAttachRowRepository._();

  final detachRow = const PlayerUuidDetachRowRepository._();

  Future<List<PlayerUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlayerUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerUuidTable>? orderByList,
    _i1.Transaction? transaction,
    PlayerUuidInclude? include,
  }) async {
    return session.db.find<_i1.UuidValue, PlayerUuid>(
      where: where?.call(PlayerUuid.t),
      orderBy: orderBy?.call(PlayerUuid.t),
      orderByList: orderByList?.call(PlayerUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<PlayerUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<PlayerUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlayerUuidTable>? orderByList,
    _i1.Transaction? transaction,
    PlayerUuidInclude? include,
  }) async {
    return session.db.findFirstRow<_i1.UuidValue, PlayerUuid>(
      where: where?.call(PlayerUuid.t),
      orderBy: orderBy?.call(PlayerUuid.t),
      orderByList: orderByList?.call(PlayerUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<PlayerUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PlayerUuidInclude? include,
  }) async {
    return session.db.findById<_i1.UuidValue, PlayerUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<PlayerUuid>> insert(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<_i1.UuidValue, PlayerUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<PlayerUuid> insertRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<_i1.UuidValue, PlayerUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<PlayerUuid>> update(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.ColumnSelections<PlayerUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<_i1.UuidValue, PlayerUuid>(
      rows,
      columns: columns?.call(PlayerUuid.t),
      transaction: transaction,
    );
  }

  Future<PlayerUuid> updateRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.ColumnSelections<PlayerUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<_i1.UuidValue, PlayerUuid>(
      row,
      columns: columns?.call(PlayerUuid.t),
      transaction: transaction,
    );
  }

  Future<List<PlayerUuid>> delete(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<_i1.UuidValue, PlayerUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<PlayerUuid> deleteRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<_i1.UuidValue, PlayerUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<PlayerUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PlayerUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<_i1.UuidValue, PlayerUuid>(
      where: where(PlayerUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<_i1.UuidValue, PlayerUuid>(
      where: where?.call(PlayerUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PlayerUuidAttachRowRepository {
  const PlayerUuidAttachRowRepository._();

  Future<void> team(
    _i1.Session session,
    PlayerUuid playerUuid,
    _i2.TeamInt team, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.id == null) {
      throw ArgumentError.notNull('playerUuid.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $playerUuid = playerUuid.copyWith(teamId: team.id);
    await session.db.updateRow<_i1.UuidValue, PlayerUuid>(
      $playerUuid,
      columns: [PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class PlayerUuidDetachRowRepository {
  const PlayerUuidDetachRowRepository._();

  Future<void> team(
    _i1.Session session,
    PlayerUuid playeruuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playeruuid.id == null) {
      throw ArgumentError.notNull('playeruuid.id');
    }

    var $playeruuid = playeruuid.copyWith(teamId: null);
    await session.db.updateRow<_i1.UuidValue, PlayerUuid>(
      $playeruuid,
      columns: [PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}
