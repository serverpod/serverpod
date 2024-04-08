/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

abstract class SimpleDataMap extends _i1.SerializableEntity {
  SimpleDataMap._({required this.data});

  factory SimpleDataMap({required Map<String, _i2.SimpleData> data}) =
      _SimpleDataMapImpl;

  factory SimpleDataMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataMap(
        data: (jsonSerialization['data'] as List<dynamic>)
            .fold<Map<String, _i2.SimpleData>>(
                {},
                (t, e) => {
                      ...t,
                      e['k'] as String: _i2.SimpleData.fromJson(
                          e['v'] as Map<String, dynamic>)
                    }));
  }

  Map<String, _i2.SimpleData> data;

  SimpleDataMap copyWith({Map<String, _i2.SimpleData>? data});
  @override
  Map<String, dynamic> toJson() {
    return {'data': data.toJson(valueToJson: (v) => v.toJson())};
  }
}

class _SimpleDataMapImpl extends SimpleDataMap {
  _SimpleDataMapImpl({required Map<String, _i2.SimpleData> data})
      : super._(data: data);

  @override
  SimpleDataMap copyWith({Map<String, _i2.SimpleData>? data}) {
    return SimpleDataMap(data: data ?? this.data.clone());
  }
}
