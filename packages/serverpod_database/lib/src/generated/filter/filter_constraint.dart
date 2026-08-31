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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

abstract class FilterConstraint
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  FilterConstraint._({
    required this.type,
    required this.column,
    required this.value,
    this.value2,
  });

  factory FilterConstraint({
    required _isd.FilterConstraintType type,
    required String column,
    required String value,
    String? value2,
  }) = _FilterConstraintImpl;

  factory FilterConstraint.fromJson(Map<String, dynamic> jsonSerialization) {
    return FilterConstraint(
      type: _isd.FilterConstraintType.fromJson(
        (jsonSerialization['type'] as int),
      ),
      column: jsonSerialization['column'] as String,
      value: jsonSerialization['value'] as String,
      value2: jsonSerialization['value2'] as String?,
    );
  }

  _isd.FilterConstraintType type;

  String column;

  String value;

  String? value2;

  /// Returns a shallow copy of this [FilterConstraint]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  FilterConstraint copyWith({
    _isd.FilterConstraintType? type,
    String? column,
    String? value,
    String? value2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.FilterConstraint',
      'type': type.toJson(),
      'column': column,
      'value': value,
      if (value2 != null) 'value2': value2,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.FilterConstraint',
      'type': type.toJson(),
      'column': column,
      'value': value,
      if (value2 != null) 'value2': value2,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FilterConstraintImpl extends FilterConstraint {
  _FilterConstraintImpl({
    required _isd.FilterConstraintType type,
    required String column,
    required String value,
    String? value2,
  }) : super._(
         type: type,
         column: column,
         value: value,
         value2: value2,
       );

  /// Returns a shallow copy of this [FilterConstraint]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  FilterConstraint copyWith({
    _isd.FilterConstraintType? type,
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
