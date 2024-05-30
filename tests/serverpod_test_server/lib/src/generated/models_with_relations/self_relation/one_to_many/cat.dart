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
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Cat extends _i1.TableRow implements _i1.ProtocolSerialization {
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

  factory Cat.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cat(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      motherId: jsonSerialization['motherId'] as int?,
      mother: jsonSerialization['mother'] == null
          ? null
          : _i2.Cat.fromJson(
              (jsonSerialization['mother'] as Map<String, dynamic>)),
      kittens: (jsonSerialization['kittens'] as List?)
          ?.map((e) => _i2.Cat.fromJson((e as Map<String, dynamic>)))
          .toList(),
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
      if (mother != null) 'mother': mother?.toJson(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJsonForProtocol(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    return session.db.find<Cat>(
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
    return session.db.findFirstRow<Cat>(
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
    return session.db.findById<Cat>(
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
    return session.db.insert<Cat>(
      rows,
      transaction: transaction,
    );
  }

  Future<Cat> insertRow(
    _i1.Session session,
    Cat row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Cat>(
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
    return session.db.update<Cat>(
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
    return session.db.updateRow<Cat>(
      row,
      columns: columns?.call(Cat.t),
      transaction: transaction,
    );
  }

  Future<List<Cat>> delete(
    _i1.Session session,
    List<Cat> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Cat>(
      rows,
      transaction: transaction,
    );
  }

  Future<Cat> deleteRow(
    _i1.Session session,
    Cat row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Cat>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Cat>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CatTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Cat>(
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
    return session.db.count<Cat>(
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
    await session.db.update<_i2.Cat>(
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
    await session.db.updateRow<Cat>(
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
    await session.db.updateRow<_i2.Cat>(
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
    await session.db.update<_i2.Cat>(
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
    await session.db.updateRow<Cat>(
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
    await session.db.updateRow<_i2.Cat>(
      $cat,
      columns: [_i2.Cat.t.motherId],
    );
  }
}
