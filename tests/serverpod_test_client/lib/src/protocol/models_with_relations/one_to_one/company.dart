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
import '../../models_with_relations/one_to_one/town.dart' as _i59ly1gg;

abstract class Company
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Company._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory Company({
    int? id,
    required String name,
    required int townId,
    _i59ly1gg.Town? town,
  }) = _CompanyImpl;

  factory Company.fromJson(Map<String, dynamic> jsonSerialization) {
    return Company(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization['town'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i59ly1gg.Town>(
              jsonSerialization['town'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int townId;

  _i59ly1gg.Town? town;

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Company copyWith({
    int? id,
    String? name,
    int? townId,
    _i59ly1gg.Town? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Company',
      if (id != null) 'id': id,
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyImpl extends Company {
  _CompanyImpl({
    int? id,
    required String name,
    required int townId,
    _i59ly1gg.Town? town,
  }) : super._(
         id: id,
         name: name,
         townId: townId,
         town: town,
       );

  /// Returns a shallow copy of this [Company]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Company copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return Company(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i59ly1gg.Town? ? town : this.town?.copyWith(),
    );
  }
}
