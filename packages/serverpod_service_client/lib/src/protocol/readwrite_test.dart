/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ReadWriteTestEntry extends _i1.SerializableEntity {
  ReadWriteTestEntry({
    this.id,
    required this.number,
  });

  factory ReadWriteTestEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ReadWriteTestEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      number: serializationManager
          .deserializeJson<int>(jsonSerialization['number']),
    );
  }

  int? id;

  int number;

  @override
  String get className => 'ReadWriteTestEntry';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
    };
  }
}
