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

abstract class LegacyEmailPassword
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  LegacyEmailPassword._({
    this.id,
    required this.emailAccountId,
    this.emailAccount,
    required this.hash,
  });

  factory LegacyEmailPassword({
    _i1.UuidValue? id,
    required _i1.UuidValue emailAccountId,
    _i2.EmailAccount? emailAccount,
    required String hash,
  }) = _LegacyEmailPasswordImpl;

  factory LegacyEmailPassword.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegacyEmailPassword(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      emailAccountId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['emailAccountId']),
      emailAccount: jsonSerialization['emailAccount'] == null
          ? null
          : _i2.EmailAccount.fromJson(
              (jsonSerialization['emailAccount'] as Map<String, dynamic>)),
      hash: jsonSerialization['hash'] as String,
    );
  }

  static final t = LegacyEmailPasswordTable();

  static const db = LegacyEmailPasswordRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue emailAccountId;

  /// The [EmailAccount] this password could log in.
  _i2.EmailAccount? emailAccount;

  /// The hashed password of the user.
  ///
  /// As stored by the legacy `serverpod_auth`'s `EmailAuth` model.
  String hash;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LegacyEmailPassword]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyEmailPassword copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? emailAccountId,
    _i2.EmailAccount? emailAccount,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'emailAccountId': emailAccountId.toJson(),
      if (emailAccount != null) 'emailAccount': emailAccount?.toJson(),
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static LegacyEmailPasswordInclude include(
      {_i2.EmailAccountInclude? emailAccount}) {
    return LegacyEmailPasswordInclude._(emailAccount: emailAccount);
  }

  static LegacyEmailPasswordIncludeList includeList({
    _i1.WhereExpressionBuilder<LegacyEmailPasswordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyEmailPasswordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyEmailPasswordTable>? orderByList,
    LegacyEmailPasswordInclude? include,
  }) {
    return LegacyEmailPasswordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyEmailPassword.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegacyEmailPassword.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyEmailPasswordImpl extends LegacyEmailPassword {
  _LegacyEmailPasswordImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue emailAccountId,
    _i2.EmailAccount? emailAccount,
    required String hash,
  }) : super._(
          id: id,
          emailAccountId: emailAccountId,
          emailAccount: emailAccount,
          hash: hash,
        );

  /// Returns a shallow copy of this [LegacyEmailPassword]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyEmailPassword copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? emailAccountId,
    Object? emailAccount = _Undefined,
    String? hash,
  }) {
    return LegacyEmailPassword(
      id: id is _i1.UuidValue? ? id : this.id,
      emailAccountId: emailAccountId ?? this.emailAccountId,
      emailAccount: emailAccount is _i2.EmailAccount?
          ? emailAccount
          : this.emailAccount?.copyWith(),
      hash: hash ?? this.hash,
    );
  }
}

class LegacyEmailPasswordUpdateTable
    extends _i1.UpdateTable<LegacyEmailPasswordTable> {
  LegacyEmailPasswordUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> emailAccountId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.emailAccountId,
        value,
      );

  _i1.ColumnValue<String, String> hash(String value) => _i1.ColumnValue(
        table.hash,
        value,
      );
}

class LegacyEmailPasswordTable extends _i1.Table<_i1.UuidValue?> {
  LegacyEmailPasswordTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_bridge_email_password') {
    updateTable = LegacyEmailPasswordUpdateTable(this);
    emailAccountId = _i1.ColumnUuid(
      'emailAccountId',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
  }

  late final LegacyEmailPasswordUpdateTable updateTable;

  late final _i1.ColumnUuid emailAccountId;

  /// The [EmailAccount] this password could log in.
  _i2.EmailAccountTable? _emailAccount;

  /// The hashed password of the user.
  ///
  /// As stored by the legacy `serverpod_auth`'s `EmailAuth` model.
  late final _i1.ColumnString hash;

  _i2.EmailAccountTable get emailAccount {
    if (_emailAccount != null) return _emailAccount!;
    _emailAccount = _i1.createRelationTable(
      relationFieldName: 'emailAccount',
      field: LegacyEmailPassword.t.emailAccountId,
      foreignField: _i2.EmailAccount.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EmailAccountTable(tableRelation: foreignTableRelation),
    );
    return _emailAccount!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        emailAccountId,
        hash,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'emailAccount') {
      return emailAccount;
    }
    return null;
  }
}

class LegacyEmailPasswordInclude extends _i1.IncludeObject {
  LegacyEmailPasswordInclude._({_i2.EmailAccountInclude? emailAccount}) {
    _emailAccount = emailAccount;
  }

  _i2.EmailAccountInclude? _emailAccount;

  @override
  Map<String, _i1.Include?> get includes => {'emailAccount': _emailAccount};

  @override
  _i1.Table<_i1.UuidValue?> get table => LegacyEmailPassword.t;
}

class LegacyEmailPasswordIncludeList extends _i1.IncludeList {
  LegacyEmailPasswordIncludeList._({
    _i1.WhereExpressionBuilder<LegacyEmailPasswordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegacyEmailPassword.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => LegacyEmailPassword.t;
}

class LegacyEmailPasswordRepository {
  const LegacyEmailPasswordRepository._();

  final attachRow = const LegacyEmailPasswordAttachRowRepository._();

  /// Returns a list of [LegacyEmailPassword]s matching the given query parameters.
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
  Future<List<LegacyEmailPassword>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyEmailPasswordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyEmailPasswordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyEmailPasswordTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyEmailPasswordInclude? include,
  }) async {
    return session.db.find<LegacyEmailPassword>(
      where: where?.call(LegacyEmailPassword.t),
      orderBy: orderBy?.call(LegacyEmailPassword.t),
      orderByList: orderByList?.call(LegacyEmailPassword.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LegacyEmailPassword] matching the given query parameters.
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
  Future<LegacyEmailPassword?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyEmailPasswordTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegacyEmailPasswordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyEmailPasswordTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyEmailPasswordInclude? include,
  }) async {
    return session.db.findFirstRow<LegacyEmailPassword>(
      where: where?.call(LegacyEmailPassword.t),
      orderBy: orderBy?.call(LegacyEmailPassword.t),
      orderByList: orderByList?.call(LegacyEmailPassword.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LegacyEmailPassword] by its [id] or null if no such row exists.
  Future<LegacyEmailPassword?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    LegacyEmailPasswordInclude? include,
  }) async {
    return session.db.findById<LegacyEmailPassword>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LegacyEmailPassword]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacyEmailPassword]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegacyEmailPassword>> insert(
    _i1.Session session,
    List<LegacyEmailPassword> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegacyEmailPassword>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegacyEmailPassword] and returns the inserted row.
  ///
  /// The returned [LegacyEmailPassword] will have its `id` field set.
  Future<LegacyEmailPassword> insertRow(
    _i1.Session session,
    LegacyEmailPassword row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacyEmailPassword>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegacyEmailPassword]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegacyEmailPassword>> update(
    _i1.Session session,
    List<LegacyEmailPassword> rows, {
    _i1.ColumnSelections<LegacyEmailPasswordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegacyEmailPassword>(
      rows,
      columns: columns?.call(LegacyEmailPassword.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyEmailPassword]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacyEmailPassword> updateRow(
    _i1.Session session,
    LegacyEmailPassword row, {
    _i1.ColumnSelections<LegacyEmailPasswordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacyEmailPassword>(
      row,
      columns: columns?.call(LegacyEmailPassword.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyEmailPassword] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegacyEmailPassword?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<LegacyEmailPasswordUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LegacyEmailPassword>(
      id,
      columnValues: columnValues(LegacyEmailPassword.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegacyEmailPassword]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LegacyEmailPassword>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LegacyEmailPasswordUpdateTable>
        columnValues,
    required _i1.WhereExpressionBuilder<LegacyEmailPasswordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyEmailPasswordTable>? orderBy,
    _i1.OrderByListBuilder<LegacyEmailPasswordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LegacyEmailPassword>(
      columnValues: columnValues(LegacyEmailPassword.t.updateTable),
      where: where(LegacyEmailPassword.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyEmailPassword.t),
      orderByList: orderByList?.call(LegacyEmailPassword.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LegacyEmailPassword]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegacyEmailPassword>> delete(
    _i1.Session session,
    List<LegacyEmailPassword> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegacyEmailPassword>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegacyEmailPassword].
  Future<LegacyEmailPassword> deleteRow(
    _i1.Session session,
    LegacyEmailPassword row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacyEmailPassword>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegacyEmailPassword>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegacyEmailPasswordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegacyEmailPassword>(
      where: where(LegacyEmailPassword.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyEmailPasswordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegacyEmailPassword>(
      where: where?.call(LegacyEmailPassword.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LegacyEmailPasswordAttachRowRepository {
  const LegacyEmailPasswordAttachRowRepository._();

  /// Creates a relation between the given [LegacyEmailPassword] and [EmailAccount]
  /// by setting the [LegacyEmailPassword]'s foreign key `emailAccountId` to refer to the [EmailAccount].
  Future<void> emailAccount(
    _i1.Session session,
    LegacyEmailPassword legacyEmailPassword,
    _i2.EmailAccount emailAccount, {
    _i1.Transaction? transaction,
  }) async {
    if (legacyEmailPassword.id == null) {
      throw ArgumentError.notNull('legacyEmailPassword.id');
    }
    if (emailAccount.id == null) {
      throw ArgumentError.notNull('emailAccount.id');
    }

    var $legacyEmailPassword =
        legacyEmailPassword.copyWith(emailAccountId: emailAccount.id);
    await session.db.updateRow<LegacyEmailPassword>(
      $legacyEmailPassword,
      columns: [LegacyEmailPassword.t.emailAccountId],
      transaction: transaction,
    );
  }
}
