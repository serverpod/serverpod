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
import '../../../common/secret_challenge/models/secret_challenge.dart' as _i2;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// Pending passwordless login request.
abstract class GenericPasswordlessLoginRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  GenericPasswordlessLoginRequest._({
    this.id,
    DateTime? createdAt,
    required this.handle,
    required this.challengeId,
    this.challenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory GenericPasswordlessLoginRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String handle,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
  }) = _GenericPasswordlessLoginRequestImpl;

  factory GenericPasswordlessLoginRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GenericPasswordlessLoginRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      handle: jsonSerialization['handle'] as String,
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
    );
  }

  static final t = GenericPasswordlessLoginRequestTable();

  static const db = GenericPasswordlessLoginRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// Serialized login handle for this pending request (e.g., email), a hash
  /// (e.g., phoneHash), or any other deterministic value the provider can
  /// resolve to an auth user.
  String handle;

  _i1.UuidValue challengeId;

  /// The single verification challenge for this request.
  _i2.SecretChallenge? challenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [GenericPasswordlessLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GenericPasswordlessLoginRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? handle,
    _i1.UuidValue? challengeId,
    _i2.SecretChallenge? challenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.GenericPasswordlessLoginRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'handle': handle,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static GenericPasswordlessLoginRequestInclude include({
    _i2.SecretChallengeInclude? challenge,
  }) {
    return GenericPasswordlessLoginRequestInclude._(challenge: challenge);
  }

  static GenericPasswordlessLoginRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GenericPasswordlessLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GenericPasswordlessLoginRequestTable>? orderByList,
    GenericPasswordlessLoginRequestInclude? include,
  }) {
    return GenericPasswordlessLoginRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GenericPasswordlessLoginRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GenericPasswordlessLoginRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GenericPasswordlessLoginRequestImpl
    extends GenericPasswordlessLoginRequest {
  _GenericPasswordlessLoginRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String handle,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         handle: handle,
         challengeId: challengeId,
         challenge: challenge,
       );

  /// Returns a shallow copy of this [GenericPasswordlessLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GenericPasswordlessLoginRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? handle,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
  }) {
    return GenericPasswordlessLoginRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      handle: handle ?? this.handle,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i2.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
    );
  }
}

class GenericPasswordlessLoginRequestUpdateTable
    extends _i1.UpdateTable<GenericPasswordlessLoginRequestTable> {
  GenericPasswordlessLoginRequestUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> handle(String value) => _i1.ColumnValue(
    table.handle,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> challengeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.challengeId,
    value,
  );
}

class GenericPasswordlessLoginRequestTable extends _i1.Table<_i1.UuidValue?> {
  GenericPasswordlessLoginRequestTable({super.tableRelation})
    : super(
        tableName: 'serverpod_auth_idp_generic_passwordless_login_request',
      ) {
    updateTable = GenericPasswordlessLoginRequestUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    handle = _i1.ColumnString(
      'handle',
      this,
    );
    challengeId = _i1.ColumnUuid(
      'challengeId',
      this,
    );
  }

  late final GenericPasswordlessLoginRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _i1.ColumnDateTime createdAt;

  /// Serialized login handle for this pending request (e.g., email), a hash
  /// (e.g., phoneHash), or any other deterministic value the provider can
  /// resolve to an auth user.
  late final _i1.ColumnString handle;

  late final _i1.ColumnUuid challengeId;

  /// The single verification challenge for this request.
  _i2.SecretChallengeTable? _challenge;

  _i2.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: GenericPasswordlessLoginRequest.t.challengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    handle,
    challengeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    return null;
  }
}

class GenericPasswordlessLoginRequestInclude extends _i1.IncludeObject {
  GenericPasswordlessLoginRequestInclude._({
    _i2.SecretChallengeInclude? challenge,
  }) {
    _challenge = challenge;
  }

  _i2.SecretChallengeInclude? _challenge;

  @override
  Map<String, _i1.Include?> get includes => {'challenge': _challenge};

  @override
  _i1.Table<_i1.UuidValue?> get table => GenericPasswordlessLoginRequest.t;
}

class GenericPasswordlessLoginRequestIncludeList extends _i1.IncludeList {
  GenericPasswordlessLoginRequestIncludeList._({
    _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GenericPasswordlessLoginRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => GenericPasswordlessLoginRequest.t;
}

class GenericPasswordlessLoginRequestRepository {
  const GenericPasswordlessLoginRequestRepository._();

  final attachRow =
      const GenericPasswordlessLoginRequestAttachRowRepository._();

  /// Returns a list of [GenericPasswordlessLoginRequest]s matching the given query parameters.
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
  Future<List<GenericPasswordlessLoginRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GenericPasswordlessLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GenericPasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    GenericPasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GenericPasswordlessLoginRequest>(
      where: where?.call(GenericPasswordlessLoginRequest.t),
      orderBy: orderBy?.call(GenericPasswordlessLoginRequest.t),
      orderByList: orderByList?.call(GenericPasswordlessLoginRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GenericPasswordlessLoginRequest] matching the given query parameters.
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
  Future<GenericPasswordlessLoginRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<GenericPasswordlessLoginRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GenericPasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    GenericPasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GenericPasswordlessLoginRequest>(
      where: where?.call(GenericPasswordlessLoginRequest.t),
      orderBy: orderBy?.call(GenericPasswordlessLoginRequest.t),
      orderByList: orderByList?.call(GenericPasswordlessLoginRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GenericPasswordlessLoginRequest] by its [id] or null if no such row exists.
  Future<GenericPasswordlessLoginRequest?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    GenericPasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GenericPasswordlessLoginRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GenericPasswordlessLoginRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [GenericPasswordlessLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<GenericPasswordlessLoginRequest>> insert(
    _i1.DatabaseSession session,
    List<GenericPasswordlessLoginRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<GenericPasswordlessLoginRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [GenericPasswordlessLoginRequest] and returns the inserted row.
  ///
  /// The returned [GenericPasswordlessLoginRequest] will have its `id` field set.
  Future<GenericPasswordlessLoginRequest> insertRow(
    _i1.DatabaseSession session,
    GenericPasswordlessLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GenericPasswordlessLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GenericPasswordlessLoginRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GenericPasswordlessLoginRequest>> update(
    _i1.DatabaseSession session,
    List<GenericPasswordlessLoginRequest> rows, {
    _i1.ColumnSelections<GenericPasswordlessLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GenericPasswordlessLoginRequest>(
      rows,
      columns: columns?.call(GenericPasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GenericPasswordlessLoginRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GenericPasswordlessLoginRequest> updateRow(
    _i1.DatabaseSession session,
    GenericPasswordlessLoginRequest row, {
    _i1.ColumnSelections<GenericPasswordlessLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GenericPasswordlessLoginRequest>(
      row,
      columns: columns?.call(GenericPasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GenericPasswordlessLoginRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GenericPasswordlessLoginRequest?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<
      GenericPasswordlessLoginRequestUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GenericPasswordlessLoginRequest>(
      id,
      columnValues: columnValues(GenericPasswordlessLoginRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GenericPasswordlessLoginRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GenericPasswordlessLoginRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      GenericPasswordlessLoginRequestUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GenericPasswordlessLoginRequestTable>? orderBy,
    _i1.OrderByListBuilder<GenericPasswordlessLoginRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GenericPasswordlessLoginRequest>(
      columnValues: columnValues(GenericPasswordlessLoginRequest.t.updateTable),
      where: where(GenericPasswordlessLoginRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GenericPasswordlessLoginRequest.t),
      orderByList: orderByList?.call(GenericPasswordlessLoginRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GenericPasswordlessLoginRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GenericPasswordlessLoginRequest>> delete(
    _i1.DatabaseSession session,
    List<GenericPasswordlessLoginRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GenericPasswordlessLoginRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GenericPasswordlessLoginRequest].
  Future<GenericPasswordlessLoginRequest> deleteRow(
    _i1.DatabaseSession session,
    GenericPasswordlessLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GenericPasswordlessLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GenericPasswordlessLoginRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GenericPasswordlessLoginRequest>(
      where: where(GenericPasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GenericPasswordlessLoginRequest>(
      where: where?.call(GenericPasswordlessLoginRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GenericPasswordlessLoginRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GenericPasswordlessLoginRequestTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GenericPasswordlessLoginRequest>(
      where: where(GenericPasswordlessLoginRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GenericPasswordlessLoginRequestAttachRowRepository {
  const GenericPasswordlessLoginRequestAttachRowRepository._();

  /// Creates a relation between the given [GenericPasswordlessLoginRequest] and [SecretChallenge]
  /// by setting the [GenericPasswordlessLoginRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.DatabaseSession session,
    GenericPasswordlessLoginRequest genericPasswordlessLoginRequest,
    _i2.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (genericPasswordlessLoginRequest.id == null) {
      throw ArgumentError.notNull('genericPasswordlessLoginRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $genericPasswordlessLoginRequest = genericPasswordlessLoginRequest
        .copyWith(challengeId: challenge.id);
    await session.db.updateRow<GenericPasswordlessLoginRequest>(
      $genericPasswordlessLoginRequest,
      columns: [GenericPasswordlessLoginRequest.t.challengeId],
      transaction: transaction,
    );
  }
}
