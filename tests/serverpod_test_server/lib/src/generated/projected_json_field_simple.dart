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

abstract class ProjectedJsonFieldSimple
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedJsonFieldSimple._({
    required this.text,
    required this.value,
  });

  factory ProjectedJsonFieldSimple({
    required String text,
    required int value,
  }) = _ProjectedJsonFieldSimpleImpl;

  factory ProjectedJsonFieldSimple.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedJsonFieldSimple(
      text: jsonSerialization['text'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  String text;

  int value;

  /// Returns a shallow copy of this [ProjectedJsonFieldSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedJsonFieldSimple copyWith({
    String? text,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedJsonFieldSimple',
      'text': text,
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedJsonFieldSimple',
      'text': text,
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ProjectedJsonFieldSimpleImpl extends ProjectedJsonFieldSimple {
  _ProjectedJsonFieldSimpleImpl({
    required String text,
    required int value,
  }) : super._(
         text: text,
         value: value,
       );

  /// Returns a shallow copy of this [ProjectedJsonFieldSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedJsonFieldSimple copyWith({
    String? text,
    int? value,
  }) {
    return ProjectedJsonFieldSimple(
      text: text ?? this.text,
      value: value ?? this.value,
    );
  }
}
