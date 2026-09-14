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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'projected_order_summary.dart' as _ivhidcz8;

abstract class ProjectedUserOrderSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserOrderSummary._({
    this.id,
    required this.name,
    this.orders,
  });

  factory ProjectedUserOrderSummary({
    _isc.UuidValue? id,
    required String name,
    List<_ivhidcz8.ProjectedOrderSummary>? orders,
  }) = _ProjectedUserOrderSummaryImpl;

  factory ProjectedUserOrderSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserOrderSummary(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_ivhidcz8.ProjectedOrderSummary>>(
                  jsonSerialization['orders'],
                ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  List<_ivhidcz8.ProjectedOrderSummary>? orders;

  /// Returns a shallow copy of this [ProjectedUserOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserOrderSummary copyWith({
    _isc.UuidValue? id,
    String? name,
    List<_ivhidcz8.ProjectedOrderSummary>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserOrderSummary',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserOrderSummary',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _isc.ProtocolSerialization
              ? (v as _isc.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserOrderSummaryImpl extends ProjectedUserOrderSummary {
  _ProjectedUserOrderSummaryImpl({
    _isc.UuidValue? id,
    required String name,
    List<_ivhidcz8.ProjectedOrderSummary>? orders,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
       );

  /// Returns a shallow copy of this [ProjectedUserOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserOrderSummary copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return ProjectedUserOrderSummary(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_ivhidcz8.ProjectedOrderSummary>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
