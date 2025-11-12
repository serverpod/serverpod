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
import 'dart:typed_data' as _i2;

/// A challenge handed out for a subsequent Passkey registration or login.
abstract class PasskeyChallenge
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PasskeyChallenge._({
    this.id,
    DateTime? createdAt,
    required this.challenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PasskeyChallenge({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required _i2.ByteData challenge,
  }) = _PasskeyChallengeImpl;

  factory PasskeyChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasskeyChallenge(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      challenge: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['challenge'],
      ),
    );
  }

  static final t = PasskeyChallengeTable();

  static const db = PasskeyChallengeRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this challenge was created.
  DateTime createdAt;

  /// The actual challenge for the client
  _i2.ByteData challenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PasskeyChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasskeyChallenge copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    _i2.ByteData? challenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'challenge': challenge.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PasskeyChallengeInclude include() {
    return PasskeyChallengeInclude._();
  }

  static PasskeyChallengeIncludeList includeList({
    _i1.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    PasskeyChallengeInclude? include,
  }) {
    return PasskeyChallengeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PasskeyChallenge.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasskeyChallengeImpl extends PasskeyChallenge {
  _PasskeyChallengeImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required _i2.ByteData challenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         challenge: challenge,
       );

  /// Returns a shallow copy of this [PasskeyChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasskeyChallenge copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    _i2.ByteData? challenge,
  }) {
    return PasskeyChallenge(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      challenge: challenge ?? this.challenge.clone(),
    );
  }
}

class PasskeyChallengeUpdateTable
    extends _i1.UpdateTable<PasskeyChallengeTable> {
  PasskeyChallengeUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i2.ByteData, _i2.ByteData> challenge(_i2.ByteData value) =>
      _i1.ColumnValue(
        table.challenge,
        value,
      );
}

class PasskeyChallengeTable extends _i1.Table<_i1.UuidValue?> {
  PasskeyChallengeTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_passkey_challenge') {
    updateTable = PasskeyChallengeUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    challenge = _i1.ColumnByteData(
      'challenge',
      this,
    );
  }

  late final PasskeyChallengeUpdateTable updateTable;

  /// The time when this challenge was created.
  late final _i1.ColumnDateTime createdAt;

  /// The actual challenge for the client
  late final _i1.ColumnByteData challenge;

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    challenge,
  ];
}

class PasskeyChallengeInclude extends _i1.IncludeObject {
  PasskeyChallengeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasskeyChallenge.t;
}

class PasskeyChallengeIncludeList extends _i1.IncludeList {
  PasskeyChallengeIncludeList._({
    _i1.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PasskeyChallenge.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasskeyChallenge.t;
}

class PasskeyChallengeRepository {
  const PasskeyChallengeRepository._();

  /// Returns a list of [PasskeyChallenge]s matching the given query parameters.
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
  Future<List<PasskeyChallenge>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PasskeyChallenge] matching the given query parameters.
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
  Future<PasskeyChallenge?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? offset,
    _i1.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PasskeyChallenge] by its [id] or null if no such row exists.
  Future<PasskeyChallenge?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PasskeyChallenge>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PasskeyChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [PasskeyChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PasskeyChallenge>> insert(
    _i1.Session session,
    List<PasskeyChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PasskeyChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PasskeyChallenge] and returns the inserted row.
  ///
  /// The returned [PasskeyChallenge] will have its `id` field set.
  Future<PasskeyChallenge> insertRow(
    _i1.Session session,
    PasskeyChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PasskeyChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PasskeyChallenge>> update(
    _i1.Session session,
    List<PasskeyChallenge> rows, {
    _i1.ColumnSelections<PasskeyChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PasskeyChallenge>(
      rows,
      columns: columns?.call(PasskeyChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasskeyChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PasskeyChallenge> updateRow(
    _i1.Session session,
    PasskeyChallenge row, {
    _i1.ColumnSelections<PasskeyChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PasskeyChallenge>(
      row,
      columns: columns?.call(PasskeyChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasskeyChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PasskeyChallenge?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PasskeyChallengeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PasskeyChallenge>(
      id,
      columnValues: columnValues(PasskeyChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PasskeyChallenge>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PasskeyChallengeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PasskeyChallengeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _i1.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PasskeyChallenge>(
      columnValues: columnValues(PasskeyChallenge.t.updateTable),
      where: where(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PasskeyChallenge]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PasskeyChallenge>> delete(
    _i1.Session session,
    List<PasskeyChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PasskeyChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PasskeyChallenge].
  Future<PasskeyChallenge> deleteRow(
    _i1.Session session,
    PasskeyChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PasskeyChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PasskeyChallenge>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PasskeyChallengeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PasskeyChallenge>(
      where: where(PasskeyChallenge.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
