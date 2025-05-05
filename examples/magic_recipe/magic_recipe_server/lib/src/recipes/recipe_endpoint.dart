// @@@SNIPSTART 03-persisted-endpoint
// ignore_for_file:  type_annotate_public_apis

import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

@visibleForTesting
var generateContent =
    (String apiKey, String prompt) async => (await GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: apiKey,
        ).generateContent(
          [Content.text(prompt)],
        ))
            .text;

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
class RecipeEndpoint extends Endpoint {
  /// Pass in a string containing the ingredients and get a recipe back.
  Future<Recipe> generateRecipe(Session session, String ingredients) async {
    // Serverpod automatically loads your passwords.yaml file and makes the passwords available
    // in the session.passwords map.
    final geminiApiKey = session.passwords['gemini'];
    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found');
    }

    // A prompt to generate a recipe, the user will provide a free text input with the ingredients
    final prompt =
        'Generate a recipe using the following ingredients: $ingredients, always put the title '
        'of the recipe in the first line, and then the instructions. The recipe should be easy '
        'to follow and include all necessary steps. Please provide a detailed recipe.';

    final responseText = await generateContent(geminiApiKey, prompt);

    // Check if the response is empty or null
    if (responseText == null || responseText.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    final recipe = Recipe(
      author: 'Gemini',
      text: responseText,
      date: DateTime.now(),
      ingredients: ingredients,
    );

    // Save the recipe to the database, the returned recipe has the id set
    final recipeWithId = await Recipe.db.insertRow(session, recipe);

    return recipeWithId;
  }

  /// This method returns all the generated recipes from the database.
  Future<List<Recipe>> getRecipes(Session session) async {
    // Get all the recipes from the database, sorted by date.
    return Recipe.db.find(
      session,
      orderBy: (t) => t.date,
      where: (t) => t.deletedAt.equals(null),
      orderDescending: true,
    );
  }

  Future<void> deleteRecipe(Session session, int recipeId) async {
    // Find the recipe in the database
    final recipe = await Recipe.db.findById(session, recipeId);
    if (recipe == null) {
      throw Exception('Recipe not found');
    }
    // Delete the recipe from the database
    recipe.deletedAt = DateTime.now();
    await Recipe.db.updateRow(session, recipe);
  }
}
// @@@SNIPEND
