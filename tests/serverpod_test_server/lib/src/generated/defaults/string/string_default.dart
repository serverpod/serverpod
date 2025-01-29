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

abstract class StringDefault
    implements _i1.TableRow, _i1.ProtocolSerialization {
  StringDefault._({
    this.id,
    String? stringDefault,
    String? stringDefaultNull,
  })  : stringDefault = stringDefault ?? 'This is a default value',
        stringDefaultNull = stringDefaultNull ?? 'This is a default null value';

  factory StringDefault({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) = _StringDefaultImpl;

  factory StringDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefault(
      id: jsonSerialization['id'] as int?,
      stringDefault: jsonSerialization['stringDefault'] as String,
      stringDefaultNull: jsonSerialization['stringDefaultNull'] as String?,
    );
  }

  static final t = StringDefaultTable();

  static const db = StringDefaultRepository._();

  @override
  int? id;

  String stringDefault;

  String? stringDefaultNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefault copyWith({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  static StringDefaultInclude include() {
    return StringDefaultInclude._();
  }

  static StringDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    StringDefaultInclude? include,
  }) {
    return StringDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultImpl extends StringDefault {
  _StringDefaultImpl({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) : super._(
          id: id,
          stringDefault: stringDefault,
          stringDefaultNull: stringDefaultNull,
        );

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefault copyWith({
    Object? id = _Undefined,
    String? stringDefault,
    Object? stringDefaultNull = _Undefined,
  }) {
    return StringDefault(
      id: id is int? ? id : this.id,
      stringDefault: stringDefault ?? this.stringDefault,
      stringDefaultNull: stringDefaultNull is String?
          ? stringDefaultNull
          : this.stringDefaultNull,
    );
  }
}

class StringDefaultTable extends _i1.Table {
  StringDefaultTable({super.tableRelation})
      : super(tableName: 'string_default') {
    stringDefault = _i1.ColumnString(
      'stringDefault',
      this,
      hasDefault: true,
    );
    stringDefaultNull = _i1.ColumnString(
      'stringDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString stringDefault;

  late final _i1.ColumnString stringDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefault,
        stringDefaultNull,
      ];
}

class StringDefaultInclude extends _i1.IncludeObject {
  StringDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefault.t;
}

class StringDefaultIncludeList extends _i1.IncludeList {
  StringDefaultIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefault.t;
}

class StringDefaultRepository {
  const StringDefaultRepository._();

  /// Returns a list of [StringDefault]s matching the given query parameters.
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
  Future<List<StringDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [StringDefault] matching the given query parameters.
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
  Future<StringDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [StringDefault] by its [id] or null if no such row exists.
  Future<StringDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [StringDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StringDefault>> insert(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StringDefault] and returns the inserted row.
  ///
  /// The returned [StringDefault] will have its `id` field set.
  Future<StringDefault> insertRow(
    _i1.Session session,
    StringDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StringDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StringDefault>> update(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.ColumnSelections<StringDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefault>(
      rows,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefault> updateRow(
    _i1.Session session,
    StringDefault row, {
    _i1.ColumnSelections<StringDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefault>(
      row,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  /// Deletes all [StringDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StringDefault>> delete(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StringDefault].
  Future<StringDefault> deleteRow(
    _i1.Session session,
    StringDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StringDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefault>(
      where: where(StringDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefault>(
      where: where?.call(StringDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
