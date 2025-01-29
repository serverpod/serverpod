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

abstract class DurationDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  DurationDefaultMix._({
    this.id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  })  : durationDefaultAndDefaultModel = durationDefaultAndDefaultModel ??
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            ),
        durationDefaultAndDefaultPersist = durationDefaultAndDefaultPersist ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
        durationDefaultModelAndDefaultPersist =
            durationDefaultModelAndDefaultPersist ??
                Duration(
                  days: 1,
                  hours: 2,
                  minutes: 10,
                  seconds: 30,
                  milliseconds: 100,
                );

  factory DurationDefaultMix({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) = _DurationDefaultMixImpl;

  factory DurationDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DurationDefaultMix(
      id: jsonSerialization['id'] as int?,
      durationDefaultAndDefaultModel: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultModel']),
      durationDefaultAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultAndDefaultPersist']),
      durationDefaultModelAndDefaultPersist: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['durationDefaultModelAndDefaultPersist']),
    );
  }

  static final t = DurationDefaultMixTable();

  static const db = DurationDefaultMixRepository._();

  @override
  int? id;

  Duration durationDefaultAndDefaultModel;

  Duration durationDefaultAndDefaultPersist;

  Duration durationDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DurationDefaultMix copyWith({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'durationDefaultAndDefaultModel': durationDefaultAndDefaultModel.toJson(),
      'durationDefaultAndDefaultPersist':
          durationDefaultAndDefaultPersist.toJson(),
      'durationDefaultModelAndDefaultPersist':
          durationDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'durationDefaultAndDefaultModel': durationDefaultAndDefaultModel.toJson(),
      'durationDefaultAndDefaultPersist':
          durationDefaultAndDefaultPersist.toJson(),
      'durationDefaultModelAndDefaultPersist':
          durationDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static DurationDefaultMixInclude include() {
    return DurationDefaultMixInclude._();
  }

  static DurationDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    DurationDefaultMixInclude? include,
  }) {
    return DurationDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DurationDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultMixImpl extends DurationDefaultMix {
  _DurationDefaultMixImpl({
    int? id,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          durationDefaultAndDefaultModel: durationDefaultAndDefaultModel,
          durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist,
          durationDefaultModelAndDefaultPersist:
              durationDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DurationDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DurationDefaultMix copyWith({
    Object? id = _Undefined,
    Duration? durationDefaultAndDefaultModel,
    Duration? durationDefaultAndDefaultPersist,
    Duration? durationDefaultModelAndDefaultPersist,
  }) {
    return DurationDefaultMix(
      id: id is int? ? id : this.id,
      durationDefaultAndDefaultModel:
          durationDefaultAndDefaultModel ?? this.durationDefaultAndDefaultModel,
      durationDefaultAndDefaultPersist: durationDefaultAndDefaultPersist ??
          this.durationDefaultAndDefaultPersist,
      durationDefaultModelAndDefaultPersist:
          durationDefaultModelAndDefaultPersist ??
              this.durationDefaultModelAndDefaultPersist,
    );
  }
}

class DurationDefaultMixTable extends _i1.Table {
  DurationDefaultMixTable({super.tableRelation})
      : super(tableName: 'duration_default_mix') {
    durationDefaultAndDefaultModel = _i1.ColumnDuration(
      'durationDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    durationDefaultAndDefaultPersist = _i1.ColumnDuration(
      'durationDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    durationDefaultModelAndDefaultPersist = _i1.ColumnDuration(
      'durationDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnDuration durationDefaultAndDefaultModel;

  late final _i1.ColumnDuration durationDefaultAndDefaultPersist;

  late final _i1.ColumnDuration durationDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        durationDefaultAndDefaultModel,
        durationDefaultAndDefaultPersist,
        durationDefaultModelAndDefaultPersist,
      ];
}

class DurationDefaultMixInclude extends _i1.IncludeObject {
  DurationDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DurationDefaultMix.t;
}

class DurationDefaultMixIncludeList extends _i1.IncludeList {
  DurationDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DurationDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DurationDefaultMix.t;
}

class DurationDefaultMixRepository {
  const DurationDefaultMixRepository._();

  /// Returns a list of [DurationDefaultMix]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DurationDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderByList: orderByList?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DurationDefaultMix] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DurationDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<DurationDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DurationDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      orderBy: orderBy?.call(DurationDefaultMix.t),
      orderByList: orderByList?.call(DurationDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DurationDefaultMix] by its [id] or null if no such row exists.
  Future<DurationDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DurationDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DurationDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [DurationDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DurationDefaultMix>> insert(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DurationDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DurationDefaultMix] and returns the inserted row.
  ///
  /// The returned [DurationDefaultMix] will have its `id` field set.
  Future<DurationDefaultMix> insertRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DurationDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DurationDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DurationDefaultMix>> update(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.ColumnSelections<DurationDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DurationDefaultMix>(
      rows,
      columns: columns?.call(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DurationDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DurationDefaultMix> updateRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.ColumnSelections<DurationDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DurationDefaultMix>(
      row,
      columns: columns?.call(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DurationDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DurationDefaultMix>> delete(
    _i1.Session session,
    List<DurationDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DurationDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DurationDefaultMix].
  Future<DurationDefaultMix> deleteRow(
    _i1.Session session,
    DurationDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DurationDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DurationDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DurationDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DurationDefaultMix>(
      where: where(DurationDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DurationDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DurationDefaultMix>(
      where: where?.call(DurationDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
