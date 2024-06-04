import 'package:googleapis/identitytoolkit/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:http/http.dart' as http;

/// Authorized http requests agains google identity toolkit api
class AuthRequestApi {
  final String _projectId;
  final ServiceAccountCredentials _credentials;
  final http.Client? _httpClient;
  IdentityToolkitApi? _identityToolkitApi;

  /// Creates a new [AuthRequestApi] object with a [projectId] and [AuthClient]
  AuthRequestApi({
    required String projectId,
    required ServiceAccountCredentials credentials,
    http.Client? httClient,
  })  : _projectId = projectId,
        _credentials = credentials,
        _httpClient = httClient;

  /// Get UserRecord by user [uiid/localId]
  Future<GoogleCloudIdentitytoolkitV1UserInfo> getUserByUiid(
    String uiid,
  ) async {
    var identityToolKitApi = await _getIdentityToolkitApi();
    var response = await identityToolKitApi.projects.accounts_1.lookup(
      GoogleCloudIdentitytoolkitV1GetAccountInfoRequest(
        localId: [uiid],
      ),
      _projectId,
    );

    var users = response.users;
    if (users == null || users.isEmpty) {
      throw FirebaseInvalidUIIDException(
        'There is no user record corresponding to the provided identifier.',
      );
    }

    return users.first;
  }

  Future<IdentityToolkitApi> _getIdentityToolkitApi() async {
    var identityToolKitApi = _identityToolkitApi;
    if (identityToolKitApi != null) return identityToolKitApi;

    var client = await clientViaServiceAccount(
      _credentials,
      [
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/identitytoolkit',
        'https://www.googleapis.com/auth/userinfo.email',
      ],
      baseClient: _httpClient,
    );

    identityToolKitApi = IdentityToolkitApi(client);
    _identityToolkitApi = identityToolKitApi;

    return identityToolKitApi;
  }
}
