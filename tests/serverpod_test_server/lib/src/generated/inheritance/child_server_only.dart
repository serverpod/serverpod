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
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ServerOnlyChildClass extends _i1.NonServerOnlyParentClass
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ServerOnlyChildClass._({
    required super.parentField,
    required this.childField,
  });

  factory ServerOnlyChildClass({
    required String parentField,
    required String childField,
  }) = _ServerOnlyChildClassImpl;

  factory ServerOnlyChildClass.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerOnlyChildClass(
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  String childField;

  /// Returns a shallow copy of this [ServerOnlyChildClass]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ServerOnlyChildClass copyWith({
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ServerOnlyChildClassImpl extends ServerOnlyChildClass {
  _ServerOnlyChildClassImpl({
    required String parentField,
    required String childField,
  }) : super._(
          parentField: parentField,
          childField: childField,
        );

  /// Returns a shallow copy of this [ServerOnlyChildClass]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ServerOnlyChildClass copyWith({
    String? parentField,
    String? childField,
  }) {
    return ServerOnlyChildClass(
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}
