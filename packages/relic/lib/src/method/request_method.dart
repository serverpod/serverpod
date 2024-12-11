/// Represents the HTTP methods used in requests as constants.
class RequestMethod {
  /// Predefined HTTP method constants.
  static const _get = 'GET';
  static const _post = 'POST';
  static const _put = 'PUT';
  static const _delete = 'DELETE';
  static const _patch = 'PATCH';
  static const _head = 'HEAD';
  static const _options = 'OPTIONS';
  static const _trace = 'TRACE';
  static const _connect = 'CONNECT';

  /// The string representation of the HTTP method.
  final String value;

  /// Creates a new [RequestMethod] instance with the given HTTP method [value].
  const RequestMethod._(this.value);

  /// Predefined HTTP method constants.
  static const get = RequestMethod._(_get);
  static const post = RequestMethod._(_post);
  static const put = RequestMethod._(_put);
  static const delete = RequestMethod._(_delete);
  static const patch = RequestMethod._(_patch);
  static const head = RequestMethod._(_head);
  static const options = RequestMethod._(_options);
  static const trace = RequestMethod._(_trace);
  static const connect = RequestMethod._(_connect);

  /// Parses a [method] string and returns the corresponding [RequestMethod] instance.
  ///
  /// Throws an [ArgumentError] if the [method] string is empty.
  /// If the method is not found in the predefined values,
  /// it returns a new [RequestMethod] instance with the method name in uppercase.
  factory RequestMethod.parse(String method) {
    if (method.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (method.toUpperCase()) {
      case _get:
        return get;
      case _post:
        return post;
      case _put:
        return put;
      case _delete:
        return delete;
      case _patch:
        return patch;
      case _head:
        return head;
      case _options:
        return options;
      case _trace:
        return trace;
      case _connect:
        return connect;
      default:
        throw FormatException('Invalid value');
    }
  }

  @override
  String toString() => 'Method($value)';
}
