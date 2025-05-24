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

/// A greeting message which can be sent to or from the server.
abstract class Greeting
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Greeting._({
    this.id,
    required this.message,
    required this.author,
    required this.timestamp,
  });

  factory Greeting({
    int? id,
    required String message,
    required String author,
    required DateTime timestamp,
  }) = _GreetingImpl;

  factory Greeting.fromJson(Map<String, dynamic> jsonSerialization) {
    return Greeting(
      id: jsonSerialization['id'] as int?,
      message: jsonSerialization['message'] as String,
      author: jsonSerialization['author'] as String,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = GreetingTable();

  static const db = GreetingRepository._();

  @override
  int? id;

  /// The greeting message.
  String message;

  /// The author of the greeting message.
  String author;

  /// The time when the message was created.
  DateTime timestamp;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Greeting]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Greeting copyWith({
    int? id,
    String? message,
    String? author,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'message': message,
      'author': author,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'message': message,
      'author': author,
      'timestamp': timestamp.toJson(),
    };
  }

  static GreetingInclude include() {
    return GreetingInclude._();
  }

  static GreetingIncludeList includeList({
    _i1.WhereExpressionBuilder<GreetingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GreetingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreetingTable>? orderByList,
    GreetingInclude? include,
  }) {
    return GreetingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Greeting.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Greeting.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GreetingImpl extends Greeting {
  _GreetingImpl({
    int? id,
    required String message,
    required String author,
    required DateTime timestamp,
  }) : super._(
          id: id,
          message: message,
          author: author,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [Greeting]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Greeting copyWith({
    Object? id = _Undefined,
    String? message,
    String? author,
    DateTime? timestamp,
  }) {
    return Greeting(
      id: id is int? ? id : this.id,
      message: message ?? this.message,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class GreetingTable extends _i1.Table<int?> {
  GreetingTable({super.tableRelation}) : super(tableName: 'greeting') {
    message = _i1.ColumnString(
      'message',
      this,
    );
    author = _i1.ColumnString(
      'author',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  /// The greeting message.
  late final _i1.ColumnString message;

  /// The author of the greeting message.
  late final _i1.ColumnString author;

  /// The time when the message was created.
  late final _i1.ColumnDateTime timestamp;

  @override
  List<_i1.Column> get columns => [
        id,
        message,
        author,
        timestamp,
      ];
}

class GreetingInclude extends _i1.IncludeObject {
  GreetingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Greeting.t;
}

class GreetingIncludeList extends _i1.IncludeList {
  GreetingIncludeList._({
    _i1.WhereExpressionBuilder<GreetingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Greeting.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Greeting.t;
}

class GreetingRepository {
  const GreetingRepository._();

  /// Returns a list of [Greeting]s matching the given query parameters.
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
  Future<List<Greeting>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreetingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GreetingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreetingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Greeting>(
      where: where?.call(Greeting.t),
      orderBy: orderBy?.call(Greeting.t),
      orderByList: orderByList?.call(Greeting.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Greeting] matching the given query parameters.
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
  Future<Greeting?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreetingTable>? where,
    int? offset,
    _i1.OrderByBuilder<GreetingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreetingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Greeting>(
      where: where?.call(Greeting.t),
      orderBy: orderBy?.call(Greeting.t),
      orderByList: orderByList?.call(Greeting.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Greeting] by its [id] or null if no such row exists.
  Future<Greeting?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Greeting>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Greeting]s in the list and returns the inserted rows.
  ///
  /// The returned [Greeting]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Greeting>> insert(
    _i1.Session session,
    List<Greeting> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Greeting>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Greeting] and returns the inserted row.
  ///
  /// The returned [Greeting] will have its `id` field set.
  Future<Greeting> insertRow(
    _i1.Session session,
    Greeting row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Greeting>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Greeting]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Greeting>> update(
    _i1.Session session,
    List<Greeting> rows, {
    _i1.ColumnSelections<GreetingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Greeting>(
      rows,
      columns: columns?.call(Greeting.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Greeting]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Greeting> updateRow(
    _i1.Session session,
    Greeting row, {
    _i1.ColumnSelections<GreetingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Greeting>(
      row,
      columns: columns?.call(Greeting.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Greeting]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Greeting>> delete(
    _i1.Session session,
    List<Greeting> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Greeting>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Greeting].
  Future<Greeting> deleteRow(
    _i1.Session session,
    Greeting row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Greeting>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Greeting>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GreetingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Greeting>(
      where: where(Greeting.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreetingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Greeting>(
      where: where?.call(Greeting.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
