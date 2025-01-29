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

abstract class StringDefaultMix
    implements _i1.TableRow, _i1.ProtocolSerialization {
  StringDefaultMix._({
    this.id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  })  : stringDefaultAndDefaultModel =
            stringDefaultAndDefaultModel ?? 'This is a default model value',
        stringDefaultAndDefaultPersist =
            stringDefaultAndDefaultPersist ?? 'This is a default value',
        stringDefaultModelAndDefaultPersist =
            stringDefaultModelAndDefaultPersist ?? 'This is a default value';

  factory StringDefaultMix({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) = _StringDefaultMixImpl;

  factory StringDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultMix(
      id: jsonSerialization['id'] as int?,
      stringDefaultAndDefaultModel:
          jsonSerialization['stringDefaultAndDefaultModel'] as String,
      stringDefaultAndDefaultPersist:
          jsonSerialization['stringDefaultAndDefaultPersist'] as String,
      stringDefaultModelAndDefaultPersist:
          jsonSerialization['stringDefaultModelAndDefaultPersist'] as String,
    );
  }

  static final t = StringDefaultMixTable();

  static const db = StringDefaultMixRepository._();

  @override
  int? id;

  String stringDefaultAndDefaultModel;

  String stringDefaultAndDefaultPersist;

  String stringDefaultModelAndDefaultPersist;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultMix copyWith({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefaultAndDefaultModel': stringDefaultAndDefaultModel,
      'stringDefaultAndDefaultPersist': stringDefaultAndDefaultPersist,
      'stringDefaultModelAndDefaultPersist':
          stringDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'stringDefaultAndDefaultModel': stringDefaultAndDefaultModel,
      'stringDefaultAndDefaultPersist': stringDefaultAndDefaultPersist,
      'stringDefaultModelAndDefaultPersist':
          stringDefaultModelAndDefaultPersist,
    };
  }

  static StringDefaultMixInclude include() {
    return StringDefaultMixInclude._();
  }

  static StringDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    StringDefaultMixInclude? include,
  }) {
    return StringDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultMixImpl extends StringDefaultMix {
  _StringDefaultMixImpl({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          stringDefaultAndDefaultModel: stringDefaultAndDefaultModel,
          stringDefaultAndDefaultPersist: stringDefaultAndDefaultPersist,
          stringDefaultModelAndDefaultPersist:
              stringDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultMix copyWith({
    Object? id = _Undefined,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) {
    return StringDefaultMix(
      id: id is int? ? id : this.id,
      stringDefaultAndDefaultModel:
          stringDefaultAndDefaultModel ?? this.stringDefaultAndDefaultModel,
      stringDefaultAndDefaultPersist:
          stringDefaultAndDefaultPersist ?? this.stringDefaultAndDefaultPersist,
      stringDefaultModelAndDefaultPersist:
          stringDefaultModelAndDefaultPersist ??
              this.stringDefaultModelAndDefaultPersist,
    );
  }
}

class StringDefaultMixTable extends _i1.Table {
  StringDefaultMixTable({super.tableRelation})
      : super(tableName: 'string_default_mix') {
    stringDefaultAndDefaultModel = _i1.ColumnString(
      'stringDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    stringDefaultAndDefaultPersist = _i1.ColumnString(
      'stringDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    stringDefaultModelAndDefaultPersist = _i1.ColumnString(
      'stringDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString stringDefaultAndDefaultModel;

  late final _i1.ColumnString stringDefaultAndDefaultPersist;

  late final _i1.ColumnString stringDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefaultAndDefaultModel,
        stringDefaultAndDefaultPersist,
        stringDefaultModelAndDefaultPersist,
      ];
}

class StringDefaultMixInclude extends _i1.IncludeObject {
  StringDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefaultMix.t;
}

class StringDefaultMixIncludeList extends _i1.IncludeList {
  StringDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefaultMix.t;
}

class StringDefaultMixRepository {
  const StringDefaultMixRepository._();

  /// Returns a list of [StringDefaultMix]s matching the given query parameters.
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
  Future<List<StringDefaultMix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [StringDefaultMix] matching the given query parameters.
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
  Future<StringDefaultMix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultMixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [StringDefaultMix] by its [id] or null if no such row exists.
  Future<StringDefaultMix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefaultMix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [StringDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StringDefaultMix>> insert(
    _i1.Session session,
    List<StringDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StringDefaultMix] and returns the inserted row.
  ///
  /// The returned [StringDefaultMix] will have its `id` field set.
  Future<StringDefaultMix> insertRow(
    _i1.Session session,
    StringDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StringDefaultMix>> update(
    _i1.Session session,
    List<StringDefaultMix> rows, {
    _i1.ColumnSelections<StringDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefaultMix>(
      rows,
      columns: columns?.call(StringDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefaultMix> updateRow(
    _i1.Session session,
    StringDefaultMix row, {
    _i1.ColumnSelections<StringDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultMix>(
      row,
      columns: columns?.call(StringDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Deletes all [StringDefaultMix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StringDefaultMix>> delete(
    _i1.Session session,
    List<StringDefaultMix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefaultMix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StringDefaultMix].
  Future<StringDefaultMix> deleteRow(
    _i1.Session session,
    StringDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StringDefaultMix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultMixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefaultMix>(
      where: where(StringDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
