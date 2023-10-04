import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/table_relation.dart';

/// Builds a SQL query for a select statement.
/// This is typically only used internally by the serverpod framework.
///
/// The query builder simplifies the process supporting order by,
/// where expressions and includes for table relations.
@internal
class SelectQueryBuilder {
  final String _table;
  List<Column>? _fields;
  List<Order>? _orderBy;
  int? _limit;
  int? _offset;
  Expression? _where;
  Include? _include;

  /// Creates a new [SelectQueryBuilder].
  SelectQueryBuilder({required table}) : _table = table;

  /// Builds the SQL query.
  String build() {
    _validateTableReferences(_table, orderBy: _orderBy, where: _where);

    var join =
        _buildJoinQuery(where: _where, orderBy: _orderBy, include: _include);

    var query = _buildSelectQuery(_fields, _include);
    query += ' FROM "$_table"';
    if (join != null) query += ' $join';
    if (_where != null) query += ' WHERE $_where';
    if (_orderBy != null) {
      query +=
          ' ORDER BY ${_orderBy?.map((order) => order.toString()).join(', ')}';
    }
    if (_limit != null) query += ' LIMIT $_limit';
    if (_offset != null) query += ' OFFSET $_offset';

    return query;
  }

  /// Sets the fields that should be selected by the query.
  /// If no fields are set, all fields will be selected.
  SelectQueryBuilder withSelectFields(List<Column>? fields) {
    _fields = fields;
    return this;
  }

  /// Sets the order by for the query.
  ///
  /// If order by includes columns from a relation, the relation will be joined
  /// in the query.
  SelectQueryBuilder withOrderBy(List<Order>? orderBy) {
    _orderBy = orderBy;
    return this;
  }

  /// Sets the limit for the query.
  SelectQueryBuilder withLimit(int? limit) {
    _limit = limit;
    return this;
  }

  /// Sets the offset for the query.
  SelectQueryBuilder withOffset(int? offset) {
    _offset = offset;
    return this;
  }

  /// Sets the where expression for the query.
  ///
  /// If the where expression includes columns from a relation, the relation
  /// will be joined in the query.
  SelectQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  /// Sets the include for the query.
  SelectQueryBuilder withInclude(Include? include) {
    _include = include;
    return this;
  }
}

/// Builds a SQL query for a count statement.
/// This is typically only used internally by the serverpod framework.
///
/// The query builder simplifies the process of supporting where expressions
/// for table relations.
@internal
class CountQueryBuilder {
  final String _table;
  String? _alias;
  String _field;
  int? _limit;
  Expression? _where;

  /// Creates a new [CountQueryBuilder].
  CountQueryBuilder({required table})
      : _table = table,
        _field = '*';

  /// Sets the alias for the count query.
  CountQueryBuilder withCountAlias(String alias) {
    _alias = alias;
    return this;
  }

  /// Sets the field to count.
  CountQueryBuilder withField(String field) {
    _field = field;
    return this;
  }

  /// Sets the limit for the query.
  CountQueryBuilder withLimit(int? limit) {
    _limit = limit;
    return this;
  }

  /// Sets the where expression for the query.
  ///
  /// If the where expression includes columns from a relation, the relation
  /// will be joined in the query.
  CountQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  /// Builds the SQL query.
  String build() {
    _validateTableReferences(_table, where: _where);

    var join = _buildJoinQuery(where: _where);

    var query = 'SELECT COUNT($_field)';
    if (_alias != null) query += ' AS $_alias';
    query += ' FROM "$_table"';
    if (join != null) query += ' $join';
    if (_where != null) query += ' WHERE $_where';
    if (_limit != null) query += ' LIMIT $_limit';
    return query;
  }
}

/// Helper class for building the Using part of a delete query.
class _UsingQuery {
  final String using;
  final String where;

  _UsingQuery({required this.using, required this.where});
}

/// Sets the return statement of queries
enum Returning {
  /// Returns all columns of the table.
  all,

  /// Returns only the id column of the table.
  id,

  /// Returns no columns.
  none,
}

/// Builds a SQL query for a delete statement.
@internal
class DeleteQueryBuilder {
  final String _table;
  String? _returningStatement;
  Expression? _where;

  /// Creates a new [DeleteQueryBuilder].
  DeleteQueryBuilder({required table})
      : _table = table,
        _returningStatement = null;

  /// Sets the returning statement for the query.
  DeleteQueryBuilder withReturn(Returning returning) {
    switch (returning) {
      case Returning.all:
        _returningStatement = ' RETURNING *';
        break;
      case Returning.id:
        _returningStatement = ' RETURNING "$_table".id';
        break;
      case Returning.none:
        _returningStatement = null;
        break;
    }
    return this;
  }

  /// Sets the where expression for the query.
  ///
  /// If the where expression includes columns from a relation, the relation
  /// will be added to the query with a using statement.
  DeleteQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  /// Builds the SQL query.
  String build() {
    _validateTableReferences(_table, where: _where);

    var using = _buildUsingQuery(where: _where);

    var query = 'DELETE FROM "$_table"';
    if (using != null) query += ' USING ${using.using}';
    if (_where != null) query += ' WHERE $_where';
    if (using != null) query += ' AND ${using.where}';
    if (_returningStatement != null) query += _returningStatement!;
    return query;
  }
}

String _buildSelectQuery(List<Column>? fields, Include? include) {
  var selectColumns = [...?fields, ..._gatherIncludeColumns(include)];

  if (selectColumns.isEmpty) {
    return 'SELECT *';
  }

  return _selectStatementFromColumns(selectColumns);
}

List<Column> _gatherIncludeColumns(Include? include) {
  if (include == null) {
    return [];
  }

  var includeTables = _gatherIncludeTables(include, include.table);

  LinkedHashMap<String, Column> fields = LinkedHashMap();
  for (var table in includeTables) {
    for (var column in table.columns) {
      fields['$column'] = column;
    }
  }

  return fields.values.toList();
}

List<Table> _gatherIncludeTables(Include? include, Table table) {
  List<Table> tables = [];
  if (include == null) {
    return tables;
  }

  include.includes.forEach((relationField, relationInclude) {
    if (relationInclude == null) {
      return;
    }

    // Get table from include
    var relationTable = table.getRelationTable(relationField);
    if (relationTable == null) {
      return;
    }

    var tablesFromInclude =
        _gatherIncludeTables(relationInclude, relationTable);
    tables.addAll([relationTable, ...tablesFromInclude]);
  });

  return tables;
}

String? _buildJoinQuery({
  Expression? where,
  List<Order>? orderBy,
  Include? include,
}) {
  LinkedHashMap<String, TableRelation> tableRelations = LinkedHashMap();
  if (where != null) {
    tableRelations.addAll(_gatherTableRelations(where.columns));
  }

  if (orderBy != null) {
    for (var order in orderBy) {
      tableRelations.addAll(_gatherTableRelations([order.column]));
    }
  }

  if (include != null) {
    tableRelations.addAll(_gatherIncludeTableRelations(include));
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _joinStatementFromTableRelations(tableRelations);
}

_UsingQuery? _buildUsingQuery({Expression? where}) {
  LinkedHashMap<String, TableRelation> tableRelations = LinkedHashMap();
  if (where != null) {
    tableRelations.addAll(_gatherTableRelations(where.columns));
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _usingQueryFromTableRelations(tableRelations);
}

LinkedHashMap<String, TableRelation> _gatherTableRelations(
    List<Column> columns) {
  // Linked hash map to preserve order
  LinkedHashMap<String, TableRelation> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.tableRelations != null);
  for (var column in columnsWithTableRelations) {
    for (var tableRelation in column.tableRelations!) {
      joins[tableRelation.tableNameWithQueryPrefix] = tableRelation;
    }
  }

  return joins;
}

LinkedHashMap<String, TableRelation> _gatherIncludeTableRelations(
  Include include,
) {
  LinkedHashMap<String, TableRelation> tableRelations = LinkedHashMap();
  var includeTables = _gatherIncludeTables(include, include.table);
  var tablesWithTableRelations =
      includeTables.where((table) => table.tableRelations != null);
  for (var table in tablesWithTableRelations) {
    for (var tableRelation in table.tableRelations!) {
      tableRelations[tableRelation.tableNameWithQueryPrefix] = tableRelation;
    }
  }

  return tableRelations;
}

String _joinStatementFromTableRelations(
    LinkedHashMap<String, TableRelation> tableRelations) {
  List<String> joinStatements = [];
  for (var tableRelation in tableRelations.values) {
    joinStatements.add('LEFT JOIN "${tableRelation.tableName}" '
        'AS ${tableRelation.tableNameWithQueryPrefix} '
        'ON ${tableRelation.foreignTableColumn} '
        '= ${tableRelation.column}');
  }
  return joinStatements.join(' ');
}

String _selectStatementFromColumns(List<Column> columns) {
  List<String> selectStatements = [];
  for (var column in columns) {
    selectStatements.add('$column AS "${column.queryAlias}"');
  }
  return 'SELECT ${selectStatements.join(', ')}';
}

_UsingQuery _usingQueryFromTableRelations(
    LinkedHashMap<String, TableRelation> tableRelations) {
  List<String> usingStatements = [];
  List<String> whereStatements = [];
  for (var tableRelation in tableRelations.values) {
    usingStatements.add(
        '"${tableRelation.tableName}" AS ${tableRelation.tableNameWithQueryPrefix}');
    whereStatements
        .add('${tableRelation.foreignTableColumn} = ${tableRelation.column}');
  }
  return _UsingQuery(
    using: usingStatements.join(', '),
    where: whereStatements.join(' AND '),
  );
}

void _validateTableReferences(
  String tableName, {
  List<Order>? orderBy,
  Expression? where,
}) {
  List<String> exceptionMessages = [];
  if (orderBy != null) {
    for (var column in orderBy.map((e) => e.column)) {
      if (!column.hasBaseTable(tableName)) {
        exceptionMessages
            .add('"orderBy" expression referencing column $column.');
      }
    }
  }

  if (where != null) {
    for (var column in where.columns) {
      if (!column.hasBaseTable(tableName)) {
        exceptionMessages.add('"where" expression referencing column $column.');
      }
    }
  }

  if (exceptionMessages.isNotEmpty) {
    var errorMessage =
        'Column references starting from other tables than "$tableName" are '
        'not supported. The following expressions need to be removed or '
        'modified:\n${exceptionMessages.join('\n')}';
    throw FormatException(errorMessage);
  }
}

extension _ColumnHelpers on Column {
  /// Returns true if the column has the specified table as base table.
  bool hasBaseTable(String table) {
    // Regex matches 'tableName_' and 'tableName.'
    return toString().startsWith(RegExp(table + r'[_\.]'));
  }
}
