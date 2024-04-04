/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class FilterConstraint extends _i1.SerializableEntity {
  FilterConstraint._({
    required this.type,
    required this.column,
    required this.value,
    this.value2,
  });

  factory FilterConstraint({
    required _i2.FilterConstraintType type,
    required String column,
    required String value,
    String? value2,
  }) = _FilterConstraintImpl;

  factory FilterConstraint.fromJson(Map<String, dynamic> jsonSerialization) {
    return FilterConstraint(
      type:
          _i2.FilterConstraintType.fromJson((jsonSerialization['type'] as int)),
      column: jsonSerialization['column'] as String,
      value: jsonSerialization['value'] as String,
      value2: jsonSerialization['value2'] as String?,
    );
  }

  _i2.FilterConstraintType type;

  String column;

  String value;

  String? value2;

  FilterConstraint copyWith({
    _i2.FilterConstraintType? type,
    String? column,
    String? value,
    String? value2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'column': column,
      'value': value,
      if (value2 != null) 'value2': value2,
    };
  }
}

class _Undefined {}

class _FilterConstraintImpl extends FilterConstraint {
  _FilterConstraintImpl({
    required _i2.FilterConstraintType type,
    required String column,
    required String value,
    String? value2,
  }) : super._(
          type: type,
          column: column,
          value: value,
          value2: value2,
        );

  @override
  FilterConstraint copyWith({
    _i2.FilterConstraintType? type,
    String? column,
    String? value,
    Object? value2 = _Undefined,
  }) {
    return FilterConstraint(
      type: type ?? this.type,
      column: column ?? this.column,
      value: value ?? this.value,
      value2: value2 is String? ? value2 : this.value2,
    );
  }
}
