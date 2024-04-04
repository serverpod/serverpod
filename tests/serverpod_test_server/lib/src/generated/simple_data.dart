/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
abstract class SimpleData extends _i1.TableRow {
  SimpleData._({
    int? id,
    required this.num,
  }) : super(id);

  factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleDataImpl;

  factory SimpleData.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleData(
      id: jsonSerialization['id'] as int?,
      num: jsonSerialization['num'] as int,
    );
  }

  static final t = SimpleDataTable();

  static const db = SimpleDataRepository._();

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int num;

  @override
  _i1.Table get table => t;

  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'num': num,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'num': num,
    };
  }

  static SimpleDataInclude include() {
    return SimpleDataInclude._();
  }

  static SimpleDataIncludeList includeList({
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    SimpleDataInclude? include,
  }) {
    return SimpleDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SimpleData.t),
      include: include,
    );
  }
}

class _Undefined {}

class _SimpleDataImpl extends SimpleData {
  _SimpleDataImpl({
    int? id,
    required int num,
  }) : super._(
          id: id,
          num: num,
        );

  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id is int? ? id : this.id,
      num: num ?? this.num,
    );
  }
}

class SimpleDataTable extends _i1.Table {
  SimpleDataTable({super.tableRelation}) : super(tableName: 'simple_data') {
    num = _i1.ColumnInt(
      'num',
      this,
    );
  }

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  late final _i1.ColumnInt num;

  @override
  List<_i1.Column> get columns => [
        id,
        num,
      ];
}

class SimpleDataInclude extends _i1.IncludeObject {
  SimpleDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SimpleData.t;
}

class SimpleDataIncludeList extends _i1.IncludeList {
  SimpleDataIncludeList._({
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SimpleData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => SimpleData.t;
}

class SimpleDataRepository {
  const SimpleDataRepository._();

  Future<List<SimpleData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SimpleData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<SimpleDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SimpleData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SimpleData>(
      id,
      transaction: transaction,
    );
  }

  Future<List<SimpleData>> insert(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SimpleData>(
      rows,
      transaction: transaction,
    );
  }

  Future<SimpleData> insertRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<SimpleData>> update(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.ColumnSelections<SimpleDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SimpleData>(
      rows,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  Future<SimpleData> updateRow(
    _i1.Session session,
    SimpleData row, {
    _i1.ColumnSelections<SimpleDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleData>(
      row,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<SimpleData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleData>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SimpleData>(
      where: where(SimpleData.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where?.call(SimpleData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
