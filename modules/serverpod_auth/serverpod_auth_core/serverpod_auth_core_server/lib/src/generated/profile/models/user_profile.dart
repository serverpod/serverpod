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
import '../../auth_user/models/auth_user.dart' as _ivyervu7;
import '../../profile/models/user_profile_image.dart' as _i7y29ltp;

/// Core database entity representing a user profile in the authentication system.
///
/// This class is meant to be used only to interact with the database. To transfer
/// user profile data, use the [UserProfileModel] DTO.
abstract class UserProfile
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.userName,
    this.fullName,
    this.email,
    DateTime? createdAt,
    this.imageId,
    this.image,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _is.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ivyervu7.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      imageId: jsonSerialization['imageId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['imageId']),
      image: jsonSerialization['image'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_i7y29ltp.UserProfileImage>(
              jsonSerialization['image'],
            ),
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to.
  _ivyervu7.AuthUser? authUser;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The verified email address of the user.
  ///
  /// This should only be set by authentication providers that have
  /// checked ownership of this email for the user.
  ///
  /// Stored in lower-case.
  String? email;

  /// The time when this user was created.
  DateTime createdAt;

  _is.UuidValue? imageId;

  /// The user's profile image.
  _i7y29ltp.UserProfileImage? image;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserProfile copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _is.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.UserProfile',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (imageId != null) 'imageId': imageId?.toJson(),
      if (image != null) 'image': image?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.UserProfile',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (imageId != null) 'imageId': imageId?.toJson(),
      if (image != null) 'image': image?.toJsonForProtocol(),
    };
  }

  static UserProfileInclude include({
    _ivyervu7.AuthUserInclude? authUser,
    _i7y29ltp.UserProfileImageInclude? image,
    _is.SelectColumnsBuilder<UserProfileTable>? select,
  }) {
    return UserProfileInclude._(
      authUser: authUser,
      image: image,
      selectedColumns: select?.call(UserProfile.t),
    );
  }

  static UserProfileIncludeList includeList({
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
    _is.SelectColumnsBuilder<UserProfileTable>? select,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
      selectedColumns: select?.call(UserProfile.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _is.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userName: userName,
         fullName: fullName,
         email: email,
         createdAt: createdAt,
         imageId: imageId,
         image: image,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? createdAt,
    Object? imageId = _Undefined,
    Object? image = _Undefined,
  }) {
    return UserProfile(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _ivyervu7.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      createdAt: createdAt ?? this.createdAt,
      imageId: imageId is _is.UuidValue? ? imageId : this.imageId,
      image: image is _i7y29ltp.UserProfileImage?
          ? image
          : this.image?.copyWith(),
    );
  }
}

class UserProfileUpdateTable extends _is.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> userName(String? value) => _is.ColumnValue(
    table.userName,
    value,
  );

  _is.ColumnValue<String, String> fullName(String? value) => _is.ColumnValue(
    table.fullName,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> imageId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.imageId,
        value,
      );
}

class UserProfileTable extends _is.Table<_is.UuidValue?> {
  UserProfileTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_profile') {
    updateTable = UserProfileUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    userName = _is.ColumnString(
      'userName',
      this,
    );
    fullName = _is.ColumnString(
      'fullName',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    imageId = _is.ColumnUuid(
      'imageId',
      this,
    );
  }

  late final UserProfileUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to.
  _ivyervu7.AuthUserTable? _authUser;

  /// The first name of the user or the user's nickname.
  late final _is.ColumnString userName;

  /// The full name of the user.
  late final _is.ColumnString fullName;

  /// The verified email address of the user.
  ///
  /// This should only be set by authentication providers that have
  /// checked ownership of this email for the user.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  /// The time when this user was created.
  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnUuid imageId;

  /// The user's profile image.
  _i7y29ltp.UserProfileImageTable? _image;

  _ivyervu7.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: UserProfile.t.authUserId,
      foreignField: _ivyervu7.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivyervu7.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i7y29ltp.UserProfileImageTable get image {
    if (_image != null) return _image!;
    _image = _is.createRelationTable(
      relationFieldName: 'image',
      field: UserProfile.t.imageId,
      foreignField: _i7y29ltp.UserProfileImage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7y29ltp.UserProfileImageTable(tableRelation: foreignTableRelation),
    );
    return _image!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    userName,
    fullName,
    email,
    createdAt,
    imageId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'image') {
      return image;
    }
    return null;
  }
}

class UserProfileInclude extends _is.IncludeObject {
  UserProfileInclude._({
    _ivyervu7.AuthUserInclude? authUser,
    _i7y29ltp.UserProfileImageInclude? image,
    this.selectedColumns,
  }) {
    _authUser = authUser;
    _image = image;
  }

  _ivyervu7.AuthUserInclude? _authUser;

  _i7y29ltp.UserProfileImageInclude? _image;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'authUser': _authUser,
    'image': _image,
  };

  @override
  _is.Table<_is.UuidValue?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _is.IncludeList {
  UserProfileIncludeList._({
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  final attachRow = const UserProfileAttachRowRepository._();

  final detachRow = const UserProfileDetachRowRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
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
  Future<List<UserProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
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
  Future<UserProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    UserProfileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserProfile>(
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
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileInclude? include,
    _is.SelectColumnsBuilder<UserProfileTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfile.t),
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
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    UserProfileInclude? include,
    _is.SelectColumnsBuilder<UserProfileTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfile.t),
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
    UserProfileInclude? include,
    _is.SelectColumnsBuilder<UserProfileTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserProfile>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(UserProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
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
  Future<List<UserProfile>> insert(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserProfile]s in the list and returns the resulting rows.
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
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> upsert(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    required _is.ColumnSelections<UserProfileTable> conflictColumns,
    _is.ColumnSelections<UserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserProfile>(
      rows,
      conflictColumns: conflictColumns(UserProfile.t),
      updateColumns: updateColumns?.call(UserProfile.t),
      updateWhere: updateWhere?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserProfile] and returns the resulting row.
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
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile?> upsertRow(
    _is.DatabaseSession session,
    UserProfile row, {
    required _is.ColumnSelections<UserProfileTable> conflictColumns,
    _is.ColumnSelections<UserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserProfile>(
      row,
      conflictColumns: conflictColumns(UserProfile.t),
      updateColumns: updateColumns?.call(UserProfile.t),
      updateWhere: updateWhere?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> update(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.ColumnSelections<UserProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.ColumnSelections<UserProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
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
  Future<List<UserProfile>> delete(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
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
  Future<List<UserProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserProfile>(
      where: where(UserProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserProfileAttachRowRepository {
  const UserProfileAttachRowRepository._();

  /// Creates a relation between the given [UserProfile] and [AuthUser]
  /// by setting the [UserProfile]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    UserProfile userProfile,
    _ivyervu7.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (userProfile.id == null) {
      throw ArgumentError.notNull('userProfile.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $userProfile = userProfile.copyWith(authUserId: authUser.id);
    await session.db.updateRow<UserProfile>(
      $userProfile,
      columns: [UserProfile.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [UserProfile] and [UserProfileImage]
  /// by setting the [UserProfile]'s foreign key `imageId` to refer to the [UserProfileImage].
  Future<void> image(
    _is.DatabaseSession session,
    UserProfile userProfile,
    _i7y29ltp.UserProfileImage image, {
    _is.Transaction? transaction,
  }) async {
    if (userProfile.id == null) {
      throw ArgumentError.notNull('userProfile.id');
    }
    if (image.id == null) {
      throw ArgumentError.notNull('image.id');
    }

    var $userProfile = userProfile.copyWith(imageId: image.id);
    await session.db.updateRow<UserProfile>(
      $userProfile,
      columns: [UserProfile.t.imageId],
      transaction: transaction,
    );
  }
}

class UserProfileDetachRowRepository {
  const UserProfileDetachRowRepository._();

  /// Detaches the relation between this [UserProfile] and the [UserProfileImage] set in `image`
  /// by setting the [UserProfile]'s foreign key `imageId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> image(
    _is.DatabaseSession session,
    UserProfile userProfile, {
    _is.Transaction? transaction,
  }) async {
    if (userProfile.id == null) {
      throw ArgumentError.notNull('userProfile.id');
    }

    var $userProfile = userProfile.copyWith(imageId: null);
    await session.db.updateRow<UserProfile>(
      $userProfile,
      columns: [UserProfile.t.imageId],
      transaction: transaction,
    );
  }
}
