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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ProjectedOrderDescription
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedOrderDescription._({
    this.id,
    required this.description,
    this.summary,
  });

  factory ProjectedOrderDescription({
    _isc.UuidValue? id,
    required String description,
    String? summary,
  }) = _ProjectedOrderDescriptionImpl;

  factory ProjectedOrderDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedOrderDescription(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      summary: jsonSerialization['summary'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String description;

  String? summary;

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedOrderDescription copyWith({
    _isc.UuidValue? id,
    String? description,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderDescriptionImpl extends ProjectedOrderDescription {
  _ProjectedOrderDescriptionImpl({
    _isc.UuidValue? id,
    required String description,
    String? summary,
  }) : super._(
         id: id,
         description: description,
         summary: summary,
       );

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedOrderDescription copyWith({
    Object? id = _Undefined,
    String? description,
    Object? summary = _Undefined,
  }) {
    return ProjectedOrderDescription(
      id: id is _isc.UuidValue? ? id : this.id,
      description: description ?? this.description,
      summary: summary is String? ? summary : this.summary,
    );
  }
}
