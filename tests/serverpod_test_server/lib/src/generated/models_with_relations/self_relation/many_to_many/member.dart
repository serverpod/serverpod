/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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
      if (id != null) 'id': id,
      'name': name,
      if (blocking != null)
        'blocking': blocking?.toJson(valueToJson: (v) => v.toJson()),
      if (blockedBy != null)
        'blockedBy': blockedBy?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (blocking != null)
        'blocking': blocking?.toJson(valueToJson: (v) => v.allToJson()),
      if (blockedBy != null)
        'blockedBy': blockedBy?.toJson(valueToJson: (v) => v.allToJson()),
    };
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
    _i1.OrderByBuilder<MemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberTable>? orderByList,
    MemberInclude? include,
  }) {
    return MemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Member.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Member.t),
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
    _i1.OrderByBuilder<MemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberTable>? orderByList,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.db.find<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Member?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<MemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberTable>? orderByList,
    _i1.Transaction? transaction,
    MemberInclude? include,
  }) async {
    return session.db.findFirstRow<Member>(
      where: where?.call(Member.t),
      orderBy: orderBy?.call(Member.t),
      orderByList: orderByList?.call(Member.t),
      orderDescending: orderDescending,
      offset: offset,
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
    return session.db.findById<Member>(
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
    return session.db.insert<Member>(
      rows,
      transaction: transaction,
    );
  }

  Future<Member> insertRow(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Member>(
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
    return session.db.update<Member>(
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
    return session.db.updateRow<Member>(
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
    return session.db.delete<Member>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Member row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Member>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Member>(
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
    return session.db.count<Member>(
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
    await session.db.update<_i2.Blocking>(
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
    await session.db.update<_i2.Blocking>(
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
    await session.db.updateRow<_i2.Blocking>(
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
    await session.db.updateRow<_i2.Blocking>(
      $blocking,
      columns: [_i2.Blocking.t.blockedId],
    );
  }
}
