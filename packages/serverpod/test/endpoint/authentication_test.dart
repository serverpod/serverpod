import 'package:serverpod/src/authentication/authentication_info.dart';
import 'package:serverpod/src/authentication/scope.dart';
import 'package:serverpod/src/server/endpoint_dispatch.dart';
import 'package:test/test.dart';

void main() {
  group('Given unauthenticated user', () {
    Future<AuthenticationInfo?> unauthenticatedUserProvider() async => null;

    test(
        'when accessing endpoint that does not required login or scopes, then null is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        unauthenticatedUserProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires login but no scopes, then authentication failure is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        unauthenticatedUserProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.unauthenticated,
      );
    });

    test(
        'when accessing endpoint that requires scopes but not login, then authentication failure is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        unauthenticatedUserProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.unauthenticated,
      );
    });

    test(
        'when accessing endpoint that requires login and scopes, then authentication failure is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        unauthenticatedUserProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.unauthenticated,
      );
    });
  });

  group('Given authenticated user with no scopes', () {
    Future<AuthenticationInfo?> authenticatedUserWithNoScopesProvider() async =>
        AuthenticationInfo(
          '1',
          {},
        );

    test(
        'when accessing endpoint that does not required login or scopes, then null is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires login but no scopes, then null is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires scopes but not login, then authentication failure is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.insufficientAccess,
      );
    });

    test(
        'when accessing endpoint that requires login and scopes, then authentication failure is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.insufficientAccess,
      );
    });
  });

  group('Given authenticated user with "admin" scope', () {
    Future<AuthenticationInfo?> authenticatedUserWithNoScopesProvider() async =>
        AuthenticationInfo(
          '1',
          {Scope.admin},
        );

    test(
        'when accessing endpoint that does not required login or scopes, then null is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires login but no scopes, then null is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = <Scope>{};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires "admin" scope but not login, then null is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires "admin" and "other" scope but not login, then null authentication failure is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = {Scope.admin, const Scope('other')};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.insufficientAccess,
      );
    });

    test(
        'when accessing endpoint that requires login and "admin" scope, then null is returned.',
        () async {
      var requiresLogin = true;
      var requiredScopes = {Scope.admin};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, null);
    });

    test(
        'when accessing endpoint that requires login and "admin" and "other" scopes, then null authentication failure is returned.',
        () async {
      var requiresLogin = false;
      var requiredScopes = {Scope.admin, const Scope('other')};
      var result = await EndpointDispatch.canUserAccessEndpoint(
        authenticatedUserWithNoScopesProvider,
        requiresLogin,
        requiredScopes,
      );

      expect(result, isNotNull);
      expect(
        (result as ResultAuthenticationFailed).reason,
        AuthenticationFailureReason.insufficientAccess,
      );
    });
  });
}
