/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ScopeNoneFields extends _i1.TableRow {
  ScopeNoneFields._({int? id}) : super(id);

  factory ScopeNoneFields({int? id}) = _ScopeNoneFieldsImpl;

  factory ScopeNoneFields.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScopeNoneFields(id: jsonSerialization['id'] as int?);
  }

  static final t = ScopeNoneFieldsTable();

  static const db = ScopeNoneFieldsRepository._();

  String? _name;

  @override
  _i1.Table get table => t;

  ScopeNoneFields copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      if (_name != null) 'name': _name,
    };
  }

  static ScopeNoneFieldsInclude include() {
    return ScopeNoneFieldsInclude._();
  }

  static ScopeNoneFieldsIncludeList includeList({
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    ScopeNoneFieldsInclude? include,
  }) {
    return ScopeNoneFieldsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScopeNoneFields.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ScopeNoneFieldsImpl extends ScopeNoneFields {
  _ScopeNoneFieldsImpl({int? id}) : super._(id: id);

  @override
  ScopeNoneFields copyWith({Object? id = _Undefined}) {
    return ScopeNoneFields(id: id is int? ? id : this.id);
  }
}

class ScopeNoneFieldsImplicit extends _ScopeNoneFieldsImpl {
  ScopeNoneFieldsImplicit._({
    int? id,
    this.$name,
  }) : super(id: id);

  factory ScopeNoneFieldsImplicit(
    ScopeNoneFields scopeNoneFields, {
    String? $name,
  }) {
    return ScopeNoneFieldsImplicit._(
      id: scopeNoneFields.id,
      $name: $name,
    );
  }

  String? $name;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({'name': $name});
    return jsonMap;
  }
}

class ScopeNoneFieldsTable extends _i1.Table {
  ScopeNoneFieldsTable({super.tableRelation})
      : super(tableName: 'scope_none_fields') {
    $name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString $name;

  @override
  List<_i1.Column> get columns => [
        id,
        $name,
      ];
}

class ScopeNoneFieldsInclude extends _i1.IncludeObject {
  ScopeNoneFieldsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsIncludeList extends _i1.IncludeList {
  ScopeNoneFieldsIncludeList._({
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScopeNoneFields.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsRepository {
  const ScopeNoneFieldsRepository._();

  Future<List<ScopeNoneFields>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ScopeNoneFields?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ScopeNoneFields?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ScopeNoneFields>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ScopeNoneFields>> insert(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  Future<ScopeNoneFields> insertRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ScopeNoneFields>> update(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScopeNoneFields>(
      rows,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  Future<ScopeNoneFields> updateRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScopeNoneFields>(
      row,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScopeNoneFields>(
      where: where(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
