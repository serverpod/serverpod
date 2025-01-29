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
import '../../long_identifiers/models_with_relations/user_note.dart' as _i2;

abstract class UserNoteCollection
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UserNoteCollection._({
    this.id,
    required this.name,
    this.userNotesPropertyName,
  });

  factory UserNoteCollection({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) = _UserNoteCollectionImpl;

  factory UserNoteCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNoteCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      userNotesPropertyName:
          (jsonSerialization['userNotesPropertyName'] as List?)
              ?.map((e) => _i2.UserNote.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  static final t = UserNoteCollectionTable();

  static const db = UserNoteCollectionRepository._();

  @override
  int? id;

  String name;

  List<_i2.UserNote>? userNotesPropertyName;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserNoteCollection copyWith({
    int? id,
    String? name,
    List<_i2.UserNote>? userNotesPropertyName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName':
            userNotesPropertyName?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName': userNotesPropertyName?.toJson(
            valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static UserNoteCollectionInclude include(
      {_i2.UserNoteIncludeList? userNotesPropertyName}) {
    return UserNoteCollectionInclude._(
        userNotesPropertyName: userNotesPropertyName);
  }

  static UserNoteCollectionIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    UserNoteCollectionInclude? include,
  }) {
    return UserNoteCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteCollection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteCollectionImpl extends UserNoteCollection {
  _UserNoteCollectionImpl({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) : super._(
          id: id,
          name: name,
          userNotesPropertyName: userNotesPropertyName,
        );

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserNoteCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? userNotesPropertyName = _Undefined,
  }) {
    return UserNoteCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      userNotesPropertyName: userNotesPropertyName is List<_i2.UserNote>?
          ? userNotesPropertyName
          : this.userNotesPropertyName?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class UserNoteCollectionTable extends _i1.Table {
  UserNoteCollectionTable({super.tableRelation})
      : super(tableName: 'user_note_collections') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.UserNoteTable? ___userNotesPropertyName;

  _i1.ManyRelation<_i2.UserNoteTable>? _userNotesPropertyName;

  _i2.UserNoteTable get __userNotesPropertyName {
    if (___userNotesPropertyName != null) return ___userNotesPropertyName!;
    ___userNotesPropertyName = _i1.createRelationTable(
      relationFieldName: '__userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _i2.UserNote.t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteTable(tableRelation: foreignTableRelation),
    );
    return ___userNotesPropertyName!;
  }

  _i1.ManyRelation<_i2.UserNoteTable> get userNotesPropertyName {
    if (_userNotesPropertyName != null) return _userNotesPropertyName!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _i2.UserNote.t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteTable(tableRelation: foreignTableRelation),
    );
    _userNotesPropertyName = _i1.ManyRelation<_i2.UserNoteTable>(
      tableWithRelations: relationTable,
      table: _i2.UserNoteTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _userNotesPropertyName!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userNotesPropertyName') {
      return __userNotesPropertyName;
    }
    return null;
  }
}

class UserNoteCollectionInclude extends _i1.IncludeObject {
  UserNoteCollectionInclude._(
      {_i2.UserNoteIncludeList? userNotesPropertyName}) {
    _userNotesPropertyName = userNotesPropertyName;
  }

  _i2.UserNoteIncludeList? _userNotesPropertyName;

  @override
  Map<String, _i1.Include?> get includes =>
      {'userNotesPropertyName': _userNotesPropertyName};

  @override
  _i1.Table get table => UserNoteCollection.t;
}

class UserNoteCollectionIncludeList extends _i1.IncludeList {
  UserNoteCollectionIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteCollection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteCollection.t;
}

class UserNoteCollectionRepository {
  const UserNoteCollectionRepository._();

  final attach = const UserNoteCollectionAttachRepository._();

  final attachRow = const UserNoteCollectionAttachRowRepository._();

  final detach = const UserNoteCollectionDetachRepository._();

  final detachRow = const UserNoteCollectionDetachRowRepository._();

  /// Returns a list of [UserNoteCollection]s matching the given query parameters.
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
  Future<List<UserNoteCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.db.find<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [UserNoteCollection] matching the given query parameters.
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
  Future<UserNoteCollection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.db.findFirstRow<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserNoteCollection] by its [id] or null if no such row exists.
  Future<UserNoteCollection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.db.findById<UserNoteCollection>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserNoteCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNoteCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserNoteCollection>> insert(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNoteCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserNoteCollection] and returns the inserted row.
  ///
  /// The returned [UserNoteCollection] will have its `id` field set.
  Future<UserNoteCollection> insertRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserNoteCollection>> update(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNoteCollection>(
      rows,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNoteCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNoteCollection> updateRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteCollection>(
      row,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserNoteCollection]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserNoteCollection>> delete(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNoteCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserNoteCollection].
  Future<UserNoteCollection> deleteRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserNoteCollection>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteCollectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNoteCollection>(
      where: where(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionAttachRepository {
  const UserNoteCollectionAttachRepository._();

  /// Creates a relation between this [UserNoteCollection] and the given [UserNote]s
  /// by setting each [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to refer to this [UserNoteCollection].
  Future<void> userNotesPropertyName(
    _i1.Session session,
    UserNoteCollection userNoteCollection,
    List<_i2.UserNote> userNote, {
    _i1.Transaction? transaction,
  }) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = userNote
        .map((e) => _i2.UserNoteImplicit(
              e,
              $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                  userNoteCollection.id,
            ))
        .toList();
    await session.db.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionAttachRowRepository {
  const UserNoteCollectionAttachRowRepository._();

  /// Creates a relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to refer to this [UserNoteCollection].
  Future<void> userNotesPropertyName(
    _i1.Session session,
    UserNoteCollection userNoteCollection,
    _i2.UserNote userNote, {
    _i1.Transaction? transaction,
  }) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = _i2.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          userNoteCollection.id,
    );
    await session.db.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionDetachRepository {
  const UserNoteCollectionDetachRepository._();

  /// Detaches the relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userNotesPropertyName(
    _i1.Session session,
    List<_i2.UserNote> userNote, {
    _i1.Transaction? transaction,
  }) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = userNote
        .map((e) => _i2.UserNoteImplicit(
              e,
              $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                  null,
            ))
        .toList();
    await session.db.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionDetachRowRepository {
  const UserNoteCollectionDetachRowRepository._();

  /// Detaches the relation between this [UserNoteCollection] and the given [UserNote]
  /// by setting the [UserNote]'s foreign key `_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userNotesPropertyName(
    _i1.Session session,
    _i2.UserNote userNote, {
    _i1.Transaction? transaction,
  }) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = _i2.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId: null,
    );
    await session.db.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction,
    );
  }
}
