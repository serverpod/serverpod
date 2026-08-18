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
import '../../models_with_relations/generated_relation_field/generated_relation_company.dart'
    as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class GeneratedRelationOffice
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GeneratedRelationOffice._({
    this.id,
    required this.address,
    required this.customCompanyId,
    this.company,
  });

  factory GeneratedRelationOffice({
    int? id,
    required String address,
    required int customCompanyId,
    _i2.GeneratedRelationCompany? company,
  }) = _GeneratedRelationOfficeImpl;

  factory GeneratedRelationOffice.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationOffice(
      id: jsonSerialization['id'] as int?,
      address: jsonSerialization['address'] as String,
      customCompanyId: jsonSerialization['customCompanyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.GeneratedRelationCompany>(
              jsonSerialization['company'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String address;

  /// The foreign key of the [company] relation.
  int customCompanyId;

  _i2.GeneratedRelationCompany? company;

  /// Returns a shallow copy of this [GeneratedRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GeneratedRelationOffice copyWith({
    int? id,
    String? address,
    int? customCompanyId,
    _i2.GeneratedRelationCompany? company,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedRelationOfficeImpl extends GeneratedRelationOffice {
  _GeneratedRelationOfficeImpl({
    int? id,
    required String address,
    required int customCompanyId,
    _i2.GeneratedRelationCompany? company,
  }) : super._(
         id: id,
         address: address,
         customCompanyId: customCompanyId,
         company: company,
       );

  /// Returns a shallow copy of this [GeneratedRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GeneratedRelationOffice copyWith({
    Object? id = _Undefined,
    String? address,
    int? customCompanyId,
    Object? company = _Undefined,
  }) {
    return GeneratedRelationOffice(
      id: id is int? ? id : this.id,
      address: address ?? this.address,
      customCompanyId: customCompanyId ?? this.customCompanyId,
      company: company is _i2.GeneratedRelationCompany?
          ? company
          : this.company?.copyWith(),
    );
  }
}
