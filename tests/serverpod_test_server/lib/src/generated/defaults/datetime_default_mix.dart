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

abstract class DateTimeDefaultMix extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  DateTimeDefaultMix._({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  })  : dateTimeDefaultAndDefaultModel = dateTimeDefaultAndDefaultModel ??
            DateTime.parse('2024-05-10T22:00:00.000Z'),
        dateTimeDefaultAndDefaultDatabase = dateTimeDefaultAndDefaultDatabase ??
            DateTime.parse('2024-05-01T22:00:00.000Z'),
        dateTimeDefaultModelAndDefaultDatabase =
            dateTimeDefaultModelAndDefaultDatabase ??
                DateTime.parse('2024-05-01T22:00:00.000Z'),
        super(id);

  factory DateTimeDefaultMix({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) = _DateTimeDefaultMixImpl;

  factory DateTimeDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultMix(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultAndDefaultModel: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultModel']),
      dateTimeDefaultAndDefaultDatabase: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultDatabase']),
      dateTimeDefaultModelAndDefaultDatabase:
          _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultModelAndDefaultDatabase']),
    );
  }

  static final t = DateTimeDefaultMixTable();

  static const db = DateTimeDefaultMixRepository._();

  DateTime dateTimeDefaultAndDefaultModel;

  DateTime dateTimeDefaultAndDefaultDatabase;

  DateTime dateTimeDefaultModelAndDefaultDatabase;

  @override
  _i1.Table get table => t;

  DateTimeDefaultMix copyWith({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultDatabase':
          dateTimeDefaultAndDefaultDatabase.toJson(),
      'dateTimeDefaultModelAndDefaultDatabase':
          dateTimeDefaultModelAndDefaultDatabase.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultDatabase':
          dateTimeDefaultAndDefaultDatabase.toJson(),
      'dateTimeDefaultModelAndDefaultDatabase':
          dateTimeDefaultModelAndDefaultDatabase.toJson(),
    };
  }

  static DateTimeDefaultMixInclude include() {
    return DateTimeDefaultMixInclude._();
  }

  static DateTimeDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<DateTimeDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultMixTable>? orderByList,
    DateTimeDefaultMixInclude? include,
  }) {
    return DateTimeDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DateTimeDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultMixImpl extends DateTimeDefaultMix {
  _DateTimeDefaultMixImpl({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) : super._(
          id: id,
          dateTimeDefaultAndDefaultModel: dateTimeDefaultAndDefaultModel,
          dateTimeDefaultAndDefaultDatabase: dateTimeDefaultAndDefaultDatabase,
          dateTimeDefaultModelAndDefaultDatabase:
              dateTimeDefaultModelAndDefaultDatabase,
        );

  @override
  DateTimeDefaultMix copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) {
    return DateTimeDefaultMix(
      id: id is int? ? id : this.id,
      dateTimeDefaultAndDefaultModel:
          dateTimeDefaultAndDefaultModel ?? this.dateTimeDefaultAndDefaultModel,
      dateTimeDefaultAndDefaultDatabase: dateTimeDefaultAndDefaultDatabase ??
          this.dateTimeDefaultAndDefaultDatabase,
      dateTimeDefaultModelAndDefaultDatabase:
          dateTimeDefaultModelAndDefaultDatabase ??
              this.dateTimeDefaultModelAndDefaultDatabase,
    );
  }
}

class DateTimeDefaultMixTable extends _i1.Table {
  DateTimeDefaultMixTable({super.tableRelation})
      : super(tableName: 'datetime_default_mix') {
    dateTimeDefaultAndDefaultModel = _i1.ColumnDateTime(
      'dateTimeDefaultAndDefaultModel',
      this,
      hasDefaults: true,
    );
    dateTimeDefaultAndDefaultDatabase = _i1.ColumnDateTime(
      'dateTimeDefaultAndDefaultDatabase',
      this,
      hasDefaults: true,
    );
    dateTimeDefaultModelAndDefaultDatabase = _i1.ColumnDateTime(
      'dateTimeDefaultModelAndDefaultDatabase',
      this,
      hasDefaults: true,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultAndDefaultModel;

  late final _i1.ColumnDateTime dateTimeDefaultAndDefaultDatabase;

  late final _i1.ColumnDateTime dateTimeDefaultModelAndDefaultDatabase;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultAndDefaultModel,
        dateTimeDefaultAndDefaultDatabase,
        dateTimeDefaultModelAndDefaultDatabase,
      ];
}

class DateTimeDefaultMixInclude extends _i1.IncludeObject {
  DateTimeDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DateTimeDefaultMix.t;
}

class DateTimeDefaultMixIncludeList extends _i1.IncludeList {
  DateTimeDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<DateTimeDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DateTimeDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DateTimeDefaultMix.t;
}

class DateTimeDefaultMixRepository {
  const DateTimeDefaultMixRepository._();

  Future<List<DateTimeDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DateTimeDefaultMix>(
      where: where?.call(DateTimeDefaultMix.t),
      orderBy: orderBy?.call(DateTimeDefaultMix.t),
      orderByList: orderByList?.call(DateTimeDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<DateTimeDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DateTimeDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultMix>(
      where: where?.call(DateTimeDefaultMix.t),
      orderBy: orderBy?.call(DateTimeDefaultMix.t),
      orderByList: orderByList?.call(DateTimeDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DateTimeDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultMix>> insert(
    _i1.Session session,
    List<DateTimeDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DateTimeDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultMix> insertRow(
    _i1.Session session,
    DateTimeDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultMix>> update(
    _i1.Session session,
    List<DateTimeDefaultMix> rows, {
    _i1.ColumnSelections<DateTimeDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DateTimeDefaultMix>(
      rows,
      columns: columns?.call(DateTimeDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultMix> updateRow(
    _i1.Session session,
    DateTimeDefaultMix row, {
    _i1.ColumnSelections<DateTimeDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultMix>(
      row,
      columns: columns?.call(DateTimeDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultMix>> delete(
    _i1.Session session,
    List<DateTimeDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DateTimeDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  Future<DateTimeDefaultMix> deleteRow(
    _i1.Session session,
    DateTimeDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DateTimeDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DateTimeDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultMix>(
      where: where(DateTimeDefaultMix.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DateTimeDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultMix>(
      where: where?.call(DateTimeDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
