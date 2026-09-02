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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
part 'child.dart';

sealed class SharedSealedParent
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  SharedSealedParent({required this.sharedSealedField});

  String sharedSealedField;

  /// Returns a shallow copy of this [SharedSealedParent]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedSealedParent copyWith({String? sharedSealedField});
}
