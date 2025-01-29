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
import '../../long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i2;

abstract class UserNoteCollectionWithALongName
    implements _i1.TableRow, _i1.ProtocolSerialization {
  UserNoteCollectionWithALongName._({
    this.id,
    required this.name,
    this.notes,
  });

  factory UserNoteCollectionWithALongName({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) = _UserNoteCollectionWithALongNameImpl;

  factory UserNoteCollectionWithALongName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UserNoteCollectionWithALongName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      notes: (jsonSerialization['notes'] as List?)
          ?.map((e) =>
              _i2.UserNoteWithALongName.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = UserNoteCollectionWithALongNameTable();

  static const db = UserNoteCollectionWithALongNameRepository._();

  @override
  int? id;

  String name;

  List<_i2.UserNoteWithALongName>? notes;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [UserNoteCollectionWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserNoteCollectionWithALongName copyWith({
    int? id,
    String? name,
    List<_i2.UserNoteWithALongName>? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (notes != null) 'notes': notes?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (notes != null)
        'notes': notes?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static UserNoteCollectionWithALongNameInclude include(
      {_i2.UserNoteWithALongNameIncludeList? notes}) {
    return UserNoteCollectionWithALongNameInclude._(notes: notes);
  }

  static UserNoteCollectionWithALongNameIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    UserNoteCollectionWithALongNameInclude? include,
  }) {
    return UserNoteCollectionWithALongNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteCollectionWithALongNameImpl
    extends UserNoteCollectionWithALongName {
  _UserNoteCollectionWithALongNameImpl({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) : super._(
          id: id,
          name: name,
          notes: notes,
        );

  /// Returns a shallow copy of this [UserNoteCollectionWithALongName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserNoteCollectionWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? notes = _Undefined,
  }) {
    return UserNoteCollectionWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      notes: notes is List<_i2.UserNoteWithALongName>?
          ? notes
          : this.notes?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class UserNoteCollectionWithALongNameTable extends _i1.Table {
  UserNoteCollectionWithALongNameTable({super.tableRelation})
      : super(tableName: 'user_note_collection_with_a_long_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.UserNoteWithALongNameTable? ___notes;

  _i1.ManyRelation<_i2.UserNoteWithALongNameTable>? _notes;

  _i2.UserNoteWithALongNameTable get __notes {
    if (___notes != null) return ___notes!;
    ___notes = _i1.createRelationTable(
      relationFieldName: '__notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _i2.UserNoteWithALongName.t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteWithALongNameTable(tableRelation: foreignTableRelation),
    );
    return ___notes!;
  }

  _i1.ManyRelation<_i2.UserNoteWithALongNameTable> get notes {
    if (_notes != null) return _notes!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _i2.UserNoteWithALongName.t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteWithALongNameTable(tableRelation: foreignTableRelation),
    );
    _notes = _i1.ManyRelation<_i2.UserNoteWithALongNameTable>(
      tableWithRelations: relationTable,
      table: _i2.UserNoteWithALongNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _notes!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'notes') {
      return __notes;
    }
    return null;
  }
}

class UserNoteCollectionWithALongNameInclude extends _i1.IncludeObject {
  UserNoteCollectionWithALongNameInclude._(
      {_i2.UserNoteWithALongNameIncludeList? notes}) {
    _notes = notes;
  }

  _i2.UserNoteWithALongNameIncludeList? _notes;

  @override
  Map<String, _i1.Include?> get includes => {'notes': _notes};

  @override
  _i1.Table get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameIncludeList extends _i1.IncludeList {
  UserNoteCollectionWithALongNameIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteCollectionWithALongName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameRepository {
  const UserNoteCollectionWithALongNameRepository._();

  final attach = const UserNoteCollectionWithALongNameAttachRepository._();

  final attachRow =
      const UserNoteCollectionWithALongNameAttachRowRepository._();

  final detach = const UserNoteCollectionWithALongNameDetachRepository._();

  final detachRow =
      const UserNoteCollectionWithALongNameDetachRowRepository._();

  /// Returns a list of [UserNoteCollectionWithALongName]s matching the given query parameters.
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
  Future<List<UserNoteCollectionWithALongName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.find<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [UserNoteCollectionWithALongName] matching the given query parameters.
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
  Future<UserNoteCollectionWithALongName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.findFirstRow<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserNoteCollectionWithALongName] by its [id] or null if no such row exists.
  Future<UserNoteCollectionWithALongName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.findById<UserNoteCollectionWithALongName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserNoteCollectionWithALongName]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNoteCollectionWithALongName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserNoteCollectionWithALongName>> insert(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNoteCollectionWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserNoteCollectionWithALongName] and returns the inserted row.
  ///
  /// The returned [UserNoteCollectionWithALongName] will have its `id` field set.
  Future<UserNoteCollectionWithALongName> insertRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteCollectionWithALongName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserNoteCollectionWithALongName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserNoteCollectionWithALongName>> update(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNoteCollectionWithALongName>(
      rows,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNoteCollectionWithALongName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNoteCollectionWithALongName> updateRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteCollectionWithALongName>(
      row,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserNoteCollectionWithALongName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserNoteCollectionWithALongName>> delete(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNoteCollectionWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserNoteCollectionWithALongName].
  Future<UserNoteCollectionWithALongName> deleteRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteCollectionWithALongName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserNoteCollectionWithALongName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNoteCollectionWithALongName>(
      where: where(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameAttachRepository {
  const UserNoteCollectionWithALongNameAttachRepository._();

  /// Creates a relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]s
  /// by setting each [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to refer to this [UserNoteCollectionWithALongName].
  Future<void> notes(
    _i1.Session session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    List<_i2.UserNoteWithALongName> userNoteWithALongName, {
    _i1.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map((e) => _i2.UserNoteWithALongNameImplicit(
              e,
              $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                  userNoteCollectionWithALongName.id,
            ))
        .toList();
    await session.db.update<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameAttachRowRepository {
  const UserNoteCollectionWithALongNameAttachRowRepository._();

  /// Creates a relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to refer to this [UserNoteCollectionWithALongName].
  Future<void> notes(
    _i1.Session session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    _i2.UserNoteWithALongName userNoteWithALongName, {
    _i1.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = _i2.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
          userNoteCollectionWithALongName.id,
    );
    await session.db.updateRow<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameDetachRepository {
  const UserNoteCollectionWithALongNameDetachRepository._();

  /// Detaches the relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> notes(
    _i1.Session session,
    List<_i2.UserNoteWithALongName> userNoteWithALongName, {
    _i1.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map((e) => _i2.UserNoteWithALongNameImplicit(
              e,
              $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                  null,
            ))
        .toList();
    await session.db.update<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameDetachRowRepository {
  const UserNoteCollectionWithALongNameDetachRowRepository._();

  /// Detaches the relation between this [UserNoteCollectionWithALongName] and the given [UserNoteWithALongName]
  /// by setting the [UserNoteWithALongName]'s foreign key `_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> notes(
    _i1.Session session,
    _i2.UserNoteWithALongName userNoteWithALongName, {
    _i1.Transaction? transaction,
  }) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = _i2.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId: null,
    );
    await session.db.updateRow<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
      transaction: transaction,
    );
  }
}
