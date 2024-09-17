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

abstract class EmptyModelWithTable extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  EmptyModelWithTable._({int? id}) : super(id);

  factory EmptyModelWithTable({int? id}) = _EmptyModelWithTableImpl;

  factory EmptyModelWithTable.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmptyModelWithTable(id: jsonSerialization['id'] as int?);
  }

  static final t = EmptyModelWithTableTable();

  static const db = EmptyModelWithTableRepository._();

  @override
  _i1.Table get table => t;

  EmptyModelWithTable copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static EmptyModelWithTableInclude include() {
    return EmptyModelWithTableInclude._();
  }

  static EmptyModelWithTableIncludeList includeList({
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    EmptyModelWithTableInclude? include,
  }) {
    return EmptyModelWithTableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelWithTableImpl extends EmptyModelWithTable {
  _EmptyModelWithTableImpl({int? id}) : super._(id: id);

  @override
  EmptyModelWithTable copyWith({Object? id = _Undefined}) {
    return EmptyModelWithTable(id: id is int? ? id : this.id);
  }
}

class EmptyModelWithTableTable extends _i1.Table {
  EmptyModelWithTableTable({super.tableRelation})
      : super(tableName: 'empty_model_with_table') {}

  @override
  List<_i1.Column> get columns => [id];
}

class EmptyModelWithTableInclude extends _i1.IncludeObject {
  EmptyModelWithTableInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmptyModelWithTable.t;
}

class EmptyModelWithTableIncludeList extends _i1.IncludeList {
  EmptyModelWithTableIncludeList._({
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmptyModelWithTable.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmptyModelWithTable.t;
}

class EmptyModelWithTableRepository {
  const EmptyModelWithTableRepository._();

  Future<List<EmptyModelWithTable>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EmptyModelWithTable?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EmptyModelWithTable?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<EmptyModelWithTable>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EmptyModelWithTable>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<EmptyModelWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<EmptyModelWithTable>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EmptyModelWithTable> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    EmptyModelWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<EmptyModelWithTable>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EmptyModelWithTable>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<EmptyModelWithTable> rows, {
    _i1.ColumnSelections<EmptyModelWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<EmptyModelWithTable>(
      rows,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EmptyModelWithTable> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    EmptyModelWithTable row, {
    _i1.ColumnSelections<EmptyModelWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<EmptyModelWithTable>(
      row,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EmptyModelWithTable>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<EmptyModelWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<EmptyModelWithTable>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<EmptyModelWithTable> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    EmptyModelWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<EmptyModelWithTable>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<EmptyModelWithTable>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<EmptyModelWithTableTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<EmptyModelWithTable>(
      where: where(EmptyModelWithTable.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
