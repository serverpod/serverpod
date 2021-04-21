library serverpod_client;

export 'package:serverpod_serialization/serverpod_serialization.dart';
export 'src/serverpod_client_io.dart'
  if (dart.library.js) 'src/serverpod_client_browser.dart'
  if (dart.library.io) 'src/serverpod_client_io.dart'
;
export 'src/auth_key_manager.dart';
export 'src/serverpod_client_exception.dart';
export 'src/serverpod_client_shared.dart';
