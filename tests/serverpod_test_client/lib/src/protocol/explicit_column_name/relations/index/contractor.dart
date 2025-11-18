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
import '../../../explicit_column_name/relations/index/service.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class Contractor implements _i1.SerializableModel {
  Contractor._({
    this.id,
    required this.name,
    this.serviceIdField,
    this.service,
  });

  factory Contractor({
    int? id,
    required String name,
    int? serviceIdField,
    _i2.Service? service,
  }) = _ContractorImpl;

  factory Contractor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Contractor(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      serviceIdField: jsonSerialization['serviceIdField'] as int?,
      service: jsonSerialization['service'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Service>(
              jsonSerialization['service'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? serviceIdField;

  _i2.Service? service;

  /// Returns a shallow copy of this [Contractor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Contractor copyWith({
    int? id,
    String? name,
    int? serviceIdField,
    _i2.Service? service,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Contractor',
      if (id != null) 'id': id,
      'name': name,
      if (serviceIdField != null) 'serviceIdField': serviceIdField,
      if (service != null) 'service': service?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContractorImpl extends Contractor {
  _ContractorImpl({
    int? id,
    required String name,
    int? serviceIdField,
    _i2.Service? service,
  }) : super._(
         id: id,
         name: name,
         serviceIdField: serviceIdField,
         service: service,
       );

  /// Returns a shallow copy of this [Contractor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Contractor copyWith({
    Object? id = _Undefined,
    String? name,
    Object? serviceIdField = _Undefined,
    Object? service = _Undefined,
  }) {
    return Contractor(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      serviceIdField: serviceIdField is int?
          ? serviceIdField
          : this.serviceIdField,
      service: service is _i2.Service? ? service : this.service?.copyWith(),
    );
  }
}
