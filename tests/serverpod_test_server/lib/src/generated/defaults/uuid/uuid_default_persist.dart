/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UuidDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UuidDefaultPersist._({
    int? id,
    this.uuidDefaultPersistRandom,
    this.uuidDefaultPersistStr,
  }) {
    _id = id;
  }

  factory UuidDefaultPersist({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) = _UuidDefaultPersistImpl;

  factory UuidDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uuidDefaultPersistRandom:
          jsonSerialization['uuidDefaultPersistRandom'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultPersistRandom']),
      uuidDefaultPersistStr: jsonSerialization['uuidDefaultPersistStr'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistStr']),
    );
  }

  static final t = UuidDefaultPersistTable();

  static const db = UuidDefaultPersistRepository._();

  int? _id;

  _i1.UuidValue? uuidDefaultPersistRandom;

  _i1.UuidValue? uuidDefaultPersistStr;

  @override
  int? get id {
    return _id;
  }

  @override
  set id(int? value) {
    _id = value;
  }

  @override
  _i1.Table get table => t;

  UuidDefaultPersist copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  static UuidDefaultPersistInclude include() {
    return UuidDefaultPersistInclude._();
  }

  static UuidDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    UuidDefaultPersistInclude? include,
  }) {
    return UuidDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultPersistImpl extends UuidDefaultPersist {
  _UuidDefaultPersistImpl({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) : super._(
          id: id,
          uuidDefaultPersistRandom: uuidDefaultPersistRandom,
          uuidDefaultPersistStr: uuidDefaultPersistStr,
        );

  @override
  UuidDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uuidDefaultPersistRandom = _Undefined,
    Object? uuidDefaultPersistStr = _Undefined,
  }) {
    return UuidDefaultPersist(
      id: id is int? ? id : this.id,
      uuidDefaultPersistRandom: uuidDefaultPersistRandom is _i1.UuidValue?
          ? uuidDefaultPersistRandom
          : this.uuidDefaultPersistRandom,
      uuidDefaultPersistStr: uuidDefaultPersistStr is _i1.UuidValue?
          ? uuidDefaultPersistStr
          : this.uuidDefaultPersistStr,
    );
  }
}

class UuidDefaultPersistTable extends _i1.Table {
  UuidDefaultPersistTable({super.tableRelation})
      : super(tableName: 'uuid_default_persist') {
    uuidDefaultPersistRandom = _i1.ColumnUuid(
      'uuidDefaultPersistRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultPersistStr = _i1.ColumnUuid(
      'uuidDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid uuidDefaultPersistRandom;

  late final _i1.ColumnUuid uuidDefaultPersistStr;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultPersistRandom,
        uuidDefaultPersistStr,
      ];
}

class UuidDefaultPersistInclude extends _i1.IncludeObject {
  UuidDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistIncludeList extends _i1.IncludeList {
  UuidDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistRepository {
  const UuidDefaultPersistRepository._();

  Future<List<UuidDefaultPersist>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UuidDefaultPersist?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UuidDefaultPersist?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<UuidDefaultPersist>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UuidDefaultPersist>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<UuidDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<UuidDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UuidDefaultPersist> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    UuidDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<UuidDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UuidDefaultPersist>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<UuidDefaultPersist> rows, {
    _i1.ColumnSelections<UuidDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<UuidDefaultPersist>(
      rows,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UuidDefaultPersist> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    UuidDefaultPersist row, {
    _i1.ColumnSelections<UuidDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<UuidDefaultPersist>(
      row,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UuidDefaultPersist>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<UuidDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<UuidDefaultPersist>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UuidDefaultPersist> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    UuidDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<UuidDefaultPersist>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UuidDefaultPersist>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<UuidDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<UuidDefaultPersist>(
      where: where(UuidDefaultPersist.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
