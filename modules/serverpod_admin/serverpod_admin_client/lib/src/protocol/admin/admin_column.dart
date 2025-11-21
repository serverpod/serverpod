/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AdminColumn implements _i1.SerializableModel {
  AdminColumn._({
    required this.name,
    required this.dataType,
    required this.hasDefault,
    required this.isPrimary,
  });

  factory AdminColumn({
    required String name,
    required String dataType,
    required bool hasDefault,
    required bool isPrimary,
  }) = _AdminColumnImpl;

  factory AdminColumn.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminColumn(
      name: jsonSerialization['name'] as String,
      dataType: jsonSerialization['dataType'] as String,
      hasDefault: jsonSerialization['hasDefault'] as bool,
      isPrimary: jsonSerialization['isPrimary'] as bool,
    );
  }

  String name;

  String dataType;

  bool hasDefault;

  bool isPrimary;

  /// Returns a shallow copy of this [AdminColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminColumn copyWith({
    String? name,
    String? dataType,
    bool? hasDefault,
    bool? isPrimary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dataType': dataType,
      'hasDefault': hasDefault,
      'isPrimary': isPrimary,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminColumnImpl extends AdminColumn {
  _AdminColumnImpl({
    required String name,
    required String dataType,
    required bool hasDefault,
    required bool isPrimary,
  }) : super._(
          name: name,
          dataType: dataType,
          hasDefault: hasDefault,
          isPrimary: isPrimary,
        );

  /// Returns a shallow copy of this [AdminColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminColumn copyWith({
    String? name,
    String? dataType,
    bool? hasDefault,
    bool? isPrimary,
  }) {
    return AdminColumn(
      name: name ?? this.name,
      dataType: dataType ?? this.dataType,
      hasDefault: hasDefault ?? this.hasDefault,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
