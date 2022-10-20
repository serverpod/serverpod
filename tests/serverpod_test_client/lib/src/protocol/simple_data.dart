/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class SimpleData extends _i1.SerializableEntity {
  SimpleData({
    this.id,
    required this.num,
  });

  factory SimpleData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleData(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      num: serializationManager.deserializeJson<int>(jsonSerialization['num']),
    );
  }

  int? id;

  int num;

  @override
  String get className => 'SimpleData';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }
}
