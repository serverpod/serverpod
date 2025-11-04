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

abstract class EmailAccountChallenge
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountChallenge._({
    this.id,
    required this.challengeCodeHash,
    required this.challengeCodeSalt,
  });

  factory EmailAccountChallenge({
    _i1.UuidValue? id,
    required _i2.ByteData challengeCodeHash,
    required _i2.ByteData challengeCodeSalt,
  }) = _EmailAccountChallengeImpl;

  factory EmailAccountChallenge.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountChallenge(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      challengeCodeHash: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['challengeCodeHash']),
      challengeCodeSalt: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['challengeCodeSalt']),
    );
  }

  static final t = EmailAccountChallengeTable();

  static const db = EmailAccountChallengeRepository._();

  @override
  _i1.UuidValue? id;

  /// The hash of the challenge code sent to the user.
  _i2.ByteData challengeCodeHash;

  /// The salt used to compute the [challengeCodeHash].
  _i2.ByteData challengeCodeSalt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountChallenge copyWith({
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

  static EmailAccountChallengeInclude include() {
    return EmailAccountChallengeInclude._();
  }

  static EmailAccountChallengeIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountChallengeTable>? orderByList,
    EmailAccountChallengeInclude? include,
  }) {
    return EmailAccountChallengeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountChallenge.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountChallenge.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountChallengeImpl extends EmailAccountChallenge {
  _EmailAccountChallengeImpl({
    _i1.UuidValue? id,
    required _i2.ByteData challengeCodeHash,
    required _i2.ByteData challengeCodeSalt,
  }) : super._(
          id: id,
          challengeCodeHash: challengeCodeHash,
          challengeCodeSalt: challengeCodeSalt,
        );

  /// Returns a shallow copy of this [EmailAccountChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountChallenge copyWith({
    Object? id = _Undefined,
    _i2.ByteData? challengeCodeHash,
    _i2.ByteData? challengeCodeSalt,
  }) {
    return EmailAccountChallenge(
      id: id is _i1.UuidValue? ? id : this.id,
      challengeCodeHash: challengeCodeHash ?? this.challengeCodeHash.clone(),
      challengeCodeSalt: challengeCodeSalt ?? this.challengeCodeSalt.clone(),
    );
  }
}

class EmailAccountChallengeUpdateTable
    extends _i1.UpdateTable<EmailAccountChallengeTable> {
  EmailAccountChallengeUpdateTable(super.table);

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

class EmailAccountChallengeTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountChallengeTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_idp_email_account_challenge') {
    updateTable = EmailAccountChallengeUpdateTable(this);
    challengeCodeHash = _i1.ColumnByteData(
      'challengeCodeHash',
      this,
    );
    challengeCodeSalt = _i1.ColumnByteData(
      'challengeCodeSalt',
      this,
    );
  }

  late final EmailAccountChallengeUpdateTable updateTable;

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

class EmailAccountChallengeInclude extends _i1.IncludeObject {
  EmailAccountChallengeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountChallenge.t;
}

class EmailAccountChallengeIncludeList extends _i1.IncludeList {
  EmailAccountChallengeIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountChallengeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountChallenge.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountChallenge.t;
}

class EmailAccountChallengeRepository {
  const EmailAccountChallengeRepository._();

  /// Returns a list of [EmailAccountChallenge]s matching the given query parameters.
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
  Future<List<EmailAccountChallenge>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountChallenge>(
      where: where?.call(EmailAccountChallenge.t),
      orderBy: orderBy?.call(EmailAccountChallenge.t),
      orderByList: orderByList?.call(EmailAccountChallenge.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountChallenge] matching the given query parameters.
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
  Future<EmailAccountChallenge?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountChallengeTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountChallenge>(
      where: where?.call(EmailAccountChallenge.t),
      orderBy: orderBy?.call(EmailAccountChallenge.t),
      orderByList: orderByList?.call(EmailAccountChallenge.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountChallenge] by its [id] or null if no such row exists.
  Future<EmailAccountChallenge?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountChallenge>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountChallenge>> insert(
    _i1.Session session,
    List<EmailAccountChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountChallenge] and returns the inserted row.
  ///
  /// The returned [EmailAccountChallenge] will have its `id` field set.
  Future<EmailAccountChallenge> insertRow(
    _i1.Session session,
    EmailAccountChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountChallenge>> update(
    _i1.Session session,
    List<EmailAccountChallenge> rows, {
    _i1.ColumnSelections<EmailAccountChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountChallenge>(
      rows,
      columns: columns?.call(EmailAccountChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountChallenge> updateRow(
    _i1.Session session,
    EmailAccountChallenge row, {
    _i1.ColumnSelections<EmailAccountChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountChallenge>(
      row,
      columns: columns?.call(EmailAccountChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountChallenge?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EmailAccountChallengeUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountChallenge>(
      id,
      columnValues: columnValues(EmailAccountChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailAccountChallenge>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EmailAccountChallengeUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<EmailAccountChallengeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountChallengeTable>? orderBy,
    _i1.OrderByListBuilder<EmailAccountChallengeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailAccountChallenge>(
      columnValues: columnValues(EmailAccountChallenge.t.updateTable),
      where: where(EmailAccountChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountChallenge.t),
      orderByList: orderByList?.call(EmailAccountChallenge.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountChallenge]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountChallenge>> delete(
    _i1.Session session,
    List<EmailAccountChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountChallenge].
  Future<EmailAccountChallenge> deleteRow(
    _i1.Session session,
    EmailAccountChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountChallenge>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountChallengeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountChallenge>(
      where: where(EmailAccountChallenge.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountChallengeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountChallenge>(
      where: where?.call(EmailAccountChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
