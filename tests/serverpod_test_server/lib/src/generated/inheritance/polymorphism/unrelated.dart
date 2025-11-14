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
import 'package:serverpod/serverpod.dart' as _i1;

/// A class that is not related to the polymorphism.
abstract class UnrelatedToPolymorphism
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UnrelatedToPolymorphism._({required this.unrelated});

  factory UnrelatedToPolymorphism({required String unrelated}) =
      _UnrelatedToPolymorphismImpl;

  factory UnrelatedToPolymorphism.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UnrelatedToPolymorphism(
      unrelated: jsonSerialization['unrelated'] as String,
    );
  }

  /// An unrelated field.
  String unrelated;

  /// Returns a shallow copy of this [UnrelatedToPolymorphism]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UnrelatedToPolymorphism copyWith({String? unrelated});
  @override
  Map<String, dynamic> toJson() {
    return {'unrelated': unrelated};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'unrelated': unrelated};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UnrelatedToPolymorphismImpl extends UnrelatedToPolymorphism {
  _UnrelatedToPolymorphismImpl({required String unrelated})
    : super._(unrelated: unrelated);

  /// Returns a shallow copy of this [UnrelatedToPolymorphism]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UnrelatedToPolymorphism copyWith({String? unrelated}) {
    return UnrelatedToPolymorphism(unrelated: unrelated ?? this.unrelated);
  }
}
