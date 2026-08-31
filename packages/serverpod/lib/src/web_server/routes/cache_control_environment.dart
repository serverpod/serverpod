import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Cache control factory that leaves the caching behavior to client side
/// heuristics.
CacheControlHeader? noCacheControl(Request request, FileInfo fileInfo) => null;

/// Resolves the [CacheControlFactory] to use when none was set in Dart.
///
/// Returns a factory built from the value of the [environmentVariable] when it
/// is set, and [fallback] otherwise.
///
/// Throws a [FormatException] if the environment variable does not hold a
/// valid `Cache-Control` header value.
CacheControlFactory cacheControlFactoryFromEnvironment(
  String environmentVariable, {
  required CacheControlFactory fallback,
}) {
  final cacheControl = Platform.environment[environmentVariable];
  if (cacheControl == null) return fallback;

  final parsedCacheControl = CacheControlHeader.parseStrict([cacheControl]);
  return (_, _) => parsedCacheControl;
}
