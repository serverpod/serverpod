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
import '../../changed_id_type/nested_one_to_many/team.dart' as _i2;

abstract class PlayerUuid
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a shallow copy of this [PlayerUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class PlayerUuidUpdateTable extends _i1.UpdateTable<PlayerUuidTable> {
  PlayerUuidUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
        table.name,
        value,
      );

  _i1.ColumnValue<int, int> teamId(int? value) => _i1.ColumnValue(
        table.teamId,
        value,
      );
}

class PlayerUuidTable extends _i1.Table<_i1.UuidValue?> {
  PlayerUuidTable({super.tableRelation}) : super(tableName: 'player_uuid') {
    updateTable = PlayerUuidUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    teamId = _i1.ColumnInt(
      'teamId',
      this,
    );
  }

  late final PlayerUuidUpdateTable updateTable;

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
  _i1.Table<_i1.UuidValue?> get table => PlayerUuid.t;
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
  _i1.Table<_i1.UuidValue?> get table => PlayerUuid.t;
}

class PlayerUuidRepository {
  const PlayerUuidRepository._();

  final attachRow = const PlayerUuidAttachRowRepository._();

  final detachRow = const PlayerUuidDetachRowRepository._();

  /// Returns a list of [PlayerUuid]s matching the given query parameters.
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
    return session.db.find<PlayerUuid>(
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

  /// Returns the first matching [PlayerUuid] matching the given query parameters.
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
    return session.db.findFirstRow<PlayerUuid>(
      where: where?.call(PlayerUuid.t),
      orderBy: orderBy?.call(PlayerUuid.t),
      orderByList: orderByList?.call(PlayerUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [PlayerUuid] by its [id] or null if no such row exists.
  Future<PlayerUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PlayerUuidInclude? include,
  }) async {
    return session.db.findById<PlayerUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [PlayerUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [PlayerUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PlayerUuid>> insert(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PlayerUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PlayerUuid] and returns the inserted row.
  ///
  /// The returned [PlayerUuid] will have its `id` field set.
  Future<PlayerUuid> insertRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlayerUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PlayerUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PlayerUuid>> update(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.ColumnSelections<PlayerUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PlayerUuid>(
      rows,
      columns: columns?.call(PlayerUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlayerUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlayerUuid> updateRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.ColumnSelections<PlayerUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlayerUuid>(
      row,
      columns: columns?.call(PlayerUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlayerUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlayerUuid?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PlayerUuidUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PlayerUuid>(
      id,
      columnValues: columnValues(PlayerUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlayerUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PlayerUuid>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PlayerUuidUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PlayerUuidTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlayerUuidTable>? orderBy,
    _i1.OrderByListBuilder<PlayerUuidTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PlayerUuid>(
      columnValues: columnValues(PlayerUuid.t.updateTable),
      where: where(PlayerUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerUuid.t),
      orderByList: orderByList?.call(PlayerUuid.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PlayerUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PlayerUuid>> delete(
    _i1.Session session,
    List<PlayerUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PlayerUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PlayerUuid].
  Future<PlayerUuid> deleteRow(
    _i1.Session session,
    PlayerUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlayerUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PlayerUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PlayerUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PlayerUuid>(
      where: where(PlayerUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlayerUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PlayerUuid>(
      where: where?.call(PlayerUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PlayerUuidAttachRowRepository {
  const PlayerUuidAttachRowRepository._();

  /// Creates a relation between the given [PlayerUuid] and [TeamInt]
  /// by setting the [PlayerUuid]'s foreign key `teamId` to refer to the [TeamInt].
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
    await session.db.updateRow<PlayerUuid>(
      $playerUuid,
      columns: [PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}

class PlayerUuidDetachRowRepository {
  const PlayerUuidDetachRowRepository._();

  /// Detaches the relation between this [PlayerUuid] and the [TeamInt] set in `team`
  /// by setting the [PlayerUuid]'s foreign key `teamId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> team(
    _i1.Session session,
    PlayerUuid playerUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (playerUuid.id == null) {
      throw ArgumentError.notNull('playerUuid.id');
    }

    var $playerUuid = playerUuid.copyWith(teamId: null);
    await session.db.updateRow<PlayerUuid>(
      $playerUuid,
      columns: [PlayerUuid.t.teamId],
      transaction: transaction,
    );
  }
}
