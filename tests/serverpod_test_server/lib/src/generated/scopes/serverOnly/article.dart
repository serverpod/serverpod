/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Article
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Article._({
    required this.name,
    required this.price,
  });

  factory Article({
    required String name,
    required double price,
  }) = _ArticleImpl;

  factory Article.fromJson(Map<String, dynamic> jsonSerialization) {
    return Article(
      name: jsonSerialization['name'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
    );
  }

  String name;

  double price;

  /// Returns a shallow copy of this [Article]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Article copyWith({
    String? name,
    double? price,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Article',
      'name': name,
      'price': price,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ArticleImpl extends Article {
  _ArticleImpl({
    required String name,
    required double price,
  }) : super._(
         name: name,
         price: price,
       );

  /// Returns a shallow copy of this [Article]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Article copyWith({
    String? name,
    double? price,
  }) {
    return Article(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}
