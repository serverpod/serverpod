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

abstract class ObjectWithTrgm
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithTrgm._({
    this.id,
    required this.searchText,
    required this.searchTextIndexed,
    this.nullableSearchTextIndexed,
  });

  factory ObjectWithTrgm({
    int? id,
    required String searchText,
    required String searchTextIndexed,
    String? nullableSearchTextIndexed,
  }) = _ObjectWithTrgmImpl;

  factory ObjectWithTrgm.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithTrgm(
      id: jsonSerialization['id'] as int?,
      searchText: jsonSerialization['searchText'] as String,
      searchTextIndexed: jsonSerialization['searchTextIndexed'] as String,
      nullableSearchTextIndexed:
          jsonSerialization['nullableSearchTextIndexed'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String searchText;

  String searchTextIndexed;

  String? nullableSearchTextIndexed;

  /// Returns a shallow copy of this [ObjectWithTrgm]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithTrgm copyWith({
    int? id,
    String? searchText,
    String? searchTextIndexed,
    String? nullableSearchTextIndexed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithTrgm',
      if (id != null) 'id': id,
      'searchText': searchText,
      'searchTextIndexed': searchTextIndexed,
      if (nullableSearchTextIndexed != null)
        'nullableSearchTextIndexed': nullableSearchTextIndexed,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithTrgm',
      if (id != null) 'id': id,
      'searchText': searchText,
      'searchTextIndexed': searchTextIndexed,
      if (nullableSearchTextIndexed != null)
        'nullableSearchTextIndexed': nullableSearchTextIndexed,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithTrgmImpl extends ObjectWithTrgm {
  _ObjectWithTrgmImpl({
    int? id,
    required String searchText,
    required String searchTextIndexed,
    String? nullableSearchTextIndexed,
  }) : super._(
         id: id,
         searchText: searchText,
         searchTextIndexed: searchTextIndexed,
         nullableSearchTextIndexed: nullableSearchTextIndexed,
       );

  /// Returns a shallow copy of this [ObjectWithTrgm]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithTrgm copyWith({
    Object? id = _Undefined,
    String? searchText,
    String? searchTextIndexed,
    Object? nullableSearchTextIndexed = _Undefined,
  }) {
    return ObjectWithTrgm(
      id: id is int? ? id : this.id,
      searchText: searchText ?? this.searchText,
      searchTextIndexed: searchTextIndexed ?? this.searchTextIndexed,
      nullableSearchTextIndexed: nullableSearchTextIndexed is String?
          ? nullableSearchTextIndexed
          : this.nullableSearchTextIndexed,
    );
  }
}
