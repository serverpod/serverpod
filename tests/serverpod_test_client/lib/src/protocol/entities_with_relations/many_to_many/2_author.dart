/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Author extends _i1.SerializableEntity {
  Author._({
    this.id,
    required this.name,
    this.blockedBy,
    this.blocked,
  });

  factory Author({
    int? id,
    required String name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  }) = _AuthorImpl;

  factory Author.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Author(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      blockedBy: serializationManager
          .deserialize<List<_i2.Blocked>?>(jsonSerialization['blockedBy']),
      blocked: serializationManager
          .deserialize<List<_i2.Blocked>?>(jsonSerialization['blocked']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Blocked>? blockedBy;

  List<_i2.Blocked>? blocked;

  Author copyWith({
    int? id,
    String? name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'blockedBy': blockedBy,
      'blocked': blocked,
    };
  }
}

class _Undefined {}

class _AuthorImpl extends Author {
  _AuthorImpl({
    int? id,
    required String name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  }) : super._(
          id: id,
          name: name,
          blockedBy: blockedBy,
          blocked: blocked,
        );

  @override
  Author copyWith({
    Object? id = _Undefined,
    String? name,
    Object? blockedBy = _Undefined,
    Object? blocked = _Undefined,
  }) {
    return Author(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      blockedBy:
          blockedBy is List<_i2.Blocked>? ? blockedBy : this.blockedBy?.clone(),
      blocked: blocked is List<_i2.Blocked>? ? blocked : this.blocked?.clone(),
    );
  }
}
