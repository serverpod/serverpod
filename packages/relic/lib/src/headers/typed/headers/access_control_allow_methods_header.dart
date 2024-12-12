import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';
import 'package:relic/src/method/request_method.dart';

/// A class representing the HTTP Access-Control-Allow-Methods header.
///
/// This header specifies which methods are allowed when accessing the resource
/// in response to a preflight request.
class AccessControlAllowMethodsHeader implements TypedHeader {
  /// The list of methods that are allowed.
  final List<RequestMethod>? methods;

  /// Whether all methods are allowed (`*`).
  final bool isWildcard;

  /// Constructs an instance allowing specific methods to be allowed.
  const AccessControlAllowMethodsHeader.methods({required this.methods})
      : isWildcard = false;

  /// Constructs an instance allowing all methods to be allowed (`*`).
  const AccessControlAllowMethodsHeader.wildcard()
      : methods = null,
        isWildcard = true;

  /// Parses the Access-Control-Allow-Methods header value and returns an
  /// [AccessControlAllowMethodsHeader] instance.
  factory AccessControlAllowMethodsHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();
    if (splitValues.isEmpty) {
      throw FormatException(
        'Value cannot be empty',
      );
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return AccessControlAllowMethodsHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException(
        'Wildcard (*) cannot be used with other values',
      );
    }

    return AccessControlAllowMethodsHeader.methods(
      methods: splitValues.map(RequestMethod.parse).toList(),
    );
  }

  /// Converts the [AccessControlAllowMethodsHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard ? '*' : methods!.join(', ');

  @override
  String toString() =>
      'AccessControlAllowMethodsHeader(methods: $methods, isWildcard: $isWildcard)';
}
