import 'package:serverpod_auth_idp_server/core.dart' as core;

/// By extending [core.RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
class RefreshJwtTokensEndpoint extends core.RefreshJwtTokensEndpoint {}
