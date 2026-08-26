/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class StringDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StringDefaultPersist._({
    this.id,
    this.stringDefaultPersist,
    this.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    this.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    this.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    this.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    this.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    this.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    this.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    this.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  });

  factory StringDefaultPersist({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  }) = _StringDefaultPersistImpl;

  factory StringDefaultPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StringDefaultPersist(
      id: jsonSerialization['id'] as int?,
      stringDefaultPersist:
          jsonSerialization['stringDefaultPersist'] as String?,
      stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithOneDoubleQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithOneDoubleQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithTwoDoubleQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithOneSingleQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithOneSingleQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithTwoSingleQuote']
              as String?,
    );
  }

  static final t = StringDefaultPersistTable();

  static const db = StringDefaultPersistRepository._();

  @override
  int? id;

  String? stringDefaultPersist;

  String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote;

  String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote;

  String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote;

  String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote;

  String? stringDefaultPersistSingleQuoteWithOneDoubleQuote;

  String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote;

  String? stringDefaultPersistDoubleQuoteWithOneSingleQuote;

  String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StringDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StringDefaultPersist copyWith({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StringDefaultPersist',
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
      if (stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithOneDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithOneDoubleQuote':
            stringDefaultPersistSingleQuoteWithOneDoubleQuote,
      if (stringDefaultPersistSingleQuoteWithTwoDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoDoubleQuote':
            stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
      if (stringDefaultPersistDoubleQuoteWithOneSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneSingleQuote':
            stringDefaultPersistDoubleQuoteWithOneSingleQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoSingleQuote':
            stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StringDefaultPersist',
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
      if (stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithOneDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithOneDoubleQuote':
            stringDefaultPersistSingleQuoteWithOneDoubleQuote,
      if (stringDefaultPersistSingleQuoteWithTwoDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoDoubleQuote':
            stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
      if (stringDefaultPersistDoubleQuoteWithOneSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneSingleQuote':
            stringDefaultPersistDoubleQuoteWithOneSingleQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoSingleQuote':
            stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
    };
  }

  /// Builds a complete [StringDefaultPersistInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StringDefaultPersistInclude include() {
    return StringDefaultPersistInclude._();
  }

  /// Builds a complete [StringDefaultPersistIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StringDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    StringDefaultPersistInclude? include,
  }) {
    return StringDefaultPersistIncludeList._(
      where: where?.call(StringDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [StringDefaultPersistJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static StringDefaultPersistJsonInclude includeJson({
    _is.SelectColumnsBuilder<StringDefaultPersistTable>? select,
  }) {
    return _StringDefaultPersistJsonInclude._(
      selectedColumns: select?.call(StringDefaultPersist.t),
    );
  }

  /// Builds a JSON-compatible [StringDefaultPersistJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static StringDefaultPersistJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    StringDefaultPersistJsonInclude? include,
    _is.SelectColumnsBuilder<StringDefaultPersistTable>? select,
  }) {
    return _StringDefaultPersistJsonIncludeList._(
      where: where?.call(StringDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      include: include,
      selectedColumns: select?.call(StringDefaultPersist.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultPersistImpl extends StringDefaultPersist {
  _StringDefaultPersistImpl({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  }) : super._(
         id: id,
         stringDefaultPersist: stringDefaultPersist,
         stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
             stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
         stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
             stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
         stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
             stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
         stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
             stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
         stringDefaultPersistSingleQuoteWithOneDoubleQuote:
             stringDefaultPersistSingleQuoteWithOneDoubleQuote,
         stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
             stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
         stringDefaultPersistDoubleQuoteWithOneSingleQuote:
             stringDefaultPersistDoubleQuoteWithOneSingleQuote,
         stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
             stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
       );

  /// Returns a shallow copy of this [StringDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StringDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? stringDefaultPersist = _Undefined,
    Object? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistSingleQuoteWithOneDoubleQuote = _Undefined,
    Object? stringDefaultPersistSingleQuoteWithTwoDoubleQuote = _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithOneSingleQuote = _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithTwoSingleQuote = _Undefined,
  }) {
    return StringDefaultPersist(
      id: id is int? ? id : this.id,
      stringDefaultPersist: stringDefaultPersist is String?
          ? stringDefaultPersist
          : this.stringDefaultPersist,
      stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
          stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote is String?
          ? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote
          : this.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
      stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
          stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote is String?
          ? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote
          : this.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
      stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
          stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote is String?
          ? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote
          : this.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
      stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
          stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote is String?
          ? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote
          : this.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
      stringDefaultPersistSingleQuoteWithOneDoubleQuote:
          stringDefaultPersistSingleQuoteWithOneDoubleQuote is String?
          ? stringDefaultPersistSingleQuoteWithOneDoubleQuote
          : this.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
      stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
          stringDefaultPersistSingleQuoteWithTwoDoubleQuote is String?
          ? stringDefaultPersistSingleQuoteWithTwoDoubleQuote
          : this.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
      stringDefaultPersistDoubleQuoteWithOneSingleQuote:
          stringDefaultPersistDoubleQuoteWithOneSingleQuote is String?
          ? stringDefaultPersistDoubleQuoteWithOneSingleQuote
          : this.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
      stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
          stringDefaultPersistDoubleQuoteWithTwoSingleQuote is String?
          ? stringDefaultPersistDoubleQuoteWithTwoSingleQuote
          : this.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
    );
  }
}

class StringDefaultPersistUpdateTable
    extends _is.UpdateTable<StringDefaultPersistTable> {
  StringDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<String, String> stringDefaultPersist(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersist,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistSingleQuoteWithOneDoubleQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistSingleQuoteWithTwoDoubleQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistDoubleQuoteWithOneSingleQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
        value,
      );

  _is.ColumnValue<String, String>
  stringDefaultPersistDoubleQuoteWithTwoSingleQuote(String? value) =>
      _is.ColumnValue(
        table.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
        value,
      );
}

class StringDefaultPersistTable extends _is.Table<int?> {
  StringDefaultPersistTable({super.tableRelation})
    : super(tableName: 'string_default_persist') {
    updateTable = StringDefaultPersistUpdateTable(this);
    stringDefaultPersist = _is.ColumnString(
      'stringDefaultPersist',
      this,
      hasDefault: true,
    );
    stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote = _is.ColumnString(
      'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote = _is.ColumnString(
      'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote = _is.ColumnString(
      'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote = _is.ColumnString(
      'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistSingleQuoteWithOneDoubleQuote = _is.ColumnString(
      'stringDefaultPersistSingleQuoteWithOneDoubleQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistSingleQuoteWithTwoDoubleQuote = _is.ColumnString(
      'stringDefaultPersistSingleQuoteWithTwoDoubleQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistDoubleQuoteWithOneSingleQuote = _is.ColumnString(
      'stringDefaultPersistDoubleQuoteWithOneSingleQuote',
      this,
      hasDefault: true,
    );
    stringDefaultPersistDoubleQuoteWithTwoSingleQuote = _is.ColumnString(
      'stringDefaultPersistDoubleQuoteWithTwoSingleQuote',
      this,
      hasDefault: true,
    );
  }

  late final StringDefaultPersistUpdateTable updateTable;

  late final _is.ColumnString stringDefaultPersist;

  late final _is.ColumnString
  stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote;

  late final _is.ColumnString
  stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote;

  late final _is.ColumnString
  stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote;

  late final _is.ColumnString
  stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote;

  late final _is.ColumnString stringDefaultPersistSingleQuoteWithOneDoubleQuote;

  late final _is.ColumnString stringDefaultPersistSingleQuoteWithTwoDoubleQuote;

  late final _is.ColumnString stringDefaultPersistDoubleQuoteWithOneSingleQuote;

  late final _is.ColumnString stringDefaultPersistDoubleQuoteWithTwoSingleQuote;

  @override
  List<_is.Column> get columns => [
    id,
    stringDefaultPersist,
    stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  ];
}

abstract interface class StringDefaultPersistJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class StringDefaultPersistJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class StringDefaultPersistInclude extends _is.IncludeObject
    implements StringDefaultPersistJsonInclude, _is.FullModelInclude {
  StringDefaultPersistInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefaultPersist.t;
}

final class StringDefaultPersistIncludeList extends _is.IncludeList
    implements StringDefaultPersistJsonIncludeList, _is.FullModelInclude {
  StringDefaultPersistIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StringDefaultPersistInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefaultPersist.t;
}

final class _StringDefaultPersistJsonInclude extends _is.IncludeObject
    implements StringDefaultPersistJsonInclude {
  _StringDefaultPersistJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefaultPersist.t;
}

final class _StringDefaultPersistJsonIncludeList extends _is.IncludeList
    implements StringDefaultPersistJsonIncludeList {
  _StringDefaultPersistJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StringDefaultPersistJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefaultPersist.t;
}

class StringDefaultPersistRepository {
  const StringDefaultPersistRepository._();

  /// Returns a list of [StringDefaultPersist]s matching the given query parameters.
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
  Future<List<StringDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StringDefaultPersist] matching the given query parameters.
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
  Future<StringDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StringDefaultPersist] by its [id] or null if no such row exists.
  Future<StringDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StringDefaultPersist>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<StringDefaultPersist>(
      id,
      transaction: transaction,
      select: select?.call(StringDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StringDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefaultPersist]s will have their `id` fields set.
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
  Future<List<StringDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<StringDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StringDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StringDefaultPersist] and returns the inserted row.
  ///
  /// The returned [StringDefaultPersist] will have its `id` field set.
  Future<StringDefaultPersist> insertRow(
    _is.DatabaseSession session,
    StringDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StringDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [StringDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<StringDefaultPersist> rows, {
    required _is.ColumnSelections<StringDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<StringDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StringDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(StringDefaultPersist.t),
      updateColumns: updateColumns?.call(StringDefaultPersist.t),
      updateWhere: updateWhere?.call(StringDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StringDefaultPersist] and returns the resulting row.
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
  /// The returned [StringDefaultPersist] will have its `id` field set.
  Future<StringDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    StringDefaultPersist row, {
    required _is.ColumnSelections<StringDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<StringDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StringDefaultPersist>(
      row,
      conflictColumns: conflictColumns(StringDefaultPersist.t),
      updateColumns: updateColumns?.call(StringDefaultPersist.t),
      updateWhere: updateWhere?.call(StringDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultPersist>> update(
    _is.DatabaseSession session,
    List<StringDefaultPersist> rows, {
    _is.ColumnSelections<StringDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StringDefaultPersist>(
      rows,
      columns: columns?.call(StringDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StringDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefaultPersist> updateRow(
    _is.DatabaseSession session,
    StringDefaultPersist row, {
    _is.ColumnSelections<StringDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultPersist>(
      row,
      columns: columns?.call(StringDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StringDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StringDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StringDefaultPersist>(
      id,
      columnValues: columnValues(StringDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StringDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<StringDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StringDefaultPersist>(
      columnValues: columnValues(StringDefaultPersist.t.updateTable),
      where: where(StringDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StringDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<StringDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<StringDefaultPersist> rows, {
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StringDefaultPersist>(
      rows,
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StringDefaultPersist].
  Future<StringDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    StringDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultPersist>(
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
  Future<List<StringDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultPersistTable> where,
    _is.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StringDefaultPersist>(
      where: where(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StringDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StringDefaultPersist>(
      where: where(StringDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
