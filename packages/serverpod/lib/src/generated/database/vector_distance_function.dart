/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Vector distance functions exposed by pgvector.
enum VectorDistanceFunction implements _i1.SerializableModel {
  /// L2 (Euclidean) distance
  l2,

  /// Inner product distance
  innerProduct,

  /// Cosine distance
  cosine,

  /// L1 (Manhattan) distance
  l1,

  /// Hamming distance (binary vectors)
  hamming,

  /// Jaccard distance (binary vectors)
  jaccard;

  static VectorDistanceFunction fromJson(int index) {
    switch (index) {
      case 0:
        return VectorDistanceFunction.l2;
      case 1:
        return VectorDistanceFunction.innerProduct;
      case 2:
        return VectorDistanceFunction.cosine;
      case 3:
        return VectorDistanceFunction.l1;
      case 4:
        return VectorDistanceFunction.hamming;
      case 5:
        return VectorDistanceFunction.jaccard;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "VectorDistanceFunction"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
