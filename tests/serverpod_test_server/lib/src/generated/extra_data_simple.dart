/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
class ExtraDataSimple extends _i1.SerializableEntity {
  ExtraDataSimple({this.num});

  factory ExtraDataSimple.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ExtraDataSimple(
        num: serializationManager.deserialize<int?>(jsonSerialization['num']));
  }

  int? num;

  @override
  Map<String, dynamic> toJson() {
    return {'num': num};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'num': num};
  }
}
