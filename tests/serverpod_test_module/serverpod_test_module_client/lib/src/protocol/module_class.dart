/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ModuleClass extends _i1.SerializableEntity {
  const ModuleClass._();

  const factory ModuleClass({
    required String name,
    required int data,
  }) = _ModuleClass;

  factory ModuleClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ModuleClass(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      data: serializationManager.deserialize<int>(jsonSerialization['data']),
    );
  }

  ModuleClass copyWith({
    String? name,
    int? data,
  });
  String get name;
  int get data;
}

class _ModuleClass extends ModuleClass {
  const _ModuleClass({
    required this.name,
    required this.data,
  }) : super._();

  @override
  final String name;

  @override
  final int data;

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

  @override
  ModuleClass copyWith({
    String? name,
    int? data,
  }) {
    return ModuleClass(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}
