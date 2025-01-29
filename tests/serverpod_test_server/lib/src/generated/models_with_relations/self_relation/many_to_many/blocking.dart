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
import '../../../models_with_relations/self_relation/many_to_many/member.dart'
    as _i2;

abstract class Blocking implements _i1.TableRow, _i1.ProtocolSerialization {
  Blocking._({
    this.id,
    required this.blockedId,
    this.blocked,
    required this.blockedById,
    this.blockedBy,
  });

  factory Blocking({
    int? id,
    required int blockedId,
    _i2.Member? blocked,
    required int blockedById,
    _i2.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(Map<String, dynamic> jsonSerialization) {
    return Blocking(
      id: jsonSerialization['id'] as int?,
      blockedId: jsonSerialization['blockedId'] as int,
      blocked: jsonSerialization['blocked'] == null
          ? null
          : _i2.Member.fromJson(
              (jsonSerialization['blocked'] as Map<String, dynamic>)),
      blockedById: jsonSerialization['blockedById'] as int,
      blockedBy: jsonSerialization['blockedBy'] == null
          ? null
          : _i2.Member.fromJson(
              (jsonSerialization['blockedBy'] as Map<String, dynamic>)),
    );
  }

  static final t = BlockingTable();

  static const db = BlockingRepository._();

  @override
  int? id;

  int blockedId;

  _i2.Member? blocked;

  int blockedById;

  _i2.Member? blockedBy;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Blocking copyWith({
    int? id,
    int? blockedId,
    _i2.Member? blocked,
    int? blockedById,
    _i2.Member? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJson(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJsonForProtocol(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJsonForProtocol(),
    };
  }

  static BlockingInclude include({
    _i2.MemberInclude? blocked,
    _i2.MemberInclude? blockedBy,
  }) {
    return BlockingInclude._(
      blocked: blocked,
      blockedBy: blockedBy,
    );
  }

  static BlockingIncludeList includeList({
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BlockingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockingTable>? orderByList,
    BlockingInclude? include,
  }) {
    return BlockingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Blocking.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Blocking.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockedId,
    _i2.Member? blocked,
    required int blockedById,
    _i2.Member? blockedBy,
  }) : super._(
          id: id,
          blockedId: blockedId,
          blocked: blocked,
          blockedById: blockedById,
          blockedBy: blockedBy,
        );

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockedId,
    Object? blocked = _Undefined,
    int? blockedById,
    Object? blockedBy = _Undefined,
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockedId: blockedId ?? this.blockedId,
      blocked: blocked is _i2.Member? ? blocked : this.blocked?.copyWith(),
      blockedById: blockedById ?? this.blockedById,
      blockedBy:
          blockedBy is _i2.Member? ? blockedBy : this.blockedBy?.copyWith(),
    );
  }
}

class BlockingTable extends _i1.Table {
  BlockingTable({super.tableRelation}) : super(tableName: 'blocking') {
    blockedId = _i1.ColumnInt(
      'blockedId',
      this,
    );
    blockedById = _i1.ColumnInt(
      'blockedById',
      this,
    );
  }

  late final _i1.ColumnInt blockedId;

  _i2.MemberTable? _blocked;

  late final _i1.ColumnInt blockedById;

  _i2.MemberTable? _blockedBy;

  _i2.MemberTable get blocked {
    if (_blocked != null) return _blocked!;
    _blocked = _i1.createRelationTable(
      relationFieldName: 'blocked',
      field: Blocking.t.blockedId,
      foreignField: _i2.Member.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MemberTable(tableRelation: foreignTableRelation),
    );
    return _blocked!;
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
        blockedId,
        blockedById,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'blocked') {
      return blocked;
    }
    if (relationField == 'blockedBy') {
      return blockedBy;
    }
    return null;
  }
}

class BlockingInclude extends _i1.IncludeObject {
  BlockingInclude._({
    _i2.MemberInclude? blocked,
    _i2.MemberInclude? blockedBy,
  }) {
    _blocked = blocked;
    _blockedBy = blockedBy;
  }

  _i2.MemberInclude? _blocked;

  _i2.MemberInclude? _blockedBy;

  @override
  Map<String, _i1.Include?> get includes => {
        'blocked': _blocked,
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

  /// Returns a list of [Blocking]s matching the given query parameters.
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
  Future<List<Blocking>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BlockingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockingTable>? orderByList,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.db.find<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Blocking] matching the given query parameters.
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
  Future<Blocking?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? offset,
    _i1.OrderByBuilder<BlockingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockingTable>? orderByList,
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.db.findFirstRow<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Blocking] by its [id] or null if no such row exists.
  Future<Blocking?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BlockingInclude? include,
  }) async {
    return session.db.findById<Blocking>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Blocking]s in the list and returns the inserted rows.
  ///
  /// The returned [Blocking]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Blocking>> insert(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Blocking>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Blocking] and returns the inserted row.
  ///
  /// The returned [Blocking] will have its `id` field set.
  Future<Blocking> insertRow(
    _i1.Session session,
    Blocking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Blocking>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Blocking]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Blocking>> update(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.ColumnSelections<BlockingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Blocking>(
      rows,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Blocking]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Blocking> updateRow(
    _i1.Session session,
    Blocking row, {
    _i1.ColumnSelections<BlockingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Blocking>(
      row,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Blocking]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Blocking>> delete(
    _i1.Session session,
    List<Blocking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Blocking>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Blocking].
  Future<Blocking> deleteRow(
    _i1.Session session,
    Blocking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Blocking>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Blocking>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BlockingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Blocking>(
      where: where(Blocking.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Blocking>(
      where: where?.call(Blocking.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BlockingAttachRowRepository {
  const BlockingAttachRowRepository._();

  /// Creates a relation between the given [Blocking] and [Member]
  /// by setting the [Blocking]'s foreign key `blockedId` to refer to the [Member].
  Future<void> blocked(
    _i1.Session session,
    Blocking blocking,
    _i2.Member blocked, {
    _i1.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (blocked.id == null) {
      throw ArgumentError.notNull('blocked.id');
    }

    var $blocking = blocking.copyWith(blockedId: blocked.id);
    await session.db.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockedId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Blocking] and [Member]
  /// by setting the [Blocking]'s foreign key `blockedById` to refer to the [Member].
  Future<void> blockedBy(
    _i1.Session session,
    Blocking blocking,
    _i2.Member blockedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (blockedBy.id == null) {
      throw ArgumentError.notNull('blockedBy.id');
    }

    var $blocking = blocking.copyWith(blockedById: blockedBy.id);
    await session.db.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockedById],
      transaction: transaction,
    );
  }
}
