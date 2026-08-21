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
import '../../models_with_relations/fk_relation/fk_relation_company.dart'
    as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class FkRelationOffice
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FkRelationOffice._({
    this.id,
    required this.address,
    required this.companyId,
    this.company,
  });

  factory FkRelationOffice({
    int? id,
    required String address,
    required int companyId,
    _i2.FkRelationCompany? company,
  }) = _FkRelationOfficeImpl;

  factory FkRelationOffice.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationOffice(
      id: jsonSerialization['id'] as int?,
      address: jsonSerialization['address'] as String,
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.FkRelationCompany>(
              jsonSerialization['company'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String address;

  int companyId;

  _i2.FkRelationCompany? company;

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FkRelationOffice copyWith({
    int? id,
    String? address,
    int? companyId,
    _i2.FkRelationCompany? company,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FkRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationOfficeImpl extends FkRelationOffice {
  _FkRelationOfficeImpl({
    int? id,
    required String address,
    required int companyId,
    _i2.FkRelationCompany? company,
  }) : super._(
         id: id,
         address: address,
         companyId: companyId,
         company: company,
       );

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FkRelationOffice copyWith({
    Object? id = _Undefined,
    String? address,
    int? companyId,
    Object? company = _Undefined,
  }) {
    return FkRelationOffice(
      id: id is int? ? id : this.id,
      address: address ?? this.address,
      companyId: companyId ?? this.companyId,
      company: company is _i2.FkRelationCompany?
          ? company
          : this.company?.copyWith(),
    );
  }
}
