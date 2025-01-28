/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class StringDefault implements _i1.SerializableModel {
  StringDefault._({
    this.id,
    String? stringDefault,
    String? stringDefaultNull,
  })  : stringDefault = stringDefault ?? 'This is a default value',
        stringDefaultNull = stringDefaultNull ?? 'This is a default null value';

  factory StringDefault({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) = _StringDefaultImpl;

  factory StringDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefault(
      id: jsonSerialization['id'] as int?,
      stringDefault: jsonSerialization['stringDefault'] as String,
      stringDefaultNull: jsonSerialization['stringDefaultNull'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringDefault;

  String? stringDefaultNull;

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefault copyWith({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultImpl extends StringDefault {
  _StringDefaultImpl({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) : super._(
          id: id,
          stringDefault: stringDefault,
          stringDefaultNull: stringDefaultNull,
        );

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefault copyWith({
    Object? id = _Undefined,
    String? stringDefault,
    Object? stringDefaultNull = _Undefined,
  }) {
    return StringDefault(
      id: id is int? ? id : this.id,
      stringDefault: stringDefault ?? this.stringDefault,
      stringDefaultNull: stringDefaultNull is String?
          ? stringDefaultNull
          : this.stringDefaultNull,
    );
  }
}
