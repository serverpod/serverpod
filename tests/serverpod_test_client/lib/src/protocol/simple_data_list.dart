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
import 'simple_data.dart' as _i2;

abstract class SimpleDataList implements _i1.SerializableModel {
  SimpleDataList._({required this.rows});

  factory SimpleDataList({required List<_i2.SimpleData> rows}) =
      _SimpleDataListImpl;

  factory SimpleDataList.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataList(
        rows: (jsonSerialization['rows'] as List)
            .map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
            .toList());
  }

  List<_i2.SimpleData> rows;

  /// Returns a shallow copy of this [SimpleDataList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SimpleDataList copyWith({List<_i2.SimpleData>? rows});
  @override
  Map<String, dynamic> toJson() {
    return {'rows': rows.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SimpleDataListImpl extends SimpleDataList {
  _SimpleDataListImpl({required List<_i2.SimpleData> rows})
      : super._(rows: rows);

  /// Returns a shallow copy of this [SimpleDataList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SimpleDataList copyWith({List<_i2.SimpleData>? rows}) {
    return SimpleDataList(
        rows: rows ?? this.rows.map((e0) => e0.copyWith()).toList());
  }
}
