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
import 'user_profile_image.dart' as _i3;

abstract class UserProfile
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.userName,
    this.fullName,
    this.email,
    DateTime? created,
    this.imageId,
    this.image,
  }) : created = created ?? DateTime.now();

  factory UserProfile({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      imageId: jsonSerialization['imageId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['imageId']),
      image: jsonSerialization['image'] == null
          ? null
          : _i3.UserProfileImage.fromJson(
              (jsonSerialization['image'] as Map<String, dynamic>)),
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to.
  _i2.AuthUser? authUser;

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
  DateTime created;

  _i1.UuidValue? imageId;

  /// The user's profile image.
  _i3.UserProfileImage? image;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageId != null) 'imageId': imageId?.toJson(),
      if (image != null) 'image': image?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static UserProfileInclude include({
    _i2.AuthUserInclude? authUser,
    _i3.UserProfileImageInclude? image,
  }) {
    return UserProfileInclude._(
      authUser: authUser,
      image: image,
    );
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          userName: userName,
          fullName: fullName,
          email: email,
          created: created,
          imageId: imageId,
          image: image,
        );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageId = _Undefined,
    Object? image = _Undefined,
  }) {
    return UserProfile(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      imageId: imageId is _i1.UuidValue? ? imageId : this.imageId,
      image: image is _i3.UserProfileImage? ? image : this.image?.copyWith(),
    );
  }
}

class UserProfileTable extends _i1.Table<_i1.UuidValue?> {
  UserProfileTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_profile_user_profile') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    imageId = _i1.ColumnUuid(
      'imageId',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to.
  _i2.AuthUserTable? _authUser;

  /// The first name of the user or the user's nickname.
  late final _i1.ColumnString userName;

  /// The full name of the user.
  late final _i1.ColumnString fullName;

  /// The verified email address of the user.
  ///
  /// This should only be set by authentication providers that have
  /// checked ownership of this email for the user.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The time when this user was created.
  late final _i1.ColumnDateTime created;

  late final _i1.ColumnUuid imageId;

  /// The user's profile image.
  _i3.UserProfileImageTable? _image;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: UserProfile.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i3.UserProfileImageTable get image {
    if (_image != null) return _image!;
    _image = _i1.createRelationTable(
      relationFieldName: 'image',
      field: UserProfile.t.imageId,
      foreignField: _i3.UserProfileImage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserProfileImageTable(tableRelation: foreignTableRelation),
    );
    return _image!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        authUserId,
        userName,
        fullName,
        email,
        created,
        imageId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'image') {
      return image;
    }
    return null;
  }
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._({
    _i2.AuthUserInclude? authUser,
    _i3.UserProfileImageInclude? image,
  }) {
    _authUser = authUser;
    _image = image;
  }

  _i2.AuthUserInclude? _authUser;

  _i3.UserProfileImageInclude? _image;

  @override
  Map<String, _i1.Include?> get includes => {
        'authUser': _authUser,
        'image': _image,
      };

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfile.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
    UserProfileInclude? include,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
    UserProfileInclude? include,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    UserProfileInclude? include,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserProfileAttachRowRepository {
  const UserProfileAttachRowRepository._();

  /// Creates a relation between the given [UserProfile] and [AuthUser]
  /// by setting the [UserProfile]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    UserProfile userProfile,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
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
    _i1.Session session,
    UserProfile userProfile,
    _i3.UserProfileImage image, {
    _i1.Transaction? transaction,
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
    _i1.Session session,
    UserProfile userprofile, {
    _i1.Transaction? transaction,
  }) async {
    if (userprofile.id == null) {
      throw ArgumentError.notNull('userprofile.id');
    }

    var $userprofile = userprofile.copyWith(imageId: null);
    await session.db.updateRow<UserProfile>(
      $userprofile,
      columns: [UserProfile.t.imageId],
      transaction: transaction,
    );
  }
}
