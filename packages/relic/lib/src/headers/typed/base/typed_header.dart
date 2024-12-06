/// A typed header that can be converted to a header string.
abstract class TypedHeader {
  const TypedHeader();

  /// Converts the header to a header string.
  String toHeaderString();
}
