/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class LongImplicitIdField extends _i1.TableRow {
  LongImplicitIdField._({
    int? id,
    required this.name,
  }) : super(id);

  factory LongImplicitIdField({
    int? id,
    required String name,
  }) = _LongImplicitIdFieldImpl;

  factory LongImplicitIdField.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LongImplicitIdField(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
    );
  }

  static final t = LongImplicitIdFieldTable();

  static const db = LongImplicitIdFieldRepository._();

  String name;

  int? _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;

  @override
  _i1.Table get table => t;

  LongImplicitIdField copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id':
          _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id !=
          null)
        '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id':
            _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id':
        _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<LongImplicitIdField>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LongImplicitIdField>(
      where: where != null ? where(LongImplicitIdField.t) : null,
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
  static Future<LongImplicitIdField?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<LongImplicitIdField>(
      where: where != null ? where(LongImplicitIdField.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<LongImplicitIdField?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<LongImplicitIdField>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LongImplicitIdFieldTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LongImplicitIdField>(
      where: where(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    LongImplicitIdField row, {
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
    LongImplicitIdField row, {
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
    LongImplicitIdField row, {
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
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LongImplicitIdField>(
      where: where != null ? where(LongImplicitIdField.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static LongImplicitIdFieldInclude include() {
    return LongImplicitIdFieldInclude._();
  }

  static LongImplicitIdFieldIncludeList includeList({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    LongImplicitIdFieldInclude? include,
  }) {
    return LongImplicitIdFieldIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LongImplicitIdField.t),
      include: include,
    );
  }
}

class _Undefined {}

class _LongImplicitIdFieldImpl extends LongImplicitIdField {
  _LongImplicitIdFieldImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  @override
  LongImplicitIdField copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return LongImplicitIdField(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class LongImplicitIdFieldImplicit extends _LongImplicitIdFieldImpl {
  LongImplicitIdFieldImplicit._({
    int? id,
    required String name,
    this.$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
  }) : super(
          id: id,
          name: name,
        );

  factory LongImplicitIdFieldImplicit(
    LongImplicitIdField longImplicitIdField, {
    int? $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
  }) {
    return LongImplicitIdFieldImplicit._(
      id: longImplicitIdField.id,
      name: longImplicitIdField.name,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    );
  }

  int? $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({
      '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id':
          $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
    });
    return jsonMap;
  }
}

class LongImplicitIdFieldTable extends _i1.Table {
  LongImplicitIdFieldTable({super.tableRelation})
      : super(tableName: 'long_implicit_id_field') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id =
        _i1.ColumnInt(
      '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
      ];
}

@Deprecated('Use LongImplicitIdFieldTable.t instead.')
LongImplicitIdFieldTable tLongImplicitIdField = LongImplicitIdFieldTable();

class LongImplicitIdFieldInclude extends _i1.IncludeObject {
  LongImplicitIdFieldInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => LongImplicitIdField.t;
}

class LongImplicitIdFieldIncludeList extends _i1.IncludeList {
  LongImplicitIdFieldIncludeList._({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LongImplicitIdField.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => LongImplicitIdField.t;
}

class LongImplicitIdFieldRepository {
  const LongImplicitIdFieldRepository._();

  Future<List<LongImplicitIdField>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<LongImplicitIdField?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<LongImplicitIdField?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<LongImplicitIdField>(
      id,
      transaction: transaction,
    );
  }

  Future<List<LongImplicitIdField>> insert(
    _i1.Session session,
    List<LongImplicitIdField> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<LongImplicitIdField>(
      rows,
      transaction: transaction,
    );
  }

  Future<LongImplicitIdField> insertRow(
    _i1.Session session,
    LongImplicitIdField row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<LongImplicitIdField>(
      row,
      transaction: transaction,
    );
  }

  Future<List<LongImplicitIdField>> update(
    _i1.Session session,
    List<LongImplicitIdField> rows, {
    _i1.ColumnSelections<LongImplicitIdFieldTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<LongImplicitIdField>(
      rows,
      columns: columns?.call(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  Future<LongImplicitIdField> updateRow(
    _i1.Session session,
    LongImplicitIdField row, {
    _i1.ColumnSelections<LongImplicitIdFieldTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<LongImplicitIdField>(
      row,
      columns: columns?.call(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<LongImplicitIdField> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<LongImplicitIdField>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    LongImplicitIdField row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<LongImplicitIdField>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LongImplicitIdFieldTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<LongImplicitIdField>(
      where: where(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
