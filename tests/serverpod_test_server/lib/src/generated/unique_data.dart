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

abstract class UniqueData implements _i1.TableRow, _i1.ProtocolSerialization {
  UniqueData._({
    this.id,
    required this.number,
    required this.email,
  });

  factory UniqueData({
    int? id,
    required int number,
    required String email,
  }) = _UniqueDataImpl;

  factory UniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniqueData(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  static final t = UniqueDataTable();

  static const db = UniqueDataRepository._();

  @override
  int? id;

  int number;

  String email;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UniqueData copyWith({
    int? id,
    int? number,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  static UniqueDataInclude include() {
    return UniqueDataInclude._();
  }

  static UniqueDataIncludeList includeList({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    UniqueDataInclude? include,
  }) {
    return UniqueDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UniqueData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniqueDataImpl extends UniqueData {
  _UniqueDataImpl({
    int? id,
    required int number,
    required String email,
  }) : super._(
          id: id,
          number: number,
          email: email,
        );

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UniqueData copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
  }) {
    return UniqueData(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
    );
  }
}

class UniqueDataTable extends _i1.Table {
  UniqueDataTable({super.tableRelation}) : super(tableName: 'unique_data') {
    number = _i1.ColumnInt(
      'number',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
  }

  late final _i1.ColumnInt number;

  late final _i1.ColumnString email;

  @override
  List<_i1.Column> get columns => [
        id,
        number,
        email,
      ];
}

class UniqueDataInclude extends _i1.IncludeObject {
  UniqueDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UniqueData.t;
}

class UniqueDataIncludeList extends _i1.IncludeList {
  UniqueDataIncludeList._({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UniqueData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UniqueData.t;
}

class UniqueDataRepository {
  const UniqueDataRepository._();

  /// Returns a list of [UniqueData]s matching the given query parameters.
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
  Future<List<UniqueData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UniqueData] matching the given query parameters.
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
  Future<UniqueData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UniqueData] by its [id] or null if no such row exists.
  Future<UniqueData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UniqueData>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UniqueData]s in the list and returns the inserted rows.
  ///
  /// The returned [UniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UniqueData>> insert(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UniqueData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UniqueData] and returns the inserted row.
  ///
  /// The returned [UniqueData] will have its `id` field set.
  Future<UniqueData> insertRow(
    _i1.Session session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UniqueData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UniqueData>> update(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UniqueData>(
      rows,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UniqueData> updateRow(
    _i1.Session session,
    UniqueData row, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniqueData>(
      row,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UniqueData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UniqueData>> delete(
    _i1.Session session,
    List<UniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UniqueData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UniqueData].
  Future<UniqueData> deleteRow(
    _i1.Session session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UniqueData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UniqueDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UniqueData>(
      where: where(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UniqueData>(
      where: where?.call(UniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
