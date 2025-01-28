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

abstract class DateTimeDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DateTimeDefaultPersist._({
    this.id,
    this.dateTimeDefaultPersistNow,
    this.dateTimeDefaultPersistStr,
  });

  factory DateTimeDefaultPersist({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) = _DateTimeDefaultPersistImpl;

  factory DateTimeDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultPersist(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultPersistNow:
          jsonSerialization['dateTimeDefaultPersistNow'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultPersistNow']),
      dateTimeDefaultPersistStr:
          jsonSerialization['dateTimeDefaultPersistStr'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultPersistStr']),
    );
  }

  static final t = DateTimeDefaultPersistTable();

  static const db = DateTimeDefaultPersistRepository._();

  @override
  int? id;

  DateTime? dateTimeDefaultPersistNow;

  DateTime? dateTimeDefaultPersistStr;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultPersist copyWith({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultPersistNow != null)
        'dateTimeDefaultPersistNow': dateTimeDefaultPersistNow?.toJson(),
      if (dateTimeDefaultPersistStr != null)
        'dateTimeDefaultPersistStr': dateTimeDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultPersistNow != null)
        'dateTimeDefaultPersistNow': dateTimeDefaultPersistNow?.toJson(),
      if (dateTimeDefaultPersistStr != null)
        'dateTimeDefaultPersistStr': dateTimeDefaultPersistStr?.toJson(),
    };
  }

  static DateTimeDefaultPersistInclude include() {
    return DateTimeDefaultPersistInclude._();
  }

  static DateTimeDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    DateTimeDefaultPersistInclude? include,
  }) {
    return DateTimeDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultPersistImpl extends DateTimeDefaultPersist {
  _DateTimeDefaultPersistImpl({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) : super._(
          id: id,
          dateTimeDefaultPersistNow: dateTimeDefaultPersistNow,
          dateTimeDefaultPersistStr: dateTimeDefaultPersistStr,
        );

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? dateTimeDefaultPersistNow = _Undefined,
    Object? dateTimeDefaultPersistStr = _Undefined,
  }) {
    return DateTimeDefaultPersist(
      id: id is int? ? id : this.id,
      dateTimeDefaultPersistNow: dateTimeDefaultPersistNow is DateTime?
          ? dateTimeDefaultPersistNow
          : this.dateTimeDefaultPersistNow,
      dateTimeDefaultPersistStr: dateTimeDefaultPersistStr is DateTime?
          ? dateTimeDefaultPersistStr
          : this.dateTimeDefaultPersistStr,
    );
  }
}

class DateTimeDefaultPersistTable extends _i1.Table {
  DateTimeDefaultPersistTable({super.tableRelation})
      : super(tableName: 'datetime_default_persist') {
    dateTimeDefaultPersistNow = _i1.ColumnDateTime(
      'dateTimeDefaultPersistNow',
      this,
      hasDefault: true,
    );
    dateTimeDefaultPersistStr = _i1.ColumnDateTime(
      'dateTimeDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultPersistNow;

  late final _i1.ColumnDateTime dateTimeDefaultPersistStr;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultPersistNow,
        dateTimeDefaultPersistStr,
      ];
}

class DateTimeDefaultPersistInclude extends _i1.IncludeObject {
  DateTimeDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DateTimeDefaultPersist.t;
}

class DateTimeDefaultPersistIncludeList extends _i1.IncludeList {
  DateTimeDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DateTimeDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DateTimeDefaultPersist.t;
}

class DateTimeDefaultPersistRepository {
  const DateTimeDefaultPersistRepository._();

  Future<List<DateTimeDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DateTimeDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultPersist>> insert(
    _i1.Session session,
    List<DateTimeDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DateTimeDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultPersist> insertRow(
    _i1.Session session,
    DateTimeDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultPersist>> update(
    _i1.Session session,
    List<DateTimeDefaultPersist> rows, {
    _i1.ColumnSelections<DateTimeDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DateTimeDefaultPersist>(
      rows,
      columns: columns?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultPersist> updateRow(
    _i1.Session session,
    DateTimeDefaultPersist row, {
    _i1.ColumnSelections<DateTimeDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultPersist>(
      row,
      columns: columns?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultPersist>> delete(
    _i1.Session session,
    List<DateTimeDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DateTimeDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultPersist> deleteRow(
    _i1.Session session,
    DateTimeDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultPersist>(
      where: where(DateTimeDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
