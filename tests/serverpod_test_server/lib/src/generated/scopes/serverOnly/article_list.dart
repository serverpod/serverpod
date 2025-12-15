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
import '../../scopes/serverOnly/article.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ArticleList
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ArticleList._({required this.results});

  factory ArticleList({required List<_i2.Article> results}) = _ArticleListImpl;

  factory ArticleList.fromJson(Map<String, dynamic> jsonSerialization) {
    return ArticleList(
      results: _i3.Protocol().deserialize<List<_i2.Article>>(
        jsonSerialization['results'],
      ),
    );
  }

  List<_i2.Article> results;

  /// Returns a shallow copy of this [ArticleList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ArticleList copyWith({List<_i2.Article>? results});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ArticleList',
      'results': results.toJson(valueToJson: (v) => v.toJson()),
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

class _ArticleListImpl extends ArticleList {
  _ArticleListImpl({required List<_i2.Article> results})
    : super._(results: results);

  /// Returns a shallow copy of this [ArticleList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ArticleList copyWith({List<_i2.Article>? results}) {
    return ArticleList(
      results: results ?? this.results.map((e0) => e0.copyWith()).toList(),
    );
  }
}
