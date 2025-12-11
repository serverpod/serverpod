import 'package:serverpod_auth_idp_server/core.dart';

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
class JwtRefreshEndpoint extends RefreshJwtTokensEndpoint {}
