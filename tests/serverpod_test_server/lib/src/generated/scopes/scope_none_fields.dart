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

  factory ScopeNoneFields.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ScopeNoneFields(
        id: serializationManager.deserialize<int?>(jsonSerialization['id']));
  }

  static final t = ScopeNoneFieldsTable();

  static const db = ScopeNoneFieldsRepository._();

  String? _name;

  @override
  _i1.Table get table => t;

  ScopeNoneFields copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': _name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': _name,
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
      case 'name':
        _name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ScopeNoneFields>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ScopeNoneFields>(
      where: where != null ? where(ScopeNoneFields.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<ScopeNoneFields?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ScopeNoneFields>(
      where: where != null ? where(ScopeNoneFields.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ScopeNoneFields?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ScopeNoneFields>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScopeNoneFields>(
      where: where(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ScopeNoneFields row, {
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
    ScopeNoneFields row, {
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
    ScopeNoneFields row, {
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
    _i1.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScopeNoneFields>(
      where: where != null ? where(ScopeNoneFields.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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

@Deprecated('Use ScopeNoneFieldsTable.t instead.')
ScopeNoneFieldsTable tScopeNoneFields = ScopeNoneFieldsTable();

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
    return session.dbNext.find<ScopeNoneFields>(
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
    return session.dbNext.findFirstRow<ScopeNoneFields>(
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
    return session.dbNext.findById<ScopeNoneFields>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ScopeNoneFields>> insert(
    _i1.Session session,
    List<ScopeNoneFields> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  Future<ScopeNoneFields> insertRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ScopeNoneFields>(
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
    return session.dbNext.update<ScopeNoneFields>(
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
    return session.dbNext.updateRow<ScopeNoneFields>(
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
    return session.dbNext.delete<ScopeNoneFields>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ScopeNoneFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ScopeNoneFields>(
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
    return session.dbNext.count<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
