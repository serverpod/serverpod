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

abstract class SecretChallenge
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SecretChallenge._({
    this.id,
    required this.challengeCodeHash,
    required this.challengeCodeSalt,
  });

  factory SecretChallenge({
    _i1.UuidValue? id,
    required _i2.ByteData challengeCodeHash,
    required _i2.ByteData challengeCodeSalt,
  }) = _SecretChallengeImpl;

  factory SecretChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecretChallenge(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      challengeCodeHash: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['challengeCodeHash']),
      challengeCodeSalt: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['challengeCodeSalt']),
    );
  }

  static final t = SecretChallengeTable();

  static const db = SecretChallengeRepository._();

  @override
  _i1.UuidValue? id;

  /// The hash of the challenge code sent to the user.
  _i2.ByteData challengeCodeHash;

  /// The salt used to compute the [challengeCodeHash].
  _i2.ByteData challengeCodeSalt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SecretChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SecretChallenge copyWith({
    _i1.UuidValue? id,
    _i2.ByteData? challengeCodeHash,
    _i2.ByteData? challengeCodeSalt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'challengeCodeHash': challengeCodeHash.toJson(),
      'challengeCodeSalt': challengeCodeSalt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SecretChallengeInclude include() {
    return SecretChallengeInclude._();
  }

  static SecretChallengeIncludeList includeList({
    _i1.WhereExpressionBuilder<SecretChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecretChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecretChallengeTable>? orderByList,
    SecretChallengeInclude? include,
  }) {
    return SecretChallengeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecretChallenge.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SecretChallenge.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecretChallengeImpl extends SecretChallenge {
  _SecretChallengeImpl({
    _i1.UuidValue? id,
    required _i2.ByteData challengeCodeHash,
    required _i2.ByteData challengeCodeSalt,
  }) : super._(
          id: id,
          challengeCodeHash: challengeCodeHash,
          challengeCodeSalt: challengeCodeSalt,
        );

  /// Returns a shallow copy of this [SecretChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SecretChallenge copyWith({
    Object? id = _Undefined,
    _i2.ByteData? challengeCodeHash,
    _i2.ByteData? challengeCodeSalt,
  }) {
    return SecretChallenge(
      id: id is _i1.UuidValue? ? id : this.id,
      challengeCodeHash: challengeCodeHash ?? this.challengeCodeHash.clone(),
      challengeCodeSalt: challengeCodeSalt ?? this.challengeCodeSalt.clone(),
    );
  }
}

class SecretChallengeUpdateTable extends _i1.UpdateTable<SecretChallengeTable> {
  SecretChallengeUpdateTable(super.table);

  _i1.ColumnValue<_i2.ByteData, _i2.ByteData> challengeCodeHash(
          _i2.ByteData value) =>
      _i1.ColumnValue(
        table.challengeCodeHash,
        value,
      );

  _i1.ColumnValue<_i2.ByteData, _i2.ByteData> challengeCodeSalt(
          _i2.ByteData value) =>
      _i1.ColumnValue(
        table.challengeCodeSalt,
        value,
      );
}

class SecretChallengeTable extends _i1.Table<_i1.UuidValue?> {
  SecretChallengeTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_idp_secret_challenge') {
    updateTable = SecretChallengeUpdateTable(this);
    challengeCodeHash = _i1.ColumnByteData(
      'challengeCodeHash',
      this,
    );
    challengeCodeSalt = _i1.ColumnByteData(
      'challengeCodeSalt',
      this,
    );
  }

  late final SecretChallengeUpdateTable updateTable;

  /// The hash of the challenge code sent to the user.
  late final _i1.ColumnByteData challengeCodeHash;

  /// The salt used to compute the [challengeCodeHash].
  late final _i1.ColumnByteData challengeCodeSalt;

  @override
  List<_i1.Column> get columns => [
        id,
        challengeCodeHash,
        challengeCodeSalt,
      ];
}

class SecretChallengeInclude extends _i1.IncludeObject {
  SecretChallengeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SecretChallenge.t;
}

class SecretChallengeIncludeList extends _i1.IncludeList {
  SecretChallengeIncludeList._({
    _i1.WhereExpressionBuilder<SecretChallengeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SecretChallenge.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SecretChallenge.t;
}

class SecretChallengeRepository {
  const SecretChallengeRepository._();

  /// Returns a list of [SecretChallenge]s matching the given query parameters.
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
  Future<List<SecretChallenge>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecretChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecretChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecretChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SecretChallenge>(
      where: where?.call(SecretChallenge.t),
      orderBy: orderBy?.call(SecretChallenge.t),
      orderByList: orderByList?.call(SecretChallenge.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SecretChallenge] matching the given query parameters.
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
  Future<SecretChallenge?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecretChallengeTable>? where,
    int? offset,
    _i1.OrderByBuilder<SecretChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecretChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SecretChallenge>(
      where: where?.call(SecretChallenge.t),
      orderBy: orderBy?.call(SecretChallenge.t),
      orderByList: orderByList?.call(SecretChallenge.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SecretChallenge] by its [id] or null if no such row exists.
  Future<SecretChallenge?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SecretChallenge>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SecretChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [SecretChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SecretChallenge>> insert(
    _i1.Session session,
    List<SecretChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SecretChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SecretChallenge] and returns the inserted row.
  ///
  /// The returned [SecretChallenge] will have its `id` field set.
  Future<SecretChallenge> insertRow(
    _i1.Session session,
    SecretChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SecretChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SecretChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SecretChallenge>> update(
    _i1.Session session,
    List<SecretChallenge> rows, {
    _i1.ColumnSelections<SecretChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SecretChallenge>(
      rows,
      columns: columns?.call(SecretChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecretChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SecretChallenge> updateRow(
    _i1.Session session,
    SecretChallenge row, {
    _i1.ColumnSelections<SecretChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SecretChallenge>(
      row,
      columns: columns?.call(SecretChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecretChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SecretChallenge?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SecretChallengeUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SecretChallenge>(
      id,
      columnValues: columnValues(SecretChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SecretChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SecretChallenge>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SecretChallengeUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<SecretChallengeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecretChallengeTable>? orderBy,
    _i1.OrderByListBuilder<SecretChallengeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SecretChallenge>(
      columnValues: columnValues(SecretChallenge.t.updateTable),
      where: where(SecretChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecretChallenge.t),
      orderByList: orderByList?.call(SecretChallenge.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SecretChallenge]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SecretChallenge>> delete(
    _i1.Session session,
    List<SecretChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SecretChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SecretChallenge].
  Future<SecretChallenge> deleteRow(
    _i1.Session session,
    SecretChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SecretChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SecretChallenge>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SecretChallengeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SecretChallenge>(
      where: where(SecretChallenge.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecretChallengeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SecretChallenge>(
      where: where?.call(SecretChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
