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

abstract class ArenaUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  ArenaUuid._({
    this.id,
    required this.name,
    this.team,
  });

  factory ArenaUuid({
    _i1.UuidValue? id,
    required String name,
    _i2.TeamInt? team,
  }) = _ArenaUuidImpl;

  factory ArenaUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return ArenaUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
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
  _i1.UuidValue? id;

  String name;

  _i2.TeamInt? team;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  ArenaUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    _i2.TeamInt? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
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

  @override
  ArenaUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? team = _Undefined,
  }) {
    return ArenaUuid(
      id: id is _i1.UuidValue? ? id : this.id,
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
    return session.db.find<_i1.UuidValue, ArenaUuid>(
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
    return session.db.findFirstRow<_i1.UuidValue, ArenaUuid>(
      where: where?.call(ArenaUuid.t),
      orderBy: orderBy?.call(ArenaUuid.t),
      orderByList: orderByList?.call(ArenaUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<ArenaUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ArenaUuidInclude? include,
  }) async {
    return session.db.findById<_i1.UuidValue, ArenaUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<ArenaUuid>> insert(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<_i1.UuidValue, ArenaUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<ArenaUuid> insertRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<_i1.UuidValue, ArenaUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ArenaUuid>> update(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.ColumnSelections<ArenaUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<_i1.UuidValue, ArenaUuid>(
      rows,
      columns: columns?.call(ArenaUuid.t),
      transaction: transaction,
    );
  }

  Future<ArenaUuid> updateRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.ColumnSelections<ArenaUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<_i1.UuidValue, ArenaUuid>(
      row,
      columns: columns?.call(ArenaUuid.t),
      transaction: transaction,
    );
  }

  Future<List<ArenaUuid>> delete(
    _i1.Session session,
    List<ArenaUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<_i1.UuidValue, ArenaUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<ArenaUuid> deleteRow(
    _i1.Session session,
    ArenaUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<_i1.UuidValue, ArenaUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ArenaUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ArenaUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<_i1.UuidValue, ArenaUuid>(
      where: where(ArenaUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ArenaUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<_i1.UuidValue, ArenaUuid>(
      where: where?.call(ArenaUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ArenaUuidAttachRowRepository {
  const ArenaUuidAttachRowRepository._();

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
    await session.db.updateRow<int, _i2.TeamInt>(
      $team,
      columns: [_i2.TeamInt.t.arenaId],
      transaction: transaction,
    );
  }
}

class ArenaUuidDetachRowRepository {
  const ArenaUuidDetachRowRepository._();

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
    await session.db.updateRow<int, _i2.TeamInt>(
      $$team,
      columns: [_i2.TeamInt.t.arenaId],
      transaction: transaction,
    );
  }
}
