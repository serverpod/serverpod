/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class FileNotFoundException
    implements _i1.SerializableException, _i1.SerializableModel {
  FileNotFoundException._({required this.message});

  factory FileNotFoundException({required String message}) =
      _FileNotFoundExceptionImpl;

  factory FileNotFoundException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return FileNotFoundException(
        message: jsonSerialization['message'] as String);
  }

  String message;

  FileNotFoundException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {'message': message};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
