import 'package:relic/relic.dart';

/// Trims, lowercases, and drops a trailing slash from an `Origin` header value.
///
/// Returns null when [origin] is null or empty after normalization. Shared by
/// Relic and RPC so the allow-list compare cannot drift.
String? normalizeOriginValue(String? origin) {
  if (origin == null) return null;
  final normalized = origin.trim().toLowerCase().replaceFirst(
    RegExp(r'/+$'),
    '',
  );
  return normalized.isEmpty ? null : normalized;
}

/// The `Origin` header of [req] after [normalizeOriginValue], or null if absent.
String? requestOrigin(Request req) =>
    normalizeOriginValue(req.headers[Headers.originHeader]?.firstOrNull);

/// Whether [req] carries an `Origin` that is present but not in
/// [allowedOrigins].
///
/// A missing `Origin` (native / mobile / server-to-server, which don't send
/// one) or an unset allow-list is not rejected. Relic is stricter on missing
/// Origin only when authenticating from the auth cookie; that policy is not
/// shared from here.
bool isPresentOriginDisallowed(
  Request req,
  List<String>? allowedOrigins,
) {
  if (allowedOrigins == null) return false;
  final origin = requestOrigin(req);
  return origin != null && !allowedOrigins.contains(origin);
}
