import 'dart:convert';

import 'package:firebaseapis/identitytoolkit/v1.dart';
import 'package:firebaseapis/identitytoolkit/v1.dart' as id;

import 'package:http/http.dart' as http;
import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;

import '../utils/error.dart';

export 'package:firebaseapis/identitytoolkit/v1.dart';

class _MyApiRequester extends commons.ApiRequester {
  static const _firebaseAuthTimeout = Duration(milliseconds: 25000);

  final Duration timeoutDuration = _firebaseAuthTimeout;

  _MyApiRequester(http.Client httpClient, String rootUrl, String basePath)
      : super(httpClient, rootUrl, basePath, {});

  @override
  Future request(
    String requestUrl,
    String method, {
    String? body,
    Map<String, List<String>>? queryParams,
    commons.Media? uploadMedia,
    commons.UploadOptions? uploadOptions,
    commons.DownloadOptions? downloadOptions = commons.DownloadOptions.metadata,
  }) async {
    queryParams ??= {};
    try {
      var fields = queryParams.remove('fields') ?? [];

      return await super
          .request(requestUrl, method,
              body: body,
              queryParams: {
                ...queryParams,
                if (fields.isNotEmpty)
                  ...Uri.splitQueryString(fields.first)
                      .map((k, v) => MapEntry(k, [v])),
              },
              uploadMedia: uploadMedia,
              uploadOptions: uploadOptions,
              downloadOptions: downloadOptions)
          .timeout(timeoutDuration,
              onTimeout: () => throw FirebaseAppError.networkTimeout(
                  'Error while making request: $requestUrl.'));
    } on commons.DetailedApiRequestError catch (e) {
      var errorCode = e.message;
      if (errorCode != null) {
        // Get detailed message if available.
        var match = RegExp(r'^([^\s]+)\s*:\s*(.*)$').firstMatch(errorCode);
        throw FirebaseAuthError.fromServerError(
          match?.group(1) ?? errorCode,
          match?.group(2),
          e,
        );
      }
      throw FirebaseAuthError.internalError(json.encode(e.jsonResponse), e);
    }
  }
}

/// Implements Google Identity Toolkit API lets you use open standards to verify a
/// user's identity.
class IdentityToolkitApi implements id.IdentityToolkitApi {
  final commons.ApiRequester _requester;

  @override
  AccountsResource get accounts => AccountsResource(_requester);
  @override
  ProjectsResource get projects => ProjectsResource(_requester);
  @override
  V1Resource get v1 => V1Resource(_requester);

  /// Creates a new [IdentityToolkitApi] with the given [Client] and configs
  IdentityToolkitApi(http.Client client,
      {String rootUrl = 'https://identitytoolkit.googleapis.com/',
      String servicePath = ''})
      : _requester = _MyApiRequester(client, rootUrl, servicePath);
}
