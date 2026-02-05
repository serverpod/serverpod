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
import 'dart:typed_data' as _i3;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i4;

/// Encrypted phone ID storage.
///
/// Stores the phone number encrypted so it can be retrieved when needed.
abstract class SmsPhoneIdCrypto
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsPhoneIdCrypto._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.phoneHash,
    required this.phoneEncrypted,
    required this.nonce,
    required this.mac,
  });

  factory SmsPhoneIdCrypto({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
    required _i3.ByteData phoneEncrypted,
    required _i3.ByteData nonce,
    required _i3.ByteData mac,
  }) = _SmsPhoneIdCryptoImpl;

  factory SmsPhoneIdCrypto.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsPhoneIdCrypto(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      phoneHash: jsonSerialization['phoneHash'] as String,
      phoneEncrypted: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['phoneEncrypted'],
      ),
      nonce: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['nonce']),
      mac: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['mac']),
    );
  }

  static final t = SmsPhoneIdCryptoTable();

  static const db = SmsPhoneIdCryptoRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this phone belongs to
  _i2.AuthUser? authUser;

  /// The hash of the phone number (for lookup).
  String phoneHash;

  /// The encrypted phone number.
  _i3.ByteData phoneEncrypted;

  /// The nonce used for encryption.
  _i3.ByteData nonce;

  /// The MAC tag for authenticated encryption.
  _i3.ByteData mac;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsPhoneIdCrypto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsPhoneIdCrypto copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? phoneHash,
    _i3.ByteData? phoneEncrypted,
    _i3.ByteData? nonce,
    _i3.ByteData? mac,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsPhoneIdCrypto',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'phoneHash': phoneHash,
      'phoneEncrypted': phoneEncrypted.toJson(),
      'nonce': nonce.toJson(),
      'mac': mac.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsPhoneIdCryptoInclude include({_i2.AuthUserInclude? authUser}) {
    return SmsPhoneIdCryptoInclude._(authUser: authUser);
  }

  static SmsPhoneIdCryptoIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdCryptoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdCryptoTable>? orderByList,
    SmsPhoneIdCryptoInclude? include,
  }) {
    return SmsPhoneIdCryptoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsPhoneIdCrypto.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsPhoneIdCrypto.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsPhoneIdCryptoImpl extends SmsPhoneIdCrypto {
  _SmsPhoneIdCryptoImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String phoneHash,
    required _i3.ByteData phoneEncrypted,
    required _i3.ByteData nonce,
    required _i3.ByteData mac,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         phoneHash: phoneHash,
         phoneEncrypted: phoneEncrypted,
         nonce: nonce,
         mac: mac,
       );

  /// Returns a shallow copy of this [SmsPhoneIdCrypto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsPhoneIdCrypto copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? phoneHash,
    _i3.ByteData? phoneEncrypted,
    _i3.ByteData? nonce,
    _i3.ByteData? mac,
  }) {
    return SmsPhoneIdCrypto(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      phoneHash: phoneHash ?? this.phoneHash,
      phoneEncrypted: phoneEncrypted ?? this.phoneEncrypted.clone(),
      nonce: nonce ?? this.nonce.clone(),
      mac: mac ?? this.mac.clone(),
    );
  }
}

class SmsPhoneIdCryptoUpdateTable
    extends _i1.UpdateTable<SmsPhoneIdCryptoTable> {
  SmsPhoneIdCryptoUpdateTable(super.table);

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

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> phoneEncrypted(
    _i3.ByteData value,
  ) => _i1.ColumnValue(
    table.phoneEncrypted,
    value,
  );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> nonce(_i3.ByteData value) =>
      _i1.ColumnValue(
        table.nonce,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> mac(_i3.ByteData value) =>
      _i1.ColumnValue(
        table.mac,
        value,
      );
}

class SmsPhoneIdCryptoTable extends _i1.Table<_i1.UuidValue?> {
  SmsPhoneIdCryptoTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_phone_id_crypto') {
    updateTable = SmsPhoneIdCryptoUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    phoneHash = _i1.ColumnString(
      'phoneHash',
      this,
    );
    phoneEncrypted = _i1.ColumnByteData(
      'phoneEncrypted',
      this,
    );
    nonce = _i1.ColumnByteData(
      'nonce',
      this,
    );
    mac = _i1.ColumnByteData(
      'mac',
      this,
    );
  }

  late final SmsPhoneIdCryptoUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this phone belongs to
  _i2.AuthUserTable? _authUser;

  /// The hash of the phone number (for lookup).
  late final _i1.ColumnString phoneHash;

  /// The encrypted phone number.
  late final _i1.ColumnByteData phoneEncrypted;

  /// The nonce used for encryption.
  late final _i1.ColumnByteData nonce;

  /// The MAC tag for authenticated encryption.
  late final _i1.ColumnByteData mac;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: SmsPhoneIdCrypto.t.authUserId,
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
    phoneEncrypted,
    nonce,
    mac,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class SmsPhoneIdCryptoInclude extends _i1.IncludeObject {
  SmsPhoneIdCryptoInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsPhoneIdCrypto.t;
}

class SmsPhoneIdCryptoIncludeList extends _i1.IncludeList {
  SmsPhoneIdCryptoIncludeList._({
    _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsPhoneIdCrypto.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsPhoneIdCrypto.t;
}

class SmsPhoneIdCryptoRepository {
  const SmsPhoneIdCryptoRepository._();

  final attachRow = const SmsPhoneIdCryptoAttachRowRepository._();

  /// Returns a list of [SmsPhoneIdCrypto]s matching the given query parameters.
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
  Future<List<SmsPhoneIdCrypto>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdCryptoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdCryptoTable>? orderByList,
    _i1.Transaction? transaction,
    SmsPhoneIdCryptoInclude? include,
  }) async {
    return session.db.find<SmsPhoneIdCrypto>(
      where: where?.call(SmsPhoneIdCrypto.t),
      orderBy: orderBy?.call(SmsPhoneIdCrypto.t),
      orderByList: orderByList?.call(SmsPhoneIdCrypto.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsPhoneIdCrypto] matching the given query parameters.
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
  Future<SmsPhoneIdCrypto?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdCryptoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsPhoneIdCryptoTable>? orderByList,
    _i1.Transaction? transaction,
    SmsPhoneIdCryptoInclude? include,
  }) async {
    return session.db.findFirstRow<SmsPhoneIdCrypto>(
      where: where?.call(SmsPhoneIdCrypto.t),
      orderBy: orderBy?.call(SmsPhoneIdCrypto.t),
      orderByList: orderByList?.call(SmsPhoneIdCrypto.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsPhoneIdCrypto] by its [id] or null if no such row exists.
  Future<SmsPhoneIdCrypto?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsPhoneIdCryptoInclude? include,
  }) async {
    return session.db.findById<SmsPhoneIdCrypto>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsPhoneIdCrypto]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsPhoneIdCrypto]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsPhoneIdCrypto>> insert(
    _i1.Session session,
    List<SmsPhoneIdCrypto> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsPhoneIdCrypto>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsPhoneIdCrypto] and returns the inserted row.
  ///
  /// The returned [SmsPhoneIdCrypto] will have its `id` field set.
  Future<SmsPhoneIdCrypto> insertRow(
    _i1.Session session,
    SmsPhoneIdCrypto row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsPhoneIdCrypto>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsPhoneIdCrypto]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsPhoneIdCrypto>> update(
    _i1.Session session,
    List<SmsPhoneIdCrypto> rows, {
    _i1.ColumnSelections<SmsPhoneIdCryptoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsPhoneIdCrypto>(
      rows,
      columns: columns?.call(SmsPhoneIdCrypto.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsPhoneIdCrypto]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsPhoneIdCrypto> updateRow(
    _i1.Session session,
    SmsPhoneIdCrypto row, {
    _i1.ColumnSelections<SmsPhoneIdCryptoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsPhoneIdCrypto>(
      row,
      columns: columns?.call(SmsPhoneIdCrypto.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsPhoneIdCrypto] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsPhoneIdCrypto?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsPhoneIdCryptoUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsPhoneIdCrypto>(
      id,
      columnValues: columnValues(SmsPhoneIdCrypto.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsPhoneIdCrypto]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsPhoneIdCrypto>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsPhoneIdCryptoUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsPhoneIdCryptoTable>? orderBy,
    _i1.OrderByListBuilder<SmsPhoneIdCryptoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsPhoneIdCrypto>(
      columnValues: columnValues(SmsPhoneIdCrypto.t.updateTable),
      where: where(SmsPhoneIdCrypto.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsPhoneIdCrypto.t),
      orderByList: orderByList?.call(SmsPhoneIdCrypto.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsPhoneIdCrypto]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsPhoneIdCrypto>> delete(
    _i1.Session session,
    List<SmsPhoneIdCrypto> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsPhoneIdCrypto>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsPhoneIdCrypto].
  Future<SmsPhoneIdCrypto> deleteRow(
    _i1.Session session,
    SmsPhoneIdCrypto row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsPhoneIdCrypto>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsPhoneIdCrypto>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsPhoneIdCrypto>(
      where: where(SmsPhoneIdCrypto.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsPhoneIdCryptoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsPhoneIdCrypto>(
      where: where?.call(SmsPhoneIdCrypto.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsPhoneIdCryptoAttachRowRepository {
  const SmsPhoneIdCryptoAttachRowRepository._();

  /// Creates a relation between the given [SmsPhoneIdCrypto] and [AuthUser]
  /// by setting the [SmsPhoneIdCrypto]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    SmsPhoneIdCrypto smsPhoneIdCrypto,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (smsPhoneIdCrypto.id == null) {
      throw ArgumentError.notNull('smsPhoneIdCrypto.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $smsPhoneIdCrypto = smsPhoneIdCrypto.copyWith(authUserId: authUser.id);
    await session.db.updateRow<SmsPhoneIdCrypto>(
      $smsPhoneIdCrypto,
      columns: [SmsPhoneIdCrypto.t.authUserId],
      transaction: transaction,
    );
  }
}
