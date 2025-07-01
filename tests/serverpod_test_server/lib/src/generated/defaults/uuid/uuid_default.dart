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

abstract class UuidDefault
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UuidDefault._({
    this.id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  })  : uuidDefaultRandom = uuidDefaultRandom ?? _i1.Uuid().v4obj(),
        uuidDefaultRandomV7 = uuidDefaultRandomV7 ?? _i1.Uuid().v7obj(),
        uuidDefaultRandomNull = uuidDefaultRandomNull ?? _i1.Uuid().v4obj(),
        uuidDefaultStr = uuidDefaultStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultStrNull = uuidDefaultStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefault({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  }) = _UuidDefaultImpl;

  factory UuidDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefault(
      id: jsonSerialization['id'] as int?,
      uuidDefaultRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultRandom']),
      uuidDefaultRandomV7: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultRandomV7']),
      uuidDefaultRandomNull: jsonSerialization['uuidDefaultRandomNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomNull']),
      uuidDefaultStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultStr']),
      uuidDefaultStrNull: jsonSerialization['uuidDefaultStrNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStrNull']),
    );
  }

  static final t = UuidDefaultTable();

  static const db = UuidDefaultRepository._();

  @override
  int? id;

  _i1.UuidValue uuidDefaultRandom;

  _i1.UuidValue uuidDefaultRandomV7;

  _i1.UuidValue? uuidDefaultRandomNull;

  _i1.UuidValue uuidDefaultStr;

  _i1.UuidValue? uuidDefaultStrNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefault copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  static UuidDefaultInclude include() {
    return UuidDefaultInclude._();
  }

  static UuidDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    UuidDefaultInclude? include,
  }) {
    return UuidDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultImpl extends UuidDefault {
  _UuidDefaultImpl({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  }) : super._(
          id: id,
          uuidDefaultRandom: uuidDefaultRandom,
          uuidDefaultRandomV7: uuidDefaultRandomV7,
          uuidDefaultRandomNull: uuidDefaultRandomNull,
          uuidDefaultStr: uuidDefaultStr,
          uuidDefaultStrNull: uuidDefaultStrNull,
        );

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefault copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    Object? uuidDefaultRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultStr,
    Object? uuidDefaultStrNull = _Undefined,
  }) {
    return UuidDefault(
      id: id is int? ? id : this.id,
      uuidDefaultRandom: uuidDefaultRandom ?? this.uuidDefaultRandom,
      uuidDefaultRandomV7: uuidDefaultRandomV7 ?? this.uuidDefaultRandomV7,
      uuidDefaultRandomNull: uuidDefaultRandomNull is _i1.UuidValue?
          ? uuidDefaultRandomNull
          : this.uuidDefaultRandomNull,
      uuidDefaultStr: uuidDefaultStr ?? this.uuidDefaultStr,
      uuidDefaultStrNull: uuidDefaultStrNull is _i1.UuidValue?
          ? uuidDefaultStrNull
          : this.uuidDefaultStrNull,
    );
  }
}

class UuidDefaultTable extends _i1.Table<int?> {
  UuidDefaultTable({super.tableRelation}) : super(tableName: 'uuid_default') {
    uuidDefaultRandom = _i1.ColumnUuid(
      'uuidDefaultRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultRandomV7 = _i1.ColumnUuid(
      'uuidDefaultRandomV7',
      this,
      hasDefault: true,
    );
    uuidDefaultRandomNull = _i1.ColumnUuid(
      'uuidDefaultRandomNull',
      this,
      hasDefault: true,
    );
    uuidDefaultStr = _i1.ColumnUuid(
      'uuidDefaultStr',
      this,
      hasDefault: true,
    );
    uuidDefaultStrNull = _i1.ColumnUuid(
      'uuidDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid uuidDefaultRandom;

  late final _i1.ColumnUuid uuidDefaultRandomV7;

  late final _i1.ColumnUuid uuidDefaultRandomNull;

  late final _i1.ColumnUuid uuidDefaultStr;

  late final _i1.ColumnUuid uuidDefaultStrNull;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultRandom,
        uuidDefaultRandomV7,
        uuidDefaultRandomNull,
        uuidDefaultStr,
        uuidDefaultStrNull,
      ];
}

class UuidDefaultInclude extends _i1.IncludeObject {
  UuidDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UuidDefault.t;
}

class UuidDefaultIncludeList extends _i1.IncludeList {
  UuidDefaultIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UuidDefault.t;
}

class UuidDefaultRepository {
  const UuidDefaultRepository._();

  /// Returns a list of [UuidDefault]s matching the given query parameters.
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
  Future<List<UuidDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UuidDefault] matching the given query parameters.
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
  Future<UuidDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UuidDefault] by its [id] or null if no such row exists.
  Future<UuidDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UuidDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UuidDefault>> insert(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UuidDefault] and returns the inserted row.
  ///
  /// The returned [UuidDefault] will have its `id` field set.
  Future<UuidDefault> insertRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UuidDefault>> update(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.ColumnSelections<UuidDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefault>(
      rows,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefault> updateRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.ColumnSelections<UuidDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefault>(
      row,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UuidDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UuidDefault>> delete(
    _i1.Session session,
    List<UuidDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UuidDefault].
  Future<UuidDefault> deleteRow(
    _i1.Session session,
    UuidDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UuidDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefault>(
      where: where(UuidDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefault>(
      where: where?.call(UuidDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
