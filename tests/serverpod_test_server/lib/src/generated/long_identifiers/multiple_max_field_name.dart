/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class MultipleMaxFieldName extends _i1.TableRow {
  MultipleMaxFieldName._({
    int? id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) : super(id);

  factory MultipleMaxFieldName({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) = _MultipleMaxFieldNameImpl;

  factory MultipleMaxFieldName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MultipleMaxFieldName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          serializationManager.deserialize<String>(jsonSerialization[
              'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1']),
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          serializationManager.deserialize<String>(jsonSerialization[
              'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2']),
    );
  }

  static final t = MultipleMaxFieldNameTable();

  static const db = MultipleMaxFieldNameRepository._();

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2;

  int? _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;

  @override
  _i1.Table get table => t;

  MultipleMaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      if (_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId !=
          null)
        '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId':
            _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      if (_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId !=
          null)
        '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId':
            _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
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
      case 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 = value;
        return;
      case 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 = value;
        return;
      case '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId':
        _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<MultipleMaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MultipleMaxFieldName>(
      where: where != null ? where(MultipleMaxFieldName.t) : null,
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
  static Future<MultipleMaxFieldName?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<MultipleMaxFieldName>(
      where: where != null ? where(MultipleMaxFieldName.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<MultipleMaxFieldName?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<MultipleMaxFieldName>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MultipleMaxFieldName>(
      where: where(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    MultipleMaxFieldName row, {
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
    MultipleMaxFieldName row, {
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
    MultipleMaxFieldName row, {
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
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MultipleMaxFieldName>(
      where: where != null ? where(MultipleMaxFieldName.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static MultipleMaxFieldNameInclude include() {
    return MultipleMaxFieldNameInclude._();
  }

  static MultipleMaxFieldNameIncludeList includeList({
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    MultipleMaxFieldNameInclude? include,
  }) {
    return MultipleMaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _MultipleMaxFieldNameImpl extends MultipleMaxFieldName {
  _MultipleMaxFieldNameImpl({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) : super._(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
        );

  @override
  MultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) {
    return MultipleMaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    );
  }
}

class MultipleMaxFieldNameImplicit extends _MultipleMaxFieldNameImpl {
  MultipleMaxFieldNameImplicit._({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    this.$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
  }) : super(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
        );

  factory MultipleMaxFieldNameImplicit(
    MultipleMaxFieldName multipleMaxFieldName, {
    int? $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
  }) {
    return MultipleMaxFieldNameImplicit._(
      id: multipleMaxFieldName.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          multipleMaxFieldName
              .thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          multipleMaxFieldName
              .thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    );
  }

  int? $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({
      '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId':
          $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
    });
    return jsonMap;
  }
}

class MultipleMaxFieldNameTable extends _i1.Table {
  MultipleMaxFieldNameTable({super.tableRelation})
      : super(tableName: 'multiple_max_field_name') {
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 =
        _i1.ColumnString(
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1',
      this,
    );
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 =
        _i1.ColumnString(
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2',
      this,
    );
    $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId =
        _i1.ColumnInt(
      '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
      this,
    );
  }

  late final _i1.ColumnString
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1;

  late final _i1.ColumnString
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2;

  late final _i1.ColumnInt
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;

  @override
  List<_i1.Column> get columns => [
        id,
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
        $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      ];
}

@Deprecated('Use MultipleMaxFieldNameTable.t instead.')
MultipleMaxFieldNameTable tMultipleMaxFieldName = MultipleMaxFieldNameTable();

class MultipleMaxFieldNameInclude extends _i1.IncludeObject {
  MultipleMaxFieldNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MultipleMaxFieldName.t;
}

class MultipleMaxFieldNameIncludeList extends _i1.IncludeList {
  MultipleMaxFieldNameIncludeList._({
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MultipleMaxFieldName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MultipleMaxFieldName.t;
}

class MultipleMaxFieldNameRepository {
  const MultipleMaxFieldNameRepository._();

  Future<List<MultipleMaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MultipleMaxFieldName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MultipleMaxFieldName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<MultipleMaxFieldName>(
      id,
      transaction: transaction,
    );
  }

  Future<List<MultipleMaxFieldName>> insert(
    _i1.Session session,
    List<MultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<MultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<MultipleMaxFieldName> insertRow(
    _i1.Session session,
    MultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<MultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MultipleMaxFieldName>> update(
    _i1.Session session,
    List<MultipleMaxFieldName> rows, {
    _i1.ColumnSelections<MultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<MultipleMaxFieldName>(
      rows,
      columns: columns?.call(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<MultipleMaxFieldName> updateRow(
    _i1.Session session,
    MultipleMaxFieldName row, {
    _i1.ColumnSelections<MultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<MultipleMaxFieldName>(
      row,
      columns: columns?.call(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<MultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<MultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    MultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<MultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<MultipleMaxFieldName>(
      where: where(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
