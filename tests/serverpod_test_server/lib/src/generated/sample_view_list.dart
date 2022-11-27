/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class SampleViewList extends _i1.SerializableEntity {
  SampleViewList({required this.rows});

  factory SampleViewList.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SampleViewList(
        rows: serializationManager
            .deserialize<List<_i2.SampleView>>(jsonSerialization['rows']));
  }

  List<_i2.SampleView> rows;

  @override
  Map<String, dynamic> toJson() {
    return {'rows': rows};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'rows': rows};
  }
}
