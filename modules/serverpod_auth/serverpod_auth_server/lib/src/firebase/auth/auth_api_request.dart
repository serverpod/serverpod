import 'dart:convert';

import '../auth.dart';
import '../app/app_extension.dart';
import '../utils/api_request.dart';
import '../utils/error.dart';

import '../app.dart';
import '../utils/validator.dart' as validator;
import 'identitytoolkit.dart';

/// Firebase AuthRequestHandler
class AuthRequestHandler {
  ///
  final IdentityToolkitApi identityToolkitApi;

  /// Firebase Project App Id
  final String projectId;

  /// Creates a Singletone [AuthRequestHandler]
  static AuthRequestHandler Function(App app) factory =
      (app) => AuthRequestHandler._(app);

  /// creates [AuthRequestHandler] with the given [App]
  factory AuthRequestHandler(App app) => factory(app);

  AuthRequestHandler._(App app)
      : projectId = app.projectId,
        identityToolkitApi = IdentityToolkitApi(AuthorizedHttpClient(app));

  /// Maximum allowed number of users to batch download at one time.
  static const maxDownloadAccountPageSize = 1000;

  /// Looks up a user by uid.
  Future<UserRecord> getAccountInfoByUid(String uid) async {
    if (!validator.isUid(uid)) {
      throw FirebaseAuthError.invalidUid();
    }
    return _getAccountInfo(localId: [uid]);
  }

  Future<UserRecord> _getAccountInfo({List<String>? localId}) async {
    var response = await identityToolkitApi.projects.accounts_1.lookup(
      GoogleCloudIdentitytoolkitV1GetAccountInfoRequest()..localId = localId,
      projectId,
    );

    if (response.users == null || response.users!.isEmpty) {
      throw FirebaseAuthError.userNotFound();
    }

    return UserRecord.fromJson(json.decode(json.encode(response.users!.first)));
  }
}
