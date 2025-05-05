import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipe_endpoint.dart';
import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  // This is an example test that uses the `withServerpod` test helper.
  // `withServerpod` enables you to call your endpoints directly from the test like regular functions.
  // Note that after adding or modifying an endpoint, you will need to run
  // `serverpod generate` to update the test tools code.
  // Refer to the docs for more information on how to use the test helper.
  withServerpod('Given Recipe endpoint', (sessionBuilder, endpoints) {
    test(
        'when generateRecipe with ingredients then the api is called with a prompt'
        ' which includes the ingredients', () async {
      // Call the endpoint method by using the `endpoints` parameter and
      // pass `sessionBuilder` as a first argument. Refer to the docs on
      // how to use the `sessionBuilder` to set up different test scenarios.

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
      final session = sessionBuilder.build();

      // drop all recipes
      await Recipe.db.deleteWhere(session, where: (t) => t.id.notEquals(null));

      // create a recipe
      final firstRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 1',
          date: DateTime.now(),
          ingredients: 'chicken, rice, broccoli');

      await Recipe.db.insertRow(session, firstRecipe);

      // create a second recipe
      final secondRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 2',
          date: DateTime.now(),
          ingredients: 'chicken, rice, broccoli');
      await Recipe.db.insertRow(session, secondRecipe);

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
  });
}
