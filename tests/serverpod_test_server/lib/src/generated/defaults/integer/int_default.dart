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

abstract class IntDefault implements _i1.TableRow, _i1.ProtocolSerialization {
  IntDefault._({
    this.id,
    int? intDefault,
    int? intDefaultNull,
  })  : intDefault = intDefault ?? 10,
        intDefaultNull = intDefaultNull ?? 20;

  factory IntDefault({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) = _IntDefaultImpl;

  factory IntDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefault(
      id: jsonSerialization['id'] as int?,
      intDefault: jsonSerialization['intDefault'] as int,
      intDefaultNull: jsonSerialization['intDefaultNull'] as int?,
    );
  }

  static final t = IntDefaultTable();

  static const db = IntDefaultRepository._();

  @override
  int? id;

  int intDefault;

  int? intDefaultNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefault copyWith({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefault': intDefault,
      if (intDefaultNull != null) 'intDefaultNull': intDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'intDefault': intDefault,
      if (intDefaultNull != null) 'intDefaultNull': intDefaultNull,
    };
  }

  static IntDefaultInclude include() {
    return IntDefaultInclude._();
  }

  static IntDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    IntDefaultInclude? include,
  }) {
    return IntDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultImpl extends IntDefault {
  _IntDefaultImpl({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) : super._(
          id: id,
          intDefault: intDefault,
          intDefaultNull: intDefaultNull,
        );

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefault copyWith({
    Object? id = _Undefined,
    int? intDefault,
    Object? intDefaultNull = _Undefined,
  }) {
    return IntDefault(
      id: id is int? ? id : this.id,
      intDefault: intDefault ?? this.intDefault,
      intDefaultNull:
          intDefaultNull is int? ? intDefaultNull : this.intDefaultNull,
    );
  }
}

class IntDefaultTable extends _i1.Table {
  IntDefaultTable({super.tableRelation}) : super(tableName: 'int_default') {
    intDefault = _i1.ColumnInt(
      'intDefault',
      this,
      hasDefault: true,
    );
    intDefaultNull = _i1.ColumnInt(
      'intDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt intDefault;

  late final _i1.ColumnInt intDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        intDefault,
        intDefaultNull,
      ];
}

class IntDefaultInclude extends _i1.IncludeObject {
  IntDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => IntDefault.t;
}

class IntDefaultIncludeList extends _i1.IncludeList {
  IntDefaultIncludeList._({
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => IntDefault.t;
}

class IntDefaultRepository {
  const IntDefaultRepository._();

  Future<List<IntDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IntDefault>(
      where: where?.call(IntDefault.t),
      orderBy: orderBy?.call(IntDefault.t),
      orderByList: orderByList?.call(IntDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<IntDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IntDefault>(
      where: where?.call(IntDefault.t),
      orderBy: orderBy?.call(IntDefault.t),
      orderByList: orderByList?.call(IntDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<IntDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IntDefault>(
      id,
      transaction: transaction,
    );
  }

  Future<List<IntDefault>> insert(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IntDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<IntDefault> insertRow(
    _i1.Session session,
    IntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<IntDefault>> update(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.ColumnSelections<IntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IntDefault>(
      rows,
      columns: columns?.call(IntDefault.t),
      transaction: transaction,
    );
  }

  Future<IntDefault> updateRow(
    _i1.Session session,
    IntDefault row, {
    _i1.ColumnSelections<IntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefault>(
      row,
      columns: columns?.call(IntDefault.t),
      transaction: transaction,
    );
  }

  Future<List<IntDefault>> delete(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IntDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<IntDefault> deleteRow(
    _i1.Session session,
    IntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<IntDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IntDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IntDefault>(
      where: where(IntDefault.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IntDefault>(
      where: where?.call(IntDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
