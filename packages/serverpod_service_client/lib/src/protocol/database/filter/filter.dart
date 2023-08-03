/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

class Filter extends _i1.SerializableEntity {
  Filter({
    required this.name,
    required this.table,
    required this.constraints,
  });

  factory Filter.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Filter(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      table:
          serializationManager.deserialize<String>(jsonSerialization['table']),
      constraints: serializationManager.deserialize<List<_i2.FilterConstraint>>(
          jsonSerialization['constraints']),
    );
  }

  String name;

  String table;

  List<_i2.FilterConstraint> constraints;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'table': table,
      'constraints': constraints,
    };
  }
}
