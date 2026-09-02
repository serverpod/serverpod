/// Maximum accepted length of a `return_to` candidate before it is rejected.
const int maxReturnToLength = 512;

/// Maximum number of URL-decode passes before a still-changing value is
/// treated as unsafe.
const int maxReturnToDecodeIterations = 5;

/// Returns a same-origin relative path from [candidate], or [fallback] if
/// [candidate] is missing or unsafe.
///
/// Used for open-redirect protection on login, OAuth `return_to`, and
/// [requireLogin].
String safeReturnTo(String? candidate, {String fallback = '/'}) {
  return trySafeReturnTo(candidate) ?? fallback;
}

/// Returns the normalized same-origin relative path, or null if [candidate]
/// is missing or unsafe.
///
/// Prefer [safeReturnTo] at request time. Use this when an invalid value must
/// throw (for example `requireLogin(redirectTo:)` at construction).
String? trySafeReturnTo(String? candidate) {
  if (candidate == null || candidate.isEmpty) return null;
  if (candidate.length > maxReturnToLength) return null;
  if (_hasUnsafeChars(candidate)) return null;

  var current = candidate;
  var stabilized = false;
  for (var i = 0; i < maxReturnToDecodeIterations; i++) {
    String decoded;
    try {
      decoded = Uri.decodeComponent(current);
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
    if (decoded == current) {
      stabilized = true;
      break;
    }
    current = decoded;
    if (_hasUnsafeChars(current)) return null;
  }
  if (!stabilized) return null;

  final withoutFragment = current.split('#').first;
  if (withoutFragment.isEmpty) return null;

  final queryIndex = withoutFragment.indexOf('?');
  final pathPart = queryIndex == -1
      ? withoutFragment
      : withoutFragment.substring(0, queryIndex);
  final queryPart = queryIndex == -1
      ? ''
      : withoutFragment.substring(queryIndex);

  if (!_isSafePath(pathPart)) return null;

  final normalized = '$pathPart$queryPart';
  if (!_isSafePath(
    queryIndex == -1 ? normalized : normalized.substring(0, queryIndex),
  )) {
    return null;
  }
  return normalized;
}

/// Appends `return_to=` to [path] using `?` or `&` depending on whether
/// [path] already has a query.
String withReturnToQuery(String path, String returnTo) {
  final separator = path.contains('?') ? '&' : '?';
  return '$path${separator}return_to=${Uri.encodeQueryComponent(returnTo)}';
}

bool _hasUnsafeChars(String value) {
  for (final code in value.codeUnits) {
    // C0 controls, DEL, and backslash (raw or decoded).
    if (code <= 0x1f || code == 0x7f || code == 0x5c) return true;
  }
  return false;
}

bool _isSafePath(String path) {
  if (!path.startsWith('/') || path.startsWith('//')) return false;

  final segments = path.split('/');
  // segments[0] is empty because of the leading `/`.
  for (var i = 1; i < segments.length; i++) {
    final segment = segments[i];
    if (segment == '..') return false;
    // Empty middle segments would produce `//` in the path. A trailing slash
    // leaves an empty last segment and is allowed.
    if (segment.isEmpty && i != segments.length - 1) return false;
  }

  final rebuilt = segments.join('/');
  return rebuilt.startsWith('/') && !rebuilt.startsWith('//');
}
