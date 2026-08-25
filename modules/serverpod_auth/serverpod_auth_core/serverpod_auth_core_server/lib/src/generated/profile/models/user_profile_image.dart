/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import '../../profile/models/user_profile.dart' as _ixqiikps;

/// Database entity for storing user profile image information.
abstract class UserProfileImage
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  UserProfileImage._({
    this.id,
    required this.userProfileId,
    this.userProfile,
    DateTime? createdAt,
    required this.storageId,
    required this.path,
    required this.url,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfileImage({
    _is.UuidValue? id,
    required _is.UuidValue userProfileId,
    _ixqiikps.UserProfile? userProfile,
    DateTime? createdAt,
    required String storageId,
    required String path,
    required Uri url,
  }) = _UserProfileImageImpl;

  factory UserProfileImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileImage(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userProfileId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['userProfileId'],
      ),
      userProfile: jsonSerialization['userProfile'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ixqiikps.UserProfile>(
              jsonSerialization['userProfile'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      url: _is.UriJsonExtension.fromJson(jsonSerialization['url']),
    );
  }

  static final t = UserProfileImageTable();

  static const db = UserProfileImageRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userProfileId;

  /// The [UserProfile] this image belongs to.
  _ixqiikps.UserProfile? userProfile;

  /// The time when this profile image was created.
  DateTime createdAt;

  /// Storage in which the image is stored.
  String storageId;

  /// Path inside [storageId] at which the image is stored.
  String path;

  /// The public URL to access the image.
  Uri url;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserProfileImage copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userProfileId,
    _ixqiikps.UserProfile? userProfile,
    DateTime? createdAt,
    String? storageId,
    String? path,
    Uri? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.UserProfileImage',
      if (id != null) 'id': id?.toJson(),
      'userProfileId': userProfileId.toJson(),
      if (userProfile != null) 'userProfile': userProfile?.toJson(),
      'createdAt': createdAt.toJson(),
      'storageId': storageId,
      'path': path,
      'url': url.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.UserProfileImage',
      if (id != null) 'id': id?.toJson(),
      'userProfileId': userProfileId.toJson(),
      if (userProfile != null) 'userProfile': userProfile?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'storageId': storageId,
      'path': path,
      'url': url.toJson(),
    };
  }

  static UserProfileImageInclude include({
    _ixqiikps.UserProfileInclude? userProfile,
    _is.SelectColumnsBuilder<UserProfileImageTable>? select,
  }) {
    return UserProfileImageInclude._(
      userProfile: userProfile,
      selectedColumns: select?.call(UserProfileImage.t),
    );
  }

  static UserProfileImageIncludeList includeList({
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    UserProfileImageInclude? include,
    _is.SelectColumnsBuilder<UserProfileImageTable>? select,
  }) {
    return UserProfileImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      include: include,
      selectedColumns: select?.call(UserProfileImage.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImageImpl extends UserProfileImage {
  _UserProfileImageImpl({
    _is.UuidValue? id,
    required _is.UuidValue userProfileId,
    _ixqiikps.UserProfile? userProfile,
    DateTime? createdAt,
    required String storageId,
    required String path,
    required Uri url,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         userProfile: userProfile,
         createdAt: createdAt,
         storageId: storageId,
         path: path,
         url: url,
       );

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserProfileImage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userProfileId,
    Object? userProfile = _Undefined,
    DateTime? createdAt,
    String? storageId,
    String? path,
    Uri? url,
  }) {
    return UserProfileImage(
      id: id is _is.UuidValue? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      userProfile: userProfile is _ixqiikps.UserProfile?
          ? userProfile
          : this.userProfile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}

class UserProfileImageUpdateTable
    extends _is.UpdateTable<UserProfileImageTable> {
  UserProfileImageUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userProfileId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.userProfileId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> storageId(String value) => _is.ColumnValue(
    table.storageId,
    value,
  );

  _is.ColumnValue<String, String> path(String value) => _is.ColumnValue(
    table.path,
    value,
  );

  _is.ColumnValue<Uri, Uri> url(Uri value) => _is.ColumnValue(
    table.url,
    value,
  );
}

class UserProfileImageTable extends _is.Table<_is.UuidValue?> {
  UserProfileImageTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_profile_image') {
    updateTable = UserProfileImageUpdateTable(this);
    userProfileId = _is.ColumnUuid(
      'userProfileId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    storageId = _is.ColumnString(
      'storageId',
      this,
    );
    path = _is.ColumnString(
      'path',
      this,
    );
    url = _is.ColumnUri(
      'url',
      this,
    );
  }

  late final UserProfileImageUpdateTable updateTable;

  late final _is.ColumnUuid userProfileId;

  /// The [UserProfile] this image belongs to.
  _ixqiikps.UserProfileTable? _userProfile;

  /// The time when this profile image was created.
  late final _is.ColumnDateTime createdAt;

  /// Storage in which the image is stored.
  late final _is.ColumnString storageId;

  /// Path inside [storageId] at which the image is stored.
  late final _is.ColumnString path;

  /// The public URL to access the image.
  late final _is.ColumnUri url;

  _ixqiikps.UserProfileTable get userProfile {
    if (_userProfile != null) return _userProfile!;
    _userProfile = _is.createRelationTable(
      relationFieldName: 'userProfile',
      field: UserProfileImage.t.userProfileId,
      foreignField: _ixqiikps.UserProfile.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ixqiikps.UserProfileTable(tableRelation: foreignTableRelation),
    );
    return _userProfile!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    userProfileId,
    createdAt,
    storageId,
    path,
    url,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'userProfile') {
      return userProfile;
    }
    return null;
  }
}

class UserProfileImageInclude extends _is.IncludeObject {
  UserProfileImageInclude._({
    _ixqiikps.UserProfileInclude? userProfile,
    this.selectedColumns,
  }) {
    _userProfile = userProfile;
  }

  _ixqiikps.UserProfileInclude? _userProfile;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'userProfile': _userProfile};

  @override
  _is.Table<_is.UuidValue?> get table => UserProfileImage.t;
}

class UserProfileImageIncludeList extends _is.IncludeList {
  UserProfileImageIncludeList._({
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserProfileImage.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => UserProfileImage.t;
}

class UserProfileImageRepository {
  const UserProfileImageRepository._();

  final attachRow = const UserProfileImageAttachRowRepository._();

  /// Returns a list of [UserProfileImage]s matching the given query parameters.
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
  Future<List<UserProfileImage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserProfileImage] matching the given query parameters.
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
  Future<UserProfileImage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserProfileImage] by its [id] or null if no such row exists.
  Future<UserProfileImage?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserProfileImage>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.SelectColumnsBuilder<UserProfileImageTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfileImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.SelectColumnsBuilder<UserProfileImageTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfileImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    UserProfileImageInclude? include,
    _is.SelectColumnsBuilder<UserProfileImageTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserProfileImage>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfileImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserProfileImage]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfileImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> insert(
    _is.DatabaseSession session,
    List<UserProfileImage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserProfileImage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserProfileImage] and returns the inserted row.
  ///
  /// The returned [UserProfileImage] will have its `id` field set.
  Future<UserProfileImage> insertRow(
    _is.DatabaseSession session,
    UserProfileImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfileImage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserProfileImage]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [UserProfileImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> upsert(
    _is.DatabaseSession session,
    List<UserProfileImage> rows, {
    required _is.ColumnSelections<UserProfileImageTable> conflictColumns,
    _is.ColumnSelections<UserProfileImageTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileImageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserProfileImage>(
      rows,
      conflictColumns: conflictColumns(UserProfileImage.t),
      updateColumns: updateColumns?.call(UserProfileImage.t),
      updateWhere: updateWhere?.call(UserProfileImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserProfileImage] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [UserProfileImage] will have its `id` field set.
  Future<UserProfileImage?> upsertRow(
    _is.DatabaseSession session,
    UserProfileImage row, {
    required _is.ColumnSelections<UserProfileImageTable> conflictColumns,
    _is.ColumnSelections<UserProfileImageTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileImageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserProfileImage>(
      row,
      conflictColumns: conflictColumns(UserProfileImage.t),
      updateColumns: updateColumns?.call(UserProfileImage.t),
      updateWhere: updateWhere?.call(UserProfileImage.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfileImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> update(
    _is.DatabaseSession session,
    List<UserProfileImage> rows, {
    _is.ColumnSelections<UserProfileImageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserProfileImage>(
      rows,
      columns: columns?.call(UserProfileImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserProfileImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfileImage> updateRow(
    _is.DatabaseSession session,
    UserProfileImage row, {
    _is.ColumnSelections<UserProfileImageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfileImage>(
      row,
      columns: columns?.call(UserProfileImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfileImage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfileImage?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<UserProfileImageUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfileImage>(
      id,
      columnValues: columnValues(UserProfileImage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfileImage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserProfileImageUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UserProfileImageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserProfileImage>(
      columnValues: columnValues(UserProfileImage.t.updateTable),
      where: where(UserProfileImage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserProfileImage]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> delete(
    _is.DatabaseSession session,
    List<UserProfileImage> rows, {
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserProfileImage>(
      rows,
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserProfileImage].
  Future<UserProfileImage> deleteRow(
    _is.DatabaseSession session,
    UserProfileImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfileImage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfileImage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileImageTable> where,
    _is.OrderByBuilder<UserProfileImageTable>? orderBy,
    _is.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserProfileImage>(
      where: where(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserProfileImage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileImageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserProfileImage>(
      where: where(UserProfileImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserProfileImageAttachRowRepository {
  const UserProfileImageAttachRowRepository._();

  /// Creates a relation between the given [UserProfileImage] and [UserProfile]
  /// by setting the [UserProfileImage]'s foreign key `userProfileId` to refer to the [UserProfile].
  Future<void> userProfile(
    _is.DatabaseSession session,
    UserProfileImage userProfileImage,
    _ixqiikps.UserProfile userProfile, {
    _is.Transaction? transaction,
  }) async {
    if (userProfileImage.id == null) {
      throw ArgumentError.notNull('userProfileImage.id');
    }
    if (userProfile.id == null) {
      throw ArgumentError.notNull('userProfile.id');
    }

    var $userProfileImage = userProfileImage.copyWith(
      userProfileId: userProfile.id,
    );
    await session.db.updateRow<UserProfileImage>(
      $userProfileImage,
      columns: [UserProfileImage.t.userProfileId],
      transaction: transaction,
    );
  }
}
