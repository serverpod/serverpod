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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

/// Defines whether a foreign key constraint is deferrable and, if so, when it
/// is checked by default.
enum DeferrableConstraint implements _i1.SerializableModel {
  /// The constraint is `DEFERRABLE INITIALLY IMMEDIATE`. It is checked after
  /// each statement by default, but can be deferred until commit within a
  /// transaction (for example with `SET CONSTRAINTS ALL DEFERRED`).
  initiallyImmediate,

  /// The constraint is `DEFERRABLE INITIALLY DEFERRED`. It is checked at
  /// transaction commit time by default.
  initiallyDeferred,
  ;

  static DeferrableConstraint fromJson(String name) {
    switch (name) {
      case 'initiallyImmediate':
        return DeferrableConstraint.initiallyImmediate;
      case 'initiallyDeferred':
        return DeferrableConstraint.initiallyDeferred;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DeferrableConstraint"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
