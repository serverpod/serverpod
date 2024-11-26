/// Represents the HTTP methods used in requests as constants.
class Method {
  /// The string representation of the HTTP method.
  final String value;

  /// Creates a new [Method] instance with the given HTTP method [value].
  const Method(this.value);

  /// Predefined HTTP method constants.
  static const get = Method('GET');
  static const post = Method('POST');
  static const put = Method('PUT');
  static const delete = Method('DELETE');
  static const patch = Method('PATCH');
  static const head = Method('HEAD');
  static const options = Method('OPTIONS');
  static const trace = Method('TRACE');
  static const connect = Method('CONNECT');

  /// A list of all predefined HTTP methods.
  static const List<Method> values = [
    get,
    post,
    put,
    delete,
    patch,
    head,
    options,
    trace,
    connect,
  ];

  /// Parses a [method] string and returns the corresponding [Method] instance.
  ///
  /// Throws an [ArgumentError] if the [method] string is empty.
  /// If the method is not found in the predefined values,
  /// it returns a new [Method] instance with the method name in uppercase.
  static Method parse(String method) {
    if (method.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    return values.firstWhere(
      (m) => m.value.toLowerCase() == method.toLowerCase(),
      orElse: () => Method(method.toUpperCase()),
    );
  }

  /// Returns the string representation of the HTTP method.
  String toHeaderString() => value;

  @override
  String toString() => 'Method($value)';
}
