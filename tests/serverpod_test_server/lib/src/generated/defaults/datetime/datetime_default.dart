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

abstract class DateTimeDefault
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DateTimeDefault._({
    this.id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  })  : dateTimeDefaultNow = dateTimeDefaultNow ?? DateTime.now(),
        dateTimeDefaultStr =
            dateTimeDefaultStr ?? DateTime.parse('2024-05-24T22:00:00.000Z'),
        dateTimeDefaultStrNull = dateTimeDefaultStrNull ??
            DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefault({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) = _DateTimeDefaultImpl;

  factory DateTimeDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefault(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultNow: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultNow']),
      dateTimeDefaultStr: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultStr']),
      dateTimeDefaultStrNull:
          jsonSerialization['dateTimeDefaultStrNull'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultStrNull']),
    );
  }

  static final t = DateTimeDefaultTable();

  static const db = DateTimeDefaultRepository._();

  @override
  int? id;

  DateTime dateTimeDefaultNow;

  DateTime dateTimeDefaultStr;

  DateTime? dateTimeDefaultStrNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefault copyWith({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultNow': dateTimeDefaultNow.toJson(),
      'dateTimeDefaultStr': dateTimeDefaultStr.toJson(),
      if (dateTimeDefaultStrNull != null)
        'dateTimeDefaultStrNull': dateTimeDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultNow': dateTimeDefaultNow.toJson(),
      'dateTimeDefaultStr': dateTimeDefaultStr.toJson(),
      if (dateTimeDefaultStrNull != null)
        'dateTimeDefaultStrNull': dateTimeDefaultStrNull?.toJson(),
    };
  }

  static DateTimeDefaultInclude include() {
    return DateTimeDefaultInclude._();
  }

  static DateTimeDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    DateTimeDefaultInclude? include,
  }) {
    return DateTimeDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DateTimeDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultImpl extends DateTimeDefault {
  _DateTimeDefaultImpl({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) : super._(
          id: id,
          dateTimeDefaultNow: dateTimeDefaultNow,
          dateTimeDefaultStr: dateTimeDefaultStr,
          dateTimeDefaultStrNull: dateTimeDefaultStrNull,
        );

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefault copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    Object? dateTimeDefaultStrNull = _Undefined,
  }) {
    return DateTimeDefault(
      id: id is int? ? id : this.id,
      dateTimeDefaultNow: dateTimeDefaultNow ?? this.dateTimeDefaultNow,
      dateTimeDefaultStr: dateTimeDefaultStr ?? this.dateTimeDefaultStr,
      dateTimeDefaultStrNull: dateTimeDefaultStrNull is DateTime?
          ? dateTimeDefaultStrNull
          : this.dateTimeDefaultStrNull,
    );
  }
}

class DateTimeDefaultTable extends _i1.Table {
  DateTimeDefaultTable({super.tableRelation})
      : super(tableName: 'datetime_default') {
    dateTimeDefaultNow = _i1.ColumnDateTime(
      'dateTimeDefaultNow',
      this,
      hasDefault: true,
    );
    dateTimeDefaultStr = _i1.ColumnDateTime(
      'dateTimeDefaultStr',
      this,
      hasDefault: true,
    );
    dateTimeDefaultStrNull = _i1.ColumnDateTime(
      'dateTimeDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultNow;

  late final _i1.ColumnDateTime dateTimeDefaultStr;

  late final _i1.ColumnDateTime dateTimeDefaultStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultNow,
        dateTimeDefaultStr,
        dateTimeDefaultStrNull,
      ];
}

class DateTimeDefaultInclude extends _i1.IncludeObject {
  DateTimeDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DateTimeDefault.t;
}

class DateTimeDefaultIncludeList extends _i1.IncludeList {
  DateTimeDefaultIncludeList._({
    _i1.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DateTimeDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DateTimeDefault.t;
}

class DateTimeDefaultRepository {
  const DateTimeDefaultRepository._();

  Future<List<DateTimeDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DateTimeDefault>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefault>> insert(
    _i1.Session session,
    List<DateTimeDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DateTimeDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefault> insertRow(
    _i1.Session session,
    DateTimeDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefault>> update(
    _i1.Session session,
    List<DateTimeDefault> rows, {
    _i1.ColumnSelections<DateTimeDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DateTimeDefault>(
      rows,
      columns: columns?.call(DateTimeDefault.t),
      transaction: transaction,
    );
  }

  Future<DateTimeDefault> updateRow(
    _i1.Session session,
    DateTimeDefault row, {
    _i1.ColumnSelections<DateTimeDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefault>(
      row,
      columns: columns?.call(DateTimeDefault.t),
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefault>> delete(
    _i1.Session session,
    List<DateTimeDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DateTimeDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefault> deleteRow(
    _i1.Session session,
    DateTimeDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DateTimeDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DateTimeDefault>(
      where: where(DateTimeDefault.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
