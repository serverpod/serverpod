/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class SimpleDataList extends _i1.SerializableEntity {
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

  SimpleDataList copyWith({List<_i2.SimpleData>? rows});
  @override
  Map<String, dynamic> toJson() {
    return {'rows': rows.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'rows': rows.toJson(valueToJson: (v) => v.allToJson())};
  }
}

class _SimpleDataListImpl extends SimpleDataList {
  _SimpleDataListImpl({required List<_i2.SimpleData> rows})
      : super._(rows: rows);

  @override
  SimpleDataList copyWith({List<_i2.SimpleData>? rows}) {
    return SimpleDataList(rows: rows ?? this.rows.clone());
  }
}
