/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Just an test enum.
enum TestEnum with _i1.SerializableEntity {
  /// The first value of [TestEnum].
  one,

  /// Second Value
  ///
  /// Second Value Extra Text
  two,
  three;

  static TestEnum fromJson(int index) {
    switch (index) {
      case 0:
        return one;
      case 1:
        return two;
      case 2:
        return three;
      default:
        throw ArgumentError('Value "$index" cannot be converted to "TestEnum"');
    }
  }

  @override
  int toJson() => index;
}
