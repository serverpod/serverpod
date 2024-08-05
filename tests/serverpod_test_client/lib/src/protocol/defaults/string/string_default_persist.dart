/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class StringDefaultPersist implements _i1.SerializableModel {
  StringDefaultPersist._({
    this.id,
    this.stringDefaultPersist,
  });

  factory StringDefaultPersist({
    int? id,
    String? stringDefaultPersist,
  }) = _StringDefaultPersistImpl;

  factory StringDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StringDefaultPersist(
      id: jsonSerialization['id'] as int?,
      stringDefaultPersist:
          jsonSerialization['stringDefaultPersist'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? stringDefaultPersist;

  StringDefaultPersist copyWith({
    int? id,
    String? stringDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultPersistImpl extends StringDefaultPersist {
  _StringDefaultPersistImpl({
    int? id,
    String? stringDefaultPersist,
  }) : super._(
          id: id,
          stringDefaultPersist: stringDefaultPersist,
        );

  @override
  StringDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? stringDefaultPersist = _Undefined,
  }) {
    return StringDefaultPersist(
      id: id is int? ? id : this.id,
      stringDefaultPersist: stringDefaultPersist is String?
          ? stringDefaultPersist
          : this.stringDefaultPersist,
    );
  }
}
