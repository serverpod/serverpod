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

abstract class BoolDefault implements _i1.TableRow, _i1.ProtocolSerialization {
  BoolDefault._({
    this.id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  })  : boolDefaultTrue = boolDefaultTrue ?? true,
        boolDefaultFalse = boolDefaultFalse ?? false,
        boolDefaultNullFalse = boolDefaultNullFalse ?? false;

  factory BoolDefault({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) = _BoolDefaultImpl;

  factory BoolDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefault(
      id: jsonSerialization['id'] as int?,
      boolDefaultTrue: jsonSerialization['boolDefaultTrue'] as bool,
      boolDefaultFalse: jsonSerialization['boolDefaultFalse'] as bool,
      boolDefaultNullFalse: jsonSerialization['boolDefaultNullFalse'] as bool?,
    );
  }

  static final t = BoolDefaultTable();

  static const db = BoolDefaultRepository._();

  @override
  int? id;

  bool boolDefaultTrue;

  bool boolDefaultFalse;

  bool? boolDefaultNullFalse;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefault copyWith({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultTrue': boolDefaultTrue,
      'boolDefaultFalse': boolDefaultFalse,
      if (boolDefaultNullFalse != null)
        'boolDefaultNullFalse': boolDefaultNullFalse,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'boolDefaultTrue': boolDefaultTrue,
      'boolDefaultFalse': boolDefaultFalse,
      if (boolDefaultNullFalse != null)
        'boolDefaultNullFalse': boolDefaultNullFalse,
    };
  }

  static BoolDefaultInclude include() {
    return BoolDefaultInclude._();
  }

  static BoolDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultTable>? orderByList,
    BoolDefaultInclude? include,
  }) {
    return BoolDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoolDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultImpl extends BoolDefault {
  _BoolDefaultImpl({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) : super._(
          id: id,
          boolDefaultTrue: boolDefaultTrue,
          boolDefaultFalse: boolDefaultFalse,
          boolDefaultNullFalse: boolDefaultNullFalse,
        );

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefault copyWith({
    Object? id = _Undefined,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    Object? boolDefaultNullFalse = _Undefined,
  }) {
    return BoolDefault(
      id: id is int? ? id : this.id,
      boolDefaultTrue: boolDefaultTrue ?? this.boolDefaultTrue,
      boolDefaultFalse: boolDefaultFalse ?? this.boolDefaultFalse,
      boolDefaultNullFalse: boolDefaultNullFalse is bool?
          ? boolDefaultNullFalse
          : this.boolDefaultNullFalse,
    );
  }
}

class BoolDefaultTable extends _i1.Table {
  BoolDefaultTable({super.tableRelation}) : super(tableName: 'bool_default') {
    boolDefaultTrue = _i1.ColumnBool(
      'boolDefaultTrue',
      this,
      hasDefault: true,
    );
    boolDefaultFalse = _i1.ColumnBool(
      'boolDefaultFalse',
      this,
      hasDefault: true,
    );
    boolDefaultNullFalse = _i1.ColumnBool(
      'boolDefaultNullFalse',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnBool boolDefaultTrue;

  late final _i1.ColumnBool boolDefaultFalse;

  late final _i1.ColumnBool boolDefaultNullFalse;

  @override
  List<_i1.Column> get columns => [
        id,
        boolDefaultTrue,
        boolDefaultFalse,
        boolDefaultNullFalse,
      ];
}

class BoolDefaultInclude extends _i1.IncludeObject {
  BoolDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => BoolDefault.t;
}

class BoolDefaultIncludeList extends _i1.IncludeList {
  BoolDefaultIncludeList._({
    _i1.WhereExpressionBuilder<BoolDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoolDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => BoolDefault.t;
}

class BoolDefaultRepository {
  const BoolDefaultRepository._();

  Future<List<BoolDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<BoolDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoolDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<BoolDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoolDefault>(
      id,
      transaction: transaction,
    );
  }

  Future<List<BoolDefault>> insert(
    _i1.Session session,
    List<BoolDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoolDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<BoolDefault> insertRow(
    _i1.Session session,
    BoolDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<BoolDefault>> update(
    _i1.Session session,
    List<BoolDefault> rows, {
    _i1.ColumnSelections<BoolDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoolDefault>(
      rows,
      columns: columns?.call(BoolDefault.t),
      transaction: transaction,
    );
  }

  Future<BoolDefault> updateRow(
    _i1.Session session,
    BoolDefault row, {
    _i1.ColumnSelections<BoolDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefault>(
      row,
      columns: columns?.call(BoolDefault.t),
      transaction: transaction,
    );
  }

  Future<List<BoolDefault>> delete(
    _i1.Session session,
    List<BoolDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoolDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<BoolDefault> deleteRow(
    _i1.Session session,
    BoolDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<BoolDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoolDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoolDefault>(
      where: where(BoolDefault.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefault>(
      where: where?.call(BoolDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
