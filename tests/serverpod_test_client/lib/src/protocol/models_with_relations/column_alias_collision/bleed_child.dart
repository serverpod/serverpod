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

/// Child model used to reproduce the include column-alias collision in
/// https://github.com/serverpod/serverpod/issues/5287
///
/// It has an `int` primary key (`id`) and a `String` column (`bleedingText`).
/// When two long-named relations point at this table, the truncated column
/// alias of one relation's `id` collides with the other relation's
/// `bleedingText`, bleeding the string into the int field on deserialization.
abstract class BleedChild
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BleedChild._({
    this.id,
    this.bleedingText,
  });

  factory BleedChild({
    int? id,
    String? bleedingText,
  }) = _BleedChildImpl;

  factory BleedChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return BleedChild(
      id: jsonSerialization['id'] as int?,
      bleedingText: jsonSerialization['bleedingText'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? bleedingText;

  /// Returns a shallow copy of this [BleedChild]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BleedChild copyWith({
    int? id,
    String? bleedingText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BleedChild',
      if (id != null) 'id': id,
      if (bleedingText != null) 'bleedingText': bleedingText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BleedChild',
      if (id != null) 'id': id,
      if (bleedingText != null) 'bleedingText': bleedingText,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BleedChildImpl extends BleedChild {
  _BleedChildImpl({
    int? id,
    String? bleedingText,
  }) : super._(
         id: id,
         bleedingText: bleedingText,
       );

  /// Returns a shallow copy of this [BleedChild]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BleedChild copyWith({
    Object? id = _Undefined,
    Object? bleedingText = _Undefined,
  }) {
    return BleedChild(
      id: id is int? ? id : this.id,
      bleedingText: bleedingText is String? ? bleedingText : this.bleedingText,
    );
  }
}
