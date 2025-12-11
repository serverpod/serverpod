/// Export the web button renderer in a platform-safe way.
library;

export 'wrapper_stub.dart' if (dart.library.js_interop) 'wrapper_web.dart';
