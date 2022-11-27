/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class SampleView extends _i1.SerializableEntity {
  SampleView({
    required this.description,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory SampleView.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SampleView(
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      createdBy: serializationManager
          .deserialize<String>(jsonSerialization['createdBy']),
      modifiedBy: serializationManager
          .deserialize<String>(jsonSerialization['modifiedBy']),
    );
  }

  String description;

  String createdBy;

  String modifiedBy;

  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }
}
