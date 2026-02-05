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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i2;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// Hash-only phone ID storage.
///
/// Stores only the hash of the phone number for privacy.
/// The original phone number cannot be recovered.
abstract class SmsPhoneIdHash
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsPhoneIdHash._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.phoneHash,
  });

  factory SmsPhoneIdHash({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
  }) = _SmsPhoneIdHashImpl;

  factory SmsPhoneIdHash.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsPhoneIdHash(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      phoneHash: jsonSerialization['phoneHash'] as String,
    );
  }

  static final t = SmsPhoneIdHashTable();

  static const db = SmsPhoneIdHashRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this phone belongs to
  _i2.AuthUser? authUser;

  /// The hash of the phone number.
  String phoneHash;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsPhoneIdHash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsPhoneIdHash copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? phoneHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsPhoneIdHash',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'phoneHash': phoneHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsPhoneIdHashInclude include({_i2.AuthUserInclude? authUser}) {
    return SmsPhoneIdHashInclude._(authUser: authUser);
  }

  static SmsPhoneIdHashIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsPhoneIdHashTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdHashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdHashTable>? orderByList,
    SmsPhoneIdHashInclude? include,
  }) {
    return SmsPhoneIdHashIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsPhoneIdHash.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsPhoneIdHash.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsPhoneIdHashImpl extends SmsPhoneIdHash {
  _SmsPhoneIdHashImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         phoneHash: phoneHash,
       );

  /// Returns a shallow copy of this [SmsPhoneIdHash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsPhoneIdHash copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? phoneHash,
  }) {
    return SmsPhoneIdHash(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      phoneHash: phoneHash ?? this.phoneHash,
    );
  }
}

class SmsPhoneIdHashUpdateTable extends _i1.UpdateTable<SmsPhoneIdHashTable> {
  SmsPhoneIdHashUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> phoneHash(String value) => _i1.ColumnValue(
    table.phoneHash,
    value,
  );
}

class SmsPhoneIdHashTable extends _i1.Table<_i1.UuidValue?> {
  SmsPhoneIdHashTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_phone_id_hash') {
    updateTable = SmsPhoneIdHashUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    phoneHash = _i1.ColumnString(
      'phoneHash',
      this,
    );
  }

  late final SmsPhoneIdHashUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this phone belongs to
  _i2.AuthUserTable? _authUser;

  /// The hash of the phone number.
  late final _i1.ColumnString phoneHash;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: SmsPhoneIdHash.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    phoneHash,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class SmsPhoneIdHashInclude extends _i1.IncludeObject {
  SmsPhoneIdHashInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsPhoneIdHash.t;
}

class SmsPhoneIdHashIncludeList extends _i1.IncludeList {
  SmsPhoneIdHashIncludeList._({
    _i1.WhereExpressionBuilder<SmsPhoneIdHashTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsPhoneIdHash.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsPhoneIdHash.t;
}

class SmsPhoneIdHashRepository {
  const SmsPhoneIdHashRepository._();

  final attachRow = const SmsPhoneIdHashAttachRowRepository._();

  /// Returns a list of [SmsPhoneIdHash]s matching the given query parameters.
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
  Future<List<SmsPhoneIdHash>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdHashTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdHashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdHashTable>? orderByList,
    _i1.Transaction? transaction,
    SmsPhoneIdHashInclude? include,
  }) async {
    return session.db.find<SmsPhoneIdHash>(
      where: where?.call(SmsPhoneIdHash.t),
      orderBy: orderBy?.call(SmsPhoneIdHash.t),
      orderByList: orderByList?.call(SmsPhoneIdHash.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsPhoneIdHash] matching the given query parameters.
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
  Future<SmsPhoneIdHash?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdHashTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdHashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdHashTable>? orderByList,
    _i1.Transaction? transaction,
    SmsPhoneIdHashInclude? include,
  }) async {
    return session.db.findFirstRow<SmsPhoneIdHash>(
      where: where?.call(SmsPhoneIdHash.t),
      orderBy: orderBy?.call(SmsPhoneIdHash.t),
      orderByList: orderByList?.call(SmsPhoneIdHash.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsPhoneIdHash] by its [id] or null if no such row exists.
  Future<SmsPhoneIdHash?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsPhoneIdHashInclude? include,
  }) async {
    return session.db.findById<SmsPhoneIdHash>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsPhoneIdHash]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsPhoneIdHash]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsPhoneIdHash>> insert(
    _i1.Session session,
    List<SmsPhoneIdHash> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsPhoneIdHash>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsPhoneIdHash] and returns the inserted row.
  ///
  /// The returned [SmsPhoneIdHash] will have its `id` field set.
  Future<SmsPhoneIdHash> insertRow(
    _i1.Session session,
    SmsPhoneIdHash row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsPhoneIdHash>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsPhoneIdHash]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsPhoneIdHash>> update(
    _i1.Session session,
    List<SmsPhoneIdHash> rows, {
    _i1.ColumnSelections<SmsPhoneIdHashTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsPhoneIdHash>(
      rows,
      columns: columns?.call(SmsPhoneIdHash.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsPhoneIdHash]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsPhoneIdHash> updateRow(
    _i1.Session session,
    SmsPhoneIdHash row, {
    _i1.ColumnSelections<SmsPhoneIdHashTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsPhoneIdHash>(
      row,
      columns: columns?.call(SmsPhoneIdHash.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsPhoneIdHash] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsPhoneIdHash?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsPhoneIdHashUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsPhoneIdHash>(
      id,
      columnValues: columnValues(SmsPhoneIdHash.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsPhoneIdHash]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsPhoneIdHash>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsPhoneIdHashUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SmsPhoneIdHashTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdHashTable>? orderBy,
    _i1.OrderByListBuilder<SmsPhoneIdHashTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsPhoneIdHash>(
      columnValues: columnValues(SmsPhoneIdHash.t.updateTable),
      where: where(SmsPhoneIdHash.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsPhoneIdHash.t),
      orderByList: orderByList?.call(SmsPhoneIdHash.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsPhoneIdHash]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsPhoneIdHash>> delete(
    _i1.Session session,
    List<SmsPhoneIdHash> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsPhoneIdHash>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsPhoneIdHash].
  Future<SmsPhoneIdHash> deleteRow(
    _i1.Session session,
    SmsPhoneIdHash row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsPhoneIdHash>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsPhoneIdHash>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsPhoneIdHashTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsPhoneIdHash>(
      where: where(SmsPhoneIdHash.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdHashTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsPhoneIdHash>(
      where: where?.call(SmsPhoneIdHash.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsPhoneIdHashAttachRowRepository {
  const SmsPhoneIdHashAttachRowRepository._();

  /// Creates a relation between the given [SmsPhoneIdHash] and [AuthUser]
  /// by setting the [SmsPhoneIdHash]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    SmsPhoneIdHash smsPhoneIdHash,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (smsPhoneIdHash.id == null) {
      throw ArgumentError.notNull('smsPhoneIdHash.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $smsPhoneIdHash = smsPhoneIdHash.copyWith(authUserId: authUser.id);
    await session.db.updateRow<SmsPhoneIdHash>(
      $smsPhoneIdHash,
      columns: [SmsPhoneIdHash.t.authUserId],
      transaction: transaction,
    );
  }
}
