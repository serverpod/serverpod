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
import '../../models_with_relations/column_alias_collision/bleed_child.dart'
    as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

/// Root model used to reproduce the include column-alias collision in
/// https://github.com/serverpod/serverpod/issues/5287
///
/// Two relations point at the same child table (`bleed_child`). Their relation
/// field names are intentionally long so the generated relation/column aliases
/// are truncated to the Postgres 63 character identifier limit. With these exact
/// names the truncated SELECT alias of the first relation's `id` column collides
/// with the second relation's `bleedingText` column, so the string value bleeds
/// into the int `id` field on deserialization.
///
/// The two relations are declared with explicit `field=` foreign keys so the FK
/// column names stay short (the long names only affect the relation aliases).
abstract class BleedRoot
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BleedRoot._({
    this.id,
    required this.name,
    this.firstChildId,
    this.childRelationWithExtremelyLongFieldNameForcingTrun24,
    this.secondChildId,
    this.childRelationWithExtremelyLongFieldNameForcingTrun23,
  });

  factory BleedRoot({
    int? id,
    required String name,
    int? firstChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun24,
    int? secondChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun23,
  }) = _BleedRootImpl;

  factory BleedRoot.fromJson(Map<String, dynamic> jsonSerialization) {
    return BleedRoot(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      firstChildId: jsonSerialization['firstChildId'] as int?,
      childRelationWithExtremelyLongFieldNameForcingTrun24:
          jsonSerialization['childRelationWithExtremelyLongFieldNameForcingTrun24'] ==
              null
          ? null
          : _i3.Protocol().deserialize<_i2.BleedChild>(
              jsonSerialization['childRelationWithExtremelyLongFieldNameForcingTrun24'],
            ),
      secondChildId: jsonSerialization['secondChildId'] as int?,
      childRelationWithExtremelyLongFieldNameForcingTrun23:
          jsonSerialization['childRelationWithExtremelyLongFieldNameForcingTrun23'] ==
              null
          ? null
          : _i3.Protocol().deserialize<_i2.BleedChild>(
              jsonSerialization['childRelationWithExtremelyLongFieldNameForcingTrun23'],
            ),
    );
  }

  static final t = BleedRootTable();

  static const db = BleedRootRepository._();

  @override
  int? id;

  String name;

  int? firstChildId;

  _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun24;

  int? secondChildId;

  _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun23;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BleedRoot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BleedRoot copyWith({
    int? id,
    String? name,
    int? firstChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun24,
    int? secondChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun23,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BleedRoot',
      if (id != null) 'id': id,
      'name': name,
      if (firstChildId != null) 'firstChildId': firstChildId,
      if (childRelationWithExtremelyLongFieldNameForcingTrun24 != null)
        'childRelationWithExtremelyLongFieldNameForcingTrun24':
            childRelationWithExtremelyLongFieldNameForcingTrun24?.toJson(),
      if (secondChildId != null) 'secondChildId': secondChildId,
      if (childRelationWithExtremelyLongFieldNameForcingTrun23 != null)
        'childRelationWithExtremelyLongFieldNameForcingTrun23':
            childRelationWithExtremelyLongFieldNameForcingTrun23?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BleedRoot',
      if (id != null) 'id': id,
      'name': name,
      if (firstChildId != null) 'firstChildId': firstChildId,
      if (childRelationWithExtremelyLongFieldNameForcingTrun24 != null)
        'childRelationWithExtremelyLongFieldNameForcingTrun24':
            childRelationWithExtremelyLongFieldNameForcingTrun24
                ?.toJsonForProtocol(),
      if (secondChildId != null) 'secondChildId': secondChildId,
      if (childRelationWithExtremelyLongFieldNameForcingTrun23 != null)
        'childRelationWithExtremelyLongFieldNameForcingTrun23':
            childRelationWithExtremelyLongFieldNameForcingTrun23
                ?.toJsonForProtocol(),
    };
  }

  static BleedRootInclude include({
    _i2.BleedChildInclude? childRelationWithExtremelyLongFieldNameForcingTrun24,
    _i2.BleedChildInclude? childRelationWithExtremelyLongFieldNameForcingTrun23,
  }) {
    return BleedRootInclude._(
      childRelationWithExtremelyLongFieldNameForcingTrun24:
          childRelationWithExtremelyLongFieldNameForcingTrun24,
      childRelationWithExtremelyLongFieldNameForcingTrun23:
          childRelationWithExtremelyLongFieldNameForcingTrun23,
    );
  }

  static BleedRootIncludeList includeList({
    _i1.WhereExpressionBuilder<BleedRootTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedRootTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BleedRootTable>? orderByList,
    BleedRootInclude? include,
  }) {
    return BleedRootIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BleedRoot.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BleedRoot.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BleedRootImpl extends BleedRoot {
  _BleedRootImpl({
    int? id,
    required String name,
    int? firstChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun24,
    int? secondChildId,
    _i2.BleedChild? childRelationWithExtremelyLongFieldNameForcingTrun23,
  }) : super._(
         id: id,
         name: name,
         firstChildId: firstChildId,
         childRelationWithExtremelyLongFieldNameForcingTrun24:
             childRelationWithExtremelyLongFieldNameForcingTrun24,
         secondChildId: secondChildId,
         childRelationWithExtremelyLongFieldNameForcingTrun23:
             childRelationWithExtremelyLongFieldNameForcingTrun23,
       );

  /// Returns a shallow copy of this [BleedRoot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BleedRoot copyWith({
    Object? id = _Undefined,
    String? name,
    Object? firstChildId = _Undefined,
    Object? childRelationWithExtremelyLongFieldNameForcingTrun24 = _Undefined,
    Object? secondChildId = _Undefined,
    Object? childRelationWithExtremelyLongFieldNameForcingTrun23 = _Undefined,
  }) {
    return BleedRoot(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      firstChildId: firstChildId is int? ? firstChildId : this.firstChildId,
      childRelationWithExtremelyLongFieldNameForcingTrun24:
          childRelationWithExtremelyLongFieldNameForcingTrun24
              is _i2.BleedChild?
          ? childRelationWithExtremelyLongFieldNameForcingTrun24
          : this.childRelationWithExtremelyLongFieldNameForcingTrun24
                ?.copyWith(),
      secondChildId: secondChildId is int? ? secondChildId : this.secondChildId,
      childRelationWithExtremelyLongFieldNameForcingTrun23:
          childRelationWithExtremelyLongFieldNameForcingTrun23
              is _i2.BleedChild?
          ? childRelationWithExtremelyLongFieldNameForcingTrun23
          : this.childRelationWithExtremelyLongFieldNameForcingTrun23
                ?.copyWith(),
    );
  }
}

class BleedRootUpdateTable extends _i1.UpdateTable<BleedRootTable> {
  BleedRootUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> firstChildId(int? value) => _i1.ColumnValue(
    table.firstChildId,
    value,
  );

  _i1.ColumnValue<int, int> secondChildId(int? value) => _i1.ColumnValue(
    table.secondChildId,
    value,
  );
}

class BleedRootTable extends _i1.Table<int?> {
  BleedRootTable({super.tableRelation}) : super(tableName: 'bleed_root') {
    updateTable = BleedRootUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    firstChildId = _i1.ColumnInt(
      'firstChildId',
      this,
    );
    secondChildId = _i1.ColumnInt(
      'secondChildId',
      this,
    );
  }

  late final BleedRootUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt firstChildId;

  _i2.BleedChildTable? _childRelationWithExtremelyLongFieldNameForcingTrun24;

  late final _i1.ColumnInt secondChildId;

  _i2.BleedChildTable? _childRelationWithExtremelyLongFieldNameForcingTrun23;

  _i2.BleedChildTable get childRelationWithExtremelyLongFieldNameForcingTrun24 {
    if (_childRelationWithExtremelyLongFieldNameForcingTrun24 != null)
      return _childRelationWithExtremelyLongFieldNameForcingTrun24!;
    _childRelationWithExtremelyLongFieldNameForcingTrun24 = _i1
        .createRelationTable(
          relationFieldName:
              'childRelationWithExtremelyLongFieldNameForcingTrun24',
          field: BleedRoot.t.firstChildId,
          foreignField: _i2.BleedChild.t.id,
          tableRelation: tableRelation,
          createTable: (foreignTableRelation) =>
              _i2.BleedChildTable(tableRelation: foreignTableRelation),
        );
    return _childRelationWithExtremelyLongFieldNameForcingTrun24!;
  }

  _i2.BleedChildTable get childRelationWithExtremelyLongFieldNameForcingTrun23 {
    if (_childRelationWithExtremelyLongFieldNameForcingTrun23 != null)
      return _childRelationWithExtremelyLongFieldNameForcingTrun23!;
    _childRelationWithExtremelyLongFieldNameForcingTrun23 = _i1
        .createRelationTable(
          relationFieldName:
              'childRelationWithExtremelyLongFieldNameForcingTrun23',
          field: BleedRoot.t.secondChildId,
          foreignField: _i2.BleedChild.t.id,
          tableRelation: tableRelation,
          createTable: (foreignTableRelation) =>
              _i2.BleedChildTable(tableRelation: foreignTableRelation),
        );
    return _childRelationWithExtremelyLongFieldNameForcingTrun23!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    firstChildId,
    secondChildId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField ==
        'childRelationWithExtremelyLongFieldNameForcingTrun24') {
      return childRelationWithExtremelyLongFieldNameForcingTrun24;
    }
    if (relationField ==
        'childRelationWithExtremelyLongFieldNameForcingTrun23') {
      return childRelationWithExtremelyLongFieldNameForcingTrun23;
    }
    return null;
  }
}

class BleedRootInclude extends _i1.IncludeObject {
  BleedRootInclude._({
    _i2.BleedChildInclude? childRelationWithExtremelyLongFieldNameForcingTrun24,
    _i2.BleedChildInclude? childRelationWithExtremelyLongFieldNameForcingTrun23,
  }) {
    _childRelationWithExtremelyLongFieldNameForcingTrun24 =
        childRelationWithExtremelyLongFieldNameForcingTrun24;
    _childRelationWithExtremelyLongFieldNameForcingTrun23 =
        childRelationWithExtremelyLongFieldNameForcingTrun23;
  }

  _i2.BleedChildInclude? _childRelationWithExtremelyLongFieldNameForcingTrun24;

  _i2.BleedChildInclude? _childRelationWithExtremelyLongFieldNameForcingTrun23;

  @override
  Map<String, _i1.Include?> get includes => {
    'childRelationWithExtremelyLongFieldNameForcingTrun24':
        _childRelationWithExtremelyLongFieldNameForcingTrun24,
    'childRelationWithExtremelyLongFieldNameForcingTrun23':
        _childRelationWithExtremelyLongFieldNameForcingTrun23,
  };

  @override
  _i1.Table<int?> get table => BleedRoot.t;
}

class BleedRootIncludeList extends _i1.IncludeList {
  BleedRootIncludeList._({
    _i1.WhereExpressionBuilder<BleedRootTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BleedRoot.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BleedRoot.t;
}

class BleedRootRepository {
  const BleedRootRepository._();

  final attachRow = const BleedRootAttachRowRepository._();

  final detachRow = const BleedRootDetachRowRepository._();

  /// Returns a list of [BleedRoot]s matching the given query parameters.
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
  Future<List<BleedRoot>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedRootTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedRootTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BleedRootTable>? orderByList,
    _i1.Transaction? transaction,
    BleedRootInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BleedRoot>(
      where: where?.call(BleedRoot.t),
      orderBy: orderBy?.call(BleedRoot.t),
      orderByList: orderByList?.call(BleedRoot.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BleedRoot] matching the given query parameters.
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
  Future<BleedRoot?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedRootTable>? where,
    int? offset,
    _i1.OrderByBuilder<BleedRootTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BleedRootTable>? orderByList,
    _i1.Transaction? transaction,
    BleedRootInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BleedRoot>(
      where: where?.call(BleedRoot.t),
      orderBy: orderBy?.call(BleedRoot.t),
      orderByList: orderByList?.call(BleedRoot.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BleedRoot] by its [id] or null if no such row exists.
  Future<BleedRoot?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    BleedRootInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BleedRoot>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BleedRoot]s in the list and returns the inserted rows.
  ///
  /// The returned [BleedRoot]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BleedRoot>> insert(
    _i1.DatabaseSession session,
    List<BleedRoot> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BleedRoot>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BleedRoot] and returns the inserted row.
  ///
  /// The returned [BleedRoot] will have its `id` field set.
  Future<BleedRoot> insertRow(
    _i1.DatabaseSession session,
    BleedRoot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BleedRoot>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BleedRoot]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BleedRoot>> update(
    _i1.DatabaseSession session,
    List<BleedRoot> rows, {
    _i1.ColumnSelections<BleedRootTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BleedRoot>(
      rows,
      columns: columns?.call(BleedRoot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BleedRoot]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BleedRoot> updateRow(
    _i1.DatabaseSession session,
    BleedRoot row, {
    _i1.ColumnSelections<BleedRootTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BleedRoot>(
      row,
      columns: columns?.call(BleedRoot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BleedRoot] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BleedRoot?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<BleedRootUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BleedRoot>(
      id,
      columnValues: columnValues(BleedRoot.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BleedRoot]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BleedRoot>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BleedRootUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BleedRootTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedRootTable>? orderBy,
    _i1.OrderByListBuilder<BleedRootTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BleedRoot>(
      columnValues: columnValues(BleedRoot.t.updateTable),
      where: where(BleedRoot.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BleedRoot.t),
      orderByList: orderByList?.call(BleedRoot.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BleedRoot]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BleedRoot>> delete(
    _i1.DatabaseSession session,
    List<BleedRoot> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BleedRoot>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BleedRoot].
  Future<BleedRoot> deleteRow(
    _i1.DatabaseSession session,
    BleedRoot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BleedRoot>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BleedRoot>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BleedRootTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BleedRoot>(
      where: where(BleedRoot.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedRootTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BleedRoot>(
      where: where?.call(BleedRoot.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BleedRoot] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BleedRootTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BleedRoot>(
      where: where(BleedRoot.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class BleedRootAttachRowRepository {
  const BleedRootAttachRowRepository._();

  /// Creates a relation between the given [BleedRoot] and [BleedChild]
  /// by setting the [BleedRoot]'s foreign key `firstChildId` to refer to the [BleedChild].
  Future<void> childRelationWithExtremelyLongFieldNameForcingTrun24(
    _i1.DatabaseSession session,
    BleedRoot bleedRoot,
    _i2.BleedChild childRelationWithExtremelyLongFieldNameForcingTrun24, {
    _i1.Transaction? transaction,
  }) async {
    if (bleedRoot.id == null) {
      throw ArgumentError.notNull('bleedRoot.id');
    }
    if (childRelationWithExtremelyLongFieldNameForcingTrun24.id == null) {
      throw ArgumentError.notNull(
        'childRelationWithExtremelyLongFieldNameForcingTrun24.id',
      );
    }

    var $bleedRoot = bleedRoot.copyWith(
      firstChildId: childRelationWithExtremelyLongFieldNameForcingTrun24.id,
    );
    await session.db.updateRow<BleedRoot>(
      $bleedRoot,
      columns: [BleedRoot.t.firstChildId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [BleedRoot] and [BleedChild]
  /// by setting the [BleedRoot]'s foreign key `secondChildId` to refer to the [BleedChild].
  Future<void> childRelationWithExtremelyLongFieldNameForcingTrun23(
    _i1.DatabaseSession session,
    BleedRoot bleedRoot,
    _i2.BleedChild childRelationWithExtremelyLongFieldNameForcingTrun23, {
    _i1.Transaction? transaction,
  }) async {
    if (bleedRoot.id == null) {
      throw ArgumentError.notNull('bleedRoot.id');
    }
    if (childRelationWithExtremelyLongFieldNameForcingTrun23.id == null) {
      throw ArgumentError.notNull(
        'childRelationWithExtremelyLongFieldNameForcingTrun23.id',
      );
    }

    var $bleedRoot = bleedRoot.copyWith(
      secondChildId: childRelationWithExtremelyLongFieldNameForcingTrun23.id,
    );
    await session.db.updateRow<BleedRoot>(
      $bleedRoot,
      columns: [BleedRoot.t.secondChildId],
      transaction: transaction,
    );
  }
}

class BleedRootDetachRowRepository {
  const BleedRootDetachRowRepository._();

  /// Detaches the relation between this [BleedRoot] and the [BleedChild] set in `childRelationWithExtremelyLongFieldNameForcingTrun24`
  /// by setting the [BleedRoot]'s foreign key `firstChildId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> childRelationWithExtremelyLongFieldNameForcingTrun24(
    _i1.DatabaseSession session,
    BleedRoot bleedRoot, {
    _i1.Transaction? transaction,
  }) async {
    if (bleedRoot.id == null) {
      throw ArgumentError.notNull('bleedRoot.id');
    }

    var $bleedRoot = bleedRoot.copyWith(firstChildId: null);
    await session.db.updateRow<BleedRoot>(
      $bleedRoot,
      columns: [BleedRoot.t.firstChildId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [BleedRoot] and the [BleedChild] set in `childRelationWithExtremelyLongFieldNameForcingTrun23`
  /// by setting the [BleedRoot]'s foreign key `secondChildId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> childRelationWithExtremelyLongFieldNameForcingTrun23(
    _i1.DatabaseSession session,
    BleedRoot bleedRoot, {
    _i1.Transaction? transaction,
  }) async {
    if (bleedRoot.id == null) {
      throw ArgumentError.notNull('bleedRoot.id');
    }

    var $bleedRoot = bleedRoot.copyWith(secondChildId: null);
    await session.db.updateRow<BleedRoot>(
      $bleedRoot,
      columns: [BleedRoot.t.secondChildId],
      transaction: transaction,
    );
  }
}
