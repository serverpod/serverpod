/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'test_enum_enhanced.dart' as _i2;
import 'test_enum_enhanced_by_name.dart' as _i3;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i4;

abstract class ObjectWithEnumEnhanced
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithEnumEnhanced._({
    this.id,
    required this.byIndex,
    this.nullableByIndex,
    required this.byIndexList,
    required this.byName,
    this.nullableByName,
    required this.byNameList,
  });

  factory ObjectWithEnumEnhanced({
    int? id,
    required _i2.TestEnumEnhanced byIndex,
    _i2.TestEnumEnhanced? nullableByIndex,
    required List<_i2.TestEnumEnhanced> byIndexList,
    required _i3.TestEnumEnhancedByName byName,
    _i3.TestEnumEnhancedByName? nullableByName,
    required List<_i3.TestEnumEnhancedByName> byNameList,
  }) = _ObjectWithEnumEnhancedImpl;

  factory ObjectWithEnumEnhanced.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithEnumEnhanced(
      id: jsonSerialization['id'] as int?,
      byIndex: _i2.TestEnumEnhanced.fromJson(
        (jsonSerialization['byIndex'] as int),
      ),
      nullableByIndex: jsonSerialization['nullableByIndex'] == null
          ? null
          : _i2.TestEnumEnhanced.fromJson(
              (jsonSerialization['nullableByIndex'] as int),
            ),
      byIndexList: _i4.Protocol().deserialize<List<_i2.TestEnumEnhanced>>(
        jsonSerialization['byIndexList'],
      ),
      byName: _i3.TestEnumEnhancedByName.fromJson(
        (jsonSerialization['byName'] as String),
      ),
      nullableByName: jsonSerialization['nullableByName'] == null
          ? null
          : _i3.TestEnumEnhancedByName.fromJson(
              (jsonSerialization['nullableByName'] as String),
            ),
      byNameList: _i4.Protocol().deserialize<List<_i3.TestEnumEnhancedByName>>(
        jsonSerialization['byNameList'],
      ),
    );
  }

  static final t = ObjectWithEnumEnhancedTable();

  static const db = ObjectWithEnumEnhancedRepository._();

  @override
  int? id;

  _i2.TestEnumEnhanced byIndex;

  _i2.TestEnumEnhanced? nullableByIndex;

  List<_i2.TestEnumEnhanced> byIndexList;

  _i3.TestEnumEnhancedByName byName;

  _i3.TestEnumEnhancedByName? nullableByName;

  List<_i3.TestEnumEnhancedByName> byNameList;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithEnumEnhanced copyWith({
    int? id,
    _i2.TestEnumEnhanced? byIndex,
    _i2.TestEnumEnhanced? nullableByIndex,
    List<_i2.TestEnumEnhanced>? byIndexList,
    _i3.TestEnumEnhancedByName? byName,
    _i3.TestEnumEnhancedByName? nullableByName,
    List<_i3.TestEnumEnhancedByName>? byNameList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  static ObjectWithEnumEnhancedInclude include() {
    return ObjectWithEnumEnhancedInclude._();
  }

  static ObjectWithEnumEnhancedIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    ObjectWithEnumEnhancedInclude? include,
  }) {
    return ObjectWithEnumEnhancedIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumEnhancedImpl extends ObjectWithEnumEnhanced {
  _ObjectWithEnumEnhancedImpl({
    int? id,
    required _i2.TestEnumEnhanced byIndex,
    _i2.TestEnumEnhanced? nullableByIndex,
    required List<_i2.TestEnumEnhanced> byIndexList,
    required _i3.TestEnumEnhancedByName byName,
    _i3.TestEnumEnhancedByName? nullableByName,
    required List<_i3.TestEnumEnhancedByName> byNameList,
  }) : super._(
         id: id,
         byIndex: byIndex,
         nullableByIndex: nullableByIndex,
         byIndexList: byIndexList,
         byName: byName,
         nullableByName: nullableByName,
         byNameList: byNameList,
       );

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithEnumEnhanced copyWith({
    Object? id = _Undefined,
    _i2.TestEnumEnhanced? byIndex,
    Object? nullableByIndex = _Undefined,
    List<_i2.TestEnumEnhanced>? byIndexList,
    _i3.TestEnumEnhancedByName? byName,
    Object? nullableByName = _Undefined,
    List<_i3.TestEnumEnhancedByName>? byNameList,
  }) {
    return ObjectWithEnumEnhanced(
      id: id is int? ? id : this.id,
      byIndex: byIndex ?? this.byIndex,
      nullableByIndex: nullableByIndex is _i2.TestEnumEnhanced?
          ? nullableByIndex
          : this.nullableByIndex,
      byIndexList: byIndexList ?? this.byIndexList.map((e0) => e0).toList(),
      byName: byName ?? this.byName,
      nullableByName: nullableByName is _i3.TestEnumEnhancedByName?
          ? nullableByName
          : this.nullableByName,
      byNameList: byNameList ?? this.byNameList.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithEnumEnhancedUpdateTable
    extends _i1.UpdateTable<ObjectWithEnumEnhancedTable> {
  ObjectWithEnumEnhancedUpdateTable(super.table);

  _i1.ColumnValue<_i2.TestEnumEnhanced, _i2.TestEnumEnhanced> byIndex(
    _i2.TestEnumEnhanced value,
  ) => _i1.ColumnValue(
    table.byIndex,
    value,
  );

  _i1.ColumnValue<_i2.TestEnumEnhanced, _i2.TestEnumEnhanced> nullableByIndex(
    _i2.TestEnumEnhanced? value,
  ) => _i1.ColumnValue(
    table.nullableByIndex,
    value,
  );

  _i1.ColumnValue<List<_i2.TestEnumEnhanced>, List<_i2.TestEnumEnhanced>>
  byIndexList(List<_i2.TestEnumEnhanced> value) => _i1.ColumnValue(
    table.byIndexList,
    value,
  );

  _i1.ColumnValue<_i3.TestEnumEnhancedByName, _i3.TestEnumEnhancedByName>
  byName(_i3.TestEnumEnhancedByName value) => _i1.ColumnValue(
    table.byName,
    value,
  );

  _i1.ColumnValue<_i3.TestEnumEnhancedByName, _i3.TestEnumEnhancedByName>
  nullableByName(_i3.TestEnumEnhancedByName? value) => _i1.ColumnValue(
    table.nullableByName,
    value,
  );

  _i1.ColumnValue<
    List<_i3.TestEnumEnhancedByName>,
    List<_i3.TestEnumEnhancedByName>
  >
  byNameList(List<_i3.TestEnumEnhancedByName> value) => _i1.ColumnValue(
    table.byNameList,
    value,
  );
}

class ObjectWithEnumEnhancedTable extends _i1.Table<int?> {
  ObjectWithEnumEnhancedTable({super.tableRelation})
    : super(tableName: 'object_with_enum_enhanced') {
    updateTable = ObjectWithEnumEnhancedUpdateTable(this);
    byIndex = _i1.ColumnEnum(
      'byIndex',
      this,
      _i1.EnumSerialization.byIndex,
    );
    nullableByIndex = _i1.ColumnEnum(
      'nullableByIndex',
      this,
      _i1.EnumSerialization.byIndex,
    );
    byIndexList = _i1.ColumnSerializable<List<_i2.TestEnumEnhanced>>(
      'byIndexList',
      this,
    );
    byName = _i1.ColumnEnum(
      'byName',
      this,
      _i1.EnumSerialization.byName,
    );
    nullableByName = _i1.ColumnEnum(
      'nullableByName',
      this,
      _i1.EnumSerialization.byName,
    );
    byNameList = _i1.ColumnSerializable<List<_i3.TestEnumEnhancedByName>>(
      'byNameList',
      this,
    );
  }

  late final ObjectWithEnumEnhancedUpdateTable updateTable;

  late final _i1.ColumnEnum<_i2.TestEnumEnhanced> byIndex;

  late final _i1.ColumnEnum<_i2.TestEnumEnhanced> nullableByIndex;

  late final _i1.ColumnSerializable<List<_i2.TestEnumEnhanced>> byIndexList;

  late final _i1.ColumnEnum<_i3.TestEnumEnhancedByName> byName;

  late final _i1.ColumnEnum<_i3.TestEnumEnhancedByName> nullableByName;

  late final _i1.ColumnSerializable<List<_i3.TestEnumEnhancedByName>>
  byNameList;

  @override
  List<_i1.Column> get columns => [
    id,
    byIndex,
    nullableByIndex,
    byIndexList,
    byName,
    nullableByName,
    byNameList,
  ];
}

class ObjectWithEnumEnhancedInclude extends _i1.IncludeObject {
  ObjectWithEnumEnhancedInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithEnumEnhanced.t;
}

class ObjectWithEnumEnhancedIncludeList extends _i1.IncludeList {
  ObjectWithEnumEnhancedIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithEnumEnhanced.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithEnumEnhanced.t;
}

class ObjectWithEnumEnhancedRepository {
  const ObjectWithEnumEnhancedRepository._();

  /// Returns a list of [ObjectWithEnumEnhanced]s matching the given query parameters.
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
  Future<List<ObjectWithEnumEnhanced>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithEnumEnhanced] matching the given query parameters.
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
  Future<ObjectWithEnumEnhanced?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithEnumEnhanced] by its [id] or null if no such row exists.
  Future<ObjectWithEnumEnhanced?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithEnumEnhanced>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithEnumEnhanced]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithEnumEnhanced]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithEnumEnhanced>> insert(
    _i1.Session session,
    List<ObjectWithEnumEnhanced> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithEnumEnhanced>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithEnumEnhanced] and returns the inserted row.
  ///
  /// The returned [ObjectWithEnumEnhanced] will have its `id` field set.
  Future<ObjectWithEnumEnhanced> insertRow(
    _i1.Session session,
    ObjectWithEnumEnhanced row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithEnumEnhanced>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnumEnhanced]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithEnumEnhanced>> update(
    _i1.Session session,
    List<ObjectWithEnumEnhanced> rows, {
    _i1.ColumnSelections<ObjectWithEnumEnhancedTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithEnumEnhanced>(
      rows,
      columns: columns?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithEnumEnhanced]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithEnumEnhanced> updateRow(
    _i1.Session session,
    ObjectWithEnumEnhanced row, {
    _i1.ColumnSelections<ObjectWithEnumEnhancedTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithEnumEnhanced>(
      row,
      columns: columns?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithEnumEnhanced] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithEnumEnhanced?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithEnumEnhancedUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithEnumEnhanced>(
      id,
      columnValues: columnValues(ObjectWithEnumEnhanced.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnumEnhanced]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithEnumEnhanced>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ObjectWithEnumEnhancedUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithEnumEnhanced>(
      columnValues: columnValues(ObjectWithEnumEnhanced.t.updateTable),
      where: where(ObjectWithEnumEnhanced.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithEnumEnhanced]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithEnumEnhanced>> delete(
    _i1.Session session,
    List<ObjectWithEnumEnhanced> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithEnumEnhanced>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithEnumEnhanced].
  Future<ObjectWithEnumEnhanced> deleteRow(
    _i1.Session session,
    ObjectWithEnumEnhanced row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithEnumEnhanced>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithEnumEnhanced>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithEnumEnhanced>(
      where: where(ObjectWithEnumEnhanced.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
