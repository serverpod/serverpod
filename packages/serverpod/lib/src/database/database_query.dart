// ignore_for_file: public_member_api_docs

import 'dart:collection';

import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/table_relation.dart';

class SelectQueryBuilder {
  final String _table;
  List<String> _fields;
  List<Order>? _orderByList;
  int? _limit;
  int? _offset;
  Expression? _where;
  Include? _include;

  SelectQueryBuilder({required table})
      : _table = table,
        _fields = ['*'];

  String build() {
    var join = _buildJoinQuery(
        where: _where, orderBy: _orderByList, include: _include);

    var query = _buildSelectQuery(_fields, _include);
    query += ' FROM $_table';
    if (join != null) query += ' $join';
    if (_where != null) query += ' WHERE $_where';
    if (_orderByList != null) {
      query +=
          ' ORDER BY ${_orderByList?.map((order) => order.toString()).join(', ')}';
    }
    if (_limit != null) query += ' LIMIT $_limit';
    if (_offset != null) query += ' OFFSET $_offset';

    return query;
  }

  SelectQueryBuilder withSelectFields(List<String> fields) {
    _fields = fields;
    return this;
  }

  SelectQueryBuilder withOrderBy(List<Order>? orderByList) {
    if (orderByList == null || orderByList.isEmpty) {
      return this;
    }

    _orderByList = orderByList;
    return this;
  }

  SelectQueryBuilder withLimit(int? limit) {
    _limit = limit;
    return this;
  }

  SelectQueryBuilder withOffset(int? offset) {
    _offset = offset;
    return this;
  }

  SelectQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  SelectQueryBuilder withInclude(Include? include) {
    _include = include;
    return this;
  }
}

class CountQueryBuilder {
  final String _table;
  String? _alias;
  String _field;
  int? _limit;
  Expression? _where;

  CountQueryBuilder({required table})
      : _table = table,
        _field = '*';

  CountQueryBuilder withCountAlias(String alias) {
    _alias = alias;
    return this;
  }

  CountQueryBuilder withField(String field) {
    _field = field;
    return this;
  }

  CountQueryBuilder withLimit(int? limit) {
    _limit = limit;
    return this;
  }

  CountQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  String build() {
    var join = _buildJoinQuery(where: _where);

    var query = 'SELECT COUNT($_field)';
    if (_alias != null) query += ' AS $_alias';
    query += ' FROM $_table';
    if (join != null) query += ' $join';
    if (_where != null) query += ' WHERE $_where';
    if (_limit != null) query += ' LIMIT $_limit';
    return query;
  }
}

class _UsingQuery {
  final String using;
  final String where;

  _UsingQuery({required this.using, required this.where});
}

class DeleteQueryBuilder {
  final String _table;
  bool? returnAll;
  Expression? _where;
  DeleteQueryBuilder({required table}) : _table = table;

  DeleteQueryBuilder withReturnAll() {
    returnAll = true;
    return this;
  }

  DeleteQueryBuilder withWhere(Expression? where) {
    _where = where;
    return this;
  }

  String build() {
    var using = _buildUsingQuery(where: _where);

    var query = 'DELETE FROM $_table';
    if (using != null) query += ' USING ${using.using}';
    if (_where != null) query += ' WHERE $_where';
    if (using != null) query += ' AND ${using.where}';
    if (returnAll != null) query += ' RETURNING *';
    return query;
  }
}

String _buildSelectQuery(List<String> fields, Include? include) {
  var selectQueryFields = fields;

  if (include != null) {
    selectQueryFields.addAll(gatherIncludeFields(include));
  }

  return 'SELECT ${selectQueryFields.join(', ')}';
}

List<String> gatherIncludeFields(Include? include) {
  if (include == null) {
    return [];
  }

  var includeTables = _gatherIncludeTables(include, include.table);

  LinkedHashSet<String> fields = LinkedHashSet();
  for (var table in includeTables) {
    for (var column in table.columns) {
      fields.add('$column AS "${column.queryAlias}"');
    }
  }

  return fields.toList();
}

List<Table> _gatherIncludeTables(Include? include, Table table) {
  List<Table> tables = [];
  if (include == null) {
    return tables;
  }

  include.includes.forEach((relationField, relationInclude) {
    // Get table from include
    var relationTable = table.getRelationTable(relationField);
    if (relationTable == null) {
      return;
    }

    tables.add(relationTable);

    var tablesFromInclude =
        _gatherIncludeTables(relationInclude, relationTable);
    tables.addAll(tablesFromInclude);
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
    tableRelations.addAll(_gatherTableRelations(where));
  }

  if (orderBy != null) {
    for (var order in orderBy) {
      tableRelations.addAll(_gatherTableRelations(order.column));
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
    tableRelations.addAll(_gatherTableRelations(where));
  }

  if (tableRelations.isEmpty) {
    return null;
  }

  return _usingQueryFromTableRelations(tableRelations);
}

LinkedHashMap<String, TableRelation> _gatherTableRelations(
    Expression expression) {
  // Linked hash map to preserve order
  LinkedHashMap<String, TableRelation> joins = LinkedHashMap();
  var columnsWithTableRelations = expression.nodes
      .whereType<Column>()
      .where((column) => column.tableRelations != null);
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
    joinStatements.add('LEFT JOIN ${tableRelation.tableName} '
        'AS ${tableRelation.tableNameWithQueryPrefix} '
        'ON ${tableRelation.foreignTableColumn} '
        '= ${tableRelation.column}');
  }
  return joinStatements.join(' ');
}

_UsingQuery _usingQueryFromTableRelations(
    LinkedHashMap<String, TableRelation> tableRelations) {
  List<String> usingStatements = [];
  List<String> whereStatements = [];
  for (var tableRelation in tableRelations.values) {
    usingStatements.add(
        '${tableRelation.tableName} AS ${tableRelation.tableNameWithQueryPrefix}');
    whereStatements
        .add('${tableRelation.foreignTableColumn} = ${tableRelation.column}');
  }
  return _UsingQuery(
    using: usingStatements.join(', '),
    where: whereStatements.join(' AND '),
  );
}
