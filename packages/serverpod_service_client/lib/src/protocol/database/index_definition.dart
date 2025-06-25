/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../database/index_element_definition.dart' as _i2;
import '../database/vector_distance_function.dart' as _i3;
import '../database/column_type.dart' as _i4;

/// The definition of a (desired) index in the database.
abstract class IndexDefinition implements _i1.SerializableModel {
  IndexDefinition._({
    required this.indexName,
    this.tableSpace,
    required this.elements,
    required this.type,
    required this.isUnique,
    required this.isPrimary,
    this.predicate,
    this.vectorDistanceFunction,
    this.vectorColumnType,
    this.parameters,
  });

  factory IndexDefinition({
    required String indexName,
    String? tableSpace,
    required List<_i2.IndexElementDefinition> elements,
    required String type,
    required bool isUnique,
    required bool isPrimary,
    String? predicate,
    _i3.VectorDistanceFunction? vectorDistanceFunction,
    _i4.ColumnType? vectorColumnType,
    Map<String, String>? parameters,
  }) = _IndexDefinitionImpl;

  factory IndexDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return IndexDefinition(
      indexName: jsonSerialization['indexName'] as String,
      tableSpace: jsonSerialization['tableSpace'] as String?,
      elements: (jsonSerialization['elements'] as List)
          .map((e) =>
              _i2.IndexElementDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      type: jsonSerialization['type'] as String,
      isUnique: jsonSerialization['isUnique'] as bool,
      isPrimary: jsonSerialization['isPrimary'] as bool,
      predicate: jsonSerialization['predicate'] as String?,
      vectorDistanceFunction:
          jsonSerialization['vectorDistanceFunction'] == null
              ? null
              : _i3.VectorDistanceFunction.fromJson(
                  (jsonSerialization['vectorDistanceFunction'] as String)),
      vectorColumnType: jsonSerialization['vectorColumnType'] == null
          ? null
          : _i4.ColumnType.fromJson(
              (jsonSerialization['vectorColumnType'] as int)),
      parameters:
          (jsonSerialization['parameters'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as String,
              )),
    );
  }

  /// The user defined name of the index
  String indexName;

  /// The tablespace this index is stored in.
  /// If null, the index is in the databases default tablespace.
  String? tableSpace;

  /// The elements, that are a part of this index.
  List<_i2.IndexElementDefinition> elements;

  /// The type of the index
  String type;

  /// Whether the index is unique.
  bool isUnique;

  /// Whether this index is the one for the primary key.
  bool isPrimary;

  /// The predicate of this partial index, if it is one.
  String? predicate;

  /// The vector index distance function, if it is a vector index.
  _i3.VectorDistanceFunction? vectorDistanceFunction;

  /// The vector column type, if it is a vector index.
  _i4.ColumnType? vectorColumnType;

  /// Parameters for the index, if needed.
  Map<String, String>? parameters;

  /// Returns a shallow copy of this [IndexDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IndexDefinition copyWith({
    String? indexName,
    String? tableSpace,
    List<_i2.IndexElementDefinition>? elements,
    String? type,
    bool? isUnique,
    bool? isPrimary,
    String? predicate,
    _i3.VectorDistanceFunction? vectorDistanceFunction,
    _i4.ColumnType? vectorColumnType,
    Map<String, String>? parameters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'indexName': indexName,
      if (tableSpace != null) 'tableSpace': tableSpace,
      'elements': elements.toJson(valueToJson: (v) => v.toJson()),
      'type': type,
      'isUnique': isUnique,
      'isPrimary': isPrimary,
      if (predicate != null) 'predicate': predicate,
      if (vectorDistanceFunction != null)
        'vectorDistanceFunction': vectorDistanceFunction?.toJson(),
      if (vectorColumnType != null)
        'vectorColumnType': vectorColumnType?.toJson(),
      if (parameters != null) 'parameters': parameters?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IndexDefinitionImpl extends IndexDefinition {
  _IndexDefinitionImpl({
    required String indexName,
    String? tableSpace,
    required List<_i2.IndexElementDefinition> elements,
    required String type,
    required bool isUnique,
    required bool isPrimary,
    String? predicate,
    _i3.VectorDistanceFunction? vectorDistanceFunction,
    _i4.ColumnType? vectorColumnType,
    Map<String, String>? parameters,
  }) : super._(
          indexName: indexName,
          tableSpace: tableSpace,
          elements: elements,
          type: type,
          isUnique: isUnique,
          isPrimary: isPrimary,
          predicate: predicate,
          vectorDistanceFunction: vectorDistanceFunction,
          vectorColumnType: vectorColumnType,
          parameters: parameters,
        );

  /// Returns a shallow copy of this [IndexDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IndexDefinition copyWith({
    String? indexName,
    Object? tableSpace = _Undefined,
    List<_i2.IndexElementDefinition>? elements,
    String? type,
    bool? isUnique,
    bool? isPrimary,
    Object? predicate = _Undefined,
    Object? vectorDistanceFunction = _Undefined,
    Object? vectorColumnType = _Undefined,
    Object? parameters = _Undefined,
  }) {
    return IndexDefinition(
      indexName: indexName ?? this.indexName,
      tableSpace: tableSpace is String? ? tableSpace : this.tableSpace,
      elements: elements ?? this.elements.map((e0) => e0.copyWith()).toList(),
      type: type ?? this.type,
      isUnique: isUnique ?? this.isUnique,
      isPrimary: isPrimary ?? this.isPrimary,
      predicate: predicate is String? ? predicate : this.predicate,
      vectorDistanceFunction:
          vectorDistanceFunction is _i3.VectorDistanceFunction?
              ? vectorDistanceFunction
              : this.vectorDistanceFunction,
      vectorColumnType: vectorColumnType is _i4.ColumnType?
          ? vectorColumnType
          : this.vectorColumnType,
      parameters: parameters is Map<String, String>?
          ? parameters
          : this.parameters?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
    );
  }
}
