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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

@_i1.immutable
abstract class ImmutableObjectWithTable implements _i1.SerializableModel {
  const ImmutableObjectWithTable._({this.id, required this.variable});

  const factory ImmutableObjectWithTable({int? id, required String variable}) =
      _ImmutableObjectWithTableImpl;

  factory ImmutableObjectWithTable.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithTable(
      id: jsonSerialization['id'] as int?,
      variable: jsonSerialization['variable'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  final String variable;

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithTable copyWith({int? id, String? variable});
  @override
  bool operator ==(Object other) {
    return identical(other, this) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithTable &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variable, variable) || other.variable == variable);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, variable);
  }

  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'variable': variable};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmutableObjectWithTableImpl extends ImmutableObjectWithTable {
  const _ImmutableObjectWithTableImpl({int? id, required String variable})
    : super._(id: id, variable: variable);

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithTable copyWith({
    Object? id = _Undefined,
    String? variable,
  }) {
    return ImmutableObjectWithTable(
      id: id is int? ? id : this.id,
      variable: variable ?? this.variable,
    );
  }
}
