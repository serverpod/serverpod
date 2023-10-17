import 'dart:collection';

import 'package:collection/collection.dart';
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
  final Table _table;
  List<Column> _fields;
  List<Order>? _orderBy;
  int? _limit;
  int? _offset;
  Expression? _where;
  Include? _include;
  _ListQueryAdditions? _listQueryAdditions;

  /// Creates a new [SelectQueryBuilder].
  /// Throws an [ArgumentError] if the table has no columns.
  SelectQueryBuilder({required Table table})
      : _table = table,
        _fields = table.columns {
    if (_fields.isEmpty) {
      throw ArgumentError.value(
        table,
        'table',
        'Must have at least one column',
      );
    }
  }

  /// Builds the SQL query.
  String build() {
    _validateTableReferences(
      _table.tableName,
      orderBy: _orderBy,
      where: _where,
    );
    var selectColumns = [..._fields, ..._gatherIncludeColumns(_include)];

    var subQueries = _buildSubQueries(orderBy: _orderBy);
    var select = _buildSelectStatement(selectColumns);
    var join =
        _buildJoinQuery(where: _where, orderBy: _orderBy, include: _include);
    var groupBy = _buildGroupByQuery(selectColumns, orderBy: _orderBy);
    var where = _buildWhereQuery(
      where: _where,
      listQueryAdditions: _listQueryAdditions,
    );
    var orderBy = _buildOrderByQuery(orderBy: _orderBy);

    var query = '';
    query += 'SELECT $select';
    query += ' FROM "${_table.tableName}"';
    if (join != null) query += ' $join';
    if (where != null) query += ' WHERE $where';
    if (groupBy != null) query += ' GROUP BY $groupBy';
    if (orderBy != null) query += ' ORDER BY $orderBy';

    var limit = _limit;
    var listQueryAdditions = _listQueryAdditions;

    if (listQueryAdditions != null && limit != null) {
      return _wrapListQueryWithLimit(
        query,
        subQueries,
        listQueryAdditions,
        limit: limit,
        offset: _offset,
      );
    } else {
      if (limit != null) query += ' LIMIT $limit';
      if (_offset != null) query += ' OFFSET $_offset';

      if (subQueries != null) query = '$subQueries $query';
      return query;
    }
  }

  String _wrapListQueryWithLimit(
    String baseQuery,
    String? subQueries,
    _ListQueryAdditions listQueryAdditions, {
    required int limit,
    required int? offset,
  }) {
    var wrappedBaseQueryAlias = '_base_query_sorting_and_ordering';
    var partitionedQueryAlias = '_partitioned_list_by_parent_id';

    var index = offset ?? 0;
    var start = index + 1;
    var end = limit + index;

    var relationalFieldName = listQueryAdditions.relationalFieldName;

    String query = subQueries != null ? '$subQueries, ' : 'WITH ';
    query += '$wrappedBaseQueryAlias AS ($baseQuery)';

    query +=
        ', $partitionedQueryAlias AS (SELECT *, row_number() OVER ( PARTITION BY $wrappedBaseQueryAlias."$relationalFieldName") FROM $wrappedBaseQueryAlias)';

    query +=
        'SELECT * FROM $partitionedQueryAlias WHERE row_number BETWEEN $start AND $end';

    return query;
  }

  /// Sets the fields that should be selected by the query.
  /// Throws an [ArgumentError] if the list is empty.
  SelectQueryBuilder withSelectFields(List<Column> fields) {
    if (fields.isEmpty) {
      throw ArgumentError.value(
        fields,
        'fields',
        'Cannot be empty',
      );
    }

    _fields = fields;
    return this;
  }

  /// Sets the order by for the query.
  ///
  /// If order by includes columns from a relation, the relation will be joined
  /// in the query.
  /// Throws an [ArgumentError] if the same column is included multiple times.
  /// Throws an [UnimplementedError] if multiple many relation columns are
  /// included.
  SelectQueryBuilder withOrderBy(List<Order>? orderBy) {
    Set<String> columns = {};
    bool hasCountColumn = false;
    for (var order in orderBy ?? []) {
      if (columns.contains(order.column.queryAlias)) {
        throw ArgumentError(
          'Ordering by same column multiple times: ${order.column.queryAlias}',
        );
      }

      if (order.column is ColumnCount) {
        if (hasCountColumn) {
          throw UnimplementedError(
            'Ordering by multiple many relation columns is not supported. '
            'Please file an issue at '
            'https://github.com/serverpod/serverpod/issues if you need this.',
          );
        }
        hasCountColumn = true;
      }

      columns.add(order.column.queryAlias);
    }

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

  /// Adds an additional filter on the query to find only rows that have a
  /// relation to the specified ids.
  SelectQueryBuilder withWhereRelationInResultSet(
    Set<int> ids,
    Table relationTable,
  ) {
    var tableRelation = relationTable.tableRelation;

    if (tableRelation == null) {
      throw ArgumentError.value(
        relationTable,
        'relationTable',
        'The table must have a relation to another table.',
      );
    }

    if (ids.isEmpty) {
      throw ArgumentError.value(
        ids,
        'ids',
        'To make a valid filtered query, the set of ids cannot be empty.',
      );
    }

    var relationFieldName = tableRelation.foreignFieldQuery;
    //'"${relationTable.tableName}"."${tableRelation.foreignFieldName}"';

    var whereAddition = Expression('$relationFieldName IN (${ids.join(', ')})');

    _listQueryAdditions = _ListQueryAdditions(
      relationalFieldName: tableRelation.foreignFieldQueryAlias,
      whereAddition: whereAddition,
    );

    return this;
  }

  /// Sets the include for the query.
  SelectQueryBuilder withInclude(Include? include) {
    _include = include;
    return this;
  }
}

class _ListQueryAdditions {
  final String relationalFieldName;

  final Expression whereAddition;

  _ListQueryAdditions({
    required this.relationalFieldName,
    required this.whereAddition,
  });
}

/// Builds a SQL query for a count statement.
/// This is typically only used internally by the serverpod framework.
///
/// The query builder simplifies the process of supporting where expressions
/// for table relations.
@internal
class CountQueryBuilder {
  final Table _table;
  String? _alias;
  Column _field;
  int? _limit;
  Expression? _where;

  /// Creates a new [CountQueryBuilder].
  CountQueryBuilder({required Table table})
      : _table = table,
        _field = table.id;

  /// Sets the alias for the count query.
  CountQueryBuilder withCountAlias(String alias) {
    _alias = alias;
    return this;
  }

  /// Sets the field to count.
  CountQueryBuilder withField(Column field) {
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
    _validateTableReferences(_table.tableName, where: _where);

    var join = _buildJoinQuery(where: _where);
    var where = _buildWhereQuery(where: _where);

    var query = 'SELECT COUNT($_field)';
    if (_alias != null) query += ' AS $_alias';
    query += ' FROM "${_table.tableName}"';
    if (join != null) query += ' $join';
    if (where != null) query += ' WHERE $where';
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
  final Table _table;
  String? _returningStatement;
  Expression? _where;

  /// Creates a new [DeleteQueryBuilder].
  DeleteQueryBuilder({required Table table})
      : _table = table,
        _returningStatement = null;

  /// Sets the returning statement for the query.
  DeleteQueryBuilder withReturn(Returning returning) {
    switch (returning) {
      case Returning.all:
        _returningStatement = ' RETURNING *';
        break;
      case Returning.id:
        _returningStatement = ' RETURNING "${_table.tableName}".id';
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
    _validateTableReferences(_table.tableName, where: _where);

    var using = _buildUsingQuery(where: _where);
    var where = _buildWhereQuery(where: _where);

    var query = 'DELETE FROM "${_table.tableName}"';
    if (using != null) query += ' USING ${using.using}';
    if (where != null) query += ' WHERE $where';
    if (using != null) query += ' AND ${using.where}';
    if (_returningStatement != null) query += _returningStatement!;
    return query;
  }
}

String _buildSelectStatement(List<Column> selectColumns) {
  return selectColumns
      .map((column) => '$column AS "${column.queryAlias}"')
      .join(', ');
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
    if (relationInclude == null || relationInclude is IncludeList) {
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

class _JoinContext {
  final TableRelation tableRelation;
  final bool subQuery;

  _JoinContext(this.tableRelation, this.subQuery);
}

String? _buildJoinQuery({
  Expression? where,
  List<Order>? orderBy,
  Include? include,
}) {
  LinkedHashMap<String, _JoinContext> tableRelations = LinkedHashMap();
  if (where != null) {
    tableRelations.addAll(_gatherJoinContexts(where.columns));
  }

  if (orderBy != null) {
    for (var order in orderBy) {
      tableRelations.addAll(_gatherJoinContexts([order.column]));
    }
  }

  if (include != null) {
    tableRelations.addAll(_gatherIncludeJoinContexts(include));
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _joinStatementFromJoinContexts(tableRelations);
}

String? _buildGroupByQuery(
  List<Column> selectFields, {
  List<Order>? orderBy,
}) {
  var anyCountColumn =
      orderBy?.any((order) => order.column is ColumnCount) ?? false;

  if (!anyCountColumn) {
    return null;
  }

  return selectFields.map((column) => '$column').join(', ');
}

String? _buildWhereQuery({
  Expression? where,
  _ListQueryAdditions? listQueryAdditions,
}) {
  if (where == null && listQueryAdditions == null) {
    return null;
  }

  if (where == null) {
    return listQueryAdditions?.whereAddition.toString();
  }

  if (where.columns.whereType<ColumnCount>().isNotEmpty) {
    // TODO - Add support for count columns in where expressions.
    throw const FormatException(
      'Count columns are not supported in where expressions.',
    );
  }

  if (listQueryAdditions == null) {
    return where.toString();
  }

  return '$where AND ${listQueryAdditions.whereAddition}';
}

_UsingQuery? _buildUsingQuery({Expression? where}) {
  LinkedHashMap<String, _JoinContext> joinContexts = LinkedHashMap();
  if (where != null) {
    joinContexts.addAll(_gatherJoinContexts(where.columns));
  }

  if (joinContexts.isEmpty) {
    return null;
  }

  return _usingQueryFromJoinContexts(joinContexts);
}

String? _buildSubQueries({List<Order>? orderBy}) {
  List<ColumnCount> countColumnsWithInnerWhere = [];

  if (orderBy != null) {
    countColumnsWithInnerWhere.addAll(
      orderBy
          .map((order) => order.column)
          .whereType<ColumnCount>()
          .where((c) => c.innerWhere != null),
    );
  }

  Map<String, String> subQueries = {};
  for (var countColumn in countColumnsWithInnerWhere) {
    var tableRelation = countColumn.table.tableRelation;

    if (tableRelation == null) {
      throw ArgumentError.notNull('countColumn.table.tableRelation');
    }

    var relationQueryAlias = tableRelation.relationQueryAlias;

    subQueries[relationQueryAlias] =
        SelectQueryBuilder(table: countColumn.baseTable)
            .withWhere(countColumn.innerWhere)
            .build();
  }

  if (subQueries.isEmpty) {
    return null;
  }

  return 'WITH ${subQueries.entries.map((e) => '"${e.key}" AS (${e.value})').join(', ')}';
}

String? _buildOrderByQuery({List<Order>? orderBy}) {
  if (orderBy == null) {
    return null;
  }

  return orderBy.map((order) {
    var str = '';

    var column = order.column;
    if (column is ColumnCount) {
      str = _buildCountColumnString(column);
    } else {
      str = '$column';
    }

    if (order.orderDescending) str += ' DESC';

    return str;
  }).join(', ');
}

String _buildCountColumnString(ColumnCount column) {
  if (column.innerWhere != null) {
    // If column is filtered then we want to use the result from the sub query
    return 'COUNT(${column.table.tableRelation?.lastJoiningForeignFieldQueryAlias})';
  }

  return 'COUNT($column)';
}

LinkedHashMap<String, _JoinContext> _gatherJoinContexts(List<Column> columns) {
  // Linked hash map to preserve order
  LinkedHashMap<String, _JoinContext> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.table.tableRelation != null);
  for (var column in columnsWithTableRelations) {
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      continue;
    }

    var subQuery = column is ColumnCount && column.innerWhere != null;

    var subTableRelations = tableRelation.getRelations;

    subTableRelations.forEachIndexed((index, subTableRelation) {
      bool lastEntry = index == subTableRelations.length - 1;
      joins[subTableRelation.relationQueryAlias] =
          _JoinContext(subTableRelation, lastEntry ? subQuery : false);
    });
  }

  return joins;
}

LinkedHashMap<String, _JoinContext> _gatherIncludeJoinContexts(
  Include include,
) {
  LinkedHashMap<String, _JoinContext> tableRelations = LinkedHashMap();
  var includeTables = _gatherIncludeTables(include, include.table);
  var tablesWithTableRelations =
      includeTables.where((table) => table.tableRelation != null);
  for (var table in tablesWithTableRelations) {
    var tableRelation = table.tableRelation;

    for (var subTableRelation in tableRelation?.getRelations ?? []) {
      tableRelations[subTableRelation.relationQueryAlias] =
          _JoinContext(subTableRelation, false);
    }
  }

  return tableRelations;
}

String _joinStatementFromJoinContexts(
    LinkedHashMap<String, _JoinContext> joinContexts) {
  List<String> joinStatements = [];
  for (var joinContext in joinContexts.values) {
    var tableRelation = joinContext.tableRelation;
    var joinStatement = 'LEFT JOIN';
    if (!joinContext.subQuery) {
      joinStatement += ' "${tableRelation.lastForeignTableName}" AS';
    }

    joinStatement += ' "${tableRelation.relationQueryAlias}" '
        'ON ${tableRelation.lastJoiningField} ';

    if (!joinContext.subQuery) {
      joinStatement += '= ${tableRelation.lastJoiningForeignField}';
    } else {
      joinStatement += '= ${tableRelation.lastJoiningForeignFieldQueryAlias}';
    }

    joinStatements.add(joinStatement);
  }
  return joinStatements.join(' ');
}

_UsingQuery _usingQueryFromJoinContexts(
    LinkedHashMap<String, _JoinContext> joinContexts) {
  List<String> usingStatements = [];
  List<String> whereStatements = [];
  for (var joinContext in joinContexts.values) {
    var tableRelation = joinContext.tableRelation;
    usingStatements.add(
        '"${tableRelation.lastForeignTableName}" AS "${tableRelation.relationQueryAlias}"');
    whereStatements.add(
        '${tableRelation.lastJoiningField} = ${tableRelation.lastJoiningForeignField}');
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
    return queryAlias.startsWith(RegExp(table + r'[_\.]'));
  }
}
