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
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;
part 'child.dart';

sealed class SharedSealedParent implements _i2.SerializableModel {
  SharedSealedParent({required this.sharedSealedField});

  String sharedSealedField;

  /// Returns a shallow copy of this [SharedSealedParent]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SharedSealedParent copyWith({String? sharedSealedField});
}
