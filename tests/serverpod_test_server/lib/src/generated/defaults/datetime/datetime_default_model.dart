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

abstract class DateTimeDefaultModel
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DateTimeDefaultModel._({
    this.id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  })  : dateTimeDefaultModelNow = dateTimeDefaultModelNow ?? DateTime.now(),
        dateTimeDefaultModelStr = dateTimeDefaultModelStr ??
            DateTime.parse('2024-05-24T22:00:00.000Z'),
        dateTimeDefaultModelStrNull = dateTimeDefaultModelStrNull ??
            DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefaultModel({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) = _DateTimeDefaultModelImpl;

  factory DateTimeDefaultModel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultModel(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultModelNow: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelNow']),
      dateTimeDefaultModelStr: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelStr']),
      dateTimeDefaultModelStrNull:
          jsonSerialization['dateTimeDefaultModelStrNull'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultModelStrNull']),
    );
  }

  static final t = DateTimeDefaultModelTable();

  static const db = DateTimeDefaultModelRepository._();

  @override
  int? id;

  DateTime dateTimeDefaultModelNow;

  DateTime dateTimeDefaultModelStr;

  DateTime? dateTimeDefaultModelStrNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultModel copyWith({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultModelNow': dateTimeDefaultModelNow.toJson(),
      'dateTimeDefaultModelStr': dateTimeDefaultModelStr.toJson(),
      if (dateTimeDefaultModelStrNull != null)
        'dateTimeDefaultModelStrNull': dateTimeDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultModelNow': dateTimeDefaultModelNow.toJson(),
      'dateTimeDefaultModelStr': dateTimeDefaultModelStr.toJson(),
      if (dateTimeDefaultModelStrNull != null)
        'dateTimeDefaultModelStrNull': dateTimeDefaultModelStrNull?.toJson(),
    };
  }

  static DateTimeDefaultModelInclude include() {
    return DateTimeDefaultModelInclude._();
  }

  static DateTimeDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    DateTimeDefaultModelInclude? include,
  }) {
    return DateTimeDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultModelImpl extends DateTimeDefaultModel {
  _DateTimeDefaultModelImpl({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) : super._(
          id: id,
          dateTimeDefaultModelNow: dateTimeDefaultModelNow,
          dateTimeDefaultModelStr: dateTimeDefaultModelStr,
          dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultModel copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    Object? dateTimeDefaultModelStrNull = _Undefined,
  }) {
    return DateTimeDefaultModel(
      id: id is int? ? id : this.id,
      dateTimeDefaultModelNow:
          dateTimeDefaultModelNow ?? this.dateTimeDefaultModelNow,
      dateTimeDefaultModelStr:
          dateTimeDefaultModelStr ?? this.dateTimeDefaultModelStr,
      dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull is DateTime?
          ? dateTimeDefaultModelStrNull
          : this.dateTimeDefaultModelStrNull,
    );
  }
}

class DateTimeDefaultModelTable extends _i1.Table {
  DateTimeDefaultModelTable({super.tableRelation})
      : super(tableName: 'datetime_default_model') {
    dateTimeDefaultModelNow = _i1.ColumnDateTime(
      'dateTimeDefaultModelNow',
      this,
    );
    dateTimeDefaultModelStr = _i1.ColumnDateTime(
      'dateTimeDefaultModelStr',
      this,
    );
    dateTimeDefaultModelStrNull = _i1.ColumnDateTime(
      'dateTimeDefaultModelStrNull',
      this,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultModelNow;

  late final _i1.ColumnDateTime dateTimeDefaultModelStr;

  late final _i1.ColumnDateTime dateTimeDefaultModelStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultModelNow,
        dateTimeDefaultModelStr,
        dateTimeDefaultModelStrNull,
      ];
}

class DateTimeDefaultModelInclude extends _i1.IncludeObject {
  DateTimeDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DateTimeDefaultModel.t;
}

class DateTimeDefaultModelIncludeList extends _i1.IncludeList {
  DateTimeDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DateTimeDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DateTimeDefaultModel.t;
}

class DateTimeDefaultModelRepository {
  const DateTimeDefaultModelRepository._();

  Future<List<DateTimeDefaultModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DateTimeDefaultModel>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultModel>> insert(
    _i1.Session session,
    List<DateTimeDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DateTimeDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultModel> insertRow(
    _i1.Session session,
    DateTimeDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultModel>> update(
    _i1.Session session,
    List<DateTimeDefaultModel> rows, {
    _i1.ColumnSelections<DateTimeDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DateTimeDefaultModel>(
      rows,
      columns: columns?.call(DateTimeDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultModel> updateRow(
    _i1.Session session,
    DateTimeDefaultModel row, {
    _i1.ColumnSelections<DateTimeDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultModel>(
      row,
      columns: columns?.call(DateTimeDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultModel>> delete(
    _i1.Session session,
    List<DateTimeDefaultModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DateTimeDefaultModel>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultModel> deleteRow(
    _i1.Session session,
    DateTimeDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DateTimeDefaultModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultModel>(
      where: where(DateTimeDefaultModel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
