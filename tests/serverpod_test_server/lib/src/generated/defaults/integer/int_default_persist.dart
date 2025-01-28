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

abstract class IntDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  IntDefaultPersist._({
    this.id,
    this.intDefaultPersist,
  });

  factory IntDefaultPersist({
    int? id,
    int? intDefaultPersist,
  }) = _IntDefaultPersistImpl;

  factory IntDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultPersist(
      id: jsonSerialization['id'] as int?,
      intDefaultPersist: jsonSerialization['intDefaultPersist'] as int?,
    );
  }

  static final t = IntDefaultPersistTable();

  static const db = IntDefaultPersistRepository._();

  @override
  int? id;

  int? intDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefaultPersist copyWith({
    int? id,
    int? intDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (intDefaultPersist != null) 'intDefaultPersist': intDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (intDefaultPersist != null) 'intDefaultPersist': intDefaultPersist,
    };
  }

  static IntDefaultPersistInclude include() {
    return IntDefaultPersistInclude._();
  }

  static IntDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    IntDefaultPersistInclude? include,
  }) {
    return IntDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultPersistImpl extends IntDefaultPersist {
  _IntDefaultPersistImpl({
    int? id,
    int? intDefaultPersist,
  }) : super._(
          id: id,
          intDefaultPersist: intDefaultPersist,
        );

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? intDefaultPersist = _Undefined,
  }) {
    return IntDefaultPersist(
      id: id is int? ? id : this.id,
      intDefaultPersist: intDefaultPersist is int?
          ? intDefaultPersist
          : this.intDefaultPersist,
    );
  }
}

class IntDefaultPersistTable extends _i1.Table {
  IntDefaultPersistTable({super.tableRelation})
      : super(tableName: 'int_default_persist') {
    intDefaultPersist = _i1.ColumnInt(
      'intDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt intDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        intDefaultPersist,
      ];
}

class IntDefaultPersistInclude extends _i1.IncludeObject {
  IntDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => IntDefaultPersist.t;
}

class IntDefaultPersistIncludeList extends _i1.IncludeList {
  IntDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => IntDefaultPersist.t;
}

class IntDefaultPersistRepository {
  const IntDefaultPersistRepository._();

  Future<List<IntDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<IntDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<IntDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IntDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  Future<List<IntDefaultPersist>> insert(
    _i1.Session session,
    List<IntDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IntDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<IntDefaultPersist> insertRow(
    _i1.Session session,
    IntDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<IntDefaultPersist>> update(
    _i1.Session session,
    List<IntDefaultPersist> rows, {
    _i1.ColumnSelections<IntDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IntDefaultPersist>(
      rows,
      columns: columns?.call(IntDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<IntDefaultPersist> updateRow(
    _i1.Session session,
    IntDefaultPersist row, {
    _i1.ColumnSelections<IntDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefaultPersist>(
      row,
      columns: columns?.call(IntDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<List<IntDefaultPersist>> delete(
    _i1.Session session,
    List<IntDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IntDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<IntDefaultPersist> deleteRow(
    _i1.Session session,
    IntDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<IntDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IntDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IntDefaultPersist>(
      where: where(IntDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
