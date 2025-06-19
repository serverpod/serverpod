import 'package:serverpod_service_client/serverpod_service_client.dart';

class IndexDefinitionBuilder {
  String _indexName;
  List<IndexElementDefinition> _elements;
  String _type;
  bool _isUnique;
  bool _isPrimary;
  String? _predicate;
  VectorDistanceFunction? _vectorDistanceFunction;
  ColumnType? _vectorColumnType;
  Map<String, String>? _parameters;

  IndexDefinitionBuilder()
      : _indexName = 'example_index',
        _elements = [],
        _type = 'btree',
        _isUnique = false,
        _isPrimary = false,
        _predicate = null,
        _vectorDistanceFunction = null,
        _vectorColumnType = null,
        _parameters = null;

  IndexDefinition build() {
    return IndexDefinition(
      indexName: _indexName,
      elements: _elements,
      type: _type,
      isUnique: _isUnique,
      isPrimary: _isPrimary,
      predicate: _predicate,
      vectorDistanceFunction: _vectorDistanceFunction,
      vectorColumnType: _vectorColumnType,
      parameters: _parameters,
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
    if ((_type == 'hnsw' || _type == 'ivfflat') &&
        _vectorDistanceFunction == null) {
      _vectorDistanceFunction = VectorDistanceFunction.l2;
    }
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

  IndexDefinitionBuilder withVectorDistanceFunction(
    VectorDistanceFunction? vectorDistanceFunction,
  ) {
    _vectorDistanceFunction = vectorDistanceFunction;
    return this;
  }

  IndexDefinitionBuilder withVectorColumnType(ColumnType? vectorColumnType) {
    _vectorColumnType = vectorColumnType;
    return this;
  }

  IndexDefinitionBuilder withParameters(Map<String, String>? parameters) {
    _parameters = parameters;
    return this;
  }
}
