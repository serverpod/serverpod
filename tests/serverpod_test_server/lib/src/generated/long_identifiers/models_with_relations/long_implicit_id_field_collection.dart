/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class LongImplicitIdFieldCollection extends _i1.TableRow {
  LongImplicitIdFieldCollection._({
    int? id,
    required this.name,
    this.thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) : super(id);

  factory LongImplicitIdFieldCollection({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) = _LongImplicitIdFieldCollectionImpl;

  factory LongImplicitIdFieldCollection.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LongImplicitIdFieldCollection(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          serializationManager.deserialize<
              List<
                  _i2.LongImplicitIdField>?>(jsonSerialization[
              'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa']),
    );
  }

  static final t = LongImplicitIdFieldCollectionTable();

  static const db = LongImplicitIdFieldCollectionRepository._();

  String name;

  List<_i2.LongImplicitIdField>?
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  @override
  _i1.Table get table => t;

  LongImplicitIdFieldCollection copyWith({
    int? id,
    String? name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
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
        name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<LongImplicitIdFieldCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.find<LongImplicitIdFieldCollection>(
      where: where != null ? where(LongImplicitIdFieldCollection.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<LongImplicitIdFieldCollection?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.findSingleRow<LongImplicitIdFieldCollection>(
      where: where != null ? where(LongImplicitIdFieldCollection.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<LongImplicitIdFieldCollection?> findById(
    _i1.Session session,
    int id, {
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.findById<LongImplicitIdFieldCollection>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LongImplicitIdFieldCollection>(
      where: where(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
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
    LongImplicitIdFieldCollection row, {
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
    LongImplicitIdFieldCollection row, {
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
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LongImplicitIdFieldCollection>(
      where: where != null ? where(LongImplicitIdFieldCollection.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static LongImplicitIdFieldCollectionInclude include(
      {_i2.LongImplicitIdFieldIncludeList?
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa}) {
    return LongImplicitIdFieldCollectionInclude._(
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa);
  }

  static LongImplicitIdFieldCollectionIncludeList includeList({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    LongImplicitIdFieldCollectionInclude? include,
  }) {
    return LongImplicitIdFieldCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      include: include,
    );
  }
}

class _Undefined {}

class _LongImplicitIdFieldCollectionImpl extends LongImplicitIdFieldCollection {
  _LongImplicitIdFieldCollectionImpl({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) : super._(
          id: id,
          name: name,
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
              thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
        );

  @override
  LongImplicitIdFieldCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _Undefined,
  }) {
    return LongImplicitIdFieldCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  is List<_i2.LongImplicitIdField>?
              ? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
              : this
                  .thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  ?.clone(),
    );
  }
}

class LongImplicitIdFieldCollectionTable extends _i1.Table {
  LongImplicitIdFieldCollectionTable({super.tableRelation})
      : super(tableName: 'long_implicit_id_field_collection') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.LongImplicitIdFieldTable?
      ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  _i1.ManyRelation<_i2.LongImplicitIdFieldTable>?
      _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  _i2.LongImplicitIdFieldTable
      get __thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa {
    if (___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa !=
        null)
      return ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
    ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _i1.createRelationTable(
      relationFieldName:
          '__thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa',
      field: LongImplicitIdFieldCollection.t.id,
      foreignField: _i2.LongImplicitIdField.t
          .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LongImplicitIdFieldTable(tableRelation: foreignTableRelation),
    );
    return ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
  }

  _i1.ManyRelation<_i2.LongImplicitIdFieldTable>
      get thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa {
    if (_thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
      return _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
    var relationTable = _i1.createRelationTable(
      relationFieldName:
          'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa',
      field: LongImplicitIdFieldCollection.t.id,
      foreignField: _i2.LongImplicitIdField.t
          .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LongImplicitIdFieldTable(tableRelation: foreignTableRelation),
    );
    _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _i1.ManyRelation<_i2.LongImplicitIdFieldTable>(
      tableWithRelations: relationTable,
      table: _i2.LongImplicitIdFieldTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField ==
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa') {
      return __thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;
    }
    return null;
  }
}

@Deprecated('Use LongImplicitIdFieldCollectionTable.t instead.')
LongImplicitIdFieldCollectionTable tLongImplicitIdFieldCollection =
    LongImplicitIdFieldCollectionTable();

class LongImplicitIdFieldCollectionInclude extends _i1.IncludeObject {
  LongImplicitIdFieldCollectionInclude._(
      {_i2.LongImplicitIdFieldIncludeList?
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa}) {
    _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;
  }

  _i2.LongImplicitIdFieldIncludeList?
      _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  @override
  Map<String, _i1.Include?> get includes => {
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
      };

  @override
  _i1.Table get table => LongImplicitIdFieldCollection.t;
}

class LongImplicitIdFieldCollectionIncludeList extends _i1.IncludeList {
  LongImplicitIdFieldCollectionIncludeList._({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LongImplicitIdFieldCollection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => LongImplicitIdFieldCollection.t;
}

class LongImplicitIdFieldCollectionRepository {
  const LongImplicitIdFieldCollectionRepository._();

  final attach = const LongImplicitIdFieldCollectionAttachRepository._();

  final attachRow = const LongImplicitIdFieldCollectionAttachRowRepository._();

  final detach = const LongImplicitIdFieldCollectionDetachRepository._();

  final detachRow = const LongImplicitIdFieldCollectionDetachRowRepository._();

  Future<List<LongImplicitIdFieldCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.dbNext.find<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<LongImplicitIdFieldCollection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.dbNext.findFirstRow<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<LongImplicitIdFieldCollection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.dbNext.findById<LongImplicitIdFieldCollection>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<LongImplicitIdFieldCollection>> insert(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<LongImplicitIdFieldCollection>(
      rows,
      transaction: transaction,
    );
  }

  Future<LongImplicitIdFieldCollection> insertRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<LongImplicitIdFieldCollection>(
      row,
      transaction: transaction,
    );
  }

  Future<List<LongImplicitIdFieldCollection>> update(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.ColumnSelections<LongImplicitIdFieldCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<LongImplicitIdFieldCollection>(
      rows,
      columns: columns?.call(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  Future<LongImplicitIdFieldCollection> updateRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.ColumnSelections<LongImplicitIdFieldCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<LongImplicitIdFieldCollection>(
      row,
      columns: columns?.call(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<LongImplicitIdFieldCollection>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<LongImplicitIdFieldCollection>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<LongImplicitIdFieldCollection>(
      where: where(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LongImplicitIdFieldCollectionAttachRepository {
  const LongImplicitIdFieldCollectionAttachRepository._();

  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    LongImplicitIdFieldCollection longImplicitIdFieldCollection,
    List<_i2.LongImplicitIdField> longImplicitIdField,
  ) async {
    if (longImplicitIdField.any((e) => e.id == null)) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }
    if (longImplicitIdFieldCollection.id == null) {
      throw ArgumentError.notNull('longImplicitIdFieldCollection.id');
    }

    var $longImplicitIdField = longImplicitIdField
        .map((e) => _i2.LongImplicitIdFieldImplicit(
              e,
              $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
                  longImplicitIdFieldCollection.id,
            ))
        .toList();
    await session.dbNext.update<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
    );
  }
}

class LongImplicitIdFieldCollectionAttachRowRepository {
  const LongImplicitIdFieldCollectionAttachRowRepository._();

  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    LongImplicitIdFieldCollection longImplicitIdFieldCollection,
    _i2.LongImplicitIdField longImplicitIdField,
  ) async {
    if (longImplicitIdField.id == null) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }
    if (longImplicitIdFieldCollection.id == null) {
      throw ArgumentError.notNull('longImplicitIdFieldCollection.id');
    }

    var $longImplicitIdField = _i2.LongImplicitIdFieldImplicit(
      longImplicitIdField,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          longImplicitIdFieldCollection.id,
    );
    await session.dbNext.updateRow<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
    );
  }
}

class LongImplicitIdFieldCollectionDetachRepository {
  const LongImplicitIdFieldCollectionDetachRepository._();

  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    List<_i2.LongImplicitIdField> longImplicitIdField,
  ) async {
    if (longImplicitIdField.any((e) => e.id == null)) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }

    var $longImplicitIdField = longImplicitIdField
        .map((e) => _i2.LongImplicitIdFieldImplicit(
              e,
              $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
                  null,
            ))
        .toList();
    await session.dbNext.update<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
    );
  }
}

class LongImplicitIdFieldCollectionDetachRowRepository {
  const LongImplicitIdFieldCollectionDetachRowRepository._();

  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    _i2.LongImplicitIdField longImplicitIdField,
  ) async {
    if (longImplicitIdField.id == null) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }

    var $longImplicitIdField = _i2.LongImplicitIdFieldImplicit(
      longImplicitIdField,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id: null,
    );
    await session.dbNext.updateRow<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
    );
  }
}
