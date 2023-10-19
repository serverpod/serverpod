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
  ColumnExpression? _having;
  Include? _include;
  _ListQueryAdditions? _listQueryAdditions;
  bool _joinOneLevelManyRelationWhereExpressions = false;
  TableRelation? _countTableRelation;

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
      countTableRelation: _countTableRelation,
    );
    var selectColumns = [..._fields, ..._gatherIncludeColumns(_include)];

    var subQueries = _SubQueries.gatherSubQueries(
      orderBy: _orderBy,
      where: _where,
    );
    var select = _buildSelectStatement(
      selectColumns,
      countTableRelation: _countTableRelation,
    );
    var join = _buildJoinQuery(
      where: _where,
      having: _having,
      orderBy: _orderBy,
      include: _include,
      subQueries: subQueries,
      countTableRelation: _countTableRelation,
      joinOneLevelManyRelations: _joinOneLevelManyRelationWhereExpressions,
    );
    var groupBy = _buildGroupByQuery(
      selectColumns,
      having: _having,
      countTableRelation: _countTableRelation,
    );
    var where = _buildWhereQuery(
        where: _where,
        listQueryAdditions: _listQueryAdditions,
        subQueries: subQueries);
    var orderBy = _buildOrderByQuery(orderBy: _orderBy, subQueries: subQueries);

    var listQueryAdditions = _listQueryAdditions;
    var limit = listQueryAdditions == null && _limit != null ? _limit : null;
    var offset = listQueryAdditions == null && _offset != null ? _offset : null;

    var query = '';
    if (subQueries != null) query += 'WITH ${subQueries.buildQueries()} ';
    query += 'SELECT $select';
    query += ' FROM "${_table.tableName}"';
    if (join != null) query += ' $join';
    if (where != null) query += ' WHERE $where';
    if (groupBy != null) query += ' GROUP BY $groupBy';
    if (_having != null) query += ' HAVING $_having';
    if (orderBy != null) query += ' ORDER BY $orderBy';
    if (limit != null) query += ' LIMIT $limit';
    if (offset != null) query += ' OFFSET $_offset';

    if (listQueryAdditions != null && (_limit != null || _offset != null)) {
      return _wrapListQueryWithLimit(
        query,
        listQueryAdditions,
        limit: _limit,
        offset: _offset,
      );
    }

    return query;
  }

  String _wrapListQueryWithLimit(
    String baseQuery,
    _ListQueryAdditions listQueryAdditions, {
    required int? limit,
    required int? offset,
  }) {
    var wrappedBaseQueryAlias = '_base_query_sorting_and_ordering';
    var partitionedQueryAlias = '_partitioned_list_by_parent_id';

    var relationalFieldName = listQueryAdditions.relationalFieldName;

    String query = 'WITH $wrappedBaseQueryAlias AS ($baseQuery)';

    query +=
        ', $partitionedQueryAlias AS (SELECT *, row_number() OVER ( PARTITION BY $wrappedBaseQueryAlias."$relationalFieldName") FROM $wrappedBaseQueryAlias)';

    var rowLimitClause = _buildMultiRowLimitClause(limit, offset);

    query +=
        ' SELECT * FROM $partitionedQueryAlias WHERE row_number $rowLimitClause';

    return query;
  }

  String _buildMultiRowLimitClause(int? limit, int? offset) {
    var index = offset ?? 0;
    var start = index + 1;

    if (limit == null) {
      return '>= $start';
    }

    var end = limit + index;
    return 'BETWEEN $start AND $end';
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

    var relationFieldName = tableRelation.foreignFieldBaseQuery;
    //'"${relationTable.tableName}"."${tableRelation.foreignFieldName}"';

    var whereAddition = Expression('$relationFieldName IN (${ids.join(', ')})');

    _listQueryAdditions = _ListQueryAdditions(
      relationalFieldName: tableRelation.foreignFieldBaseQueryAlias,
      whereAddition: whereAddition,
    );

    return this;
  }

  /// Sets the include for the query.
  SelectQueryBuilder withInclude(Include? include) {
    _include = include;
    return this;
  }

  /// Sets the having expression for the query.
  SelectQueryBuilder withHaving(ColumnExpression? having) {
    _having = having;
    return this;
  }

  /// Sets whether to build a count field from the table relations last joining
  /// foreign field for the query.
  SelectQueryBuilder withCountTableRelation(TableRelation relation) {
    _countTableRelation = relation;
    return this;
  }

  /// Determines whether to join or create sub queries for one level many
  /// relations. if set to true, the query will join the many relation in the
  /// where expression.
  SelectQueryBuilder enableOneLevelWhereExpressionJoins() {
    _joinOneLevelManyRelationWhereExpressions = true;
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

    var subQueries = _SubQueries.gatherSubQueries(where: _where);
    var join = _buildJoinQuery(where: _where, subQueries: subQueries);
    var where = _buildWhereQuery(where: _where, subQueries: subQueries);

    var query = '';
    if (subQueries != null) query += 'WITH ${subQueries.buildQueries()} ';
    query += 'SELECT COUNT($_field)';
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
    var where = _buildWhereQueryWithoutSubQueries(where: _where);

    var query = 'DELETE FROM "${_table.tableName}"';
    if (using != null) query += ' USING ${using.using}';
    if (where != null) query += ' WHERE $where';
    if (using != null) query += ' AND ${using.where}';
    if (_returningStatement != null) query += _returningStatement!;
    return query;
  }
}

String _buildSelectStatement(
  List<Column> selectColumns, {
  TableRelation? countTableRelation,
}) {
  var selectStatements = selectColumns
      .map((column) => '$column AS "${column.queryAlias}"')
      .join(', ');

  if (countTableRelation != null) {
    selectStatements +=
        ', COUNT(${countTableRelation.lastJoiningForeignField}) AS "count"';
  }

  return selectStatements;
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
  // TODO: Remove class once we have full support for many relations
  // Only the join statement should matter at that point.
  final TableRelation tableRelation;
  final bool subQuery;
  final String? joinStatement;

  _JoinContext(
    this.tableRelation,
    this.subQuery, {
    this.joinStatement,
  });
}

String? _buildJoinQuery({
  Expression? where,
  ColumnExpression? having,
  List<Order>? orderBy,
  Include? include,
  _SubQueries? subQueries,
  TableRelation? countTableRelation,
  joinOneLevelManyRelations = false,
}) {
  LinkedHashMap<String, _JoinContext> tableRelations = LinkedHashMap();
  if (where != null) {
    tableRelations.addAll(_gatherWhereJoinContexts(
      where.columns,
      joinOneLevelManyRelations: joinOneLevelManyRelations,
    ));
  }

  if (orderBy != null) {
    tableRelations
        .addAll(_gatherOrderByJoinContexts(orderBy, subQueries: subQueries));
  }

  if (include != null) {
    tableRelations.addAll(_gatherIncludeJoinContexts(include));
  }

  if (countTableRelation != null) {
    tableRelations[countTableRelation.relationQueryAlias] = _JoinContext(
      countTableRelation,
      false,
      joinStatement: _buildJoinStatement(tableRelation: countTableRelation),
    );
  }

  if (having != null) {
    tableRelations.addEntries([_gatherHavingJoinContext(having)]);
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _joinStatementFromJoinContexts(tableRelations);
}

String? _buildGroupByQuery(
  List<Column> selectFields, {
  Expression? having,
  TableRelation? countTableRelation,
}) {
  if (countTableRelation == null && having == null) {
    return null;
  }

  return selectFields.map((column) => '$column').join(', ');
}

String? _buildWhereQuery({
  Expression? where,
  _SubQueries? subQueries,
  _ListQueryAdditions? listQueryAdditions,
}) {
  if (where == null && listQueryAdditions == null) {
    return null;
  }

  if (where == null) {
    return listQueryAdditions?.whereAddition.toString();
  }

  var whereQuery = '';

  if (where is TwoPartExpression) {
    var subExpressions = where.subExpressions;

    whereQuery += '(';
    whereQuery += subExpressions
        .map((e) => _buildWhereQuery(where: e, subQueries: subQueries))
        .join(' ${where.operator} ');
    whereQuery += ')';
  } else if (where is ColumnExpression && where.isManyRelationExpression) {
    var column = where.column;
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      throw StateError('Table relation is null');
    }

    var expressionIndex = where.index;
    if (expressionIndex == null) {
      throw StateError('Expression index is null');
    }

    var subQuery = subQueries?._whereCountQueries[expressionIndex];
    if (subQuery == null) {
      throw StateError(
          'Sub query for expression index \'$expressionIndex\' is null');
    }

    whereQuery = '${tableRelation.lastJoiningField} IN '
        '(SELECT "${subQuery.alias}"."${tableRelation.fieldBaseQueryAlias}" '
        'FROM "${subQuery.alias}")';
  } else {
    whereQuery = where.toString();
  }

  if (listQueryAdditions == null) {
    return whereQuery;
  }

  return '$whereQuery AND ${listQueryAdditions.whereAddition}';
}

String? _buildWhereQueryWithoutSubQueries({
  Expression? where,
}) {
  if (where == null) {
    return null;
  }

  if (where.columns.whereType<ColumnCount>().isNotEmpty) {
    // TODO - Add support for count columns in where expressions.
    throw const FormatException(
      'Count columns are not supported in where expressions.',
    );
  }

  return where.toString();
}

_UsingQuery? _buildUsingQuery({Expression? where}) {
  LinkedHashMap<String, _JoinContext> joinContexts = LinkedHashMap();
  if (where != null) {
    joinContexts.addAll(_gatherWhereJoinContexts(where.columns));
  }

  if (joinContexts.isEmpty) {
    return null;
  }

  return _usingQueryFromJoinContexts(joinContexts);
}

class _SubQuery {
  final String query;
  final String alias;

  _SubQuery(this.query, this.alias);
}

class _SubQueries {
  static const String orderByPrefix = 'order_by';
  static const String whereCountPrefix = 'where_count';
  final Map<int, _SubQuery> _orderByQueries = {};
  final Map<int, _SubQuery> _whereCountQueries = {};

  bool get isEmpty => _orderByQueries.isEmpty && _whereCountQueries.isEmpty;

  static _SubQueries? gatherSubQueries({
    List<Order>? orderBy,
    Expression? where,
  }) {
    var subQueries = _SubQueries();
    if (orderBy != null) {
      subQueries._orderByQueries.addAll(_gatherOrderBySubQueries(orderBy));
    }

    if (where != null) {
      subQueries._whereCountQueries.addAll(_gatherWhereCountSubQueries(where));
    }

    if (subQueries.isEmpty) {
      return null;
    }

    return subQueries;
  }

  static String buildUniqueQueryAlias(
      String orderByPrefix, String queryAlias, int index) {
    return '${orderByPrefix}_${queryAlias}_$index';
  }

  static Map<int, _SubQuery> _gatherOrderBySubQueries(List<Order> orderBy) {
    Map<int, _SubQuery> subQueries = {};

    orderBy.forEachIndexed((index, order) {
      var column = order.column;
      if (column is! ColumnCount) return;

      var tableRelation = column.table.tableRelation;
      if (tableRelation == null) {
        throw StateError('Table relation is null');
      }

      var relationQueryAlias = tableRelation.relationQueryAlias;
      var uniqueRelationQueryAlias =
          buildUniqueQueryAlias(orderByPrefix, relationQueryAlias, index);

      var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
          .withWhere(column.innerWhere)
          .enableOneLevelWhereExpressionJoins()
          .withSelectFields([tableRelation.lastJoiningColumn])
          .withCountTableRelation(tableRelation.lastRelation)
          .build();

      subQueries[index] = _SubQuery(subQuery, uniqueRelationQueryAlias);
    });

    return subQueries;
  }

  static Map<int, _SubQuery> _gatherWhereCountSubQueries(Expression where) {
    Map<int, _SubQuery> subQueries = {};

    where.forEachDepthFirstIndexed((index, expression) {
      if (expression is! ColumnExpression) return;

      if (!expression.isManyRelationExpression) return;

      var column = expression.column;

      if (column is! ColumnCount) return;

      var tableRelation = column.table.tableRelation;

      if (tableRelation == null) {
        throw StateError('Table relation is null');
      }

      var relationQueryAlias = tableRelation.relationQueryAlias;
      var uniqueRelationQueryAlias =
          buildUniqueQueryAlias(whereCountPrefix, relationQueryAlias, index);

      var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
          .withWhere(column.innerWhere)
          .withSelectFields([tableRelation.lastJoiningColumn])
          .enableOneLevelWhereExpressionJoins()
          .withHaving(expression)
          .build();

      subQueries[index] = _SubQuery(subQuery, uniqueRelationQueryAlias);

      /// Store index of the expressions so that we later can retrieve the
      /// matching sub query alias.
      expression.index = index;
    });

    return subQueries;
  }

  String buildQueries() {
    var subQueries = [
      ..._formatQueries(_orderByQueries),
      ..._formatQueries(_whereCountQueries),
    ];
    return subQueries.join(', ');
  }

  List<String> _formatQueries(Map<int, _SubQuery> subQueries) {
    var queries = <String>[];

    subQueries.forEach((_, subQuery) {
      queries.add('"${subQuery.alias}" AS (${subQuery.query})');
    });

    return queries;
  }
}

String? _buildOrderByQuery({List<Order>? orderBy, _SubQueries? subQueries}) {
  if (orderBy == null) {
    return null;
  }

  return orderBy.mapIndexed((index, order) {
    var str = '';

    var column = order.column;
    var orderDescending = order.orderDescending;
    if (column is ColumnCount) {
      str = _formatOrderByCount(index, subQueries, orderDescending);
    } else {
      str = '$column';
      if (orderDescending) str += ' DESC';
    }

    return str;
  }).join(', ');
}

String _formatOrderByCount(
  int index,
  _SubQueries? subQueries,
  bool orderDescending,
) {
  var queryAlias = subQueries?._orderByQueries[index]?.alias;

  if (queryAlias == null) {
    throw StateError('Query alias for order by sub query is null.');
  }

  var str = '"$queryAlias"."count"';
  str += orderDescending ? ' DESC NULLS LAST' : ' NULLS FIRST';
  return str;
}

LinkedHashMap<String, _JoinContext> _gatherOrderByJoinContexts(
  List<Order> orderBy, {
  _SubQueries? subQueries,
}) {
  LinkedHashMap<String, _JoinContext> joins = LinkedHashMap();
  var orderByQueries = subQueries?._orderByQueries;
  orderBy.forEachIndexed((orderIndex, order) {
    var column = order.column;
    var tableRelation = column.table.tableRelation;

    if (tableRelation == null) return;

    var manyRelationColumn = column is ColumnCount;

    var subTableRelations = tableRelation.getRelations;
    subTableRelations.forEachIndexed((index, subTableRelation) {
      bool lastEntry = index == subTableRelations.length - 1;
      if (lastEntry && manyRelationColumn) {
        /// Last relation Query Alias is stored as unique

        if (orderByQueries == null) {
          throw StateError('Order by sub queries is null.');
        }

        var queryAlias = orderByQueries[orderIndex]?.alias;

        if (queryAlias == null) {
          throw StateError(
              'Missing query alias for order by sub query with index $index.');
        }

        joins[queryAlias] = _JoinContext(
          subTableRelation,
          true,
          joinStatement: _buildSubQueryJoinStatement(
            tableRelation: tableRelation,
            queryAlias: queryAlias,
          ),
        );
      } else {
        joins[subTableRelation.relationQueryAlias] = _JoinContext(
          subTableRelation,
          false,
          joinStatement: _buildJoinStatement(tableRelation: subTableRelation),
        );
      }
    });
  });

  return joins;
}

String _buildSubQueryJoinStatement({
  required TableRelation tableRelation,
  required String queryAlias,
}) {
  return 'LEFT JOIN "$queryAlias" ON ${tableRelation.lastJoiningField} '
      '= "$queryAlias"."${tableRelation.fieldBaseQueryAlias}"';
}

String _buildJoinStatement({required TableRelation tableRelation}) {
  return 'LEFT JOIN "${tableRelation.lastForeignTableName}" AS '
      '"${tableRelation.relationQueryAlias}" ON '
      '${tableRelation.lastJoiningField} = '
      '${tableRelation.lastJoiningForeignField}';
}

LinkedHashMap<String, _JoinContext> _gatherWhereJoinContexts(
  List<Column> columns, {
  joinOneLevelManyRelations = false,
}) {
  // Linked hash map to preserve order
  LinkedHashMap<String, _JoinContext> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.table.tableRelation != null);
  for (var column in columnsWithTableRelations) {
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      continue;
    }

    var manyRelationColumn = column is ColumnCount;
    var hasSubQuery = manyRelationColumn && column.innerWhere != null;

    var subTableRelations = tableRelation.getRelations;

    bool oneLevelManyRelation =
        manyRelationColumn && subTableRelations.length == 1;

    subTableRelations.forEachIndexed((index, subTableRelation) {
      bool lastEntry = index == subTableRelations.length - 1;
      if (lastEntry &&
          manyRelationColumn &&
          !(oneLevelManyRelation && joinOneLevelManyRelations)) {
        return;
      }

      joins[subTableRelation.relationQueryAlias] = _JoinContext(
        subTableRelation,
        lastEntry ? hasSubQuery : false,
        joinStatement: _buildJoinStatement(tableRelation: subTableRelation),
      );
    });
  }

  return joins;
}

MapEntry<String, _JoinContext> _gatherHavingJoinContext(
  ColumnExpression having,
) {
  var column = having.column;
  var tableRelation = column.table.tableRelation;
  if (tableRelation == null) {
    throw StateError('Table relation is null.');
  }
  var lastRelation = tableRelation.lastRelation;

  return MapEntry(
    lastRelation.relationQueryAlias,
    _JoinContext(lastRelation, false,
        joinStatement: _buildJoinStatement(tableRelation: lastRelation)),
  );
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
    var joinStatement = joinContext.joinStatement;
    if (joinStatement != null) {
      joinStatements.add(joinStatement);
      continue;
    }

    var tableRelation = joinContext.tableRelation;
    joinStatement = 'LEFT JOIN';
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
  TableRelation? countTableRelation,
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

  if (countTableRelation != null) {
    if (!countTableRelation.lastJoiningColumn.hasBaseTable(tableName)) {
      exceptionMessages.add('"countTableRelation" referencing column '
          '${countTableRelation.lastJoiningColumn}.');
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
