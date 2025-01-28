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

abstract class DateTimeDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DateTimeDefaultMix._({
    this.id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  })  : dateTimeDefaultAndDefaultModel = dateTimeDefaultAndDefaultModel ??
            DateTime.parse('2024-05-10T22:00:00.000Z'),
        dateTimeDefaultAndDefaultPersist = dateTimeDefaultAndDefaultPersist ??
            DateTime.parse('2024-05-01T22:00:00.000Z'),
        dateTimeDefaultModelAndDefaultPersist =
            dateTimeDefaultModelAndDefaultPersist ??
                DateTime.parse('2024-05-01T22:00:00.000Z');

  factory DateTimeDefaultMix({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) = _DateTimeDefaultMixImpl;

  factory DateTimeDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultMix(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultAndDefaultModel: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultModel']),
      dateTimeDefaultAndDefaultPersist: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultPersist']),
      dateTimeDefaultModelAndDefaultPersist: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelAndDefaultPersist']),
    );
  }

  static final t = DateTimeDefaultMixTable();

  static const db = DateTimeDefaultMixRepository._();

  @override
  int? id;

  DateTime dateTimeDefaultAndDefaultModel;

  DateTime dateTimeDefaultAndDefaultPersist;

  DateTime dateTimeDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DateTimeDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultMix copyWith({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultPersist':
          dateTimeDefaultAndDefaultPersist.toJson(),
      'dateTimeDefaultModelAndDefaultPersist':
          dateTimeDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultPersist':
          dateTimeDefaultAndDefaultPersist.toJson(),
      'dateTimeDefaultModelAndDefaultPersist':
          dateTimeDefaultModelAndDefaultPersist.toJson(),
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
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          dateTimeDefaultAndDefaultModel: dateTimeDefaultAndDefaultModel,
          dateTimeDefaultAndDefaultPersist: dateTimeDefaultAndDefaultPersist,
          dateTimeDefaultModelAndDefaultPersist:
              dateTimeDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DateTimeDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultMix copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) {
    return DateTimeDefaultMix(
      id: id is int? ? id : this.id,
      dateTimeDefaultAndDefaultModel:
          dateTimeDefaultAndDefaultModel ?? this.dateTimeDefaultAndDefaultModel,
      dateTimeDefaultAndDefaultPersist: dateTimeDefaultAndDefaultPersist ??
          this.dateTimeDefaultAndDefaultPersist,
      dateTimeDefaultModelAndDefaultPersist:
          dateTimeDefaultModelAndDefaultPersist ??
              this.dateTimeDefaultModelAndDefaultPersist,
    );
  }
}

class DateTimeDefaultMixTable extends _i1.Table {
  DateTimeDefaultMixTable({super.tableRelation})
      : super(tableName: 'datetime_default_mix') {
    dateTimeDefaultAndDefaultModel = _i1.ColumnDateTime(
      'dateTimeDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    dateTimeDefaultAndDefaultPersist = _i1.ColumnDateTime(
      'dateTimeDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    dateTimeDefaultModelAndDefaultPersist = _i1.ColumnDateTime(
      'dateTimeDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDateTime dateTimeDefaultAndDefaultModel;

  late final _i1.ColumnDateTime dateTimeDefaultAndDefaultPersist;

  late final _i1.ColumnDateTime dateTimeDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTimeDefaultAndDefaultModel,
        dateTimeDefaultAndDefaultPersist,
        dateTimeDefaultModelAndDefaultPersist,
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
