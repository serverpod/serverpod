// @@@SNIPSTART magic-recipe-endpoint
// ignore_for_file:  type_annotate_public_apis

import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

@visibleForTesting
var generateContent =
    (String apiKey, List<Content> prompt) async => (await GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: apiKey,
        ).generateContent(
          prompt,
        ))
            .text;
@visibleForTesting
var generateContentStreamFromText =
    (String apiKey, List<Content> prompt) async* {
  await for (final message in GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  ).generateContentStream(
    prompt,
  )) {
    if (message.text != null) {
      yield message.text!;
    }
  }
};

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
class RecipeEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Pass in a string containing the ingredients and get a recipe back.
  Stream<Recipe> generateRecipeAsStream(Session session, String ingredients,
      [String? imagePath]) async* {
    session.log(
        'Ingredients Length: ${ingredients.length}, Image Path: $imagePath');

    // Serverpod automatically loads your passwords.yaml file and makes the
    // passwords available in the session.passwords map.
    final userId = (await session.authenticated)?.userId;
    final geminiApiKey = session.passwords['gemini'];

    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found');
    }

    final cacheKey = 'recipe-$ingredients-$imagePath';

    // Check if the recipe is already in the cache
    final cachedRecipe = await session.caches.local.get<Recipe>(cacheKey);

    if (cachedRecipe != null) {
      session.log('Recipe found in cache for ingredients: $ingredients');
      cachedRecipe.userId = userId;
      await Recipe.db.insertRow(session, cachedRecipe);
      yield cachedRecipe;
      return;
    }

    final List<Content> prompt = [];

    if (imagePath != null) {
      final imageData = await session.storage
          .retrieveFile(storageId: 'public', path: imagePath);
      if (imageData == null) {
        throw Exception('Image not found');
      }

      prompt.add(
        Content.data(
          'image/jpeg',
          imageData.buffer.asUint8List(),
        ),
      );
      prompt.add(Content.text('''
Generate a recipe using the detected ingeredients. Always put the title
of the recipe in the first line, and then the instructions. The recipe
should be easy to follow and include all necessary steps. Please provide
a detailed recipe. Only put the title in the first line, no markup.'''));
    }

    // A prompt to generate a recipe, from a text input with the ingredients
    final textPrompt = '''
Generate a recipe using the following ingredients: $ingredients, always put the
title of the recipe in the first line, and then the instructions. The recipe
should be easy to follow and include all necessary steps. Please provide a
detailed recipe.
''';

    if (prompt.isEmpty) {
      prompt.add(Content.text(textPrompt));
    }

    final responseStream = generateContentStreamFromText(geminiApiKey, prompt);

    Recipe recipe = Recipe(
      author: 'Gemini',
      text: '',
      date: DateTime.now(),
      ingredients: ingredients,
      imageUrl: imagePath,
    );
    session.log('Generating recipe with prompt: $textPrompt');
    await for (final responseText in responseStream) {
      // this creates much more traffic than needed, in a real app you should probably
      // just send the incremental updates and then the final result
      recipe = recipe.copyWith(text: recipe.text + responseText);
      session.log('Still streaming: $responseText');
      yield recipe;
    }

    session.log('Final recipe: $recipe');

    await session.caches.local
        .put(cacheKey, recipe, lifetime: const Duration(days: 1));

    // Save the recipe to the database, the returned recipe has the id set
    final recipeWithId = await Recipe.db.insertRow(
      session,
      recipe.copyWith(userId: userId),
    );

    yield recipeWithId;
  }

  /// Pass in a string containing the ingredients and get a recipe back.
  Future<Recipe> generateRecipe(Session session, String ingredients,
      [String? imagePath]) async {
    session.log(
        'Ingredients Length: ${ingredients.length}, Image Path: $imagePath');

    // Serverpod automatically loads your passwords.yaml file and makes the
    // passwords available in the session.passwords map.
    final userId = (await session.authenticated)?.userId;
    final geminiApiKey = session.passwords['gemini'];

    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found');
    }

    final cacheKey = 'recipe-$ingredients-$imagePath';

    // Check if the recipe is already in the cache
    final cachedRecipe = await session.caches.local.get<Recipe>(cacheKey);

    if (cachedRecipe != null) {
      session.log('Recipe found in cache for ingredients: $ingredients');
      cachedRecipe.userId = userId;
      await Recipe.db.insertRow(session, cachedRecipe);
      return cachedRecipe;
    }

    final List<Content> prompt = [];

    if (imagePath != null) {
      final imageData = await session.storage
          .retrieveFile(storageId: 'public', path: imagePath);
      if (imageData == null) {
        throw Exception('Image not found');
      }

      prompt.add(
        Content.data(
          'image/jpeg',
          imageData.buffer.asUint8List(),
        ),
      );
      prompt.add(Content.text('''
Generate a recipe using the detected ingeredients. Always put the title
of the recipe in the first line, and then the instructions. The recipe
should be easy to follow and include all necessary steps. Please provide
a detailed recipe. Only put the title in the first line, no markup.'''));
    }

    // A prompt to generate a recipe, from a text input with the ingredients
    final textPrompt = '''
Generate a recipe using the following ingredients: $ingredients, always put the
title of the recipe in the first line, and then the instructions. The recipe
should be easy to follow and include all necessary steps. Please provide a
detailed recipe.
''';

    if (prompt.isEmpty) {
      prompt.add(Content.text(textPrompt));
    }

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
      imageUrl: imagePath,
    );

    await session.caches.local
        .put(cacheKey, recipe, lifetime: const Duration(days: 1));

    // Save the recipe to the database, the returned recipe has the id set
    final recipeWithId = await Recipe.db.insertRow(
      session,
      recipe.copyWith(userId: userId),
    );

    return recipeWithId;
  }

  /// This method returns all the generated recipes from the database.
  Future<List<Recipe>> getRecipes(Session session) async {
    final userId = (await session.authenticated)?.userId;
    // Get all the recipes from the database, sorted by date.
    return Recipe.db.find(
      session,
      orderBy: (t) => t.date,
      where: (t) => t.userId.equals(userId) & t.deletedAt.equals(null),
      orderDescending: true,
    );
  }

  Future<void> deleteRecipe(Session session, int recipeId) async {
    final userId = (await session.authenticated)?.userId;
    // Find the recipe in the database
    final recipe = await Recipe.db.findById(session, recipeId);
    if (recipe == null || recipe.userId != userId) {
      throw Exception('Recipe not found');
    }
    session.log('Deleting recipe with id: $recipeId');
    // Delete the recipe from the database
    recipe.deletedAt = DateTime.now();
    await Recipe.db.updateRow(session, recipe);
  }

  Future<(String? description, String path)> getUploadDescription(
      Session session, String filename) async {
    const Uuid uuid = Uuid();

    // Generate a unique path for the file
    // Using a uuid prevents collisions and enumeration attacks
    final path = 'uploads/${uuid.v4()}/$filename';

    final description = await session.storage.createDirectFileUploadDescription(
      storageId: 'public',
      path: path,
    );

    return (description, path);
  }

  Future<bool> verifyUpload(Session session, String path) async {
    return await session.storage.verifyDirectFileUpload(
      storageId: 'public',
      path: path,
    );
  }

  Future<String> getPublicUrlForPath(Session session, String path) async {
    final publicUrl =
        await session.storage.getPublicUrl(storageId: 'public', path: path);

    session.log('Public URL:\n$publicUrl');
    return publicUrl.toString();
  }
}
// @@@SNIPEND
