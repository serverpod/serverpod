import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

// TODO(dkbast): We should have a testing style guide for serverpod users
void main() {
  withServerpod('Given Admin endpoint', (unAuthSessionBuilder, endpoints) {
    test('no endpoint is callable without authentication', () async {
      await expectException(
          () => endpoints.admin.listUsers(unAuthSessionBuilder),
          isA<ServerpodUnauthenticatedException>());

      await expectException(
          () => endpoints.admin.blockUser(unAuthSessionBuilder, 1),
          isA<ServerpodUnauthenticatedException>());

      await expectException(
          () => endpoints.admin.unblockUser(unAuthSessionBuilder, 1),
          isA<ServerpodUnauthenticatedException>());

      await expectException(
          () => endpoints.admin.deleteUser(unAuthSessionBuilder, 1),
          isA<ServerpodUnauthenticatedException>());
    });
    test('no endpoint is callable without admin scope', () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));

      await expectException(() => endpoints.admin.listUsers(sessionBuilder),
          isA<ServerpodInsufficientAccessException>());

      await expectException(() => endpoints.admin.blockUser(sessionBuilder, 1),
          isA<ServerpodInsufficientAccessException>());

      await expectException(
          () => endpoints.admin.unblockUser(sessionBuilder, 1),
          isA<ServerpodInsufficientAccessException>());

      await expectException(() => endpoints.admin.deleteUser(sessionBuilder, 1),
          isA<ServerpodInsufficientAccessException>());
    });
  });
}
