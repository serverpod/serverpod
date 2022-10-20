/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class Example extends _i1.SerializableEntity {
  Example({
    required this.name,
    required this.data,
  });

  factory Example.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Example(
      name: serializationManager
          .deserializeJson<String>(jsonSerialization['name']),
      data:
          serializationManager.deserializeJson<int>(jsonSerialization['data']),
    );
  }

  String name;

  int data;

  @override
  String get className => 'Example';
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}
