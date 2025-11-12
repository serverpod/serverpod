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

@_i1.immutable
class ImmutableObject implements _i1.SerializableModel {
  const ImmutableObject({required this.variable});

  factory ImmutableObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImmutableObject(variable: jsonSerialization['variable'] as String);
  }

  final String variable;

  /// Returns a shallow copy of this [ImmutableObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObject copyWith({String? variable}) {
    return ImmutableObject(variable: variable ?? this.variable);
  }

  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObject &&
            (identical(
                  other.variable,
                  variable,
                ) ||
                other.variable == variable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      variable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'variable': variable};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}
