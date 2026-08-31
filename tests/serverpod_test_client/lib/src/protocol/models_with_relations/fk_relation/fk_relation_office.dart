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
import '../../models_with_relations/fk_relation/fk_relation_company.dart'
    as _ikyus01r;

abstract class FkRelationOffice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _ikyus01r.FkRelationCompany? company,
  }) = _FkRelationOfficeImpl;

  factory FkRelationOffice.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationOffice(
      id: jsonSerialization['id'] as int?,
      address: jsonSerialization['address'] as String,
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ikyus01r.FkRelationCompany>(
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

  _ikyus01r.FkRelationCompany? company;

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FkRelationOffice copyWith({
    int? id,
    String? address,
    int? companyId,
    _ikyus01r.FkRelationCompany? company,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationOfficeImpl extends FkRelationOffice {
  _FkRelationOfficeImpl({
    int? id,
    required String address,
    required int companyId,
    _ikyus01r.FkRelationCompany? company,
  }) : super._(
         id: id,
         address: address,
         companyId: companyId,
         company: company,
       );

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      company: company is _ikyus01r.FkRelationCompany?
          ? company
          : this.company?.copyWith(),
    );
  }
}
