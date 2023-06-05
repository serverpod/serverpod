/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// The definition of a (desired) index in the database.
class IndexDefinition extends _i1.SerializableEntity {
  IndexDefinition({
    required this.indexName,
    this.tableSpace,
    required this.elements,
    required this.type,
    required this.isUnique,
    required this.isPrimary,
    this.predicate,
  });

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
  final String indexName;

  /// The tablespace this index is stored in.
  /// If null, the index is in the databases default tablespace.
  final String? tableSpace;

  /// The elements, that are a part of this index.
  final List<_i2.IndexElementDefinition> elements;

  /// The type of the index
  final String type;

  /// Whether the index is unique.
  final bool isUnique;

  /// Whether this index is the one for the primary key.
  final bool isPrimary;

  /// The predicate of this partial index, if it is one.
  final String? predicate;

  late Function({
    String? indexName,
    String? tableSpace,
    List<_i2.IndexElementDefinition>? elements,
    String? type,
    bool? isUnique,
    bool? isPrimary,
    String? predicate,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'indexName': indexName,
      'tableSpace': tableSpace,
      'elements': elements,
      'type': type,
      'isUnique': isUnique,
      'isPrimary': isPrimary,
      'predicate': predicate,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is IndexDefinition &&
            (identical(
                  other.indexName,
                  indexName,
                ) ||
                other.indexName == indexName) &&
            (identical(
                  other.tableSpace,
                  tableSpace,
                ) ||
                other.tableSpace == tableSpace) &&
            (identical(
                  other.type,
                  type,
                ) ||
                other.type == type) &&
            (identical(
                  other.isUnique,
                  isUnique,
                ) ||
                other.isUnique == isUnique) &&
            (identical(
                  other.isPrimary,
                  isPrimary,
                ) ||
                other.isPrimary == isPrimary) &&
            (identical(
                  other.predicate,
                  predicate,
                ) ||
                other.predicate == predicate) &&
            const _i3.DeepCollectionEquality().equals(
              elements,
              other.elements,
            ));
  }

  @override
  int get hashCode => Object.hash(
        indexName,
        tableSpace,
        type,
        isUnique,
        isPrimary,
        predicate,
        const _i3.DeepCollectionEquality().hash(elements),
      );

  IndexDefinition _copyWith({
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
      tableSpace:
          tableSpace == _Undefined ? this.tableSpace : (tableSpace as String?),
      elements: elements ?? this.elements,
      type: type ?? this.type,
      isUnique: isUnique ?? this.isUnique,
      isPrimary: isPrimary ?? this.isPrimary,
      predicate:
          predicate == _Undefined ? this.predicate : (predicate as String?),
    );
  }
}
