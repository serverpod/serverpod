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
import 'package:uuid/uuid.dart' as _i2;

abstract class UuidDefault implements _i1.TableRow, _i1.ProtocolSerialization {
  UuidDefault._({
    this.id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  })  : uuidDefaultRandom = uuidDefaultRandom ?? _i2.Uuid().v4obj(),
        uuidDefaultRandomNull = uuidDefaultRandomNull ?? _i2.Uuid().v4obj(),
        uuidDefaultStr = uuidDefaultStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultStrNull = uuidDefaultStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefault({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  }) = _UuidDefaultImpl;

  factory UuidDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefault(
      id: jsonSerialization['id'] as int?,
      uuidDefaultRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultRandom']),
      uuidDefaultRandomNull: jsonSerialization['uuidDefaultRandomNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomNull']),
      uuidDefaultStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultStr']),
      uuidDefaultStrNull: jsonSerialization['uuidDefaultStrNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStrNull']),
    );
  }

  static final t = UuidDefaultTable();

  static const db = UuidDefaultRepository._();

  @override
  int? id;

  _i1.UuidValue uuidDefaultRandom;

  _i1.UuidValue? uuidDefaultRandomNull;

  _i1.UuidValue uuidDefaultStr;

  _i1.UuidValue? uuidDefaultStrNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefault copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  static UuidDefaultInclude include() {
    return UuidDefaultInclude._();
  }

  static UuidDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    UuidDefaultInclude? include,
  }) {
    return UuidDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultImpl extends UuidDefault {
  _UuidDefaultImpl({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  }) : super._(
          id: id,
          uuidDefaultRandom: uuidDefaultRandom,
          uuidDefaultRandomNull: uuidDefaultRandomNull,
          uuidDefaultStr: uuidDefaultStr,
          uuidDefaultStrNull: uuidDefaultStrNull,
        );

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefault copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultRandom,
    Object? uuidDefaultRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultStr,
    Object? uuidDefaultStrNull = _Undefined,
  }) {
    return UuidDefault(
      id: id is int? ? id : this.id,
      uuidDefaultRandom: uuidDefaultRandom ?? this.uuidDefaultRandom,
      uuidDefaultRandomNull: uuidDefaultRandomNull is _i1.UuidValue?
          ? uuidDefaultRandomNull
          : this.uuidDefaultRandomNull,
      uuidDefaultStr: uuidDefaultStr ?? this.uuidDefaultStr,
      uuidDefaultStrNull: uuidDefaultStrNull is _i1.UuidValue?
          ? uuidDefaultStrNull
          : this.uuidDefaultStrNull,
    );
  }
}

class UuidDefaultTable extends _i1.Table {
  UuidDefaultTable({super.tableRelation}) : super(tableName: 'uuid_default') {
    uuidDefaultRandom = _i1.ColumnUuid(
      'uuidDefaultRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultRandomNull = _i1.ColumnUuid(
      'uuidDefaultRandomNull',
      this,
      hasDefault: true,
    );
    uuidDefaultStr = _i1.ColumnUuid(
      'uuidDefaultStr',
      this,
      hasDefault: true,
    );
    uuidDefaultStrNull = _i1.ColumnUuid(
      'uuidDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid uuidDefaultRandom;

  late final _i1.ColumnUuid uuidDefaultRandomNull;

  late final _i1.ColumnUuid uuidDefaultStr;

  late final _i1.ColumnUuid uuidDefaultStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultRandom,
        uuidDefaultRandomNull,
        uuidDefaultStr,
        uuidDefaultStrNull,
      ];
}

class UuidDefaultInclude extends _i1.IncludeObject {
  UuidDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UuidDefault.t;
}

class UuidDefaultIncludeList extends _i1.IncludeList {
  UuidDefaultIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UuidDefault.t;
}

class UuidDefaultRepository {
  const UuidDefaultRepository._();

  Future<List<UuidDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefault>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UuidDefault>> insert(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefault> insertRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefault>> update(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.ColumnSelections<UuidDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefault>(
      rows,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  Future<UuidDefault> updateRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.ColumnSelections<UuidDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefault>(
      row,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  Future<List<UuidDefault>> delete(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefault> deleteRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefault>(
      where: where(UuidDefault.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefault>(
      where: where?.call(UuidDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
