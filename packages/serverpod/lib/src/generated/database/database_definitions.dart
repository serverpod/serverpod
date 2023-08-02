/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class DatabaseDefinitions extends _i1.SerializableEntity {
  DatabaseDefinitions({
    required this.target,
    required this.live,
  });

  factory DatabaseDefinitions.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDefinitions(
      target: serializationManager
          .deserialize<_i2.DatabaseDefinition>(jsonSerialization['target']),
      live: serializationManager
          .deserialize<_i2.DatabaseDefinition>(jsonSerialization['live']),
    );
  }

  _i2.DatabaseDefinition target;

  _i2.DatabaseDefinition live;

  @override
  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'live': live,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'target': target,
      'live': live,
    };
  }
}
