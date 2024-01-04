import 'package:serverpod_cli/src/test_util/builders/database/column_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/index_definition_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class TableDefinitionBuilder {
  String _name;
  String? _dartName;
  String? _module;
  String _schema;
  List<ColumnDefinition> _columns;
  List<ForeignKeyDefinition> _foreignKeys;
  List<IndexDefinition> _indexes;
  bool? _managed;

  TableDefinitionBuilder()
      : _name = 'example',
        _dartName = 'Example',
        _schema = 'public',
        _module = 'test_project',
        _columns = [
          ColumnDefinitionBuilder().withIdColumn().build(),
          ColumnDefinitionBuilder().withNameColumn().build(),
        ],
        _foreignKeys = [],
        _indexes = [
          IndexDefinitionBuilder().withIdIndex('example').build(),
        ],
        _managed = true;

  TableDefinition build() {
    return TableDefinition(
      name: _name,
      dartName: _dartName,
      module: _module,
      schema: _schema,
      columns: _columns,
      foreignKeys: _foreignKeys,
      indexes: _indexes,
      managed: _managed,
    );
  }

  TableDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  TableDefinitionBuilder withDartName(String? dartName) {
    _dartName = dartName;
    return this;
  }

  TableDefinitionBuilder withModule(String? module) {
    _module = module;
    return this;
  }

  TableDefinitionBuilder withSchema(String schema) {
    _schema = schema;
    return this;
  }

  TableDefinitionBuilder withColumn(ColumnDefinition column) {
    _columns.add(column);
    return this;
  }

  TableDefinitionBuilder withColumns(List<ColumnDefinition> columns) {
    _columns = columns;
    return this;
  }

  TableDefinitionBuilder withForeignKey(ForeignKeyDefinition foreignKey) {
    _foreignKeys.add(foreignKey);
    return this;
  }

  TableDefinitionBuilder withForeignKeys(
      List<ForeignKeyDefinition> foreignKeys) {
    _foreignKeys = foreignKeys;
    return this;
  }

  TableDefinitionBuilder withIndex(IndexDefinition index) {
    _indexes.add(index);
    return this;
  }

  TableDefinitionBuilder withIndexes(List<IndexDefinition> indexes) {
    _indexes = indexes;
    return this;
  }

  TableDefinitionBuilder withManaged(bool? managed) {
    _managed = managed;
    return this;
  }
}
