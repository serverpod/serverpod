/// Where a client-side test database lives, per platform.
///
/// On the VM this is a file in a temporary directory. On the web there is no
/// file system: the "path" is a name in the browser's origin private file
/// system, so the web implementation only has to hand out unique names.
///
/// The condition is `dart.library.js_interop` rather than `dart.library.io`
/// because Flutter's web SDK ships `dart:io` as a stub: it is present on the
/// web, and its members throw when used.
export 'database_path_io.dart'
    if (dart.library.js_interop) 'database_path_web.dart';
