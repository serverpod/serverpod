import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Validate SecuritySchemaObject Serialization: ', () {
    test(
      'When HttpSecurityScheme\'s scheme is basic ',
      () {
        HttpSecurityScheme httpSecurityScheme = HttpSecurityScheme(
          scheme: 'basic',
        );
        expect(
          {
            'type': 'http',
            'scheme': 'basic',
          },
          httpSecurityScheme.toJson(),
        );
      },
    );

    test(
      'When HttpSecurityScheme\'s scheme is bearer and JWT ',
      () {
        HttpSecurityScheme httpSecurityScheme = HttpSecurityScheme(
          scheme: 'bearer',
          bearerFormat: 'JWT',
        );
        expect(
          {
            'type': 'http',
            'scheme': 'bearer',
            'bearerFormat': 'JWT',
          },
          httpSecurityScheme.toJson(),
        );
      },
    );

    test(
      'When HttpSecurityScheme\'s scheme is bearer and bearerFormat is null throw assertion error ',
      () {
        expect(() {
          HttpSecurityScheme(
            scheme: 'bearer',
          );
        }, throwsA(isA<AssertionError>()));
      },
    );

    test(
      'Validate ApiKeySecurityScheme ',
      () {
        ApiKeySecurityScheme securityScheme = ApiKeySecurityScheme(
          name: 'api_key',
          inField: 'header',
        );
        expect(
          {
            'type': 'apiKey',
            'name': 'api_key',
            'in': 'header',
          },
          securityScheme.toJson(),
        );
      },
    );
    test(
      'When ApiKeySecurityScheme\'s inField data is wrong throw assertion error ',
      () {
        expect(() {
          ApiKeySecurityScheme(
            name: 'api_key',
            inField: 'somewhere',
          );
        }, throwsA(isA<AssertionError>()));
      },
    );

    test(
      'Validate OpenIdSecurityScheme ',
      () {
        OpenIdSecurityScheme securityScheme =
            OpenIdSecurityScheme(openIdConnectUrl: 'https://www.google.com');
        expect(
          {
            'type': 'openIdConnect',
            'openIdConnectUrl': 'https://www.google.com',
          },
          securityScheme.toJson(),
        );
      },
    );

    test(
      'Validate OauthSecurityScheme ',
      () {
        OauthSecurityScheme securityScheme = OauthSecurityScheme(
          flows: OauthFlowObject(),
        );
        expect(
          {
            'type': 'oauth2',
            'flows': {},
          },
          securityScheme.toJson(),
        );
      },
    );
  });
}
