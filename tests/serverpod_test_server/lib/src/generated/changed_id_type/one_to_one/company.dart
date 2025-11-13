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
import '../../changed_id_type/one_to_one/town.dart' as _i2;

abstract class CompanyUuid
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CompanyUuid._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory CompanyUuid({
    _i1.UuidValue? id,
    required String name,
    required int townId,
    _i2.TownInt? town,
  }) = _CompanyUuidImpl;

  factory CompanyUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CompanyUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization['town'] == null
          ? null
          : _i2.TownInt.fromJson(
              (jsonSerialization['town'] as Map<String, dynamic>),
            ),
    );
  }

  static final t = CompanyUuidTable();

  static const db = CompanyUuidRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  int townId;

  _i2.TownInt? town;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CompanyUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CompanyUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    int? townId,
    _i2.TownInt? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJsonForProtocol(),
    };
  }

  static CompanyUuidInclude include({_i2.TownIntInclude? town}) {
    return CompanyUuidInclude._(town: town);
  }

  static CompanyUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    CompanyUuidInclude? include,
  }) {
    return CompanyUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CompanyUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyUuidImpl extends CompanyUuid {
  _CompanyUuidImpl({
    _i1.UuidValue? id,
    required String name,
    required int townId,
    _i2.TownInt? town,
  }) : super._(
         id: id,
         name: name,
         townId: townId,
         town: town,
       );

  /// Returns a shallow copy of this [CompanyUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CompanyUuid copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return CompanyUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i2.TownInt? ? town : this.town?.copyWith(),
    );
  }
}

class CompanyUuidUpdateTable extends _i1.UpdateTable<CompanyUuidTable> {
  CompanyUuidUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> townId(int value) => _i1.ColumnValue(
    table.townId,
    value,
  );
}

class CompanyUuidTable extends _i1.Table<_i1.UuidValue?> {
  CompanyUuidTable({super.tableRelation}) : super(tableName: 'company_uuid') {
    updateTable = CompanyUuidUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    townId = _i1.ColumnInt(
      'townId',
      this,
    );
  }

  late final CompanyUuidUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt townId;

  _i2.TownIntTable? _town;

  _i2.TownIntTable get town {
    if (_town != null) return _town!;
    _town = _i1.createRelationTable(
      relationFieldName: 'town',
      field: CompanyUuid.t.townId,
      foreignField: _i2.TownInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TownIntTable(tableRelation: foreignTableRelation),
    );
    return _town!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    townId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'town') {
      return town;
    }
    return null;
  }
}

class CompanyUuidInclude extends _i1.IncludeObject {
  CompanyUuidInclude._({_i2.TownIntInclude? town}) {
    _town = town;
  }

  _i2.TownIntInclude? _town;

  @override
  Map<String, _i1.Include?> get includes => {'town': _town};

  @override
  _i1.Table<_i1.UuidValue?> get table => CompanyUuid.t;
}

class CompanyUuidIncludeList extends _i1.IncludeList {
  CompanyUuidIncludeList._({
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CompanyUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CompanyUuid.t;
}

class CompanyUuidRepository {
  const CompanyUuidRepository._();

  final attachRow = const CompanyUuidAttachRowRepository._();

  /// Returns a list of [CompanyUuid]s matching the given query parameters.
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
  Future<List<CompanyUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.find<CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      orderBy: orderBy?.call(CompanyUuid.t),
      orderByList: orderByList?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CompanyUuid] matching the given query parameters.
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
  Future<CompanyUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.findFirstRow<CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      orderBy: orderBy?.call(CompanyUuid.t),
      orderByList: orderByList?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CompanyUuid] by its [id] or null if no such row exists.
  Future<CompanyUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.findById<CompanyUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CompanyUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [CompanyUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CompanyUuid>> insert(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CompanyUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CompanyUuid] and returns the inserted row.
  ///
  /// The returned [CompanyUuid] will have its `id` field set.
  Future<CompanyUuid> insertRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CompanyUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CompanyUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CompanyUuid>> update(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.ColumnSelections<CompanyUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CompanyUuid>(
      rows,
      columns: columns?.call(CompanyUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CompanyUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CompanyUuid> updateRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.ColumnSelections<CompanyUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CompanyUuid>(
      row,
      columns: columns?.call(CompanyUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CompanyUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CompanyUuid?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CompanyUuidUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CompanyUuid>(
      id,
      columnValues: columnValues(CompanyUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CompanyUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CompanyUuid>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CompanyUuidUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CompanyUuidTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CompanyUuid>(
      columnValues: columnValues(CompanyUuid.t.updateTable),
      where: where(CompanyUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CompanyUuid.t),
      orderByList: orderByList?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CompanyUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CompanyUuid>> delete(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CompanyUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CompanyUuid].
  Future<CompanyUuid> deleteRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CompanyUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CompanyUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CompanyUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CompanyUuid>(
      where: where(CompanyUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CompanyUuidAttachRowRepository {
  const CompanyUuidAttachRowRepository._();

  /// Creates a relation between the given [CompanyUuid] and [TownInt]
  /// by setting the [CompanyUuid]'s foreign key `townId` to refer to the [TownInt].
  Future<void> town(
    _i1.Session session,
    CompanyUuid companyUuid,
    _i2.TownInt town, {
    _i1.Transaction? transaction,
  }) async {
    if (companyUuid.id == null) {
      throw ArgumentError.notNull('companyUuid.id');
    }
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $companyUuid = companyUuid.copyWith(townId: town.id);
    await session.db.updateRow<CompanyUuid>(
      $companyUuid,
      columns: [CompanyUuid.t.townId],
      transaction: transaction,
    );
  }
}
