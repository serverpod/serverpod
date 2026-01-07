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
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i2;
import 'package:serverpod_auth_test_server/src/generated/protocol.dart' as _i3;

abstract class ChallengeTracker
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ChallengeTracker._({
    this.id,
    required this.secretChallengeId,
    this.secretChallenge,
    DateTime? trackedAt,
    this.notes,
  }) : trackedAt = trackedAt ?? DateTime.now();

  factory ChallengeTracker({
    int? id,
    required _i1.UuidValue secretChallengeId,
    _i2.SecretChallenge? secretChallenge,
    DateTime? trackedAt,
    String? notes,
  }) = _ChallengeTrackerImpl;

  factory ChallengeTracker.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChallengeTracker(
      id: jsonSerialization['id'] as int?,
      secretChallengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['secretChallengeId'],
      ),
      secretChallenge: jsonSerialization['secretChallenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['secretChallenge'],
            ),
      trackedAt: jsonSerialization['trackedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['trackedAt']),
      notes: jsonSerialization['notes'] as String?,
    );
  }

  static final t = ChallengeTrackerTable();

  static const db = ChallengeTrackerRepository._();

  @override
  int? id;

  _i1.UuidValue secretChallengeId;

  /// The [SecretChallenge] being tracked
  _i2.SecretChallenge? secretChallenge;

  /// Tracking timestamp
  DateTime trackedAt;

  /// Notes about the challenge
  String? notes;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChallengeTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChallengeTracker copyWith({
    int? id,
    _i1.UuidValue? secretChallengeId,
    _i2.SecretChallenge? secretChallenge,
    DateTime? trackedAt,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChallengeTracker',
      if (id != null) 'id': id,
      'secretChallengeId': secretChallengeId.toJson(),
      if (secretChallenge != null) 'secretChallenge': secretChallenge?.toJson(),
      'trackedAt': trackedAt.toJson(),
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ChallengeTrackerInclude include({
    _i2.SecretChallengeInclude? secretChallenge,
  }) {
    return ChallengeTrackerInclude._(secretChallenge: secretChallenge);
  }

  static ChallengeTrackerIncludeList includeList({
    _i1.WhereExpressionBuilder<ChallengeTrackerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChallengeTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChallengeTrackerTable>? orderByList,
    ChallengeTrackerInclude? include,
  }) {
    return ChallengeTrackerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChallengeTracker.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChallengeTracker.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChallengeTrackerImpl extends ChallengeTracker {
  _ChallengeTrackerImpl({
    int? id,
    required _i1.UuidValue secretChallengeId,
    _i2.SecretChallenge? secretChallenge,
    DateTime? trackedAt,
    String? notes,
  }) : super._(
         id: id,
         secretChallengeId: secretChallengeId,
         secretChallenge: secretChallenge,
         trackedAt: trackedAt,
         notes: notes,
       );

  /// Returns a shallow copy of this [ChallengeTracker]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChallengeTracker copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? secretChallengeId,
    Object? secretChallenge = _Undefined,
    DateTime? trackedAt,
    Object? notes = _Undefined,
  }) {
    return ChallengeTracker(
      id: id is int? ? id : this.id,
      secretChallengeId: secretChallengeId ?? this.secretChallengeId,
      secretChallenge: secretChallenge is _i2.SecretChallenge?
          ? secretChallenge
          : this.secretChallenge?.copyWith(),
      trackedAt: trackedAt ?? this.trackedAt,
      notes: notes is String? ? notes : this.notes,
    );
  }
}

class ChallengeTrackerUpdateTable
    extends _i1.UpdateTable<ChallengeTrackerTable> {
  ChallengeTrackerUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> secretChallengeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.secretChallengeId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> trackedAt(DateTime value) =>
      _i1.ColumnValue(
        table.trackedAt,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );
}

class ChallengeTrackerTable extends _i1.Table<int?> {
  ChallengeTrackerTable({super.tableRelation})
    : super(tableName: 'challenge_tracker') {
    updateTable = ChallengeTrackerUpdateTable(this);
    secretChallengeId = _i1.ColumnUuid(
      'secretChallengeId',
      this,
    );
    trackedAt = _i1.ColumnDateTime(
      'trackedAt',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
  }

  late final ChallengeTrackerUpdateTable updateTable;

  late final _i1.ColumnUuid secretChallengeId;

  /// The [SecretChallenge] being tracked
  _i2.SecretChallengeTable? _secretChallenge;

  /// Tracking timestamp
  late final _i1.ColumnDateTime trackedAt;

  /// Notes about the challenge
  late final _i1.ColumnString notes;

  _i2.SecretChallengeTable get secretChallenge {
    if (_secretChallenge != null) return _secretChallenge!;
    _secretChallenge = _i1.createRelationTable(
      relationFieldName: 'secretChallenge',
      field: ChallengeTracker.t.secretChallengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _secretChallenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    secretChallengeId,
    trackedAt,
    notes,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'secretChallenge') {
      return secretChallenge;
    }
    return null;
  }
}

class ChallengeTrackerInclude extends _i1.IncludeObject {
  ChallengeTrackerInclude._({_i2.SecretChallengeInclude? secretChallenge}) {
    _secretChallenge = secretChallenge;
  }

  _i2.SecretChallengeInclude? _secretChallenge;

  @override
  Map<String, _i1.Include?> get includes => {
    'secretChallenge': _secretChallenge,
  };

  @override
  _i1.Table<int?> get table => ChallengeTracker.t;
}

class ChallengeTrackerIncludeList extends _i1.IncludeList {
  ChallengeTrackerIncludeList._({
    _i1.WhereExpressionBuilder<ChallengeTrackerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChallengeTracker.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChallengeTracker.t;
}

class ChallengeTrackerRepository {
  const ChallengeTrackerRepository._();

  final attachRow = const ChallengeTrackerAttachRowRepository._();

  /// Returns a list of [ChallengeTracker]s matching the given query parameters.
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
  Future<List<ChallengeTracker>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChallengeTrackerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChallengeTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChallengeTrackerTable>? orderByList,
    _i1.Transaction? transaction,
    ChallengeTrackerInclude? include,
  }) async {
    return session.db.find<ChallengeTracker>(
      where: where?.call(ChallengeTracker.t),
      orderBy: orderBy?.call(ChallengeTracker.t),
      orderByList: orderByList?.call(ChallengeTracker.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ChallengeTracker] matching the given query parameters.
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
  Future<ChallengeTracker?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChallengeTrackerTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChallengeTrackerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChallengeTrackerTable>? orderByList,
    _i1.Transaction? transaction,
    ChallengeTrackerInclude? include,
  }) async {
    return session.db.findFirstRow<ChallengeTracker>(
      where: where?.call(ChallengeTracker.t),
      orderBy: orderBy?.call(ChallengeTracker.t),
      orderByList: orderByList?.call(ChallengeTracker.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ChallengeTracker] by its [id] or null if no such row exists.
  Future<ChallengeTracker?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ChallengeTrackerInclude? include,
  }) async {
    return session.db.findById<ChallengeTracker>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ChallengeTracker]s in the list and returns the inserted rows.
  ///
  /// The returned [ChallengeTracker]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChallengeTracker>> insert(
    _i1.Session session,
    List<ChallengeTracker> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChallengeTracker>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChallengeTracker] and returns the inserted row.
  ///
  /// The returned [ChallengeTracker] will have its `id` field set.
  Future<ChallengeTracker> insertRow(
    _i1.Session session,
    ChallengeTracker row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChallengeTracker>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChallengeTracker]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChallengeTracker>> update(
    _i1.Session session,
    List<ChallengeTracker> rows, {
    _i1.ColumnSelections<ChallengeTrackerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChallengeTracker>(
      rows,
      columns: columns?.call(ChallengeTracker.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChallengeTracker]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChallengeTracker> updateRow(
    _i1.Session session,
    ChallengeTracker row, {
    _i1.ColumnSelections<ChallengeTrackerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChallengeTracker>(
      row,
      columns: columns?.call(ChallengeTracker.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChallengeTracker] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChallengeTracker?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChallengeTrackerUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChallengeTracker>(
      id,
      columnValues: columnValues(ChallengeTracker.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChallengeTracker]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChallengeTracker>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChallengeTrackerUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ChallengeTrackerTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChallengeTrackerTable>? orderBy,
    _i1.OrderByListBuilder<ChallengeTrackerTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChallengeTracker>(
      columnValues: columnValues(ChallengeTracker.t.updateTable),
      where: where(ChallengeTracker.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChallengeTracker.t),
      orderByList: orderByList?.call(ChallengeTracker.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChallengeTracker]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChallengeTracker>> delete(
    _i1.Session session,
    List<ChallengeTracker> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChallengeTracker>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChallengeTracker].
  Future<ChallengeTracker> deleteRow(
    _i1.Session session,
    ChallengeTracker row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChallengeTracker>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChallengeTracker>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChallengeTrackerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChallengeTracker>(
      where: where(ChallengeTracker.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChallengeTrackerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChallengeTracker>(
      where: where?.call(ChallengeTracker.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChallengeTrackerAttachRowRepository {
  const ChallengeTrackerAttachRowRepository._();

  /// Creates a relation between the given [ChallengeTracker] and [SecretChallenge]
  /// by setting the [ChallengeTracker]'s foreign key `secretChallengeId` to refer to the [SecretChallenge].
  Future<void> secretChallenge(
    _i1.Session session,
    ChallengeTracker challengeTracker,
    _i2.SecretChallenge secretChallenge, {
    _i1.Transaction? transaction,
  }) async {
    if (challengeTracker.id == null) {
      throw ArgumentError.notNull('challengeTracker.id');
    }
    if (secretChallenge.id == null) {
      throw ArgumentError.notNull('secretChallenge.id');
    }

    var $challengeTracker = challengeTracker.copyWith(
      secretChallengeId: secretChallenge.id,
    );
    await session.db.updateRow<ChallengeTracker>(
      $challengeTracker,
      columns: [ChallengeTracker.t.secretChallengeId],
      transaction: transaction,
    );
  }
}
