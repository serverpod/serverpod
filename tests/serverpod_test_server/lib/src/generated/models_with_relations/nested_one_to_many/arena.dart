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
import '../../models_with_relations/nested_one_to_many/team.dart' as _i2;

abstract class Arena implements _i1.TableRow, _i1.ProtocolSerialization {
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

  static final t = ArenaTable();

  static const db = ArenaRepository._();

  @override
  int? id;

  String name;

  _i2.Team? team;

  @override
  _i1.Table get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  static ArenaInclude include({_i2.TeamInclude? team}) {
    return ArenaInclude._(team: team);
  }

  static ArenaIncludeList includeList({
    _i1.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArenaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaTable>? orderByList,
    ArenaInclude? include,
  }) {
    return ArenaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Arena.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Arena.t),
      include: include,
    );
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

class ArenaTable extends _i1.Table {
  ArenaTable({super.tableRelation}) : super(tableName: 'arena') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.TeamTable? _team;

  _i2.TeamTable get team {
    if (_team != null) return _team!;
    _team = _i1.createRelationTable(
      relationFieldName: 'team',
      field: Arena.t.id,
      foreignField: _i2.Team.t.arenaId,
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
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'team') {
      return team;
    }
    return null;
  }
}

class ArenaInclude extends _i1.IncludeObject {
  ArenaInclude._({_i2.TeamInclude? team}) {
    _team = team;
  }

  _i2.TeamInclude? _team;

  @override
  Map<String, _i1.Include?> get includes => {'team': _team};

  @override
  _i1.Table get table => Arena.t;
}

class ArenaIncludeList extends _i1.IncludeList {
  ArenaIncludeList._({
    _i1.WhereExpressionBuilder<ArenaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Arena.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Arena.t;
}

class ArenaRepository {
  const ArenaRepository._();

  final attachRow = const ArenaAttachRowRepository._();

  final detachRow = const ArenaDetachRowRepository._();

  Future<List<Arena>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArenaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaTable>? orderByList,
    _i1.Transaction? transaction,
    ArenaInclude? include,
  }) async {
    return session.db.find<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Arena?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaTable>? where,
    int? offset,
    _i1.OrderByBuilder<ArenaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArenaTable>? orderByList,
    _i1.Transaction? transaction,
    ArenaInclude? include,
  }) async {
    return session.db.findFirstRow<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Arena?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ArenaInclude? include,
  }) async {
    return session.db.findById<Arena>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Arena>> insert(
    _i1.Session session,
    List<Arena> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Arena>(
      rows,
      transaction: transaction,
    );
  }

  Future<Arena> insertRow(
    _i1.Session session,
    Arena row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Arena>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Arena>> update(
    _i1.Session session,
    List<Arena> rows, {
    _i1.ColumnSelections<ArenaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Arena>(
      rows,
      columns: columns?.call(Arena.t),
      transaction: transaction,
    );
  }

  Future<Arena> updateRow(
    _i1.Session session,
    Arena row, {
    _i1.ColumnSelections<ArenaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Arena>(
      row,
      columns: columns?.call(Arena.t),
      transaction: transaction,
    );
  }

  Future<List<Arena>> delete(
    _i1.Session session,
    List<Arena> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Arena>(
      rows,
      transaction: transaction,
    );
  }

  Future<Arena> deleteRow(
    _i1.Session session,
    Arena row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Arena>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Arena>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ArenaTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Arena>(
      where: where(Arena.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Arena>(
      where: where?.call(Arena.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ArenaAttachRowRepository {
  const ArenaAttachRowRepository._();

  Future<void> team(
    _i1.Session session,
    Arena arena,
    _i2.Team team, {
    _i1.Transaction? transaction,
  }) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $team = team.copyWith(arenaId: arena.id);
    await session.db.updateRow<_i2.Team>(
      $team,
      columns: [_i2.Team.t.arenaId],
      transaction: transaction,
    );
  }
}

class ArenaDetachRowRepository {
  const ArenaDetachRowRepository._();

  Future<void> team(
    _i1.Session session,
    Arena arena, {
    _i1.Transaction? transaction,
  }) async {
    var $team = arena.team;

    if ($team == null) {
      throw ArgumentError.notNull('arena.team');
    }
    if ($team.id == null) {
      throw ArgumentError.notNull('arena.team.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $$team = $team.copyWith(arenaId: null);
    await session.db.updateRow<_i2.Team>(
      $$team,
      columns: [_i2.Team.t.arenaId],
      transaction: transaction,
    );
  }
}
