/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class EmptyModelRelationItem implements _i1.SerializableModel {
  EmptyModelRelationItem._({
    this.id,
    required this.name,
    required this.containerId,
  });

  factory EmptyModelRelationItem({
    int? id,
    required String name,
    required int containerId,
  }) = _EmptyModelRelationItemImpl;

  factory EmptyModelRelationItem.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmptyModelRelationItem(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      containerId: jsonSerialization['containerId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int containerId;

  EmptyModelRelationItem copyWith({
    int? id,
    String? name,
    int? containerId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'containerId': containerId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelRelationItemImpl extends EmptyModelRelationItem {
  _EmptyModelRelationItemImpl({
    int? id,
    required String name,
    required int containerId,
  }) : super._(
          id: id,
          name: name,
          containerId: containerId,
        );

  @override
  EmptyModelRelationItem copyWith({
    Object? id = _Undefined,
    String? name,
    int? containerId,
  }) {
    return EmptyModelRelationItem(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      containerId: containerId ?? this.containerId,
    );
  }
}
