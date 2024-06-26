/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class DateTimeDefaultDatabase extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  DateTimeDefaultDatabase._({
    int? id,
    this.dateTimeDefaultDatabaseNow,
    this.dateTimeDefaultDatabaseStr,
  }) : super(id);

  factory DateTimeDefaultDatabase({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  }) = _DateTimeDefaultDatabaseImpl;

  factory DateTimeDefaultDatabase.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultDatabase(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultDatabaseNow:
          jsonSerialization['dateTimeDefaultDatabaseNow'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultDatabaseNow']),
      dateTimeDefaultDatabaseStr:
          jsonSerialization['dateTimeDefaultDatabaseStr'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultDatabaseStr']),
    );
  }

  static final t = DateTimeDefaultDatabaseTable();

  static const db = DateTimeDefaultDatabaseRepository._();

  DateTime? dateTimeDefaultDatabaseNow;

  DateTime? dateTimeDefaultDatabaseStr;

  @override
  _i1.Table get table => t;

  DateTimeDefaultDatabase copyWith({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultDatabaseNow != null)
        'dateTimeDefaultDatabaseNow': dateTimeDefaultDatabaseNow?.toJson(),
      if (dateTimeDefaultDatabaseStr != null)
        'dateTimeDefaultDatabaseStr': dateTimeDefaultDatabaseStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultDatabaseNow != null)
        'dateTimeDefaultDatabaseNow': dateTimeDefaultDatabaseNow?.toJson(),
      if (dateTimeDefaultDatabaseStr != null)
        'dateTimeDefaultDatabaseStr': dateTimeDefaultDatabaseStr?.toJson(),
    };
  }

  static DateTimeDefaultDatabaseInclude include() {
    return DateTimeDefaultDatabaseInclude._();
  }

  static DateTimeDefaultDatabaseIncludeList includeList({
    _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultDatabaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultDatabaseTable>? orderByList,
    DateTimeDefaultDatabaseInclude? include,
  }) {
    return DateTimeDefaultDatabaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultDatabase.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DateTimeDefaultDatabase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultDatabaseImpl extends DateTimeDefaultDatabase {
  _DateTimeDefaultDatabaseImpl({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  }) : super._(
          id: id,
          dateTimeDefaultDatabaseNow: dateTimeDefaultDatabaseNow,
          dateTimeDefaultDatabaseStr: dateTimeDefaultDatabaseStr,
        );

  @override
  DateTimeDefaultDatabase copyWith({
    Object? id = _Undefined,
    Object? dateTimeDefaultDatabaseNow = _Undefined,
    Object? dateTimeDefaultDatabaseStr = _Undefined,
  }) {
    return DateTimeDefaultDatabase(
      id: id is int? ? id : this.id,
      dateTimeDefaultDatabaseNow: dateTimeDefaultDatabaseNow is DateTime?
          ? dateTimeDefaultDatabaseNow
          : this.dateTimeDefaultDatabaseNow,
      dateTimeDefaultDatabaseStr: dateTimeDefaultDatabaseStr is DateTime?
          ? dateTimeDefaultDatabaseStr
          : this.dateTimeDefaultDatabaseStr,
    );
  }
}

class DateTimeDefaultDatabaseTable extends _i1.Table {
  DateTimeDefaultDatabaseTable({super.tableRelation})
      : super(tableName: 'datetime_default_database') {
    dateTimeDefaultDatabaseNow = _i1.ColumnDateTime(
      'dateTimeDefaultDatabaseNow',
      this,
      hasDefaults: true,
    );
    dateTimeDefaultDatabaseStr = _i1.ColumnDateTime(
      'dateTimeDefaultDatabaseStr',
      this,
      hasDefaults: true,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultDatabaseNow;

  late final _i1.ColumnDateTime dateTimeDefaultDatabaseStr;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultDatabaseNow,
        dateTimeDefaultDatabaseStr,
      ];
}

class DateTimeDefaultDatabaseInclude extends _i1.IncludeObject {
  DateTimeDefaultDatabaseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DateTimeDefaultDatabase.t;
}

class DateTimeDefaultDatabaseIncludeList extends _i1.IncludeList {
  DateTimeDefaultDatabaseIncludeList._({
    _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DateTimeDefaultDatabase.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DateTimeDefaultDatabase.t;
}

class DateTimeDefaultDatabaseRepository {
  const DateTimeDefaultDatabaseRepository._();

  Future<List<DateTimeDefaultDatabase>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultDatabaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultDatabaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DateTimeDefaultDatabase>(
      where: where?.call(DateTimeDefaultDatabase.t),
      orderBy: orderBy?.call(DateTimeDefaultDatabase.t),
      orderByList: orderByList?.call(DateTimeDefaultDatabase.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultDatabase?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable>? where,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultDatabaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultDatabaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultDatabase>(
      where: where?.call(DateTimeDefaultDatabase.t),
      orderBy: orderBy?.call(DateTimeDefaultDatabase.t),
      orderByList: orderByList?.call(DateTimeDefaultDatabase.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultDatabase?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DateTimeDefaultDatabase>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultDatabase>> insert(
    _i1.Session session,
    List<DateTimeDefaultDatabase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DateTimeDefaultDatabase>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultDatabase> insertRow(
    _i1.Session session,
    DateTimeDefaultDatabase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultDatabase>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultDatabase>> update(
    _i1.Session session,
    List<DateTimeDefaultDatabase> rows, {
    _i1.ColumnSelections<DateTimeDefaultDatabaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DateTimeDefaultDatabase>(
      rows,
      columns: columns?.call(DateTimeDefaultDatabase.t),
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultDatabase> updateRow(
    _i1.Session session,
    DateTimeDefaultDatabase row, {
    _i1.ColumnSelections<DateTimeDefaultDatabaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultDatabase>(
      row,
      columns: columns?.call(DateTimeDefaultDatabase.t),
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultDatabase>> delete(
    _i1.Session session,
    List<DateTimeDefaultDatabase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DateTimeDefaultDatabase>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultDatabase> deleteRow(
    _i1.Session session,
    DateTimeDefaultDatabase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultDatabase>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultDatabase>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultDatabase>(
      where: where(DateTimeDefaultDatabase.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultDatabaseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultDatabase>(
      where: where?.call(DateTimeDefaultDatabase.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
