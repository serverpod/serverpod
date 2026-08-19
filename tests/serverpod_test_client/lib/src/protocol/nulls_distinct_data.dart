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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class NullsDistinctData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NullsDistinctData._({
    this.id,
    required this.tenantId,
    required this.category,
    this.archivedAt,
    this.deletedAt,
  });

  factory NullsDistinctData({
    int? id,
    required int tenantId,
    required String category,
    String? archivedAt,
    String? deletedAt,
  }) = _NullsDistinctDataImpl;

  factory NullsDistinctData.fromJson(Map<String, dynamic> jsonSerialization) {
    return NullsDistinctData(
      id: jsonSerialization['id'] as int?,
      tenantId: jsonSerialization['tenantId'] as int,
      category: jsonSerialization['category'] as String,
      archivedAt: jsonSerialization['archivedAt'] as String?,
      deletedAt: jsonSerialization['deletedAt'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int tenantId;

  String category;

  /// Indexed with nulls distinct, so rows with a null here never collide.
  String? archivedAt;

  /// Indexed with nulls not distinct, so rows with a null here do collide.
  String? deletedAt;

  /// Returns a shallow copy of this [NullsDistinctData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NullsDistinctData copyWith({
    int? id,
    int? tenantId,
    String? category,
    String? archivedAt,
    String? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NullsDistinctData',
      if (id != null) 'id': id,
      'tenantId': tenantId,
      'category': category,
      if (archivedAt != null) 'archivedAt': archivedAt,
      if (deletedAt != null) 'deletedAt': deletedAt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NullsDistinctData',
      if (id != null) 'id': id,
      'tenantId': tenantId,
      'category': category,
      if (archivedAt != null) 'archivedAt': archivedAt,
      if (deletedAt != null) 'deletedAt': deletedAt,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NullsDistinctDataImpl extends NullsDistinctData {
  _NullsDistinctDataImpl({
    int? id,
    required int tenantId,
    required String category,
    String? archivedAt,
    String? deletedAt,
  }) : super._(
         id: id,
         tenantId: tenantId,
         category: category,
         archivedAt: archivedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [NullsDistinctData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NullsDistinctData copyWith({
    Object? id = _Undefined,
    int? tenantId,
    String? category,
    Object? archivedAt = _Undefined,
    Object? deletedAt = _Undefined,
  }) {
    return NullsDistinctData(
      id: id is int? ? id : this.id,
      tenantId: tenantId ?? this.tenantId,
      category: category ?? this.category,
      archivedAt: archivedAt is String? ? archivedAt : this.archivedAt,
      deletedAt: deletedAt is String? ? deletedAt : this.deletedAt,
    );
  }
}
