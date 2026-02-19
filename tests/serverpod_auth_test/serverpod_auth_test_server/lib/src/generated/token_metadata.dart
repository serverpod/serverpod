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
import 'package:serverpod_auth_test_server/src/generated/protocol.dart' as _i3;

abstract class TokenMetadata
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TokenMetadata._({
    this.id,
    required this.refreshTokenId,
    this.refreshToken,
    required this.deviceName,
    this.ipAddress,
    this.userAgent,
    this.metadata,
  });

  factory TokenMetadata({
    int? id,
    required _i1.UuidValue refreshTokenId,
    _i2.RefreshToken? refreshToken,
    required String deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  }) = _TokenMetadataImpl;

  factory TokenMetadata.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenMetadata(
      id: jsonSerialization['id'] as int?,
      refreshTokenId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['refreshTokenId'],
      ),
      refreshToken: jsonSerialization['refreshToken'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.RefreshToken>(
              jsonSerialization['refreshToken'],
            ),
      deviceName: jsonSerialization['deviceName'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  static final t = TokenMetadataTable();

  static const db = TokenMetadataRepository._();

  @override
  int? id;

  _i1.UuidValue refreshTokenId;

  /// The [RefreshToken] this metadata belongs to
  _i2.RefreshToken? refreshToken;

  /// Device information for the token
  String deviceName;

  /// IP address from which the token was created
  String? ipAddress;

  /// User agent string
  String? userAgent;

  /// Additional metadata stored as JSON
  String? metadata;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TokenMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenMetadata copyWith({
    int? id,
    _i1.UuidValue? refreshTokenId,
    _i2.RefreshToken? refreshToken,
    String? deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TokenMetadata',
      if (id != null) 'id': id,
      'refreshTokenId': refreshTokenId.toJson(),
      if (refreshToken != null) 'refreshToken': refreshToken?.toJson(),
      'deviceName': deviceName,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TokenMetadataInclude include({_i2.RefreshTokenInclude? refreshToken}) {
    return TokenMetadataInclude._(refreshToken: refreshToken);
  }

  static TokenMetadataIncludeList includeList({
    _i1.WhereExpressionBuilder<TokenMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenMetadataTable>? orderByList,
    TokenMetadataInclude? include,
  }) {
    return TokenMetadataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TokenMetadata.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TokenMetadata.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TokenMetadataImpl extends TokenMetadata {
  _TokenMetadataImpl({
    int? id,
    required _i1.UuidValue refreshTokenId,
    _i2.RefreshToken? refreshToken,
    required String deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  }) : super._(
         id: id,
         refreshTokenId: refreshTokenId,
         refreshToken: refreshToken,
         deviceName: deviceName,
         ipAddress: ipAddress,
         userAgent: userAgent,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [TokenMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenMetadata copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? refreshTokenId,
    Object? refreshToken = _Undefined,
    String? deviceName,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return TokenMetadata(
      id: id is int? ? id : this.id,
      refreshTokenId: refreshTokenId ?? this.refreshTokenId,
      refreshToken: refreshToken is _i2.RefreshToken?
          ? refreshToken
          : this.refreshToken?.copyWith(),
      deviceName: deviceName ?? this.deviceName,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}

class TokenMetadataUpdateTable extends _i1.UpdateTable<TokenMetadataTable> {
  TokenMetadataUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> refreshTokenId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.refreshTokenId,
    value,
  );

  _i1.ColumnValue<String, String> deviceName(String value) => _i1.ColumnValue(
    table.deviceName,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<String, String> userAgent(String? value) => _i1.ColumnValue(
    table.userAgent,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
    value,
  );
}

class TokenMetadataTable extends _i1.Table<int?> {
  TokenMetadataTable({super.tableRelation})
    : super(tableName: 'token_metadata') {
    updateTable = TokenMetadataUpdateTable(this);
    refreshTokenId = _i1.ColumnUuid(
      'refreshTokenId',
      this,
    );
    deviceName = _i1.ColumnString(
      'deviceName',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    userAgent = _i1.ColumnString(
      'userAgent',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
      this,
    );
  }

  late final TokenMetadataUpdateTable updateTable;

  late final _i1.ColumnUuid refreshTokenId;

  /// The [RefreshToken] this metadata belongs to
  _i2.RefreshTokenTable? _refreshToken;

  /// Device information for the token
  late final _i1.ColumnString deviceName;

  /// IP address from which the token was created
  late final _i1.ColumnString ipAddress;

  /// User agent string
  late final _i1.ColumnString userAgent;

  /// Additional metadata stored as JSON
  late final _i1.ColumnString metadata;

  _i2.RefreshTokenTable get refreshToken {
    if (_refreshToken != null) return _refreshToken!;
    _refreshToken = _i1.createRelationTable(
      relationFieldName: 'refreshToken',
      field: TokenMetadata.t.refreshTokenId,
      foreignField: _i2.RefreshToken.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RefreshTokenTable(tableRelation: foreignTableRelation),
    );
    return _refreshToken!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    refreshTokenId,
    deviceName,
    ipAddress,
    userAgent,
    metadata,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'refreshToken') {
      return refreshToken;
    }
    return null;
  }
}

class TokenMetadataInclude extends _i1.IncludeObject {
  TokenMetadataInclude._({_i2.RefreshTokenInclude? refreshToken}) {
    _refreshToken = refreshToken;
  }

  _i2.RefreshTokenInclude? _refreshToken;

  @override
  Map<String, _i1.Include?> get includes => {'refreshToken': _refreshToken};

  @override
  _i1.Table<int?> get table => TokenMetadata.t;
}

class TokenMetadataIncludeList extends _i1.IncludeList {
  TokenMetadataIncludeList._({
    _i1.WhereExpressionBuilder<TokenMetadataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TokenMetadata.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TokenMetadata.t;
}

class TokenMetadataRepository {
  const TokenMetadataRepository._();

  final attachRow = const TokenMetadataAttachRowRepository._();

  /// Returns a list of [TokenMetadata]s matching the given query parameters.
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
  Future<List<TokenMetadata>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    TokenMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TokenMetadata>(
      where: where?.call(TokenMetadata.t),
      orderBy: orderBy?.call(TokenMetadata.t),
      orderByList: orderByList?.call(TokenMetadata.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TokenMetadata] matching the given query parameters.
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
  Future<TokenMetadata?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenMetadataTable>? where,
    int? offset,
    _i1.OrderByBuilder<TokenMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    TokenMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TokenMetadata>(
      where: where?.call(TokenMetadata.t),
      orderBy: orderBy?.call(TokenMetadata.t),
      orderByList: orderByList?.call(TokenMetadata.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TokenMetadata] by its [id] or null if no such row exists.
  Future<TokenMetadata?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TokenMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TokenMetadata>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TokenMetadata]s in the list and returns the inserted rows.
  ///
  /// The returned [TokenMetadata]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TokenMetadata>> insert(
    _i1.Session session,
    List<TokenMetadata> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TokenMetadata>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TokenMetadata] and returns the inserted row.
  ///
  /// The returned [TokenMetadata] will have its `id` field set.
  Future<TokenMetadata> insertRow(
    _i1.Session session,
    TokenMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TokenMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TokenMetadata]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TokenMetadata>> update(
    _i1.Session session,
    List<TokenMetadata> rows, {
    _i1.ColumnSelections<TokenMetadataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TokenMetadata>(
      rows,
      columns: columns?.call(TokenMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TokenMetadata]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TokenMetadata> updateRow(
    _i1.Session session,
    TokenMetadata row, {
    _i1.ColumnSelections<TokenMetadataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TokenMetadata>(
      row,
      columns: columns?.call(TokenMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TokenMetadata] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TokenMetadata?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TokenMetadataUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TokenMetadata>(
      id,
      columnValues: columnValues(TokenMetadata.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TokenMetadata]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TokenMetadata>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TokenMetadataUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TokenMetadataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenMetadataTable>? orderBy,
    _i1.OrderByListBuilder<TokenMetadataTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TokenMetadata>(
      columnValues: columnValues(TokenMetadata.t.updateTable),
      where: where(TokenMetadata.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TokenMetadata.t),
      orderByList: orderByList?.call(TokenMetadata.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TokenMetadata]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TokenMetadata>> delete(
    _i1.Session session,
    List<TokenMetadata> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TokenMetadata>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TokenMetadata].
  Future<TokenMetadata> deleteRow(
    _i1.Session session,
    TokenMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TokenMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TokenMetadata>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TokenMetadataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TokenMetadata>(
      where: where(TokenMetadata.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenMetadataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TokenMetadata>(
      where: where?.call(TokenMetadata.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TokenMetadata] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TokenMetadataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TokenMetadata>(
      where: where(TokenMetadata.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class TokenMetadataAttachRowRepository {
  const TokenMetadataAttachRowRepository._();

  /// Creates a relation between the given [TokenMetadata] and [RefreshToken]
  /// by setting the [TokenMetadata]'s foreign key `refreshTokenId` to refer to the [RefreshToken].
  Future<void> refreshToken(
    _i1.Session session,
    TokenMetadata tokenMetadata,
    _i2.RefreshToken refreshToken, {
    _i1.Transaction? transaction,
  }) async {
    if (tokenMetadata.id == null) {
      throw ArgumentError.notNull('tokenMetadata.id');
    }
    if (refreshToken.id == null) {
      throw ArgumentError.notNull('refreshToken.id');
    }

    var $tokenMetadata = tokenMetadata.copyWith(
      refreshTokenId: refreshToken.id,
    );
    await session.db.updateRow<TokenMetadata>(
      $tokenMetadata,
      columns: [TokenMetadata.t.refreshTokenId],
      transaction: transaction,
    );
  }
}
