import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a HttpSecurityScheme\'s with basic scheme when converting to json then the type is set to http and scheme is basic.',
    () {
      HttpSecurityScheme httpSecurityScheme = HttpSecurityScheme(
        scheme: HttpSecuritySchemeType.basic,
      );
      expect(
        httpSecurityScheme.toJson(),
        {
          'type': 'http',
          'scheme': 'basic',
        },
      );
    },
  );

  test(
    'Given a HttpSecurityScheme\'s with bearer scheme and JWT  when converting to json then the type is set to http and the bearerFormat is JWT.',
    () {
      HttpSecurityScheme httpSecurityScheme = HttpSecurityScheme(
        scheme: HttpSecuritySchemeType.bearer,
        bearerFormat: 'JWT',
      );
      expect(
        httpSecurityScheme.toJson(),
        {
          'type': 'http',
          'scheme': HttpSecuritySchemeType.bearer.name,
          'bearerFormat': 'JWT',
        },
      );
    },
  );

  test(
    'Given a HttpSecurityScheme\'s with bearer scheme and null bearerFormat when converting to json then assertion error is throw. ',
    () {
      expect(() {
        HttpSecurityScheme(
          scheme: HttpSecuritySchemeType.bearer,
        );
      }, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'Given an ApiKeySecurityScheme when converting to json then got excepted output.',
    () {
      ApiKeySecurityScheme securityScheme = ApiKeySecurityScheme(
        name: 'api_key',
        inField: ApiKeyLocation.header,
      );
      expect(
        securityScheme.toJson(),
        {
          'type': 'apiKey',
          'name': 'api_key',
          'in': 'header',
        },
      );
    },
  );
  test(
    'Given an OpenIdSecurityScheme when converting to json then got excepted output.',
    () {
      OpenIdSecurityScheme securityScheme =
          OpenIdSecurityScheme(openIdConnectUrl: 'https://www.google.com');
      expect(
        securityScheme.toJson(),
        {
          'type': 'openIdConnect',
          'openIdConnectUrl': 'https://www.google.com',
        },
      );
    },
  );

  test(
    'Given an OauthSecurityScheme when converting to json then got excepted output.',
    () {
      OauthSecurityScheme securityScheme = OauthSecurityScheme(
        flows: {},
      );
      expect(
        securityScheme.toJson(),
        {
          'type': 'oauth2',
          'flows': {},
        },
      );
    },
  );
}
