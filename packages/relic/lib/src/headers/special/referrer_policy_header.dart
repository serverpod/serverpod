part of '../headers.dart';

/// A class representing the HTTP Referrer-Policy header.
///
/// This class manages the referrer policy, providing functionality to parse
/// and generate referrer policy header values.
class ReferrerPolicyHeader {
  /// The string representation of the referrer policy directive.
  final String directive;

  /// Private constructor for [ReferrerPolicyHeader].
  const ReferrerPolicyHeader(this.directive);

  /// Predefined referrer policy directives.
  static const _noReferrer = 'no-referrer';
  static const _noReferrerWhenDowngrade = 'no-referrer-when-downgrade';
  static const _origin = 'origin';
  static const _originWhenCrossOrigin = 'origin-when-cross-origin';
  static const _sameOrigin = 'same-origin';
  static const _strictOrigin = 'strict-origin';
  static const _strictOriginWhenCrossOrigin = 'strict-origin-when-cross-origin';
  static const _unsafeUrl = 'unsafe-url';

  static const noReferrer = ReferrerPolicyHeader(_noReferrer);
  static const noReferrerWhenDowngrade =
      ReferrerPolicyHeader(_noReferrerWhenDowngrade);
  static const origin = ReferrerPolicyHeader(_origin);
  static const originWhenCrossOrigin =
      ReferrerPolicyHeader(_originWhenCrossOrigin);
  static const sameOrigin = ReferrerPolicyHeader(_sameOrigin);
  static const strictOrigin = ReferrerPolicyHeader(_strictOrigin);
  static const strictOriginWhenCrossOrigin =
      ReferrerPolicyHeader(_strictOriginWhenCrossOrigin);
  static const unsafeUrl = ReferrerPolicyHeader(_unsafeUrl);

  /// Parses a [directive] and returns the corresponding [ReferrerPolicyHeader] instance.
  /// If the directive does not match any predefined types, it returns a custom instance.
  factory ReferrerPolicyHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed) {
      case _noReferrer:
        return noReferrer;
      case _noReferrerWhenDowngrade:
        return noReferrerWhenDowngrade;
      case _origin:
        return origin;
      case _originWhenCrossOrigin:
        return originWhenCrossOrigin;
      case _sameOrigin:
        return sameOrigin;
      case _strictOrigin:
        return strictOrigin;
      case _strictOriginWhenCrossOrigin:
        return strictOriginWhenCrossOrigin;
      case _unsafeUrl:
        return unsafeUrl;
      default:
        return ReferrerPolicyHeader(value);
    }
  }

  /// Converts the [ReferrerPolicyHeader] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => directive;

  @override
  String toString() {
    return 'ReferrerPolicyHeader(directive: $directive)';
  }
}
