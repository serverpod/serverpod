/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Member extends _i1.TableRow {
  Member._({
    int? id,
    required this.name,
    this.blocking,
    this.blockedBy,
  }) : super(id);

  factory Member({
    int? id,
    required String name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  }) = _MemberImpl;

  factory Member.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Member(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      blocking: serializationManager
          .deserialize<List<_i2.Blocking>?>(jsonSerialization['blocking']),
      blockedBy: serializationManager
          .deserialize<List<_i2.Blocking>?>(jsonSerialization['blockedBy']),
    );
  }

  static final t = MemberTable();

  static const db = MemberRepository._();

  String name;

  List<_i2.Blocking>? blocking;

  List<_i2.Blocking>? blockedBy;

  @override
  _i1.Table get table => t;

  Member copyWith({
    int? id,
    String? name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'blocking': blocking,
      'blockedBy': blockedBy,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'blocking': blocking,
      'blockedBy': blockedBy,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Member>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.db.find<Member>(
      where: where != null ? where(Member.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Member?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.db.findSingleRow<Member>(
      where: where != null ? where(Member.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Member?> findById(
    _i1.Session session,
    int id, {
    MemberInclude? include,
  }) async {
    return session.db.findById<Member>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Member>(
      where: where(Member.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Member>(
      where: where != null ? where(Member.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static MemberInclude include({
    _i2.BlockingIncludeList? blocking,
    _i2.BlockingIncludeList? blockedBy,
  }) {
    return MemberInclude._(
      blocking: blocking,
      blockedBy: blockedBy,
    );
  }

  static MemberIncludeList includeList({
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    MemberInclude? include,
  }) {
    return MemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _MemberImpl extends Member {
  _MemberImpl({
    int? id,
    required String name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  }) : super._(
          id: id,
          name: name,
          blocking: blocking,
          blockedBy: blockedBy,
        );

  @override
  Member copyWith({
    Object? id = _Undefined,
    String? name,
    Object? blocking = _Undefined,
    Object? blockedBy = _Undefined,
  }) {
    return Member(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      blocking:
          blocking is List<_i2.Blocking>? ? blocking : this.blocking?.clone(),
      blockedBy: blockedBy is List<_i2.Blocking>?
          ? blockedBy
          : this.blockedBy?.clone(),
    );
  }
}

class MemberTable extends _i1.Table {
  MemberTable({super.tableRelation}) : super(tableName: 'member') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.BlockingTable? ___blocking;

  _i1.ManyRelation<_i2.BlockingTable>? _blocking;

  _i2.BlockingTable? ___blockedBy;

  _i1.ManyRelation<_i2.BlockingTable>? _blockedBy;

  _i2.BlockingTable get __blocking {
    if (___blocking != null) return ___blocking!;
    ___blocking = _i1.createRelationTable(
      relationFieldName: '__blocking',
      field: Member.t.id,
      foreignField: _i2.Blocking.t.blockedById,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.BlockingTable(tableRelation: foreignTableRelation),
    );
    return ___blocking!;
  }

  _i2.BlockingTable get __blockedBy {
    if (___blockedBy != null) return ___blockedBy!;
    ___blockedBy = _i1.createRelationTable(
      relationFieldName: '__blockedBy',
      field: Member.t.id,
      foreignField: _i2.Blocking.t.blockedId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.BlockingTable(tableRelation: foreignTableRelation),
    );
    return ___blockedBy!;
  }

  _i1.ManyRelation<_i2.BlockingTable> get blocking {
    if (_blocking != null) return _blocking!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'blocking',
      field: Member.t.id,
      foreignField: _i2.Blocking.t.blockedById,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.BlockingTable(tableRelation: foreignTableRelation),
    );
    _blocking = _i1.ManyRelation<_i2.BlockingTable>(
      tableWithRelations: relationTable,
      table: _i2.BlockingTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _blocking!;
  }

  _i1.ManyRelation<_i2.BlockingTable> get blockedBy {
    if (_blockedBy != null) return _blockedBy!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'blockedBy',
      field: Member.t.id,
      foreignField: _i2.Blocking.t.blockedId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.BlockingTable(tableRelation: foreignTableRelation),
    );
    _blockedBy = _i1.ManyRelation<_i2.BlockingTable>(
      tableWithRelations: relationTable,
      table: _i2.BlockingTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _blockedBy!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'blocking') {
      return __blocking;
    }
    if (relationField == 'blockedBy') {
      return __blockedBy;
    }
    return null;
  }
}

@Deprecated('Use MemberTable.t instead.')
MemberTable tMember = MemberTable();

class MemberInclude extends _i1.IncludeObject {
  MemberInclude._({
    _i2.BlockingIncludeList? blocking,
    _i2.BlockingIncludeList? blockedBy,
  }) {
    _blocking = blocking;
    _blockedBy = blockedBy;
  }

  _i2.BlockingIncludeList? _blocking;

  _i2.BlockingIncludeList? _blockedBy;

  @override
  Map<String, _i1.Include?> get includes => {
        'blocking': _blocking,
        'blockedBy': _blockedBy,
      };

  @override
  _i1.Table get table => Member.t;
}

class MemberIncludeList extends _i1.IncludeList {
  MemberIncludeList._({
    _i1.WhereExpressionBuilder<MemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Member.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Member.t;
}

class MemberRepository {
  const MemberRepository._();

  final attach = const MemberAttachRepository._();

  final attachRow = const MemberAttachRowRepository._();

  Future<List<Member>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.dbNext.find<Member>(
      where: where?.call(Member.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Member?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Member>(
      where: where?.call(Member.t),
      transaction: transaction,
      include: include,
    );
  }

  Future<Member?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.dbNext.findById<Member>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Member>> insert(
    _i1.Session session,
    List<Member> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Member>(
      rows,
      transaction: transaction,
    );
  }

  Future<Member> insertRow(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Member>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Member>> update(
    _i1.Session session,
    List<Member> rows, {
    _i1.ColumnSelections<MemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Member>(
      rows,
      columns: columns?.call(Member.t),
      transaction: transaction,
    );
  }

  Future<Member> updateRow(
    _i1.Session session,
    Member row, {
    _i1.ColumnSelections<MemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Member>(
      row,
      columns: columns?.call(Member.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Member> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Member>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Member>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Member>(
      where: where(Member.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Member>(
      where: where?.call(Member.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class MemberAttachRepository {
  const MemberAttachRepository._();

  Future<void> blocking(
    _i1.Session session,
    Member member,
    List<_i2.Blocking> blocking,
  ) async {
    if (blocking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking =
        blocking.map((e) => e.copyWith(blockedById: member.id)).toList();
    await session.dbNext.update<_i2.Blocking>(
      $blocking,
      columns: [_i2.Blocking.t.blockedById],
    );
  }

  Future<void> blockedBy(
    _i1.Session session,
    Member member,
    List<_i2.Blocking> blocking,
  ) async {
    if (blocking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking =
        blocking.map((e) => e.copyWith(blockedId: member.id)).toList();
    await session.dbNext.update<_i2.Blocking>(
      $blocking,
      columns: [_i2.Blocking.t.blockedId],
    );
  }
}

class MemberAttachRowRepository {
  const MemberAttachRowRepository._();

  Future<void> blocking(
    _i1.Session session,
    Member member,
    _i2.Blocking blocking,
  ) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking.copyWith(blockedById: member.id);
    await session.dbNext.updateRow<_i2.Blocking>(
      $blocking,
      columns: [_i2.Blocking.t.blockedById],
    );
  }

  Future<void> blockedBy(
    _i1.Session session,
    Member member,
    _i2.Blocking blocking,
  ) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (member.id == null) {
      throw ArgumentError.notNull('member.id');
    }

    var $blocking = blocking.copyWith(blockedId: member.id);
    await session.dbNext.updateRow<_i2.Blocking>(
      $blocking,
      columns: [_i2.Blocking.t.blockedId],
    );
  }
}
