/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class MaxFieldName extends _i1.TableRow {
  MaxFieldName._({
    int? id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) : super(id);

  factory MaxFieldName({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) = _MaxFieldNameImpl;

  factory MaxFieldName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MaxFieldName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          serializationManager.deserialize<String>(jsonSerialization[
              'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo']),
    );
  }

  static final t = MaxFieldNameTable();

  static const db = MaxFieldNameRepository._();

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  _i1.Table get table => t;

  MaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  static MaxFieldNameInclude include() {
    return MaxFieldNameInclude._();
  }

  static MaxFieldNameIncludeList includeList({
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    MaxFieldNameInclude? include,
  }) {
    return MaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MaxFieldName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _MaxFieldNameImpl extends MaxFieldName {
  _MaxFieldNameImpl({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) : super._(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
        );

  @override
  MaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) {
    return MaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    );
  }
}

class MaxFieldNameTable extends _i1.Table {
  MaxFieldNameTable({super.tableRelation})
      : super(tableName: 'max_field_name') {
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo =
        _i1.ColumnString(
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
      this,
    );
  }

  late final _i1.ColumnString
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  List<_i1.Column> get columns => [
        id,
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
      ];
}

class MaxFieldNameInclude extends _i1.IncludeObject {
  MaxFieldNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MaxFieldName.t;
}

class MaxFieldNameIncludeList extends _i1.IncludeList {
  MaxFieldNameIncludeList._({
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MaxFieldName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MaxFieldName.t;
}

class MaxFieldNameRepository {
  const MaxFieldNameRepository._();

  Future<List<MaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MaxFieldName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MaxFieldName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MaxFieldName>(
      id,
      transaction: transaction,
    );
  }

  Future<List<MaxFieldName>> insert(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<MaxFieldName> insertRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MaxFieldName>> update(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.ColumnSelections<MaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MaxFieldName>(
      rows,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<MaxFieldName> updateRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.ColumnSelections<MaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MaxFieldName>(
      row,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<List<MaxFieldName>> delete(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<MaxFieldName> deleteRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MaxFieldName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MaxFieldNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MaxFieldName>(
      where: where(MaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
