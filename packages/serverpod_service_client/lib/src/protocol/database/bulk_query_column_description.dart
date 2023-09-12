/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class BulkQueryColumnDescription extends _i1.SerializableEntity {
  BulkQueryColumnDescription._({
    required this.name,
    required this.table,
  });

  factory BulkQueryColumnDescription({
    required String name,
    required String table,
  }) = _BulkQueryColumnDescriptionImpl;

  factory BulkQueryColumnDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return BulkQueryColumnDescription(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      table:
          serializationManager.deserialize<String>(jsonSerialization['table']),
    );
  }

  String name;

  String table;

  BulkQueryColumnDescription copyWith({
    String? name,
    String? table,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'table': table,
    };
  }
}

class _BulkQueryColumnDescriptionImpl extends BulkQueryColumnDescription {
  _BulkQueryColumnDescriptionImpl({
    required String name,
    required String table,
  }) : super._(
          name: name,
          table: table,
        );

  @override
  BulkQueryColumnDescription copyWith({
    String? name,
    String? table,
  }) {
    return BulkQueryColumnDescription(
      name: name ?? this.name,
      table: table ?? this.table,
    );
  }
}
