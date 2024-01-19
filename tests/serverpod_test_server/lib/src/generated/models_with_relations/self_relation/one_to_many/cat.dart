/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Cat extends _i1.TableRow {
  Cat._({
    int? id,
    required this.name,
    this.motherId,
    this.mother,
    this.kittens,
  }) : super(id);

  factory Cat({
    int? id,
    required String name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  }) = _CatImpl;

  factory Cat.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Cat(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      motherId:
          serializationManager.deserialize<int?>(jsonSerialization['motherId']),
      mother: serializationManager
          .deserialize<_i2.Cat?>(jsonSerialization['mother']),
      kittens: serializationManager
          .deserialize<List<_i2.Cat>?>(jsonSerialization['kittens']),
    );
  }

  static final t = CatTable();

  static const db = CatRepository._();

  String name;

  int? motherId;

  _i2.Cat? mother;

  List<_i2.Cat>? kittens;

  @override
  _i1.Table get table => t;

  Cat copyWith({
    int? id,
    String? name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother,
      if (kittens != null) 'kittens': kittens,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother,
      if (kittens != null) 'kittens': kittens,
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
      case 'motherId':
        motherId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Cat>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CatInclude? include,
  }) async {
    return session.db.find<Cat>(
      where: where != null ? where(Cat.t) : null,
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
  static Future<Cat?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CatInclude? include,
  }) async {
    return session.db.findSingleRow<Cat>(
      where: where != null ? where(Cat.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Cat?> findById(
    _i1.Session session,
    int id, {
    CatInclude? include,
  }) async {
    return session.db.findById<Cat>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CatTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Cat>(
      where: where(Cat.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Cat row, {
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
    Cat row, {
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
    Cat row, {
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
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Cat>(
      where: where != null ? where(Cat.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CatInclude include({
    _i2.CatInclude? mother,
    _i2.CatIncludeList? kittens,
  }) {
    return CatInclude._(
      mother: mother,
      kittens: kittens,
    );
  }

  static CatIncludeList includeList({
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CatTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatTable>? orderByList,
    CatInclude? include,
  }) {
    return CatIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cat.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Cat.t),
      include: include,
    );
  }
}

class _Undefined {}

class _CatImpl extends Cat {
  _CatImpl({
    int? id,
    required String name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  }) : super._(
          id: id,
          name: name,
          motherId: motherId,
          mother: mother,
          kittens: kittens,
        );

  @override
  Cat copyWith({
    Object? id = _Undefined,
    String? name,
    Object? motherId = _Undefined,
    Object? mother = _Undefined,
    Object? kittens = _Undefined,
  }) {
    return Cat(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      motherId: motherId is int? ? motherId : this.motherId,
      mother: mother is _i2.Cat? ? mother : this.mother?.copyWith(),
      kittens: kittens is List<_i2.Cat>? ? kittens : this.kittens?.clone(),
    );
  }
}

class CatTable extends _i1.Table {
  CatTable({super.tableRelation}) : super(tableName: 'cat') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    motherId = _i1.ColumnInt(
      'motherId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt motherId;

  _i2.CatTable? _mother;

  _i2.CatTable? ___kittens;

  _i1.ManyRelation<_i2.CatTable>? _kittens;

  _i2.CatTable get mother {
    if (_mother != null) return _mother!;
    _mother = _i1.createRelationTable(
      relationFieldName: 'mother',
      field: Cat.t.motherId,
      foreignField: _i2.Cat.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CatTable(tableRelation: foreignTableRelation),
    );
    return _mother!;
  }

  _i2.CatTable get __kittens {
    if (___kittens != null) return ___kittens!;
    ___kittens = _i1.createRelationTable(
      relationFieldName: '__kittens',
      field: Cat.t.id,
      foreignField: _i2.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CatTable(tableRelation: foreignTableRelation),
    );
    return ___kittens!;
  }

  _i1.ManyRelation<_i2.CatTable> get kittens {
    if (_kittens != null) return _kittens!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'kittens',
      field: Cat.t.id,
      foreignField: _i2.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CatTable(tableRelation: foreignTableRelation),
    );
    _kittens = _i1.ManyRelation<_i2.CatTable>(
      tableWithRelations: relationTable,
      table: _i2.CatTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _kittens!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        motherId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'mother') {
      return mother;
    }
    if (relationField == 'kittens') {
      return __kittens;
    }
    return null;
  }
}

@Deprecated('Use CatTable.t instead.')
CatTable tCat = CatTable();

class CatInclude extends _i1.IncludeObject {
  CatInclude._({
    _i2.CatInclude? mother,
    _i2.CatIncludeList? kittens,
  }) {
    _mother = mother;
    _kittens = kittens;
  }

  _i2.CatInclude? _mother;

  _i2.CatIncludeList? _kittens;

  @override
  Map<String, _i1.Include?> get includes => {
        'mother': _mother,
        'kittens': _kittens,
      };

  @override
  _i1.Table get table => Cat.t;
}

class CatIncludeList extends _i1.IncludeList {
  CatIncludeList._({
    _i1.WhereExpressionBuilder<CatTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Cat.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Cat.t;
}

class CatRepository {
  const CatRepository._();

  final attach = const CatAttachRepository._();

  final attachRow = const CatAttachRowRepository._();

  final detach = const CatDetachRepository._();

  final detachRow = const CatDetachRowRepository._();

  Future<List<Cat>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CatTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatTable>? orderByList,
    _i1.Transaction? transaction,
    CatInclude? include,
  }) async {
    return session.dbNext.find<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Cat?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? offset,
    _i1.OrderByBuilder<CatTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatTable>? orderByList,
    _i1.Transaction? transaction,
    CatInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Cat?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CatInclude? include,
  }) async {
    return session.dbNext.findById<Cat>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Cat>> insert(
    _i1.Session session,
    List<Cat> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Cat>(
      rows,
      transaction: transaction,
    );
  }

  Future<Cat> insertRow(
    _i1.Session session,
    Cat row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Cat>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Cat>> update(
    _i1.Session session,
    List<Cat> rows, {
    _i1.ColumnSelections<CatTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Cat>(
      rows,
      columns: columns?.call(Cat.t),
      transaction: transaction,
    );
  }

  Future<Cat> updateRow(
    _i1.Session session,
    Cat row, {
    _i1.ColumnSelections<CatTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Cat>(
      row,
      columns: columns?.call(Cat.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Cat> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Cat>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Cat row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Cat>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CatTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Cat>(
      where: where(Cat.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Cat>(
      where: where?.call(Cat.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CatAttachRepository {
  const CatAttachRepository._();

  Future<void> kittens(
    _i1.Session session,
    Cat cat,
    List<_i2.Cat> nestedCat,
  ) async {
    if (nestedCat.any((e) => e.id == null)) {
      throw ArgumentError.notNull('nestedCat.id');
    }
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $nestedCat =
        nestedCat.map((e) => e.copyWith(motherId: cat.id)).toList();
    await session.dbNext.update<_i2.Cat>(
      $nestedCat,
      columns: [_i2.Cat.t.motherId],
    );
  }
}

class CatAttachRowRepository {
  const CatAttachRowRepository._();

  Future<void> mother(
    _i1.Session session,
    Cat cat,
    _i2.Cat mother,
  ) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }
    if (mother.id == null) {
      throw ArgumentError.notNull('mother.id');
    }

    var $cat = cat.copyWith(motherId: mother.id);
    await session.dbNext.updateRow<Cat>(
      $cat,
      columns: [Cat.t.motherId],
    );
  }

  Future<void> kittens(
    _i1.Session session,
    Cat cat,
    _i2.Cat nestedCat,
  ) async {
    if (nestedCat.id == null) {
      throw ArgumentError.notNull('nestedCat.id');
    }
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $nestedCat = nestedCat.copyWith(motherId: cat.id);
    await session.dbNext.updateRow<_i2.Cat>(
      $nestedCat,
      columns: [_i2.Cat.t.motherId],
    );
  }
}

class CatDetachRepository {
  const CatDetachRepository._();

  Future<void> kittens(
    _i1.Session session,
    List<_i2.Cat> cat,
  ) async {
    if (cat.any((e) => e.id == null)) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.map((e) => e.copyWith(motherId: null)).toList();
    await session.dbNext.update<_i2.Cat>(
      $cat,
      columns: [_i2.Cat.t.motherId],
    );
  }
}

class CatDetachRowRepository {
  const CatDetachRowRepository._();

  Future<void> mother(
    _i1.Session session,
    Cat cat,
  ) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.copyWith(motherId: null);
    await session.dbNext.updateRow<Cat>(
      $cat,
      columns: [Cat.t.motherId],
    );
  }

  Future<void> kittens(
    _i1.Session session,
    _i2.Cat cat,
  ) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.copyWith(motherId: null);
    await session.dbNext.updateRow<_i2.Cat>(
      $cat,
      columns: [_i2.Cat.t.motherId],
    );
  }
}
