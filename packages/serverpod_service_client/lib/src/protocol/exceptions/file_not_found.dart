/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class FileNotFoundException extends _i1.SerializableEntity
    implements _i1.SerializableException {
  FileNotFoundException._({required this.message});

  factory FileNotFoundException({required String message}) =
      _FileNotFoundExceptionImpl;

  factory FileNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return FileNotFoundException(
        message: serializationManager
            .deserialize<String>(jsonSerialization['message']));
  }

  String message;

  FileNotFoundException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class _FileNotFoundExceptionImpl extends FileNotFoundException {
  _FileNotFoundExceptionImpl({required String message})
      : super._(message: message);

  @override
  FileNotFoundException copyWith({String? message}) {
    return FileNotFoundException(message: message ?? this.message);
  }
}
