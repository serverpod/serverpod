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
import 'user_profile.dart' as _i2;

abstract class UserProfileImage
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserProfileImage._({
    this.id,
    required this.userProfileId,
    this.userProfile,
    DateTime? created,
    required this.storageId,
    required this.path,
    required this.url,
  }) : created = created ?? DateTime.now();

  factory UserProfileImage({
    _i1.UuidValue? id,
    required _i1.UuidValue userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? created,
    required String storageId,
    required String path,
    required Uri url,
  }) = _UserProfileImageImpl;

  factory UserProfileImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileImage(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userProfileId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['userProfileId']),
      userProfile: jsonSerialization['userProfile'] == null
          ? null
          : _i2.UserProfile.fromJson(
              (jsonSerialization['userProfile'] as Map<String, dynamic>)),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      url: _i1.UriJsonExtension.fromJson(jsonSerialization['url']),
    );
  }

  static final t = UserProfileImageTable();

  static const db = UserProfileImageRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userProfileId;

  /// The [UserProfile] this image belongs to.
  _i2.UserProfile? userProfile;

  /// The time when this profile image was created.
  DateTime created;

  /// Storage in which the image is stored.
  String storageId;

  /// Path inside [storageId] at which the image is stored.
  String path;

  /// The public URL to access the image.
  Uri url;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileImage copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? created,
    String? storageId,
    String? path,
    Uri? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userProfileId': userProfileId.toJson(),
      if (userProfile != null) 'userProfile': userProfile?.toJson(),
      'created': created.toJson(),
      'storageId': storageId,
      'path': path,
      'url': url.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static UserProfileImageInclude include(
      {_i2.UserProfileInclude? userProfile}) {
    return UserProfileImageInclude._(userProfile: userProfile);
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
    required _i1.UuidValue userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? created,
    required String storageId,
    required String path,
    required Uri url,
  }) : super._(
          id: id,
          userProfileId: userProfileId,
          userProfile: userProfile,
          created: created,
          storageId: storageId,
          path: path,
          url: url,
        );

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileImage copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userProfileId,
    Object? userProfile = _Undefined,
    DateTime? created,
    String? storageId,
    String? path,
    Uri? url,
  }) {
    return UserProfileImage(
      id: id is _i1.UuidValue? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      userProfile: userProfile is _i2.UserProfile?
          ? userProfile
          : this.userProfile?.copyWith(),
      created: created ?? this.created,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}

class UserProfileImageTable extends _i1.Table<_i1.UuidValue?> {
  UserProfileImageTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_profile_user_profile_image') {
    userProfileId = _i1.ColumnUuid(
      'userProfileId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    storageId = _i1.ColumnString(
      'storageId',
      this,
    );
    path = _i1.ColumnString(
      'path',
      this,
    );
    url = _i1.ColumnUri(
      'url',
      this,
    );
  }

  late final _i1.ColumnUuid userProfileId;

  /// The [UserProfile] this image belongs to.
  _i2.UserProfileTable? _userProfile;

  /// The time when this profile image was created.
  late final _i1.ColumnDateTime created;

  /// Storage in which the image is stored.
  late final _i1.ColumnString storageId;

  /// Path inside [storageId] at which the image is stored.
  late final _i1.ColumnString path;

  /// The public URL to access the image.
  late final _i1.ColumnUri url;

  _i2.UserProfileTable get userProfile {
    if (_userProfile != null) return _userProfile!;
    _userProfile = _i1.createRelationTable(
      relationFieldName: 'userProfile',
      field: UserProfileImage.t.userProfileId,
      foreignField: _i2.UserProfile.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserProfileTable(tableRelation: foreignTableRelation),
    );
    return _userProfile!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userProfileId,
        created,
        storageId,
        path,
        url,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userProfile') {
      return userProfile;
    }
    return null;
  }
}

class UserProfileImageInclude extends _i1.IncludeObject {
  UserProfileImageInclude._({_i2.UserProfileInclude? userProfile}) {
    _userProfile = userProfile;
  }

  _i2.UserProfileInclude? _userProfile;

  @override
  Map<String, _i1.Include?> get includes => {'userProfile': _userProfile};

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

  /// Creates a relation between the given [UserProfileImage] and [UserProfile]
  /// by setting the [UserProfileImage]'s foreign key `userProfileId` to refer to the [UserProfile].
  Future<void> userProfile(
    _i1.Session session,
    UserProfileImage userProfileImage,
    _i2.UserProfile userProfile, {
    _i1.Transaction? transaction,
  }) async {
    if (userProfileImage.id == null) {
      throw ArgumentError.notNull('userProfileImage.id');
    }
    if (userProfile.id == null) {
      throw ArgumentError.notNull('userProfile.id');
    }

    var $userProfileImage =
        userProfileImage.copyWith(userProfileId: userProfile.id);
    await session.db.updateRow<UserProfileImage>(
      $userProfileImage,
      columns: [UserProfileImage.t.userProfileId],
      transaction: transaction,
    );
  }
}
