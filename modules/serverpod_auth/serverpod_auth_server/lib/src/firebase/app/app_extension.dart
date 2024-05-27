import 'dart:io';

import 'package:serverpod_auth_server/src/firebase/auth/credential.dart';

import '../firebase_admin.dart';

/// Exposes Firebase App [projectId] variable
extension GetProjectIdExtension on App {
  /// Firebase app project id
  String get projectId => _getProjectId(this);
}

String _getProjectId(App app) {
  var options = app.options;
  if (options.projectId != null && options.projectId!.isNotEmpty) {
    return options.projectId!;
  }

  var cert = _tryGetCertificate(options.credential);
  if (cert != null && cert.projectId != null && cert.projectId!.isNotEmpty) {
    return cert.projectId!;
  }

  var projectId = Platform.environment['GOOGLE_CLOUD_PROJECT'] ??
      Platform.environment['GCLOUD_PROJECT'];
  if (projectId != null && projectId.isNotEmpty) {
    return projectId;
  }

  throw FirebaseAuthError.invalidCredential(
    'Must initialize app with a cert credential or set your Firebase project ID as the '
    'GOOGLE_CLOUD_PROJECT environment variable.',
  );
}

Certificate? _tryGetCertificate(Credential credential) {
  if (credential is FirebaseCredential) {
    return credential.certificate;
  }
  return null;
}
