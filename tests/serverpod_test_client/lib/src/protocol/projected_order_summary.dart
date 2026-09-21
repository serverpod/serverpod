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

abstract class ProjectedOrderSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedOrderSummary._({
    this.id,
    this.summary,
  });

  factory ProjectedOrderSummary({
    _isc.UuidValue? id,
    String? summary,
  }) = _ProjectedOrderSummaryImpl;

  factory ProjectedOrderSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedOrderSummary(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      summary: jsonSerialization['summary'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String? summary;

  /// Returns a shallow copy of this [ProjectedOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedOrderSummary copyWith({
    _isc.UuidValue? id,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrderSummary',
      if (id != null) 'id': id?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrderSummary',
      if (id != null) 'id': id?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderSummaryImpl extends ProjectedOrderSummary {
  _ProjectedOrderSummaryImpl({
    _isc.UuidValue? id,
    String? summary,
  }) : super._(
         id: id,
         summary: summary,
       );

  /// Returns a shallow copy of this [ProjectedOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedOrderSummary copyWith({
    Object? id = _Undefined,
    Object? summary = _Undefined,
  }) {
    return ProjectedOrderSummary(
      id: id is _isc.UuidValue? ? id : this.id,
      summary: summary is String? ? summary : this.summary,
    );
  }
}
