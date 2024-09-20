/// Represents the HTTP methods used in requests.
enum Method {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH'),
  head('HEAD'),
  options('OPTIONS'),
  trace('TRACE'),
  connect('CONNECT');

  /// The string representation of the HTTP method.
  final String value;

  const Method(this.value);

  /// Parses a [method] string and returns the corresponding [Method] enum.
  ///
  /// Throws an [ArgumentError] if the method is invalid.
  static Method parse(String method) {
    return Method.values.firstWhere(
      (e) => e.name.toLowerCase() == method.toLowerCase(),
      orElse: () => throw ArgumentError.value(
        method,
        'method',
        'Invalid method. Supported methods are: ${Method.values.map((m) => m.value).join(', ')}.',
      ),
    );
  }
}
