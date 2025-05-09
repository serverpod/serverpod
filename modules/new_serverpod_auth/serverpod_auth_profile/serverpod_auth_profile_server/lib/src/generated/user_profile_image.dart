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

abstract class UserProfileImage
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserProfileImage._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.version,
    required this.url,
  });

  factory UserProfileImage({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required int version,
    required String url,
  }) = _UserProfileImageImpl;

  factory UserProfileImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileImage(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      version: jsonSerialization['version'] as int,
      url: jsonSerialization['url'] as String,
    );
  }

  static final t = UserProfileImageTable();

  static const db = UserProfileImageRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile image belongs to
  _i2.AuthUser? authUser;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileImage copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    int? version,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'version': version,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static UserProfileImageInclude include({_i2.AuthUserInclude? authUser}) {
    return UserProfileImageInclude._(authUser: authUser);
  }

  static UserProfileImageIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileImageTable>? orderByList,
    UserProfileImageInclude? include,
  }) {
    return UserProfileImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfileImage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfileImage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImageImpl extends UserProfileImage {
  _UserProfileImageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required int version,
    required String url,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          version: version,
          url: url,
        );

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileImage copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    int? version,
    String? url,
  }) {
    return UserProfileImage(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}

class UserProfileImageTable extends _i1.Table<_i1.UuidValue?> {
  UserProfileImageTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_profile_user_profile_image') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile image belongs to
  _i2.AuthUserTable? _authUser;

  /// Version of the image. Increased by one for every uploaded image.
  late final _i1.ColumnInt version;

  /// The URL to the image.
  late final _i1.ColumnString url;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: UserProfileImage.t.authUserId,
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
        version,
        url,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class UserProfileImageInclude extends _i1.IncludeObject {
  UserProfileImageInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfileImage.t;
}

class UserProfileImageIncludeList extends _i1.IncludeList {
  UserProfileImageIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfileImage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfileImage.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _i1.Transaction? transaction,
    UserProfileImageInclude? include,
  }) async {
    return session.db.find<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileImageTable>? orderByList,
    _i1.Transaction? transaction,
    UserProfileImageInclude? include,
  }) async {
    return session.db.findFirstRow<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      orderBy: orderBy?.call(UserProfileImage.t),
      orderByList: orderByList?.call(UserProfileImage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserProfileImage] by its [id] or null if no such row exists.
  Future<UserProfileImage?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    UserProfileImageInclude? include,
  }) async {
    return session.db.findById<UserProfileImage>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserProfileImage]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfileImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfileImage>> insert(
    _i1.Session session,
    List<UserProfileImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfileImage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfileImage] and returns the inserted row.
  ///
  /// The returned [UserProfileImage] will have its `id` field set.
  Future<UserProfileImage> insertRow(
    _i1.Session session,
    UserProfileImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfileImage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfileImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfileImage>> update(
    _i1.Session session,
    List<UserProfileImage> rows, {
    _i1.ColumnSelections<UserProfileImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfileImage>(
      rows,
      columns: columns?.call(UserProfileImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfileImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfileImage> updateRow(
    _i1.Session session,
    UserProfileImage row, {
    _i1.ColumnSelections<UserProfileImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfileImage>(
      row,
      columns: columns?.call(UserProfileImage.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfileImage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfileImage>> delete(
    _i1.Session session,
    List<UserProfileImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfileImage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfileImage].
  Future<UserProfileImage> deleteRow(
    _i1.Session session,
    UserProfileImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfileImage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfileImage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfileImage>(
      where: where(UserProfileImage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileImageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfileImage>(
      where: where?.call(UserProfileImage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserProfileImageAttachRowRepository {
  const UserProfileImageAttachRowRepository._();

  /// Creates a relation between the given [UserProfileImage] and [AuthUser]
  /// by setting the [UserProfileImage]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    UserProfileImage userProfileImage,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (userProfileImage.id == null) {
      throw ArgumentError.notNull('userProfileImage.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $userProfileImage = userProfileImage.copyWith(authUserId: authUser.id);
    await session.db.updateRow<UserProfileImage>(
      $userProfileImage,
      columns: [UserProfileImage.t.authUserId],
      transaction: transaction,
    );
  }
}
