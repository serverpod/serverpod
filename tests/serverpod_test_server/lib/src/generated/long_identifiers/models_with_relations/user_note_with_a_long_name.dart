/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UserNoteWithALongName
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UserNoteWithALongName._({
    this.id,
    required this.name,
  });

  factory UserNoteWithALongName({
    int? id,
    required String name,
  }) = _UserNoteWithALongNameImpl;

  factory UserNoteWithALongName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UserNoteWithALongName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = UserNoteWithALongNameTable();

  static const db = UserNoteWithALongNameRepository._();

  @override
  int? id;

  String name;

  int? _userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UserNoteWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserNoteWithALongName copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId !=
          null)
        '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId':
            _userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static UserNoteWithALongNameInclude include() {
    return UserNoteWithALongNameInclude._();
  }

  static UserNoteWithALongNameIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    UserNoteWithALongNameInclude? include,
  }) {
    return UserNoteWithALongNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteWithALongNameImpl extends UserNoteWithALongName {
  _UserNoteWithALongNameImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  /// Returns a shallow copy of this [UserNoteWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserNoteWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNoteWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class UserNoteWithALongNameImplicit extends _UserNoteWithALongNameImpl {
  UserNoteWithALongNameImplicit._({
    int? id,
    required String name,
    this.$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
  }) : super(
          id: id,
          name: name,
        );

  factory UserNoteWithALongNameImplicit(
    UserNoteWithALongName userNoteWithALongName, {
    int? $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
  }) {
    return UserNoteWithALongNameImplicit._(
      id: userNoteWithALongName.id,
      name: userNoteWithALongName.name,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
          $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
    );
  }

  int? $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  Map<String, dynamic> toJson() {
    var jsonMap = super.toJson();
    jsonMap.addAll({
      '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId':
          $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
    });
    return jsonMap;
  }
}

class UserNoteWithALongNameTable extends _i1.Table {
  UserNoteWithALongNameTable({super.tableRelation})
      : super(tableName: 'user_note_with_a_long_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId =
        _i1.ColumnInt(
      '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ];
}

class UserNoteWithALongNameInclude extends _i1.IncludeObject {
  UserNoteWithALongNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UserNoteWithALongName.t;
}

class UserNoteWithALongNameIncludeList extends _i1.IncludeList {
  UserNoteWithALongNameIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteWithALongName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteWithALongName.t;
}

class UserNoteWithALongNameRepository {
  const UserNoteWithALongNameRepository._();

  /// Returns a list of [UserNoteWithALongName]s matching the given query parameters.
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
  Future<List<UserNoteWithALongName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserNoteWithALongName] matching the given query parameters.
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
  Future<UserNoteWithALongName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserNoteWithALongName] by its [id] or null if no such row exists.
  Future<UserNoteWithALongName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserNoteWithALongName>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserNoteWithALongName]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNoteWithALongName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserNoteWithALongName>> insert(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNoteWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserNoteWithALongName] and returns the inserted row.
  ///
  /// The returned [UserNoteWithALongName] will have its `id` field set.
  Future<UserNoteWithALongName> insertRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteWithALongName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteWithALongName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserNoteWithALongName>> update(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.ColumnSelections<UserNoteWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNoteWithALongName>(
      rows,
      columns: columns?.call(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNoteWithALongName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNoteWithALongName> updateRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.ColumnSelections<UserNoteWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteWithALongName>(
      row,
      columns: columns?.call(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserNoteWithALongName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserNoteWithALongName>> delete(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNoteWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserNoteWithALongName].
  Future<UserNoteWithALongName> deleteRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteWithALongName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserNoteWithALongName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteWithALongNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNoteWithALongName>(
      where: where(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
