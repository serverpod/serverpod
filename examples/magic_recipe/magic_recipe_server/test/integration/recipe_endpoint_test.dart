import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipe_endpoint.dart';
import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

// TODO(dkbast): We should have a testing style guide for serverpod users
void main() {
  // This is an example test that uses the `withServerpod` test helper.
  // `withServerpod` enables you to call your endpoints directly from the test like regular functions.
  // Note that after adding or modifying an endpoint, you will need to run
  // `serverpod generate` to update the test tools code.
  // Refer to the docs for more information on how to use the test helper.
  withServerpod('Given Recipe endpoint', (unAuthSessionBuilder, endpoints) {
    test(
        'when generateRecipe with ingredients then the api is called with a prompt'
        ' which includes the ingredients', () async {
      // Call the endpoint method by using the `endpoints` parameter and
      // pass `sessionBuilder` as a first argument. Refer to the docs on
      // how to use the `sessionBuilder` to set up different test scenarios.

      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      String capturedPrompt = '';

      generateContent = (_, prompt) {
        capturedPrompt = prompt;
        return Future.value('Mock Recipe');
      };

      final recipe = await endpoints.recipe
          .generateRecipe(sessionBuilder, 'chicken, rice, broccoli');
      expect(recipe.text, 'Mock Recipe');
      expect(capturedPrompt, contains('chicken, rice, broccoli'));
    });

    test(
        'when calling getRecipes, all recipes that are not deleted are returned',
        () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

      // drop all recipes
      await Recipe.db.deleteWhere(session, where: (t) => t.id.notEquals(null));

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
            userId: 1,
            ingredients: 'chicken, rice, broccoli'),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 3',
            date: DateTime.now(),
            userId: 2,
            ingredients: 'chicken, rice, broccoli'),
      ]);

      // get all recipes
      final recipes = await endpoints.recipe.getRecipes(sessionBuilder);

      // check that the recipes are returned
      expect(recipes.length, 2);

      // get the first recipe to get its id
      final recipeToDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 1'),
      );

      // delete the first recipe
      await endpoints.recipe.deleteRecipe(sessionBuilder, recipeToDelete!.id!);

      // get all recipes
      final recipes2 = await endpoints.recipe.getRecipes(sessionBuilder);
      // check that the recipes are returned
      expect(recipes2.length, 1);
      expect(recipes2[0].text, 'Mock Recipe 2');
    });

    //TODO(dkbast): Add more tests for the other scenarios
    test('when deleting a recipe users can only delete their own recipes',
        () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

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
            userId: 1,
            ingredients: 'chicken, rice, broccoli'),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 3',
            date: DateTime.now(),
            userId: 2,
            ingredients: 'chicken, rice, broccoli'),
      ]);

      // get the first recipe to get its id
      final recipeToDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 1'),
      );

      // delete the first recipe
      await endpoints.recipe.deleteRecipe(sessionBuilder, recipeToDelete!.id!);

      // try to delete a recipe that is not yours

      final recipeYouShouldntDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 3'),
      );

      await expectException(
          () => endpoints.recipe
              .deleteRecipe(sessionBuilder, recipeYouShouldntDelete!.id!),
          isA<Exception>());
    });

    // verify unauthenticated users cannot interact with the API
    test('when delete recipe with unauthenticated user, an exception is thrown',
        () async {
      await expectException(
          () => endpoints.recipe.deleteRecipe(unAuthSessionBuilder, 1),
          isA<ServerpodUnauthenticatedException>());
    });

    test(
        'when trying to generate a recipe as an unauthenticated user an exception is thrown',
        () async {
      await expectException(
          () => endpoints.recipe
              .generateRecipe(unAuthSessionBuilder, 'chicken, rice, broccoli'),
          isA<ServerpodUnauthenticatedException>());
    });

    test(
        'when trying to get recipes as an unauthenticated user an exception is thrown',
        () async {
      await expectException(
          () => endpoints.recipe.getRecipes(unAuthSessionBuilder),
          isA<ServerpodUnauthenticatedException>());
    });

    test('returns cached recipe if it exists', () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

      String capturedPrompt = '';

      generateContent = (_, prompt) {
        capturedPrompt = prompt;
        return Future.value('Mock Recipe');
      };

      final recipe = await endpoints.recipe
          .generateRecipe(sessionBuilder, 'chicken, rice, broccoli');
      expect(recipe.text, 'Mock Recipe');
      expect(capturedPrompt, contains('chicken, rice, broccoli'));
      final cache = await session.caches.local
          .get<Recipe>('recipe-chicken, rice, broccoli');
      expect(cache, isNotNull);
      expect(cache?.text, 'Mock Recipe');

      // reset
      capturedPrompt = '';

      // Call the endpoint again with the same ingredients
      final recipe2 = await endpoints.recipe
          .generateRecipe(sessionBuilder, 'chicken, rice, broccoli');
      expect(recipe2.text, 'Mock Recipe');
      expect(capturedPrompt, equals(''));
    });
  });
}
