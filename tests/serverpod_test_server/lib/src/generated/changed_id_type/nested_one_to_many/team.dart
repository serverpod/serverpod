/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/nested_one_to_many/arena.dart' as _i2;
import '../../changed_id_type/nested_one_to_many/player.dart' as _i3;

abstract class TeamInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
              (jsonSerialization['arena'] as Map<String, dynamic>),
            ),
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TeamInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a shallow copy of this [TeamInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class TeamIntUpdateTable extends _i1.UpdateTable<TeamIntTable> {
  TeamIntUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> arenaId(_i1.UuidValue? value) =>
      _i1.ColumnValue(
        table.arenaId,
        value,
      );
}

class TeamIntTable extends _i1.Table<int?> {
  TeamIntTable({super.tableRelation}) : super(tableName: 'team_int') {
    updateTable = TeamIntUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    arenaId = _i1.ColumnUuid(
      'arenaId',
      this,
    );
  }

  late final TeamIntUpdateTable updateTable;

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
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
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
  _i1.Table<int?> get table => TeamInt.t;
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
  _i1.Table<int?> get table => TeamInt.t;
}

class TeamIntRepository {
  const TeamIntRepository._();

  final attach = const TeamIntAttachRepository._();

  final attachRow = const TeamIntAttachRowRepository._();

  final detach = const TeamIntDetachRepository._();

  final detachRow = const TeamIntDetachRowRepository._();

  /// Returns a list of [TeamInt]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
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
    return session.db.find<TeamInt>(
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

  /// Returns the first matching [TeamInt] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
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
    return session.db.findFirstRow<TeamInt>(
      where: where?.call(TeamInt.t),
      orderBy: orderBy?.call(TeamInt.t),
      orderByList: orderByList?.call(TeamInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [TeamInt] by its [id] or null if no such row exists.
  Future<TeamInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TeamIntInclude? include,
  }) async {
    return session.db.findById<TeamInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [TeamInt]s in the list and returns the inserted rows.
  ///
  /// The returned [TeamInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TeamInt>> insert(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TeamInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TeamInt] and returns the inserted row.
  ///
  /// The returned [TeamInt] will have its `id` field set.
  Future<TeamInt> insertRow(
    _i1.Session session,
    TeamInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeamInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TeamInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TeamInt>> update(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.ColumnSelections<TeamIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TeamInt>(
      rows,
      columns: columns?.call(TeamInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeamInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeamInt> updateRow(
    _i1.Session session,
    TeamInt row, {
    _i1.ColumnSelections<TeamIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeamInt>(
      row,
      columns: columns?.call(TeamInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeamInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeamInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TeamIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TeamInt>(
      id,
      columnValues: columnValues(TeamInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeamInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TeamInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TeamIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TeamIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeamIntTable>? orderBy,
    _i1.OrderByListBuilder<TeamIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TeamInt>(
      columnValues: columnValues(TeamInt.t.updateTable),
      where: where(TeamInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeamInt.t),
      orderByList: orderByList?.call(TeamInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TeamInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TeamInt>> delete(
    _i1.Session session,
    List<TeamInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TeamInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TeamInt].
  Future<TeamInt> deleteRow(
    _i1.Session session,
    TeamInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeamInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TeamInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TeamIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TeamInt>(
      where: where(TeamInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TeamInt>(
      where: where?.call(TeamInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TeamIntAttachRepository {
  const TeamIntAttachRepository._();

  /// Creates a relation between this [TeamInt] and the given [PlayerUuid]s
  /// by setting each [PlayerUuid]'s foreign key `teamId` to refer to this [TeamInt].
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

    var $playerUuid = playerUuid
        .map((e) => e.copyWith(teamId: teamInt.id))
        .toList();
    await session.db.update<_i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntAttachRowRepository {
  const TeamIntAttachRowRepository._();

  /// Creates a relation between the given [TeamInt] and [ArenaUuid]
  /// by setting the [TeamInt]'s foreign key `arenaId` to refer to the [ArenaUuid].
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
    await session.db.updateRow<TeamInt>(
      $teamInt,
      columns: [TeamInt.t.arenaId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [TeamInt] and the given [PlayerUuid]
  /// by setting the [PlayerUuid]'s foreign key `teamId` to refer to this [TeamInt].
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
    await session.db.updateRow<_i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntDetachRepository {
  const TeamIntDetachRepository._();

  /// Detaches the relation between this [TeamInt] and the given [PlayerUuid]
  /// by setting the [PlayerUuid]'s foreign key `teamId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> players(
    _i1.Session session,
    List<_i3.PlayerUuid> playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('playerUuid.id');
    }

    var $playerUuid = playerUuid.map((e) => e.copyWith(teamId: null)).toList();
    await session.db.update<_i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamIntDetachRowRepository {
  const TeamIntDetachRowRepository._();

  /// Detaches the relation between this [TeamInt] and the [ArenaUuid] set in `arena`
  /// by setting the [TeamInt]'s foreign key `arenaId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> arena(
    _i1.Session session,
    TeamInt teamInt, {
    _i1.Transaction? transaction,
  }) async {
    if (teamInt.id == null) {
      throw ArgumentError.notNull('teamInt.id');
    }

    var $teamInt = teamInt.copyWith(arenaId: null);
    await session.db.updateRow<TeamInt>(
      $teamInt,
      columns: [TeamInt.t.arenaId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [TeamInt] and the given [PlayerUuid]
  /// by setting the [PlayerUuid]'s foreign key `teamId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> players(
    _i1.Session session,
    _i3.PlayerUuid playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.id == null) {
      throw ArgumentError.notNull('playerUuid.id');
    }

    var $playerUuid = playerUuid.copyWith(teamId: null);
    await session.db.updateRow<_i3.PlayerUuid>(
      $playerUuid,
      columns: [_i3.PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}
