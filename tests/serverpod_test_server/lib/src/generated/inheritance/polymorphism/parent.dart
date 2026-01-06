/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A parent class.
class PolymorphicParent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PolymorphicParent({required this.parent});

  factory PolymorphicParent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolymorphicParent(parent: jsonSerialization['parent'] as String);
  }

  /// The parent field.
  String parent;

  /// Returns a shallow copy of this [PolymorphicParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PolymorphicParent copyWith({String? parent}) {
    return PolymorphicParent(parent: parent ?? this.parent);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolymorphicParent',
      'parent': parent,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolymorphicParent',
      'parent': parent,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}
