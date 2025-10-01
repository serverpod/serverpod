import 'package:serverpod/serverpod.dart';

// NOTE: This class has been cleared out and marked abstract.
// It is only left behind to add a deprecation annotation
// to help people move to use StaticRoute.
/// A path pattern to match, and the max age that paths that match the pattern
/// should be cached for, in seconds.
@Deprecated('Use StaticRoute.directory and CacheControlFactory instead')
class PathCacheMaxAge {}

// NOTE: This class has been cleared out and marked abstract.
// It is only left behind to add a deprecation annotation
// to help people move to use StaticRoute.
/// Route for serving a directory of static files.
@Deprecated('Use StaticRoute.directory instead')
abstract class RouteStaticDirectory extends Route {}
