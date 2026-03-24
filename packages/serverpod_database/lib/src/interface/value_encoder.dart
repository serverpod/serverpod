/// Interface for value encoders.
///
/// Can be accessed through the [instance] property if a database has been
/// created before.
abstract interface class ValueEncoder {
  /// The shared singleton encoder for the current database to be used for query
  /// builder and expressions to correctly encode values.
  static ValueEncoder get instance {
    if (_instance == null) {
      throw StateError('Encoder not available. No Database has been created.');
    }
    return _instance!;
  }

  static ValueEncoder? _instance;

  /// Sets the singleton [instance] to the given [encoder].
  static void set(ValueEncoder encoder) {
    _instance = encoder;
  }

  /// Converts an object to a string.
  String convert(
    Object? input, {
    bool escapeStrings = true,
    bool hasDefaults = false,
  });

  /// Tries to convert an object to a string.
  /// Returns `null` if the conversion fails.
  String? tryConvert(Object? input, {bool escapeStrings = false});
}
