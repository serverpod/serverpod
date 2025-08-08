/// This file demonstrates the expected behavior after the authentication resolution changes.
/// 
/// BEFORE (Issue #3091):
/// - Endpoints that don't check authentication: logs show "authenticatedUser: null"
/// - Authentication was only resolved when explicitly accessed via session.authenticated
/// 
/// AFTER (This solution):
/// - All endpoints: logs show actual authenticated user ID when valid auth token provided
/// - Authentication is resolved immediately when Session is created (if auth key present)
/// - Logging in Session.close() waits for authentication resolution before finalizing logs

import 'package:serverpod/serverpod.dart';

/// Example endpoint that doesn't explicitly check authentication
class ExampleEndpoint extends Endpoint {
  /// This endpoint doesn't call session.authenticated, but should still
  /// show the correct user ID in logs when authentication token is provided
  Future<String> publicMethod(Session session, String input) async {
    // Before the fix: session.authenticated would be null in logs
    // After the fix: session.authenticated will contain resolved auth info in logs
    
    // The endpoint doesn't explicitly check authentication, but
    // the Session constructor has already started resolving it,
    // and Session.close() will wait for resolution before logging
    
    return 'Processed: $input';
  }
  
  /// This endpoint explicitly checks authentication
  Future<String> privateMethod(Session session, String input) async {
    // This has always worked correctly because it explicitly accesses authentication
    final authInfo = await session.authenticatedAsync;
    if (authInfo == null) {
      throw Exception('Authentication required');
    }
    
    return 'Processed for user ${authInfo.userIdentifier}: $input';
  }
}

/// Expected log output scenarios:
/// 
/// SCENARIO 1: Request to publicMethod with valid auth token
/// OLD LOGS: "CALL: example.publicMethod duration: 5ms authenticatedUser: null"
/// NEW LOGS: "CALL: example.publicMethod duration: 5ms authenticatedUser: 123"
/// 
/// SCENARIO 2: Request to privateMethod with valid auth token  
/// OLD LOGS: "CALL: example.privateMethod duration: 8ms authenticatedUser: 123"
/// NEW LOGS: "CALL: example.privateMethod duration: 8ms authenticatedUser: 123" (unchanged)
/// 
/// SCENARIO 3: Request to publicMethod without auth token
/// OLD LOGS: "CALL: example.publicMethod duration: 5ms authenticatedUser: null"
/// NEW LOGS: "CALL: example.publicMethod duration: 5ms authenticatedUser: null" (unchanged)

/// Migration guide for existing code:
/// 
/// OLD CODE:
/// ```dart
/// final authInfo = await session.authenticated;
/// final isSignedIn = await session.isUserSignedIn;
/// ```
/// 
/// NEW CODE (Option 1 - Guaranteed resolution):
/// ```dart
/// final authInfo = await session.authenticatedAsync;
/// final isSignedIn = session.isUserSignedIn;  // Now synchronous
/// ```
/// 
/// NEW CODE (Option 2 - Current state access):
/// ```dart
/// final authInfo = session.authenticated;  // Now synchronous, returns current state
/// final isSignedIn = session.isUserSignedIn;  // Now synchronous
/// ```

void main() {
  // This file serves as documentation and expected behavior specification
  print('Authentication resolution implementation complete');
  print('See comments above for expected behavior changes');
}