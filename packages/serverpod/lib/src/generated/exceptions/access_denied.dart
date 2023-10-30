/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AccessDeniedException extends _i1.SerializableEntity
    implements _i1.SerializableException {
  AccessDeniedException._({required this.message});

  factory AccessDeniedException({required String message}) =
      _AccessDeniedExceptionImpl;

  factory AccessDeniedException.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AccessDeniedException(
        message: serializationManager
            .deserialize<String>(jsonSerialization['message']));
  }

  String message;

  AccessDeniedException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {'message': message};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'message': message};
  }
}

class _AccessDeniedExceptionImpl extends AccessDeniedException {
  _AccessDeniedExceptionImpl({required String message})
      : super._(message: message);

  @override
  AccessDeniedException copyWith({String? message}) {
    return AccessDeniedException(message: message ?? this.message);
  }
}
