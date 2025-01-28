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

abstract class UuidDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UuidDefaultModel._({
    this.id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  })  : uuidDefaultModelRandom = uuidDefaultModelRandom ?? _i2.Uuid().v4obj(),
        uuidDefaultModelRandomNull =
            uuidDefaultModelRandomNull ?? _i2.Uuid().v4obj(),
        uuidDefaultModelStr = uuidDefaultModelStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultModelStrNull = uuidDefaultModelStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefaultModel({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) = _UuidDefaultModelImpl;

  factory UuidDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultModel(
      id: jsonSerialization['id'] as int?,
      uuidDefaultModelRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelRandom']),
      uuidDefaultModelRandomNull:
          jsonSerialization['uuidDefaultModelRandomNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelRandomNull']),
      uuidDefaultModelStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelStr']),
      uuidDefaultModelStrNull:
          jsonSerialization['uuidDefaultModelStrNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelStrNull']),
    );
  }

  static final t = UuidDefaultModelTable();

  static const db = UuidDefaultModelRepository._();

  @override
  int? id;

  _i1.UuidValue uuidDefaultModelRandom;

  _i1.UuidValue? uuidDefaultModelRandomNull;

  _i1.UuidValue uuidDefaultModelStr;

  _i1.UuidValue? uuidDefaultModelStrNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultModel copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  static UuidDefaultModelInclude include() {
    return UuidDefaultModelInclude._();
  }

  static UuidDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    UuidDefaultModelInclude? include,
  }) {
    return UuidDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultModelImpl extends UuidDefaultModel {
  _UuidDefaultModelImpl({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) : super._(
          id: id,
          uuidDefaultModelRandom: uuidDefaultModelRandom,
          uuidDefaultModelRandomNull: uuidDefaultModelRandomNull,
          uuidDefaultModelStr: uuidDefaultModelStr,
          uuidDefaultModelStrNull: uuidDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultModel copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultModelRandom,
    Object? uuidDefaultModelRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultModelStr,
    Object? uuidDefaultModelStrNull = _Undefined,
  }) {
    return UuidDefaultModel(
      id: id is int? ? id : this.id,
      uuidDefaultModelRandom:
          uuidDefaultModelRandom ?? this.uuidDefaultModelRandom,
      uuidDefaultModelRandomNull: uuidDefaultModelRandomNull is _i1.UuidValue?
          ? uuidDefaultModelRandomNull
          : this.uuidDefaultModelRandomNull,
      uuidDefaultModelStr: uuidDefaultModelStr ?? this.uuidDefaultModelStr,
      uuidDefaultModelStrNull: uuidDefaultModelStrNull is _i1.UuidValue?
          ? uuidDefaultModelStrNull
          : this.uuidDefaultModelStrNull,
    );
  }
}

class UuidDefaultModelTable extends _i1.Table {
  UuidDefaultModelTable({super.tableRelation})
      : super(tableName: 'uuid_default_model') {
    uuidDefaultModelRandom = _i1.ColumnUuid(
      'uuidDefaultModelRandom',
      this,
    );
    uuidDefaultModelRandomNull = _i1.ColumnUuid(
      'uuidDefaultModelRandomNull',
      this,
    );
    uuidDefaultModelStr = _i1.ColumnUuid(
      'uuidDefaultModelStr',
      this,
    );
    uuidDefaultModelStrNull = _i1.ColumnUuid(
      'uuidDefaultModelStrNull',
      this,
    );
  }

  late final _i1.ColumnUuid uuidDefaultModelRandom;

  late final _i1.ColumnUuid uuidDefaultModelRandomNull;

  late final _i1.ColumnUuid uuidDefaultModelStr;

  late final _i1.ColumnUuid uuidDefaultModelStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultModelRandom,
        uuidDefaultModelRandomNull,
        uuidDefaultModelStr,
        uuidDefaultModelStrNull,
      ];
}

class UuidDefaultModelInclude extends _i1.IncludeObject {
  UuidDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UuidDefaultModel.t;
}

class UuidDefaultModelIncludeList extends _i1.IncludeList {
  UuidDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UuidDefaultModel.t;
}

class UuidDefaultModelRepository {
  const UuidDefaultModelRepository._();

  Future<List<UuidDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UuidDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultModel>> insert(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefaultModel> insertRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultModel>> update(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.ColumnSelections<UuidDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefaultModel>(
      rows,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<UuidDefaultModel> updateRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.ColumnSelections<UuidDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultModel>(
      row,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultModel>> delete(
    _i1.Session session,
    List<UuidDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<UuidDefaultModel> deleteRow(
    _i1.Session session,
    UuidDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UuidDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefaultModel>(
      where: where(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
