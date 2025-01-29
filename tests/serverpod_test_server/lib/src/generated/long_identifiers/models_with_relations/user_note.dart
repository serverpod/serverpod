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

abstract class UserNote implements _i1.TableRow, _i1.ProtocolSerialization {
  UserNote._({
    this.id,
    required this.name,
  });

  factory UserNote({
    int? id,
    required String name,
  }) = _UserNoteImpl;

  factory UserNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNote(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = UserNoteTable();

  static const db = UserNoteRepository._();

  @override
  int? id;

  String name;

  int? _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UserNote]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserNote copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId !=
          null)
        '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId':
            _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static UserNoteInclude include() {
    return UserNoteInclude._();
  }

  static UserNoteIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteTable>? orderByList,
    UserNoteInclude? include,
  }) {
    return UserNoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNote.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteImpl extends UserNote {
  _UserNoteImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  /// Returns a shallow copy of this [UserNote]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserNote copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNote(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class UserNoteImplicit extends _UserNoteImpl {
  UserNoteImplicit._({
    int? id,
    required String name,
    this.$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
  }) : super(
          id: id,
          name: name,
        );

  factory UserNoteImplicit(
    UserNote userNote, {
    int? $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
  }) {
    return UserNoteImplicit._(
      id: userNote.id,
      name: userNote.name,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
    );
  }

  int? $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;

  @override
  Map<String, dynamic> toJson() {
    var jsonMap = super.toJson();
    jsonMap.addAll({
      '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId':
          $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
    });
    return jsonMap;
  }
}

class UserNoteTable extends _i1.Table {
  UserNoteTable({super.tableRelation}) : super(tableName: 'user_note') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId =
        _i1.ColumnInt(
      '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      ];
}

class UserNoteInclude extends _i1.IncludeObject {
  UserNoteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UserNote.t;
}

class UserNoteIncludeList extends _i1.IncludeList {
  UserNoteIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNote.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNote.t;
}

class UserNoteRepository {
  const UserNoteRepository._();

  /// Returns a list of [UserNote]s matching the given query parameters.
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
  Future<List<UserNote>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserNote] matching the given query parameters.
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
  Future<UserNote?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserNote] by its [id] or null if no such row exists.
  Future<UserNote?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserNote>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserNote]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserNote>> insert(
    _i1.Session session,
    List<UserNote> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNote>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserNote] and returns the inserted row.
  ///
  /// The returned [UserNote] will have its `id` field set.
  Future<UserNote> insertRow(
    _i1.Session session,
    UserNote row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNote>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserNote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserNote>> update(
    _i1.Session session,
    List<UserNote> rows, {
    _i1.ColumnSelections<UserNoteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNote>(
      rows,
      columns: columns?.call(UserNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNote> updateRow(
    _i1.Session session,
    UserNote row, {
    _i1.ColumnSelections<UserNoteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNote>(
      row,
      columns: columns?.call(UserNote.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserNote]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserNote>> delete(
    _i1.Session session,
    List<UserNote> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNote>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserNote].
  Future<UserNote> deleteRow(
    _i1.Session session,
    UserNote row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNote>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserNote>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNote>(
      where: where(UserNote.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNote>(
      where: where?.call(UserNote.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
