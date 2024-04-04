/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UniqueData extends _i1.TableRow {
  UniqueData._({
    int? id,
    required this.number,
    required this.email,
  }) : super(id);

  factory UniqueData({
    int? id,
    required int number,
    required String email,
  }) = _UniqueDataImpl;

  factory UniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniqueData(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  static final t = UniqueDataTable();

  static const db = UniqueDataRepository._();

  int number;

  String email;

  @override
  _i1.Table get table => t;

  UniqueData copyWith({
    int? id,
    int? number,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  static UniqueDataInclude include() {
    return UniqueDataInclude._();
  }

  static UniqueDataIncludeList includeList({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    UniqueDataInclude? include,
  }) {
    return UniqueDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UniqueData.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UniqueDataImpl extends UniqueData {
  _UniqueDataImpl({
    int? id,
    required int number,
    required String email,
  }) : super._(
          id: id,
          number: number,
          email: email,
        );

  @override
  UniqueData copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
  }) {
    return UniqueData(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
    );
  }
}

class UniqueDataTable extends _i1.Table {
  UniqueDataTable({super.tableRelation}) : super(tableName: 'unique_data') {
    number = _i1.ColumnInt(
      'number',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
  }

  late final _i1.ColumnInt number;

  late final _i1.ColumnString email;

  @override
  List<_i1.Column> get columns => [
        id,
        number,
        email,
      ];
}

class UniqueDataInclude extends _i1.IncludeObject {
  UniqueDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UniqueData.t;
}

class UniqueDataIncludeList extends _i1.IncludeList {
  UniqueDataIncludeList._({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UniqueData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UniqueData.t;
}

class UniqueDataRepository {
  const UniqueDataRepository._();

  Future<List<UniqueData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UniqueData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UniqueData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UniqueData>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UniqueData>> insert(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UniqueData>(
      rows,
      transaction: transaction,
    );
  }

  Future<UniqueData> insertRow(
    _i1.Session session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UniqueData>> update(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UniqueData>(
      rows,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  Future<UniqueData> updateRow(
    _i1.Session session,
    UniqueData row, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniqueData>(
      row,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UniqueData>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UniqueDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UniqueData>(
      where: where(UniqueData.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UniqueData>(
      where: where?.call(UniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
