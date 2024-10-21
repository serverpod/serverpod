/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
part 'sealed_child.dart';
part 'sealed_grandchild.dart';

sealed class SealedParent
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SealedParent({
    required this.sealedInt,
    required this.sealedString,
  });

  int sealedInt;

  String sealedString;

  @override
  Map<String, dynamic> toJson() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}
