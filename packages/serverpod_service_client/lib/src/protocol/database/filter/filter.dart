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

abstract class Filter implements _i1.SerializableModel {
  Filter._({
    required this.name,
    required this.table,
    required this.constraints,
  });

  factory Filter({
    required String name,
    required String table,
    required List<_i2.FilterConstraint> constraints,
  }) = _FilterImpl;

  factory Filter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Filter(
      name: jsonSerialization['name'] as String,
      table: jsonSerialization['table'] as String,
      constraints: (jsonSerialization['constraints'] as List)
          .map(
              (e) => _i2.FilterConstraint.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  String name;

  String table;

  List<_i2.FilterConstraint> constraints;

  Filter copyWith({
    String? name,
    String? table,
    List<_i2.FilterConstraint>? constraints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'table': table,
      'constraints': constraints.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FilterImpl extends Filter {
  _FilterImpl({
    required String name,
    required String table,
    required List<_i2.FilterConstraint> constraints,
  }) : super._(
          name: name,
          table: table,
          constraints: constraints,
        );

  @override
  Filter copyWith({
    String? name,
    String? table,
    List<_i2.FilterConstraint>? constraints,
  }) {
    return Filter(
      name: name ?? this.name,
      table: table ?? this.table,
      constraints: constraints ?? this.constraints.clone(),
    );
  }
}
