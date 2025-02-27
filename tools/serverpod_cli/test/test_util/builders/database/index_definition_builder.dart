import 'package:serverpod_service_client/serverpod_service_client.dart';

class IndexDefinitionBuilder {
  String _indexName;
  List<IndexElementDefinition> _elements;
  String _type;
  bool _isUnique;
  bool _isPrimary;
  String? _predicate;

  IndexDefinitionBuilder()
      : _indexName = 'example_index',
        _elements = [],
        _type = 'btree',
        _isUnique = false,
        _isPrimary = false,
        _predicate = null;

  IndexDefinition build() {
    return IndexDefinition(
      indexName: _indexName,
      elements: _elements,
      type: _type,
      isUnique: _isUnique,
      isPrimary: _isPrimary,
      predicate: _predicate,
    );
  }

  IndexDefinitionBuilder withIdIndex(String tableName) {
    _indexName = '${tableName}_pkey';
    _elements = [
      IndexElementDefinition(
          definition: 'id', type: IndexElementDefinitionType.column)
    ];
    _type = 'btree';
    _isUnique = true;
    _isPrimary = true;
    return this;
  }

  IndexDefinitionBuilder withIndexName(String indexName) {
    _indexName = indexName;
    return this;
  }

  IndexDefinitionBuilder withElements(List<IndexElementDefinition> elements) {
    _elements = elements;
    return this;
  }

  IndexDefinitionBuilder withType(String type) {
    _type = type;
    return this;
  }

  IndexDefinitionBuilder withIsUnique(bool isUnique) {
    _isUnique = isUnique;
    return this;
  }

  IndexDefinitionBuilder withIsPrimary(bool isPrimary) {
    _isPrimary = isPrimary;
    return this;
  }

  IndexDefinitionBuilder withPredicate(String? predicate) {
    _predicate = predicate;
    return this;
  }
}
