import 'package:magic_recipe_server/server.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// This future call is used to remove deleted recipes from the database.
///
/// This is useful to clean up the database and remove any recipes that were
/// deleted by the user.
class RemoveDeletedRecipesFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    final deletedRecipes = await Recipe.db.deleteWhere(session,
        where: (RecipeTable recipe) => recipe.deletedAt.notEquals(null));
    // You could also only delete recipes that were deleted more than 1 day ago.
    // This would allow you to keep the recipes in the database for a little
    // longer, so that users can still recover them if they want.
    session.log('Deleted ${deletedRecipes.length} recipes during cleanup');
  }
}

/// This future call is used to reschedule the removal of deleted recipes every
/// 5 minutes.
///
/// This is useful to clean up the database and remove any recipes that were
/// deleted by the user.
class ReschedulingRemoveDeletedRecipesFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    // We can run the future call with the logic directly, no need to schedule
    // it
    await RemoveDeletedRecipesFutureCall().invoke(session, null);

    final pod = session.serverpod;
    // Cancel any existing future call with this name to avoid scheduling
    // multiple future calls
    await pod.cancelFutureCall(
      FutureCallNames.rescheduleRemoveDeletedRecipes.name,
    );
    // Schedule a new future call to run in 5 seconds
    await pod.futureCallWithDelay(
      FutureCallNames.rescheduleRemoveDeletedRecipes.name,
      null,
      Duration(minutes: 5),
    );
    session
        .log('Rescheduled future call to remove deleted recipes in 5 minutes');
  }
}
