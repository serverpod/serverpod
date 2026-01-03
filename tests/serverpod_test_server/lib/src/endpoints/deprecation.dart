import 'package:serverpod/serverpod.dart';

double globalDouble = 0;

/// A simple endpoint for testing deprecated endpoint methods.
class DeprecationEndpoint extends Endpoint {
  /// A method with a simple "@deprecated" annotation.
  @deprecated
  Future<void> setGlobalDouble(Session session, double? value) async {
    globalDouble = value!;
  }

  /// A method with a "@Deprecated(..)" annotation.
  @Deprecated('Marking endpoint method as deprecated')
  Future<double> getGlobalDouble(Session session) async {
    return globalDouble;
  }

  /// A method with a deprecated parameter using "@deprecated" annotation.
  Future<String> methodWithDeprecatedParam(
    Session session,
    @deprecated String deprecatedParam,
  ) async {
    return deprecatedParam;
  }

  /// A method with a deprecated parameter using "@Deprecated(..)" annotation.
  Future<String> methodWithDeprecatedParamMessage(
    Session session,
    @Deprecated('This parameter is deprecated') String deprecatedParam,
  ) async {
    return deprecatedParam;
  }

  /// A method with both deprecated and non-deprecated parameters.
  Future<String> methodWithMixedParams(
    Session session,
    String normalParam,
    @deprecated String deprecatedParam,
  ) async {
    return normalParam + deprecatedParam;
  }

  /// A method with deprecated optional positional parameter.
  Future<String> methodWithOptionalDeprecatedParam(
    Session session, [
    @deprecated String? deprecatedParam,
  ]) async {
    return deprecatedParam ?? 'default';
  }

  /// A method with deprecated named parameter.
  Future<String> methodWithNamedDeprecatedParam(
    Session session, {
    required String normalParam,
    @deprecated String? deprecatedParam,
  }) async {
    return normalParam + (deprecatedParam ?? '');
  }
}
