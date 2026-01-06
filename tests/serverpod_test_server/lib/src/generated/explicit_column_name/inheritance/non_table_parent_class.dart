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

class NonTableParentClass
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NonTableParentClass({required this.nonTableParentField});

  factory NonTableParentClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return NonTableParentClass(
      nonTableParentField: jsonSerialization['nonTableParentField'] as String,
    );
  }

  String nonTableParentField;

  /// Returns a shallow copy of this [NonTableParentClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NonTableParentClass copyWith({String? nonTableParentField}) {
    return NonTableParentClass(
      nonTableParentField: nonTableParentField ?? this.nonTableParentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NonTableParentClass',
      'nonTableParentField': nonTableParentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NonTableParentClass',
      'nonTableParentField': nonTableParentField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}
