/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../protocol.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;

abstract class ChildEntity extends _i1.BaseEntity
    implements _i2.SerializableModel {
  ChildEntity._({
    this.id,
    required super.sharedField,
    required this.localField,
  });

  factory ChildEntity({
    int? id,
    required String sharedField,
    required String localField,
  }) = _ChildEntityImpl;

  factory ChildEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildEntity(
      id: jsonSerialization['id'] as int?,
      sharedField: jsonSerialization['sharedField'] as String,
      localField: jsonSerialization['localField'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String localField;

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildEntity copyWith({
    int? id,
    String? sharedField,
    String? localField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildEntity',
      if (id != null) 'id': id,
      'sharedField': sharedField,
      'localField': localField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildEntityImpl extends ChildEntity {
  _ChildEntityImpl({
    int? id,
    required String sharedField,
    required String localField,
  }) : super._(
         id: id,
         sharedField: sharedField,
         localField: localField,
       );

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildEntity copyWith({
    Object? id = _Undefined,
    String? sharedField,
    String? localField,
  }) {
    return ChildEntity(
      id: id is int? ? id : this.id,
      sharedField: sharedField ?? this.sharedField,
      localField: localField ?? this.localField,
    );
  }
}
