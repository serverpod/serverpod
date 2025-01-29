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

abstract class UuidDefaultPersist
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UuidDefaultPersist._({
    this.id,
    this.uuidDefaultPersistRandom,
    this.uuidDefaultPersistStr,
  });

  factory UuidDefaultPersist({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) = _UuidDefaultPersistImpl;

  factory UuidDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uuidDefaultPersistRandom:
          jsonSerialization['uuidDefaultPersistRandom'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultPersistRandom']),
      uuidDefaultPersistStr: jsonSerialization['uuidDefaultPersistStr'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistStr']),
    );
  }

  static final t = UuidDefaultPersistTable();

  static const db = UuidDefaultPersistRepository._();

  @override
  int? id;

  _i1.UuidValue? uuidDefaultPersistRandom;

  _i1.UuidValue? uuidDefaultPersistStr;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultPersist copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  static UuidDefaultPersistInclude include() {
    return UuidDefaultPersistInclude._();
  }

  static UuidDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    UuidDefaultPersistInclude? include,
  }) {
    return UuidDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultPersistImpl extends UuidDefaultPersist {
  _UuidDefaultPersistImpl({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) : super._(
          id: id,
          uuidDefaultPersistRandom: uuidDefaultPersistRandom,
          uuidDefaultPersistStr: uuidDefaultPersistStr,
        );

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uuidDefaultPersistRandom = _Undefined,
    Object? uuidDefaultPersistStr = _Undefined,
  }) {
    return UuidDefaultPersist(
      id: id is int? ? id : this.id,
      uuidDefaultPersistRandom: uuidDefaultPersistRandom is _i1.UuidValue?
          ? uuidDefaultPersistRandom
          : this.uuidDefaultPersistRandom,
      uuidDefaultPersistStr: uuidDefaultPersistStr is _i1.UuidValue?
          ? uuidDefaultPersistStr
          : this.uuidDefaultPersistStr,
    );
  }
}

class UuidDefaultPersistTable extends _i1.Table {
  UuidDefaultPersistTable({super.tableRelation})
      : super(tableName: 'uuid_default_persist') {
    uuidDefaultPersistRandom = _i1.ColumnUuid(
      'uuidDefaultPersistRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultPersistStr = _i1.ColumnUuid(
      'uuidDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnUuid uuidDefaultPersistRandom;

  late final _i1.ColumnUuid uuidDefaultPersistStr;

  @override
  List<_i1.Column> get columns => [
        id,
        uuidDefaultPersistRandom,
        uuidDefaultPersistStr,
      ];
}

class UuidDefaultPersistInclude extends _i1.IncludeObject {
  UuidDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistIncludeList extends _i1.IncludeList {
  UuidDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UuidDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistRepository {
  const UuidDefaultPersistRepository._();

  /// Returns a list of [UuidDefaultPersist]s matching the given query parameters.
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
  Future<List<UuidDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UuidDefaultPersist] matching the given query parameters.
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
  Future<UuidDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UuidDefaultPersist] by its [id] or null if no such row exists.
  Future<UuidDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UuidDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UuidDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UuidDefaultPersist>> insert(
    _i1.Session session,
    List<UuidDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UuidDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UuidDefaultPersist] and returns the inserted row.
  ///
  /// The returned [UuidDefaultPersist] will have its `id` field set.
  Future<UuidDefaultPersist> insertRow(
    _i1.Session session,
    UuidDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UuidDefaultPersist>> update(
    _i1.Session session,
    List<UuidDefaultPersist> rows, {
    _i1.ColumnSelections<UuidDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UuidDefaultPersist>(
      rows,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefaultPersist> updateRow(
    _i1.Session session,
    UuidDefaultPersist row, {
    _i1.ColumnSelections<UuidDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultPersist>(
      row,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UuidDefaultPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UuidDefaultPersist>> delete(
    _i1.Session session,
    List<UuidDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UuidDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UuidDefaultPersist].
  Future<UuidDefaultPersist> deleteRow(
    _i1.Session session,
    UuidDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UuidDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UuidDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UuidDefaultPersist>(
      where: where(UuidDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
