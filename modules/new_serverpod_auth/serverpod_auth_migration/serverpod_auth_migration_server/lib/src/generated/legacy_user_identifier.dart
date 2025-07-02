/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i2;

abstract class LegacyUserIdentifier
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LegacyUserIdentifier._({
    this.id,
    required this.newAuthUserId,
    this.newAuthUser,
    required this.userIdentifier,
  });

  factory LegacyUserIdentifier({
    int? id,
    required _i1.UuidValue newAuthUserId,
    _i2.AuthUser? newAuthUser,
    required String userIdentifier,
  }) = _LegacyUserIdentifierImpl;

  factory LegacyUserIdentifier.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return LegacyUserIdentifier(
      id: jsonSerialization['id'] as int?,
      newAuthUserId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['newAuthUserId']),
      newAuthUser: jsonSerialization['newAuthUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['newAuthUser'] as Map<String, dynamic>)),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = LegacyUserIdentifierTable();

  static const db = LegacyUserIdentifierRepository._();

  @override
  int? id;

  _i1.UuidValue newAuthUserId;

  /// The [AuthUser] this identifier belongs to
  _i2.AuthUser? newAuthUser;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  ///
  /// From the import we don't know whether this came from Apple/Google/Firebase
  /// and thus we have to match them on each incoming request.
  String userIdentifier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegacyUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyUserIdentifier copyWith({
    int? id,
    _i1.UuidValue? newAuthUserId,
    _i2.AuthUser? newAuthUser,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'newAuthUserId': newAuthUserId.toJson(),
      if (newAuthUser != null) 'newAuthUser': newAuthUser?.toJson(),
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static LegacyUserIdentifierInclude include(
      {_i2.AuthUserInclude? newAuthUser}) {
    return LegacyUserIdentifierInclude._(newAuthUser: newAuthUser);
  }

  static LegacyUserIdentifierIncludeList includeList({
    _i1.WhereExpressionBuilder<LegacyUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyUserIdentifierTable>? orderByList,
    LegacyUserIdentifierInclude? include,
  }) {
    return LegacyUserIdentifierIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyUserIdentifier.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegacyUserIdentifier.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyUserIdentifierImpl extends LegacyUserIdentifier {
  _LegacyUserIdentifierImpl({
    int? id,
    required _i1.UuidValue newAuthUserId,
    _i2.AuthUser? newAuthUser,
    required String userIdentifier,
  }) : super._(
          id: id,
          newAuthUserId: newAuthUserId,
          newAuthUser: newAuthUser,
          userIdentifier: userIdentifier,
        );

  /// Returns a shallow copy of this [LegacyUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyUserIdentifier copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? newAuthUserId,
    Object? newAuthUser = _Undefined,
    String? userIdentifier,
  }) {
    return LegacyUserIdentifier(
      id: id is int? ? id : this.id,
      newAuthUserId: newAuthUserId ?? this.newAuthUserId,
      newAuthUser: newAuthUser is _i2.AuthUser?
          ? newAuthUser
          : this.newAuthUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class LegacyUserIdentifierTable extends _i1.Table<int?> {
  LegacyUserIdentifierTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_migration_legacy_user_identifier') {
    newAuthUserId = _i1.ColumnUuid(
      'newAuthUserId',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final _i1.ColumnUuid newAuthUserId;

  /// The [AuthUser] this identifier belongs to
  _i2.AuthUserTable? _newAuthUser;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  ///
  /// From the import we don't know whether this came from Apple/Google/Firebase
  /// and thus we have to match them on each incoming request.
  late final _i1.ColumnString userIdentifier;

  _i2.AuthUserTable get newAuthUser {
    if (_newAuthUser != null) return _newAuthUser!;
    _newAuthUser = _i1.createRelationTable(
      relationFieldName: 'newAuthUser',
      field: LegacyUserIdentifier.t.newAuthUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _newAuthUser!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        newAuthUserId,
        userIdentifier,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'newAuthUser') {
      return newAuthUser;
    }
    return null;
  }
}

class LegacyUserIdentifierInclude extends _i1.IncludeObject {
  LegacyUserIdentifierInclude._({_i2.AuthUserInclude? newAuthUser}) {
    _newAuthUser = newAuthUser;
  }

  _i2.AuthUserInclude? _newAuthUser;

  @override
  Map<String, _i1.Include?> get includes => {'newAuthUser': _newAuthUser};

  @override
  _i1.Table<int?> get table => LegacyUserIdentifier.t;
}

class LegacyUserIdentifierIncludeList extends _i1.IncludeList {
  LegacyUserIdentifierIncludeList._({
    _i1.WhereExpressionBuilder<LegacyUserIdentifierTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegacyUserIdentifier.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LegacyUserIdentifier.t;
}

class LegacyUserIdentifierRepository {
  const LegacyUserIdentifierRepository._();

  final attachRow = const LegacyUserIdentifierAttachRowRepository._();

  /// Returns a list of [LegacyUserIdentifier]s matching the given query parameters.
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
  Future<List<LegacyUserIdentifier>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacyUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyUserIdentifierTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyUserIdentifierInclude? include,
  }) async {
    return session.db.find<LegacyUserIdentifier>(
      where: where?.call(LegacyUserIdentifier.t),
      orderBy: orderBy?.call(LegacyUserIdentifier.t),
      orderByList: orderByList?.call(LegacyUserIdentifier.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LegacyUserIdentifier] matching the given query parameters.
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
  Future<LegacyUserIdentifier?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyUserIdentifierTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegacyUserIdentifierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacyUserIdentifierTable>? orderByList,
    _i1.Transaction? transaction,
    LegacyUserIdentifierInclude? include,
  }) async {
    return session.db.findFirstRow<LegacyUserIdentifier>(
      where: where?.call(LegacyUserIdentifier.t),
      orderBy: orderBy?.call(LegacyUserIdentifier.t),
      orderByList: orderByList?.call(LegacyUserIdentifier.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LegacyUserIdentifier] by its [id] or null if no such row exists.
  Future<LegacyUserIdentifier?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    LegacyUserIdentifierInclude? include,
  }) async {
    return session.db.findById<LegacyUserIdentifier>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LegacyUserIdentifier]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacyUserIdentifier]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegacyUserIdentifier>> insert(
    _i1.Session session,
    List<LegacyUserIdentifier> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegacyUserIdentifier>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegacyUserIdentifier] and returns the inserted row.
  ///
  /// The returned [LegacyUserIdentifier] will have its `id` field set.
  Future<LegacyUserIdentifier> insertRow(
    _i1.Session session,
    LegacyUserIdentifier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacyUserIdentifier>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegacyUserIdentifier]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegacyUserIdentifier>> update(
    _i1.Session session,
    List<LegacyUserIdentifier> rows, {
    _i1.ColumnSelections<LegacyUserIdentifierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegacyUserIdentifier>(
      rows,
      columns: columns?.call(LegacyUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyUserIdentifier]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacyUserIdentifier> updateRow(
    _i1.Session session,
    LegacyUserIdentifier row, {
    _i1.ColumnSelections<LegacyUserIdentifierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacyUserIdentifier>(
      row,
      columns: columns?.call(LegacyUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Deletes all [LegacyUserIdentifier]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegacyUserIdentifier>> delete(
    _i1.Session session,
    List<LegacyUserIdentifier> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegacyUserIdentifier>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegacyUserIdentifier].
  Future<LegacyUserIdentifier> deleteRow(
    _i1.Session session,
    LegacyUserIdentifier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacyUserIdentifier>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegacyUserIdentifier>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegacyUserIdentifierTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegacyUserIdentifier>(
      where: where(LegacyUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacyUserIdentifierTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegacyUserIdentifier>(
      where: where?.call(LegacyUserIdentifier.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LegacyUserIdentifierAttachRowRepository {
  const LegacyUserIdentifierAttachRowRepository._();

  /// Creates a relation between the given [LegacyUserIdentifier] and [AuthUser]
  /// by setting the [LegacyUserIdentifier]'s foreign key `newAuthUserId` to refer to the [AuthUser].
  Future<void> newAuthUser(
    _i1.Session session,
    LegacyUserIdentifier legacyUserIdentifier,
    _i2.AuthUser newAuthUser, {
    _i1.Transaction? transaction,
  }) async {
    if (legacyUserIdentifier.id == null) {
      throw ArgumentError.notNull('legacyUserIdentifier.id');
    }
    if (newAuthUser.id == null) {
      throw ArgumentError.notNull('newAuthUser.id');
    }

    var $legacyUserIdentifier =
        legacyUserIdentifier.copyWith(newAuthUserId: newAuthUser.id);
    await session.db.updateRow<LegacyUserIdentifier>(
      $legacyUserIdentifier,
      columns: [LegacyUserIdentifier.t.newAuthUserId],
      transaction: transaction,
    );
  }
}
