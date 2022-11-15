/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum LogLevel with _i1.SerializableEntity {
  debug,
  info,
  warning,
  error,
  fatal;

  static LogLevel? fromJson(int index) {
    switch (index) {
      case 0:
        return debug;
      case 1:
        return info;
      case 2:
        return warning;
      case 3:
        return error;
      case 4:
        return fatal;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
