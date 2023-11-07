/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Blocking extends _i1.TableRow {
  Blocking._({
    int? id,
    required this.blockingId,
    this.blocking,
    required this.blockedById,
    this.blockedBy,
  }) : super(id);

  factory Blocking({
    int? id,
    required int blockingId,
    _i2.Member? blocking,
    required int blockedById,
    _i2.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blocking(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      blockingId: serializationManager
          .deserialize<int>(jsonSerialization['blockingId']),
      blocking: serializationManager
          .deserialize<_i2.Member?>(jsonSerialization['blocking']),
      blockedById: serializationManager
          .deserialize<int>(jsonSerialization['blockedById']),
      blockedBy: serializationManager
          .deserialize<_i2.Member?>(jsonSerialization['blockedBy']),
    );
  }

  static final t = BlockingTable();

  static const db = BlockingRepository._();

  int blockingId;

  _i2.Member? blocking;

  int blockedById;

  _i2.Member? blockedBy;

  @override
  _i1.Table get table => t;

  Blocking copyWith({
    int? id,
    int? blockingId,
    _i2.Member? blocking,
    int? blockedById,
    _i2.Member? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockingId': blockingId,
      'blocking': blocking,
      'blockedById': blockedById,
      'blockedBy': blockedBy,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'blockingId': blockingId,
      'blockedById': blockedById,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'blockingId': blockingId,
      'blocking': blocking,
      'blockedById': blockedById,
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
      case 'blockingId':
        blockingId = value;
        return;
      case 'blockedById':
        blockedById = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Blocking>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.db.find<Blocking>(
      where: where != null ? where(Blocking.t) : null,
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
  static Future<Blocking?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.db.findSingleRow<Blocking>(
      where: where != null ? where(Blocking.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Blocking?> findById(
    _i1.Session session,
    int id, {
    BlockingInclude? include,
  }) async {
    return session.db.findById<Blocking>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BlockingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Blocking>(
      where: where(Blocking.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Blocking row, {
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
    Blocking row, {
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
    Blocking row, {
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
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Blocking>(
      where: where != null ? where(Blocking.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static BlockingInclude include({
    _i2.MemberInclude? blocking,
    _i2.MemberInclude? blockedBy,
  }) {
    return BlockingInclude._(
      blocking: blocking,
      blockedBy: blockedBy,
    );
  }

  static BlockingIncludeList includeList({
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    BlockingInclude? include,
  }) {
    return BlockingIncludeList._(
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

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockingId,
    _i2.Member? blocking,
    required int blockedById,
    _i2.Member? blockedBy,
  }) : super._(
          id: id,
          blockingId: blockingId,
          blocking: blocking,
          blockedById: blockedById,
          blockedBy: blockedBy,
        );

  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockingId,
    Object? blocking = _Undefined,
    int? blockedById,
    Object? blockedBy = _Undefined,
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockingId: blockingId ?? this.blockingId,
      blocking: blocking is _i2.Member? ? blocking : this.blocking?.copyWith(),
      blockedById: blockedById ?? this.blockedById,
      blockedBy:
          blockedBy is _i2.Member? ? blockedBy : this.blockedBy?.copyWith(),
    );
  }
}

class BlockingTable extends _i1.Table {
  BlockingTable({super.tableRelation}) : super(tableName: 'blocking') {
    blockingId = _i1.ColumnInt(
      'blockingId',
      this,
    );
    blockedById = _i1.ColumnInt(
      'blockedById',
      this,
    );
  }

  late final _i1.ColumnInt blockingId;

  _i2.MemberTable? _blocking;

  late final _i1.ColumnInt blockedById;

  _i2.MemberTable? _blockedBy;

  _i2.MemberTable get blocking {
    if (_blocking != null) return _blocking!;
    _blocking = _i1.createRelationTable(
      relationFieldName: 'blocking',
      field: Blocking.t.blockingId,
      foreignField: _i2.Member.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MemberTable(tableRelation: foreignTableRelation),
    );
    return _blocking!;
  }

  _i2.MemberTable get blockedBy {
    if (_blockedBy != null) return _blockedBy!;
    _blockedBy = _i1.createRelationTable(
      relationFieldName: 'blockedBy',
      field: Blocking.t.blockedById,
      foreignField: _i2.Member.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MemberTable(tableRelation: foreignTableRelation),
    );
    return _blockedBy!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        blockingId,
        blockedById,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'blocking') {
      return blocking;
    }
    if (relationField == 'blockedBy') {
      return blockedBy;
    }
    return null;
  }
}

@Deprecated('Use BlockingTable.t instead.')
BlockingTable tBlocking = BlockingTable();

class BlockingInclude extends _i1.IncludeObject {
  BlockingInclude._({
    _i2.MemberInclude? blocking,
    _i2.MemberInclude? blockedBy,
  }) {
    _blocking = blocking;
    _blockedBy = blockedBy;
  }

  _i2.MemberInclude? _blocking;

  _i2.MemberInclude? _blockedBy;

  @override
  Map<String, _i1.Include?> get includes => {
        'blocking': _blocking,
        'blockedBy': _blockedBy,
      };

  @override
  _i1.Table get table => Blocking.t;
}

class BlockingIncludeList extends _i1.IncludeList {
  BlockingIncludeList._({
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Blocking.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Blocking.t;
}

class BlockingRepository {
  const BlockingRepository._();

  final attachRow = const BlockingAttachRowRepository._();

  Future<List<Blocking>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.dbNext.find<Blocking>(
      where: where?.call(Blocking.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Blocking?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Blocking>(
      where: where?.call(Blocking.t),
      transaction: transaction,
      include: include,
    );
  }

  Future<Blocking?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.dbNext.findById<Blocking>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Blocking>> insert(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Blocking>(
      rows,
      transaction: transaction,
    );
  }

  Future<Blocking> insertRow(
    _i1.Session session,
    Blocking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Blocking>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Blocking>> update(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.ColumnSelections<BlockingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Blocking>(
      rows,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
    );
  }

  Future<Blocking> updateRow(
    _i1.Session session,
    Blocking row, {
    _i1.ColumnSelections<BlockingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Blocking>(
      row,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Blocking>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Blocking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Blocking>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BlockingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Blocking>(
      where: where(Blocking.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Blocking>(
      where: where?.call(Blocking.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BlockingAttachRowRepository {
  const BlockingAttachRowRepository._();

  Future<void> blocking(
    _i1.Session session,
    Blocking blocking,
    _i2.Member nestedBlocking,
  ) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (nestedBlocking.id == null) {
      throw ArgumentError.notNull('nestedBlocking.id');
    }

    var $blocking = blocking.copyWith(blockingId: nestedBlocking.id);
    await session.dbNext.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockingId],
    );
  }

  Future<void> blockedBy(
    _i1.Session session,
    Blocking blocking,
    _i2.Member blockedBy,
  ) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (blockedBy.id == null) {
      throw ArgumentError.notNull('blockedBy.id');
    }

    var $blocking = blocking.copyWith(blockedById: blockedBy.id);
    await session.dbNext.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockedById],
    );
  }
}
