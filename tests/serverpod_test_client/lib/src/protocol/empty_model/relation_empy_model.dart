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
import '../empty_model/empty_model_relation_item.dart' as _i2;

abstract class RelationEmptyModel implements _i1.SerializableModel {
  RelationEmptyModel._({
    this.id,
    this.items,
  });

  factory RelationEmptyModel({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) = _RelationEmptyModelImpl;

  factory RelationEmptyModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelationEmptyModel(
      id: jsonSerialization['id'] as int?,
      items: (jsonSerialization['items'] as List?)
          ?.map((e) =>
              _i2.EmptyModelRelationItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<_i2.EmptyModelRelationItem>? items;

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelationEmptyModel copyWith({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (items != null) 'items': items?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationEmptyModelImpl extends RelationEmptyModel {
  _RelationEmptyModelImpl({
    int? id,
    List<_i2.EmptyModelRelationItem>? items,
  }) : super._(
          id: id,
          items: items,
        );

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RelationEmptyModel copyWith({
    Object? id = _Undefined,
    Object? items = _Undefined,
  }) {
    return RelationEmptyModel(
      id: id is int? ? id : this.id,
      items: items is List<_i2.EmptyModelRelationItem>?
          ? items
          : this.items?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
