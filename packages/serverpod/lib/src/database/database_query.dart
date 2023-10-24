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
  Expression? _manyRelationWhereAddition;
  bool _forceGroupBy = false;
  ColumnExpression? _having;
  Include? _include;
  _ListQueryAdditions? _listQueryAdditions;
  bool _joinOneLevelManyRelationWhereExpressions = false;
  bool _wrapWhereInNot = false;
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
      manyRelationWhereAddition: _manyRelationWhereAddition,
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
      forceGroupBy: _forceGroupBy,
    );

    var where = _buildWhereQuery(
      where: _where,
      manyRelationWhereAddition: _manyRelationWhereAddition,
      listQueryAdditions: _listQueryAdditions,
      subQueries: subQueries,
      wrapWhereInNot: _wrapWhereInNot,
    );

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

  /// Sets an expression addition to the where expression without adding more
  /// sub queries for the query. This is used to support filtering on many
  /// relations in sub queries without adding more sub queries.
  ///
  /// The where addition will be added to the where expression with an AND
  /// operator.
  SelectQueryBuilder withManyRelationWhereAddition(
      Expression? manyRelationWhereAddition) {
    _manyRelationWhereAddition = manyRelationWhereAddition;
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

  /// Wraps the where expression in a NOT statement.
  SelectQueryBuilder _wrapWhereInNotStatement() {
    _wrapWhereInNot = true;
    return this;
  }

  /// Forces the query to include a group by statement.
  SelectQueryBuilder forceGroupBy() {
    _forceGroupBy = true;
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
  ///
  /// Throws a [UnimplementedError] if the where expression includes a count
  /// column since these are not supported yet.
  DeleteQueryBuilder withWhere(Expression? where) {
    if (where != null && where.columns.whereType<ColumnCount>().isNotEmpty) {
      // TODO - Add support for count columns in where expressions.
      throw UnimplementedError(
        'Count columns are not supported in delete where expressions.',
      );
    }
    _where = where;
    return this;
  }

  /// Builds the SQL query.
  String build() {
    _validateTableReferences(_table.tableName, where: _where);

    var using = _buildUsingQuery(where: _where);

    var query = 'DELETE FROM "${_table.tableName}"';
    if (using != null) query += ' USING ${using.using}';
    if (_where != null) query += ' WHERE $_where';
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
        ', COUNT(${countTableRelation.foreignFieldNameWithJoins}) AS "count"';
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

String? _buildJoinQuery({
  Expression? where,
  Expression? manyRelationWhereAddition,
  ColumnExpression? having,
  List<Order>? orderBy,
  Include? include,
  _SubQueries? subQueries,
  TableRelation? countTableRelation,
  joinOneLevelManyRelations = false,
}) {
  // Linked hash map to preserve order and remove duplicates.
  // Key is the query alias and value is the join statement.
  LinkedHashMap<String, String> joins = LinkedHashMap();
  if (where != null) {
    joins.addAll(_gatherWhereJoins(
      where.columns,
      joinOneLevelManyRelations: joinOneLevelManyRelations,
    ));
  }

  if (manyRelationWhereAddition != null) {
    joins.addAll(_gatherWhereAdditionJoins(manyRelationWhereAddition.columns));
  }

  if (orderBy != null) {
    joins.addAll(_gatherOrderByJoins(orderBy, subQueries: subQueries));
  }

  if (include != null) {
    joins.addAll(_gatherIncludeJoins(include));
  }

  if (countTableRelation != null) {
    joins[countTableRelation.relationQueryAlias] =
        _buildJoinStatement(tableRelation: countTableRelation);
  }

  if (having != null) {
    joins.addEntries([_buildHavingJoin(having)]);
  }

  if (joins.isEmpty) {
    return null;
  }

  return joins.values.join(' ');
}

String? _buildGroupByQuery(
  List<Column> selectFields, {
  Expression? having,
  Expression? whereAddition,
  TableRelation? countTableRelation,
  bool forceGroupBy = false,
}) {
  if (countTableRelation == null &&
      having == null &&
      whereAddition == null &&
      forceGroupBy == false) {
    return null;
  }

  return selectFields.map((column) => '$column').join(', ');
}

StateError _createStateErrorWithMessage(String message) {
  const stateErrorMessage = 'This likely means that the code generator did not '
      'create the table relations correctly.';
  return StateError('$message - $stateErrorMessage');
}

String? _buildWhereQuery({
  Expression? where,
  Expression? manyRelationWhereAddition,
  _SubQueries? subQueries,
  _ListQueryAdditions? listQueryAdditions,
  bool wrapWhereInNot = false,
}) {
  var whereQuery = '';

  if (where != null) {
    whereQuery += _resolveWhereQuery(where: where, subQueries: subQueries);

    if (wrapWhereInNot) {
      whereQuery = 'NOT $whereQuery';
    }
  }

  if (listQueryAdditions != null) {
    if (whereQuery.isNotEmpty) {
      whereQuery += ' AND ';
    }

    whereQuery += '${listQueryAdditions.whereAddition}';
  }

  if (manyRelationWhereAddition != null) {
    if (whereQuery.isNotEmpty) {
      if (manyRelationWhereAddition is EveryExpression) {
        whereQuery += ' OR ';
      } else {
        whereQuery += ' AND ';
      }
    }

    whereQuery += '$manyRelationWhereAddition';
  }

  return whereQuery.isEmpty ? null : whereQuery;
}

String _resolveWhereQuery(
    {Expression<dynamic>? where, _SubQueries? subQueries}) {
  var whereQuery = '';

  if (where == null) {
    return whereQuery;
  }

  if (where is TwoPartExpression) {
    var subExpressions = where.subExpressions;

    whereQuery += '(';
    whereQuery += subExpressions
        .map((e) => _resolveWhereQuery(where: e, subQueries: subQueries))
        .join(' ${where.operator} ');
    whereQuery += ')';
  } else if (where is NotExpression) {
    whereQuery += where.wrapExpression(
        _resolveWhereQuery(where: where.subExpression, subQueries: subQueries));
  } else if (where is ColumnExpression && where.isManyRelationExpression) {
    var column = where.column;
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      throw _createStateErrorWithMessage('Table relation is null');
    }

    var expressionIndex = where.index;
    if (expressionIndex == null) {
      throw _createStateErrorWithMessage('Expression index is null');
    }

    var subQuery = subQueries?._whereCountQueries[expressionIndex];
    if (subQuery == null) {
      throw _createStateErrorWithMessage(
          'Sub query for expression index \'$expressionIndex\' is null');
    }

    if (where is NoneExpression || where is EveryExpression) {
      whereQuery = '${tableRelation.fieldNameWithJoins} NOT IN '
          '(SELECT "${subQuery.alias}"."${tableRelation.fieldQueryAlias}" '
          'FROM "${subQuery.alias}")';
    } else {
      whereQuery = '${tableRelation.fieldNameWithJoins} IN '
          '(SELECT "${subQuery.alias}"."${tableRelation.fieldQueryAlias}" '
          'FROM "${subQuery.alias}")';
    }
  } else {
    whereQuery = where.toString();
  }
  return whereQuery;
}

_UsingQuery? _buildUsingQuery({Expression? where}) {
  List<TableRelation> tableRelations = [];
  if (where != null) {
    tableRelations.addAll(
      _gatherTableRelationsFromWhereWithoutSubQueries(where.columns),
    );
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _usingQueryFromTableRelations(tableRelations);
}

class _SubQuery {
  final String query;
  final String alias;

  _SubQuery(this.query, this.alias);
}

class _SubQueries {
  static const String orderByPrefix = 'order_by';
  static const String whereCountPrefix = 'where_count';
  static const String whereNonePrefix = 'where_none';
  static const String whereAnyPrefix = 'where_any';
  static const String whereEveryPrefix = 'where_every';
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
      subQueries._whereCountQueries.addAll(_gatherWhereSubQueries(where));
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
        throw _createStateErrorWithMessage('Table relation is null');
      }

      var relationQueryAlias = tableRelation.relationQueryAlias;
      var uniqueRelationQueryAlias =
          buildUniqueQueryAlias(orderByPrefix, relationQueryAlias, index);

      var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
          .withWhere(column.innerWhere)
          .enableOneLevelWhereExpressionJoins()
          .withSelectFields([tableRelation.fieldColumn])
          .withCountTableRelation(tableRelation.lastRelation)
          .build();

      subQueries[index] = _SubQuery(subQuery, uniqueRelationQueryAlias);
    });

    return subQueries;
  }

  static Map<int, _SubQuery> _gatherWhereSubQueries(Expression where) {
    Map<int, _SubQuery> subQueries = {};

    where.forEachDepthFirstIndexed((index, expression) {
      if (expression is! ColumnExpression) return;

      if (!expression.isManyRelationExpression) return;

      var column = expression.column;

      if (column is! ColumnCount) return;

      var tableRelation = column.table.tableRelation;

      if (tableRelation == null) {
        throw _createStateErrorWithMessage('Table relation is null');
      }

      var relationQueryAlias = tableRelation.relationQueryAlias;

      /// Store index of the expressions so that we later can retrieve the
      /// matching sub query alias.
      expression.index = index;
      if (expression is NoneExpression) {
        subQueries[index] = _buildWhereNoneSubQuery(
          relationQueryAlias,
          index,
          tableRelation,
          column,
          expression,
        );
      } else if (expression is AnyExpression) {
        subQueries[index] = _buildWhereAnySubQuery(
          relationQueryAlias,
          index,
          tableRelation,
          column,
          expression,
        );
      } else if (expression is EveryExpression) {
        subQueries[index] = _buildWhereEverySubQuery(
          relationQueryAlias,
          index,
          tableRelation,
          column,
          expression,
        );
      } else {
        subQueries[index] = _buildWhereCountSubQuery(
          relationQueryAlias,
          index,
          tableRelation,
          column,
          expression,
        );
      }
    });

    return subQueries;
  }

  static _SubQuery _buildWhereCountSubQuery(
      String relationQueryAlias,
      int index,
      TableRelation tableRelation,
      ColumnCount column,
      ColumnExpression<dynamic> expression) {
    var uniqueRelationQueryAlias =
        buildUniqueQueryAlias(whereCountPrefix, relationQueryAlias, index);

    var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
        .withWhere(column.innerWhere)
        .withSelectFields([tableRelation.fieldColumn])
        .enableOneLevelWhereExpressionJoins()
        .withHaving(expression)
        .build();

    return _SubQuery(subQuery, uniqueRelationQueryAlias);
  }

  static _SubQuery _buildWhereNoneSubQuery(
      String relationQueryAlias,
      int index,
      TableRelation tableRelation,
      ColumnCount column,
      ColumnExpression<dynamic> expression) {
    var uniqueRelationQueryAlias =
        buildUniqueQueryAlias(whereNonePrefix, relationQueryAlias, index);

    var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
        .withWhere(column.innerWhere)
        .withManyRelationWhereAddition(expression)
        .withSelectFields([tableRelation.fieldColumn])
        .enableOneLevelWhereExpressionJoins()
        .forceGroupBy()
        .build();

    return _SubQuery(subQuery, uniqueRelationQueryAlias);
  }

  static _SubQuery _buildWhereAnySubQuery(
      String relationQueryAlias,
      int index,
      TableRelation tableRelation,
      ColumnCount column,
      ColumnExpression<dynamic> expression) {
    var uniqueRelationQueryAlias =
        buildUniqueQueryAlias(whereAnyPrefix, relationQueryAlias, index);

    var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
        .withWhere(column.innerWhere)
        .withManyRelationWhereAddition(expression)
        .withSelectFields([tableRelation.fieldColumn])
        .enableOneLevelWhereExpressionJoins()
        .forceGroupBy()
        .build();

    return _SubQuery(subQuery, uniqueRelationQueryAlias);
  }

  static _SubQuery _buildWhereEverySubQuery(
      String relationQueryAlias,
      int index,
      TableRelation tableRelation,
      ColumnCount column,
      ColumnExpression<dynamic> expression) {
    var uniqueRelationQueryAlias =
        buildUniqueQueryAlias(whereEveryPrefix, relationQueryAlias, index);

    var subQuery = SelectQueryBuilder(table: tableRelation.fieldTable)
        .withWhere(column.innerWhere)
        .withManyRelationWhereAddition(expression)
        .withSelectFields([tableRelation.fieldColumn])
        .enableOneLevelWhereExpressionJoins()
        ._wrapWhereInNotStatement()
        .forceGroupBy()
        .build();

    return _SubQuery(subQuery, uniqueRelationQueryAlias);
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
    throw _createStateErrorWithMessage(
        'Query alias for order by sub query is null.');
  }

  var str = '"$queryAlias"."count"';
  str += orderDescending ? ' DESC NULLS LAST' : ' ASC NULLS FIRST';
  return str;
}

LinkedHashMap<String, String> _gatherOrderByJoins(
  List<Order> orderBy, {
  _SubQueries? subQueries,
}) {
  // Linked hash map to preserve order and remove duplicates.
  LinkedHashMap<String, String> joins = LinkedHashMap();
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
          throw _createStateErrorWithMessage('Order by sub queries is null.');
        }

        var queryAlias = orderByQueries[orderIndex]?.alias;

        if (queryAlias == null) {
          throw _createStateErrorWithMessage(
              'Missing query alias for order by sub query with index $index.');
        }

        joins[queryAlias] = _buildSubQueryJoinStatement(
          tableRelation: tableRelation,
          queryAlias: queryAlias,
        );
      } else {
        joins[subTableRelation.relationQueryAlias] = _buildJoinStatement(
          tableRelation: subTableRelation,
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
  return 'LEFT JOIN "$queryAlias" ON ${tableRelation.fieldNameWithJoins} '
      '= "$queryAlias"."${tableRelation.fieldQueryAlias}"';
}

String _buildJoinStatement({required TableRelation tableRelation}) {
  return 'LEFT JOIN "${tableRelation.foreignTableName}" AS '
      '"${tableRelation.relationQueryAlias}" ON '
      '${tableRelation.fieldNameWithJoins} = '
      '${tableRelation.foreignFieldNameWithJoins}';
}

LinkedHashMap<String, String> _gatherWhereJoins(
  List<Column> columns, {
  joinOneLevelManyRelations = false,
}) {
  // Linked hash map to preserve order and remove duplicates.
  LinkedHashMap<String, String> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.table.tableRelation != null);
  for (var column in columnsWithTableRelations) {
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      continue;
    }

    var manyRelationColumn = column is ColumnCount;
    var subTableRelations = tableRelation.getRelations;

    bool oneLevelManyRelation =
        manyRelationColumn && subTableRelations.length == 1;

    var skipLast = manyRelationColumn &&
        !(oneLevelManyRelation && joinOneLevelManyRelations);

    var lastEntryIndex = subTableRelations.length - 1;
    subTableRelations.forEachIndexed((index, subTableRelation) {
      bool lastEntry = index == lastEntryIndex;
      if (lastEntry && skipLast) {
        return;
      }

      joins[subTableRelation.relationQueryAlias] =
          _buildJoinStatement(tableRelation: subTableRelation);
    });
  }

  return joins;
}

LinkedHashMap<String, String> _gatherWhereAdditionJoins(List<Column> columns) {
  // Linked hash map to preserve order and remove duplicates.
  LinkedHashMap<String, String> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.table.tableRelation != null);
  for (var column in columnsWithTableRelations) {
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      continue;
    }

    // We only join the last relation since the where addition is only added
    // to support filtering on filter on a many relations. And the last relation
    // represents the connection to the many relation.
    var lastRelation = tableRelation.lastRelation;
    joins[lastRelation.relationQueryAlias] =
        _buildJoinStatement(tableRelation: lastRelation);
  }

  return joins;
}

List<TableRelation> _gatherTableRelationsFromWhereWithoutSubQueries(
  List<Column> columns,
) {
  // Linked hash map to preserve order and remove duplicates.
  LinkedHashMap<String, TableRelation> joins = LinkedHashMap();
  var columnsWithTableRelations =
      columns.where((column) => column.table.tableRelation != null);
  for (var column in columnsWithTableRelations) {
    var tableRelation = column.table.tableRelation;
    if (tableRelation == null) {
      continue;
    }

    List<TableRelation> subTableRelations = tableRelation.getRelations;
    subTableRelations.forEachIndexed((index, subTableRelation) {
      joins[subTableRelation.relationQueryAlias] = subTableRelation;
    });
  }

  return joins.values.toList();
}

MapEntry<String, String> _buildHavingJoin(
  ColumnExpression having,
) {
  var column = having.column;
  var tableRelation = column.table.tableRelation;
  if (tableRelation == null) {
    throw _createStateErrorWithMessage('Table relation is null.');
  }
  var lastRelation = tableRelation.lastRelation;

  return MapEntry(
    lastRelation.relationQueryAlias,
    _buildJoinStatement(tableRelation: lastRelation),
  );
}

LinkedHashMap<String, String> _gatherIncludeJoins(
  Include include,
) {
  // Linked hash map to preserve order and remove duplicates.
  LinkedHashMap<String, String> joins = LinkedHashMap();
  var includeTables = _gatherIncludeTables(include, include.table);
  var tablesWithTableRelations =
      includeTables.where((table) => table.tableRelation != null);
  for (var table in tablesWithTableRelations) {
    var tableRelation = table.tableRelation;

    for (var subTableRelation in tableRelation?.getRelations ?? []) {
      joins[subTableRelation.relationQueryAlias] = _buildJoinStatement(
        tableRelation: subTableRelation,
      );
    }
  }

  return joins;
}

_UsingQuery _usingQueryFromTableRelations(List<TableRelation> tableRelations) {
  List<String> usingStatements = [];
  List<String> whereStatements = [];
  for (var tableRelation in tableRelations) {
    usingStatements.add(
        '"${tableRelation.foreignTableName}" AS "${tableRelation.relationQueryAlias}"');
    whereStatements.add(
        '${tableRelation.fieldNameWithJoins} = ${tableRelation.foreignFieldNameWithJoins}');
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
    if (!countTableRelation.fieldColumn.hasBaseTable(tableName)) {
      exceptionMessages.add('"countTableRelation" referencing column '
          '${countTableRelation.fieldColumn}.');
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
