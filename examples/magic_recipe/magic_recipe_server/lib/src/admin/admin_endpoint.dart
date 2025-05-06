// ignore_for_file: avoid_escaping_inner_quotes

import 'package:magic_recipe_server/server.dart';
import 'package:magic_recipe_server/src/recipes/remove_deleted_recipes_future_call.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  Future<List<UserInfo>> listUsers(Session session) async {
    final users = await UserInfo.db.find(session);

    return users;
  }

  Future<void> blockUser(Session session, int userId) async {
    await Users.blockUser(session, userId);
  }

  Future<void> unblockUser(Session session, int userId) async {
    await Users.unblockUser(session, userId);
  }

  // see https://github.com/serverpod/serverpod/discussions/1096
  Future<void> deleteUser(Session session, int userId) async {
    await blockUser(session, userId);

    final UserInfo? user = await UserInfo.db.findById(session, userId);

    if (user == null) {
      return;
    }

    try {
      final String? email = user.email;

      if (email == null) {
        return;
      }

      await session.db.transaction((transaction) async {
        await session.db.unsafeQuery(
          'DELETE FROM serverpod_user_info WHERE email=\'$email\'',
          transaction: transaction,
        );

        await session.db.unsafeQuery(
          'DELETE FROM serverpod_email_auth WHERE email=\'$email\'',
          transaction: transaction,
        );

        await session.db.unsafeQuery(
          'DELETE FROM serverpod_email_create_request WHERE email=\'$email\'',
          transaction: transaction,
        );

        await session.db.unsafeQuery(
          'DELETE FROM serverpod_email_failed_sign_in WHERE email=\'$email\'',
          transaction: transaction,
        );

        final ColumnInt columnInt =
            ColumnInt('userId', Table(tableName: 'serverpod_email_reset'));

        await session.db.unsafeQuery(
          'DELETE FROM serverpod_email_reset WHERE $columnInt = \'$userId\'',
          transaction: transaction,
        );

        final ColumnInt columnInt2 =
            ColumnInt('userId', Table(tableName: 'serverpod_auth_key'));

        await session.db.unsafeQuery(
          'DELETE FROM serverpod_auth_key WHERE $columnInt2 = \'$userId\'',
          transaction: transaction,
        );

        await session.db.unsafeExecute(
          'DELETE FROM serverpod_email_auth WHERE email = \'$email\'',
          transaction: transaction,
        );
      });
    } catch (e, s) {
      session.log('Failed to delete account',
          exception: e, level: LogLevel.error, stackTrace: s);
    }
  }

  /// Trigger a cleanup of deleted recipes.
  ///
  /// This will immediately delete all recipes that were deleted - this is an
  /// example for how you can trigger future calls from the admin endpoint.
  Future<void> triggerDeletedRecipeCleanup(Session session) async {
    await RemoveDeletedRecipesFutureCall().invoke(session, null);
  }

  /// Schedule a future call to cleanup deleted recipes.
  ///
  /// The future call will be saved to the database and executed at the
  /// specified time. This future call will reschedule itself every 5 minutes.
  Future<void> scheduleDeletedRecipeCleanup(Session session) async {
    await pod.futureCallWithDelay(
      FutureCallNames.rescheduleRemoveDeletedRecipes.name,
      null,
      Duration(seconds: 5),
    );
  }
}
