/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class BulkQueryColumnDescription extends _i1.SerializableEntity {
  BulkQueryColumnDescription._({required this.name});

  factory BulkQueryColumnDescription({required String name}) =
      _BulkQueryColumnDescriptionImpl;

  factory BulkQueryColumnDescription.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return BulkQueryColumnDescription(
        name: jsonSerialization['name'] as String);
  }

  String name;

  BulkQueryColumnDescription copyWith({String? name});
  @override
  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class _BulkQueryColumnDescriptionImpl extends BulkQueryColumnDescription {
  _BulkQueryColumnDescriptionImpl({required String name}) : super._(name: name);

  @override
  BulkQueryColumnDescription copyWith({String? name}) {
    return BulkQueryColumnDescription(name: name ?? this.name);
  }
}
