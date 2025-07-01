/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class BulkQueryColumnDescription
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BulkQueryColumnDescription._({required this.name});

  factory BulkQueryColumnDescription({required String name}) =
      _BulkQueryColumnDescriptionImpl;

  factory BulkQueryColumnDescription.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return BulkQueryColumnDescription(
        name: jsonSerialization['name'] as String);
  }

  String name;

  /// Returns a shallow copy of this [BulkQueryColumnDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BulkQueryColumnDescription copyWith({String? name});
  @override
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'name': name};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BulkQueryColumnDescriptionImpl extends BulkQueryColumnDescription {
  _BulkQueryColumnDescriptionImpl({required String name}) : super._(name: name);

  /// Returns a shallow copy of this [BulkQueryColumnDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BulkQueryColumnDescription copyWith({String? name}) {
    return BulkQueryColumnDescription(name: name ?? this.name);
  }
}
