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

/// Just some simple data.
abstract class SimpleDateTime extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  SimpleDateTime._({
    int? id,
    required this.dateTime,
  }) : super(id);

  factory SimpleDateTime({
    int? id,
    required DateTime dateTime,
  }) = _SimpleDateTimeImpl;

  factory SimpleDateTime.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDateTime(
      id: jsonSerialization['id'] as int?,
      dateTime:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateTime']),
    );
  }

  static final t = SimpleDateTimeTable();

  static const db = SimpleDateTimeRepository._();

  /// The only field of [SimpleDateTime]
  DateTime dateTime;

  @override
  _i1.Table get table => t;

  SimpleDateTime copyWith({
    int? id,
    DateTime? dateTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  static SimpleDateTimeInclude include() {
    return SimpleDateTimeInclude._();
  }

  static SimpleDateTimeIncludeList includeList({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    SimpleDateTimeInclude? include,
  }) {
    return SimpleDateTimeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SimpleDateTime.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimpleDateTimeImpl extends SimpleDateTime {
  _SimpleDateTimeImpl({
    int? id,
    required DateTime dateTime,
  }) : super._(
          id: id,
          dateTime: dateTime,
        );

  @override
  SimpleDateTime copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
  }) {
    return SimpleDateTime(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class SimpleDateTimeTable extends _i1.Table {
  SimpleDateTimeTable({super.tableRelation})
      : super(tableName: 'simple_date_time') {
    dateTime = _i1.ColumnDateTime(
      'dateTime',
      this,
    );
  }

  /// The only field of [SimpleDateTime]
  late final _i1.ColumnDateTime dateTime;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTime,
      ];
}

class SimpleDateTimeInclude extends _i1.IncludeObject {
  SimpleDateTimeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeIncludeList extends _i1.IncludeList {
  SimpleDateTimeIncludeList._({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SimpleDateTime.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeRepository {
  const SimpleDateTimeRepository._();

  Future<List<SimpleDateTime>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _i1.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SimpleDateTime>(
      id,
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> insert(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime> insertRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> update(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SimpleDateTime>(
      rows,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<SimpleDateTime> updateRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleDateTime>(
      row,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> delete(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime> deleteRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDateTimeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
