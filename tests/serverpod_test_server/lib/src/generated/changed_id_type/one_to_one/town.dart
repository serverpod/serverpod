/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/one_to_one/citizen.dart' as _i2;

abstract class TownInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TownInt._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory TownInt({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) = _TownIntImpl;

  factory TownInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TownInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i2.CitizenInt.fromJson(
              (jsonSerialization['mayor'] as Map<String, dynamic>),
            ),
    );
  }

  static final t = TownIntTable();

  static const db = TownIntRepository._();

  @override
  int? id;

  String name;

  int? mayorId;

  _i2.CitizenInt? mayor;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TownInt copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJsonForProtocol(),
    };
  }

  static TownIntInclude include({_i2.CitizenIntInclude? mayor}) {
    return TownIntInclude._(mayor: mayor);
  }

  static TownIntIncludeList includeList({
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    TownIntInclude? include,
  }) {
    return TownIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TownInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TownInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownIntImpl extends TownInt {
  _TownIntImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) : super._(
         id: id,
         name: name,
         mayorId: mayorId,
         mayor: mayor,
       );

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TownInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return TownInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.CitizenInt? ? mayor : this.mayor?.copyWith(),
    );
  }
}

class TownIntUpdateTable extends _i1.UpdateTable<TownIntTable> {
  TownIntUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> mayorId(int? value) => _i1.ColumnValue(
    table.mayorId,
    value,
  );
}

class TownIntTable extends _i1.Table<int?> {
  TownIntTable({super.tableRelation}) : super(tableName: 'town_int') {
    updateTable = TownIntUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    mayorId = _i1.ColumnInt(
      'mayorId',
      this,
    );
  }

  late final TownIntUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt mayorId;

  _i2.CitizenIntTable? _mayor;

  _i2.CitizenIntTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _i1.createRelationTable(
      relationFieldName: 'mayor',
      field: TownInt.t.mayorId,
      foreignField: _i2.CitizenInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CitizenIntTable(tableRelation: foreignTableRelation),
    );
    return _mayor!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    mayorId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

class TownIntInclude extends _i1.IncludeObject {
  TownIntInclude._({_i2.CitizenIntInclude? mayor}) {
    _mayor = mayor;
  }

  _i2.CitizenIntInclude? _mayor;

  @override
  Map<String, _i1.Include?> get includes => {'mayor': _mayor};

  @override
  _i1.Table<int?> get table => TownInt.t;
}

class TownIntIncludeList extends _i1.IncludeList {
  TownIntIncludeList._({
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TownInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TownInt.t;
}

class TownIntRepository {
  const TownIntRepository._();

  final attachRow = const TownIntAttachRowRepository._();

  final detachRow = const TownIntDetachRowRepository._();

  /// Returns a list of [TownInt]s matching the given query parameters.
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
  Future<List<TownInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.find<TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [TownInt] matching the given query parameters.
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
  Future<TownInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.findFirstRow<TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [TownInt] by its [id] or null if no such row exists.
  Future<TownInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.findById<TownInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [TownInt]s in the list and returns the inserted rows.
  ///
  /// The returned [TownInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TownInt>> insert(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TownInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TownInt] and returns the inserted row.
  ///
  /// The returned [TownInt] will have its `id` field set.
  Future<TownInt> insertRow(
    _i1.Session session,
    TownInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TownInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TownInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TownInt>> update(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.ColumnSelections<TownIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TownInt>(
      rows,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TownInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TownInt> updateRow(
    _i1.Session session,
    TownInt row, {
    _i1.ColumnSelections<TownIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TownInt>(
      row,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TownInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TownInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TownIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TownInt>(
      id,
      columnValues: columnValues(TownInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TownInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TownInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TownIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TownIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TownInt>(
      columnValues: columnValues(TownInt.t.updateTable),
      where: where(TownInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TownInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TownInt>> delete(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TownInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TownInt].
  Future<TownInt> deleteRow(
    _i1.Session session,
    TownInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TownInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TownInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TownIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TownInt>(
      where: where(TownInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TownInt>(
      where: where?.call(TownInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TownIntAttachRowRepository {
  const TownIntAttachRowRepository._();

  /// Creates a relation between the given [TownInt] and [CitizenInt]
  /// by setting the [TownInt]'s foreign key `mayorId` to refer to the [CitizenInt].
  Future<void> mayor(
    _i1.Session session,
    TownInt townInt,
    _i2.CitizenInt mayor, {
    _i1.Transaction? transaction,
  }) async {
    if (townInt.id == null) {
      throw ArgumentError.notNull('townInt.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $townInt = townInt.copyWith(mayorId: mayor.id);
    await session.db.updateRow<TownInt>(
      $townInt,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}

class TownIntDetachRowRepository {
  const TownIntDetachRowRepository._();

  /// Detaches the relation between this [TownInt] and the [CitizenInt] set in `mayor`
  /// by setting the [TownInt]'s foreign key `mayorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> mayor(
    _i1.Session session,
    TownInt townInt, {
    _i1.Transaction? transaction,
  }) async {
    if (townInt.id == null) {
      throw ArgumentError.notNull('townInt.id');
    }

    var $townInt = townInt.copyWith(mayorId: null);
    await session.db.updateRow<TownInt>(
      $townInt,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}
