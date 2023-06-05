/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

class ModuleClass extends _i1.SerializableEntity {
  ModuleClass({
    required this.name,
    required this.data,
  });

  factory ModuleClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ModuleClass(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      data: serializationManager.deserialize<int>(jsonSerialization['data']),
    );
  }

  final String name;

  final int data;

  late Function({
    String? name,
    int? data,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ModuleClass &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.data,
                  data,
                ) ||
                other.data == data));
  }

  @override
  int get hashCode => Object.hash(
        name,
        data,
      );

  ModuleClass _copyWith({
    String? name,
    int? data,
  }) {
    return ModuleClass(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}
