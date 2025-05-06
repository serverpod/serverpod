import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/remove_deleted_recipes_future_call.dart';
import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RemoveDeletedRecipesFutureCall',
      (unAuthSessionBuilder, endpoints) {
    test(
        'when executed then all recipes with a deleted_at timestamp are deleted',
        () async {
      // Given we have recipes in our database and some are deleted
      final session = unAuthSessionBuilder.build();
      await Recipe.db.insert(session, [
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 1',
            date: DateTime.now(),
            userId: 1,
            ingredients: 'chicken, rice, broccoli'),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 2',
            date: DateTime.now(),
            userId: 2,
            ingredients: 'chicken, rice, broccoli',
            deletedAt: DateTime.now()),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 3',
            date: DateTime.now(),
            userId: 3,
            ingredients: 'chicken, rice, broccoli'),
      ]);
      // we expect the database to have 3 recipes in total
      final recipes = await Recipe.db.find(session);
      expect(recipes.length, 3);

      // when we trigger the future call
      await RemoveDeletedRecipesFutureCall().invoke(session, null);

      // we expect the database to have 2 recipes in total
      final recipes2 = await Recipe.db.find(session);
      expect(recipes2.length, 2);

      // and the deleted recipe to be gone
      expect(recipes2.any((recipe) => recipe.deletedAt != null), false);
    });
  });
}
