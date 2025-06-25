/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/nested_one_to_many/team.dart' as _i2;

abstract class ArenaUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
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

  static final t = ArenaUuidTable();

  static const db = ArenaUuidRepository._();

  @override
  _i1.UuidValue id;

  String name;

  _i2.TeamInt? team;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id.toJson(),
      'name': name,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  static ArenaUuidInclude include({_i2.TeamIntInclude? team}) {
    return ArenaUuidInclude._(team: team);
  }

  static ArenaUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArenaUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaUuidTable>? orderByList,
    ArenaUuidInclude? include,
  }) {
    return ArenaUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ArenaUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ArenaUuid.t),
      include: include,
    );
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

class ArenaUuidTable extends _i1.Table<_i1.UuidValue> {
  ArenaUuidTable({super.tableRelation}) : super(tableName: 'arena_uuid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.TeamIntTable? _team;

  _i2.TeamIntTable get team {
    if (_team != null) return _team!;
    _team = _i1.createRelationTable(
      relationFieldName: 'team',
      field: ArenaUuid.t.id,
      foreignField: _i2.TeamInt.t.arenaId,
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
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'team') {
      return team;
    }
    return null;
  }
}

class ArenaUuidInclude extends _i1.IncludeObject {
  ArenaUuidInclude._({_i2.TeamIntInclude? team}) {
    _team = team;
  }

  _i2.TeamIntInclude? _team;

  @override
  Map<String, _i1.Include?> get includes => {'team': _team};

  @override
  _i1.Table<_i1.UuidValue> get table => ArenaUuid.t;
}

class ArenaUuidIncludeList extends _i1.IncludeList {
  ArenaUuidIncludeList._({
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ArenaUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => ArenaUuid.t;
}

class ArenaUuidRepository {
  const ArenaUuidRepository._();

  final attachRow = const ArenaUuidAttachRowRepository._();

  final detachRow = const ArenaUuidDetachRowRepository._();

  /// Returns a list of [ArenaUuid]s matching the given query parameters.
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
  Future<List<ArenaUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArenaUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaUuidTable>? orderByList,
    _i1.Transaction? transaction,
    ArenaUuidInclude? include,
  }) async {
    return session.db.find<ArenaUuid>(
      where: where?.call(ArenaUuid.t),
      orderBy: orderBy?.call(ArenaUuid.t),
      orderByList: orderByList?.call(ArenaUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ArenaUuid] matching the given query parameters.
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
  Future<ArenaUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<ArenaUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaUuidTable>? orderByList,
    _i1.Transaction? transaction,
    ArenaUuidInclude? include,
  }) async {
    return session.db.findFirstRow<ArenaUuid>(
      where: where?.call(ArenaUuid.t),
      orderBy: orderBy?.call(ArenaUuid.t),
      orderByList: orderByList?.call(ArenaUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ArenaUuid] by its [id] or null if no such row exists.
  Future<ArenaUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ArenaUuidInclude? include,
  }) async {
    return session.db.findById<ArenaUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ArenaUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [ArenaUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ArenaUuid>> insert(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ArenaUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ArenaUuid] and returns the inserted row.
  ///
  /// The returned [ArenaUuid] will have its `id` field set.
  Future<ArenaUuid> insertRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ArenaUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ArenaUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ArenaUuid>> update(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.ColumnSelections<ArenaUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ArenaUuid>(
      rows,
      columns: columns?.call(ArenaUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ArenaUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ArenaUuid> updateRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.ColumnSelections<ArenaUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ArenaUuid>(
      row,
      columns: columns?.call(ArenaUuid.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ArenaUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ArenaUuid>> delete(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ArenaUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ArenaUuid].
  Future<ArenaUuid> deleteRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ArenaUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ArenaUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ArenaUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ArenaUuid>(
      where: where(ArenaUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ArenaUuid>(
      where: where?.call(ArenaUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ArenaUuidAttachRowRepository {
  const ArenaUuidAttachRowRepository._();

  /// Creates a relation between the given [ArenaUuid] and [TeamInt]
  /// by setting the [ArenaUuid]'s foreign key `id` to refer to the [TeamInt].
  Future<void> team(
    _i1.Session session,
    ArenaUuid arenaUuid,
    _i2.TeamInt team, {
    _i1.Transaction? transaction,
  }) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }
    if (arenaUuid.id == null) {
      throw ArgumentError.notNull('arenaUuid.id');
    }

    var $team = team.copyWith(arenaId: arenaUuid.id);
    await session.db.updateRow<_i2.TeamInt>(
      $team,
      columns: [_i2.TeamInt.t.arenaId],
      transaction: transaction,
    );
  }
}

class ArenaUuidDetachRowRepository {
  const ArenaUuidDetachRowRepository._();

  /// Detaches the relation between this [ArenaUuid] and the [TeamInt] set in `team`
  /// by setting the [ArenaUuid]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> team(
    _i1.Session session,
    ArenaUuid arenauuid, {
    _i1.Transaction? transaction,
  }) async {
    var $team = arenauuid.team;

    if ($team == null) {
      throw ArgumentError.notNull('arenauuid.team');
    }
    if ($team.id == null) {
      throw ArgumentError.notNull('arenauuid.team.id');
    }
    if (arenauuid.id == null) {
      throw ArgumentError.notNull('arenauuid.id');
    }

    var $$team = $team.copyWith(arenaId: null);
    await session.db.updateRow<_i2.TeamInt>(
      $$team,
      columns: [_i2.TeamInt.t.arenaId],
      transaction: transaction,
    );
  }
}
