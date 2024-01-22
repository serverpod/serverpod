/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// The definition of a (desired) index in the database.
abstract class IndexDefinition extends _i1.SerializableEntity {
  IndexDefinition._({
    required this.indexName,
    this.tableSpace,
    required this.elements,
    required this.type,
    required this.isUnique,
    required this.isPrimary,
    this.predicate,
  });

  factory IndexDefinition({
    required String indexName,
    String? tableSpace,
    required List<_i2.IndexElementDefinition> elements,
    required String type,
    required bool isUnique,
    required bool isPrimary,
    String? predicate,
  }) = _IndexDefinitionImpl;

  factory IndexDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return IndexDefinition(
      indexName: serializationManager
          .deserialize<String>(jsonSerialization['indexName']),
      tableSpace: serializationManager
          .deserialize<String?>(jsonSerialization['tableSpace']),
      elements:
          serializationManager.deserialize<List<_i2.IndexElementDefinition>>(
              jsonSerialization['elements']),
      type: serializationManager.deserialize<String>(jsonSerialization['type']),
      isUnique:
          serializationManager.deserialize<bool>(jsonSerialization['isUnique']),
      isPrimary: serializationManager
          .deserialize<bool>(jsonSerialization['isPrimary']),
      predicate: serializationManager
          .deserialize<String?>(jsonSerialization['predicate']),
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

  IndexDefinition copyWith({
    String? indexName,
    String? tableSpace,
    List<_i2.IndexElementDefinition>? elements,
    String? type,
    bool? isUnique,
    bool? isPrimary,
    String? predicate,
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
    };
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
  }) : super._(
          indexName: indexName,
          tableSpace: tableSpace,
          elements: elements,
          type: type,
          isUnique: isUnique,
          isPrimary: isPrimary,
          predicate: predicate,
        );

  @override
  IndexDefinition copyWith({
    String? indexName,
    Object? tableSpace = _Undefined,
    List<_i2.IndexElementDefinition>? elements,
    String? type,
    bool? isUnique,
    bool? isPrimary,
    Object? predicate = _Undefined,
  }) {
    return IndexDefinition(
      indexName: indexName ?? this.indexName,
      tableSpace: tableSpace is String? ? tableSpace : this.tableSpace,
      elements: elements ?? this.elements.clone(),
      type: type ?? this.type,
      isUnique: isUnique ?? this.isUnique,
      isPrimary: isPrimary ?? this.isPrimary,
      predicate: predicate is String? ? predicate : this.predicate,
    );
  }
}
