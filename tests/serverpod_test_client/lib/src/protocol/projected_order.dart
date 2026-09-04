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

abstract class ProjectedOrder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedOrder._({
    this.id,
    required this.description,
    this.summary,
    required this.price,
  });

  factory ProjectedOrder({
    _isc.UuidValue? id,
    required String description,
    String? summary,
    required double price,
  }) = _ProjectedOrderImpl;

  factory ProjectedOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedOrder(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      summary: jsonSerialization['summary'] as String?,
      price: (jsonSerialization['price'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String description;

  String? summary;

  double price;

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedOrder copyWith({
    _isc.UuidValue? id,
    String? description,
    String? summary,
    double? price,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
      'price': price,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
      'price': price,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderImpl extends ProjectedOrder {
  _ProjectedOrderImpl({
    _isc.UuidValue? id,
    required String description,
    String? summary,
    required double price,
  }) : super._(
         id: id,
         description: description,
         summary: summary,
         price: price,
       );

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedOrder copyWith({
    Object? id = _Undefined,
    String? description,
    Object? summary = _Undefined,
    double? price,
  }) {
    return ProjectedOrder(
      id: id is _isc.UuidValue? ? id : this.id,
      description: description ?? this.description,
      summary: summary is String? ? summary : this.summary,
      price: price ?? this.price,
    );
  }
}
