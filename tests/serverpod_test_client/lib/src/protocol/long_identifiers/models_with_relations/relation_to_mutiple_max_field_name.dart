/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class RelationToMultipleMaxFieldName extends _i1.SerializableEntity {
  RelationToMultipleMaxFieldName._({
    this.id,
    required this.name,
    this.multipleMaxFieldNames,
  });

  factory RelationToMultipleMaxFieldName({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) = _RelationToMultipleMaxFieldNameImpl;

  factory RelationToMultipleMaxFieldName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RelationToMultipleMaxFieldName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      multipleMaxFieldNames:
          serializationManager.deserialize<List<_i2.MultipleMaxFieldName>?>(
              jsonSerialization['multipleMaxFieldNames']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames;

  RelationToMultipleMaxFieldName copyWith({
    int? id,
    String? name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames':
            multipleMaxFieldNames?.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _Undefined {}

class _RelationToMultipleMaxFieldNameImpl
    extends RelationToMultipleMaxFieldName {
  _RelationToMultipleMaxFieldNameImpl({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) : super._(
          id: id,
          name: name,
          multipleMaxFieldNames: multipleMaxFieldNames,
        );

  @override
  RelationToMultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? multipleMaxFieldNames = _Undefined,
  }) {
    return RelationToMultipleMaxFieldName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      multipleMaxFieldNames:
          multipleMaxFieldNames is List<_i2.MultipleMaxFieldName>?
              ? multipleMaxFieldNames
              : this.multipleMaxFieldNames?.clone(),
    );
  }
}
