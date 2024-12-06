part of '../headers.dart';

/// A class representing the HTTP Authentication header.
class AuthenticationHeader {
  /// The authentication scheme (e.g., "Basic", "Bearer", "Digest").
  final String scheme;

  /// The parameters associated with the authentication scheme.
  final List<AuthenticationParameter> parameters;

  /// Constructs an [AuthenticationHeader] instance with the specified scheme and parameters.
  const AuthenticationHeader({
    required this.scheme,
    required this.parameters,
  });

  /// Parses the Authentication header value and returns an [AuthenticationHeader] instance.
  factory AuthenticationHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    // Split into scheme and parameters part
    final firstSpace = trimmed.indexOf(' ');
    if (firstSpace == -1) {
      throw FormatException('Missing scheme or parameters');
    }

    final scheme = trimmed.substring(0, firstSpace).trim();
    final paramsString = trimmed.substring(firstSpace + 1).trim();
    final parameters = <AuthenticationParameter>[];

    if (paramsString.isNotEmpty) {
      // Split parameters by comma, but not within quotes
      final paramRegex = RegExp(r'(\w+)="([^"]*)"');
      final matches = paramRegex.allMatches(paramsString);

      if (matches.isEmpty && paramsString.isNotEmpty) {
        // If no key="value" pairs found but string is not empty,
        // treat the entire remaining string as a single parameter value
        parameters.add(AuthenticationParameter('', paramsString));
      } else {
        for (final match in matches) {
          final key = match.group(1)!;
          final value = match.group(2)!;
          parameters.add(AuthenticationParameter(key, value));
        }
      }
    }

    return AuthenticationHeader(scheme: scheme, parameters: parameters);
  }

  /// Converts the [AuthenticationHeader] instance into a string representation suitable for HTTP headers.
  String toHeaderString() {
    final paramsString = parameters.map((param) {
      if (param.key.isEmpty) return param.value;
      return '${param.key}="${param.value}"';
    }).join(', ');
    return '$scheme $paramsString';
  }

  @override
  String toString() {
    return 'AuthenticationHeader(scheme: $scheme, parameters: $parameters)';
  }
}

/// A class representing a key-value pair parameter for authentication.
class AuthenticationParameter {
  final String key;
  final String value;

  const AuthenticationParameter(this.key, this.value);

  //TODO: fix it
  @override
  String toString() => key.isEmpty ? value : '$key="$value"';
}
