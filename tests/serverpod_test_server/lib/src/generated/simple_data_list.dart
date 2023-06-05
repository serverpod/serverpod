/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

abstract class SimpleDataList extends _i1.SerializableEntity {
  const SimpleDataList._();

  const factory SimpleDataList({required List<_i2.SimpleData> rows}) =
      _SimpleDataList;

  factory SimpleDataList.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleDataList(
        rows: serializationManager
            .deserialize<List<_i2.SimpleData>>(jsonSerialization['rows']));
  }

  SimpleDataList copyWith({List<_i2.SimpleData>? rows});
  List<_i2.SimpleData> get rows;
}

class _SimpleDataList extends SimpleDataList {
  const _SimpleDataList({required this.rows}) : super._();

  @override
  final List<_i2.SimpleData> rows;

  @override
  Map<String, dynamic> toJson() {
    return {'rows': rows};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SimpleDataList &&
            const _i3.DeepCollectionEquality().equals(
              rows,
              other.rows,
            ));
  }

  @override
  int get hashCode => const _i3.DeepCollectionEquality().hash(rows);

  @override
  SimpleDataList copyWith({List<_i2.SimpleData>? rows}) {
    return SimpleDataList(rows: rows ?? this.rows);
  }
}
