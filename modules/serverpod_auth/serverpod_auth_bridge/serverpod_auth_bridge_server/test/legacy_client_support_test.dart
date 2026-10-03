import 'package:serverpod_auth_bridge_server/src/business/legacy_endpoint_disposition.dart';
import 'package:test/test.dart';

/// Tests which legacy `serverpod_auth` endpoints survive
/// `enableLegacyClientSupport`.
///
/// A server that depends on `serverpod_auth_migration_server` mounts the
/// entire legacy endpoint surface, but the bridge forwards only `email`,
/// `status` and `user`. The rest answer out of the legacy tables: the
/// sign-ins hand out legacy session keys, and `admin` acts on rows the new
/// stack no longer reads.
///
/// The invariant: an endpoint is either forwarded to the bridge or refused -
/// never quietly served by the legacy module.
void main() {
  group('Given unbridged legacy endpoints are blocked,', () {
    LegacyEndpointDisposition disposition(final String endpoint) =>
        dispositionFor(endpoint, blockUnbridgedAuthEndpoints: true);

    test('when the email endpoint is called, then it is forwarded.', () {
      expect(
        disposition('serverpod_auth.email'),
        isA<ForwardToBridge>().having(
          (final d) => d.bridgeEndpoint,
          'bridgeEndpoint',
          'serverpod_auth_bridge.legacyEmail',
        ),
      );
    });

    test('when the status endpoint is called, then it is forwarded.', () {
      expect(disposition('serverpod_auth.status'), isA<ForwardToBridge>());
    });

    test('when the user endpoint is called, then it is forwarded.', () {
      expect(disposition('serverpod_auth.user'), isA<ForwardToBridge>());
    });

    for (final endpoint in const [
      'serverpod_auth.admin',
      'serverpod_auth.apple',
      'serverpod_auth.firebase',
      'serverpod_auth.google',
    ]) {
      test('when $endpoint is called, then it is blocked.', () {
        expect(
          disposition(endpoint),
          isA<BlockLegacyEndpoint>(),
          reason: 'Serving $endpoint leaves the legacy module answering.',
        );
      });
    }

    test(
      'when a legacy endpoint nobody listed is called, then it is blocked.',
      () {
        expect(
          disposition('serverpod_auth.somethingAddedLater'),
          isA<BlockLegacyEndpoint>(),
          reason: 'The refusals are the complement of what is forwarded.',
        );
      },
    );

    test('when an application endpoint is called, then it is untouched.', () {
      expect(disposition('myEndpoint'), isA<PassThrough>());
    });

    test('when a bridge endpoint is called, then it is untouched.', () {
      expect(
        disposition('serverpod_auth_bridge.legacyEmail'),
        isA<PassThrough>(),
        reason: 'Forwarding must not loop.',
      );
    });

    test('when a new-stack endpoint is called, then it is untouched.', () {
      expect(disposition('serverpod_auth_idp.email'), isA<PassThrough>());
    });
  });

  group('Given unbridged legacy endpoints are served,', () {
    LegacyEndpointDisposition disposition(final String endpoint) =>
        dispositionFor(endpoint, blockUnbridgedAuthEndpoints: false);

    test('when the apple endpoint is called, then it is served.', () {
      expect(disposition('serverpod_auth.apple'), isA<PassThrough>());
    });

    test('when the email endpoint is called, then it is still forwarded.', () {
      expect(disposition('serverpod_auth.email'), isA<ForwardToBridge>());
    });
  });
}
