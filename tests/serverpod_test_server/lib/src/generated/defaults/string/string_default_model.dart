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

abstract class StringDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  StringDefaultModel._({
    this.id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  })  : stringDefaultModel =
            stringDefaultModel ?? 'This is a default model value',
        stringDefaultModelNull =
            stringDefaultModelNull ?? 'This is a default model null value';

  factory StringDefaultModel({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) = _StringDefaultModelImpl;

  factory StringDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultModel(
      id: jsonSerialization['id'] as int?,
      stringDefaultModel: jsonSerialization['stringDefaultModel'] as String,
      stringDefaultModelNull:
          jsonSerialization['stringDefaultModelNull'] as String,
    );
  }

  static final t = StringDefaultModelTable();

  static const db = StringDefaultModelRepository._();

  @override
  int? id;

  String stringDefaultModel;

  String stringDefaultModelNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultModel copyWith({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  static StringDefaultModelInclude include() {
    return StringDefaultModelInclude._();
  }

  static StringDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    StringDefaultModelInclude? include,
  }) {
    return StringDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultModelImpl extends StringDefaultModel {
  _StringDefaultModelImpl({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) : super._(
          id: id,
          stringDefaultModel: stringDefaultModel,
          stringDefaultModelNull: stringDefaultModelNull,
        );

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultModel copyWith({
    Object? id = _Undefined,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) {
    return StringDefaultModel(
      id: id is int? ? id : this.id,
      stringDefaultModel: stringDefaultModel ?? this.stringDefaultModel,
      stringDefaultModelNull:
          stringDefaultModelNull ?? this.stringDefaultModelNull,
    );
  }
}

class StringDefaultModelTable extends _i1.Table {
  StringDefaultModelTable({super.tableRelation})
      : super(tableName: 'string_default_model') {
    stringDefaultModel = _i1.ColumnString(
      'stringDefaultModel',
      this,
    );
    stringDefaultModelNull = _i1.ColumnString(
      'stringDefaultModelNull',
      this,
    );
  }

  late final _i1.ColumnString stringDefaultModel;

  late final _i1.ColumnString stringDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefaultModel,
        stringDefaultModelNull,
      ];
}

class StringDefaultModelInclude extends _i1.IncludeObject {
  StringDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefaultModel.t;
}

class StringDefaultModelIncludeList extends _i1.IncludeList {
  StringDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefaultModel.t;
}

class StringDefaultModelRepository {
  const StringDefaultModelRepository._();

  Future<List<StringDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultModel>> insert(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefaultModel> insertRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultModel>> update(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.ColumnSelections<StringDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefaultModel>(
      rows,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<StringDefaultModel> updateRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.ColumnSelections<StringDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultModel>(
      row,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<List<StringDefaultModel>> delete(
    _i1.Session session,
    List<StringDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefaultModel> deleteRow(
    _i1.Session session,
    StringDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefaultModel>(
      where: where(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
