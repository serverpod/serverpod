/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Our AI generated Recipe
abstract class Recipe implements _i1.SerializableModel {
  Recipe._({
    required this.author,
    required this.text,
    required this.date,
    required this.ingredients,
  });

  factory Recipe({
    required String author,
    required String text,
    required DateTime date,
    required String ingredients,
  }) = _RecipeImpl;

  factory Recipe.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recipe(
      author: jsonSerialization['author'] as String,
      text: jsonSerialization['text'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      ingredients: jsonSerialization['ingredients'] as String,
    );
  }

  /// The author of the recipe
  String author;

  /// The recipe text
  String text;

  /// The date the recipe was created
  DateTime date;

  /// The ingredients the user has passed in
  String ingredients;

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Recipe copyWith({
    String? author,
    String? text,
    DateTime? date,
    String? ingredients,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'text': text,
      'date': date.toJson(),
      'ingredients': ingredients,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RecipeImpl extends Recipe {
  _RecipeImpl({
    required String author,
    required String text,
    required DateTime date,
    required String ingredients,
  }) : super._(
          author: author,
          text: text,
          date: date,
          ingredients: ingredients,
        );

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Recipe copyWith({
    String? author,
    String? text,
    DateTime? date,
    String? ingredients,
  }) {
    return Recipe(
      author: author ?? this.author,
      text: text ?? this.text,
      date: date ?? this.date,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
