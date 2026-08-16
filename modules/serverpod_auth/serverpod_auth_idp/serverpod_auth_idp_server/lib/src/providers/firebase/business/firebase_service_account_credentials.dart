import 'dart:convert';
import 'dart:io';

/// Contains information about the Firebase service account credentials.
///
/// The service account JSON file can be downloaded from the Firebase console
/// under Project Settings > Service Accounts > Generate new private key.
///
/// For Firebase ID token verification, only the [projectId] is strictly
/// required to validate the audience claim.
final class FirebaseServiceAccountCredentials {
  /// The Firebase project identifier.
  final String projectId;

  /// The service account client email.
  final String? clientEmail;

  /// Creates a new instance with just the project ID.
  ///
  /// This is useful when only token verification is needed (no admin operations).
  const FirebaseServiceAccountCredentials({
    required this.projectId,
    this.clientEmail,
  });

  /// Creates a new instance of [FirebaseServiceAccountCredentials] from a JSON
  /// map.
  ///
  /// Expects the JSON to match the structure of the file downloaded from
  /// Firebase console.
  ///
  /// Example:
  /// ```json
  /// {
  ///   "type": "service_account",
  ///   "project_id": "your-project-id",
  ///   "private_key_id": "...",
  ///   "private_key": "...",
  ///   "client_email": "firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com",
  ///   "client_id": "...",
  ///   ...
  /// }
  /// ```
  factory FirebaseServiceAccountCredentials.fromJson(
    final Map<String, dynamic> json,
  ) {
    final projectId = json['project_id'] as String?;
    if (projectId == null || projectId.isEmpty) {
      throw const FormatException('Missing or empty "project_id"');
    }

    final clientEmail = json['client_email'] as String?;

    return FirebaseServiceAccountCredentials(
      projectId: projectId,
      clientEmail: clientEmail,
    );
  }

  /// Creates a new instance of [FirebaseServiceAccountCredentials] from a JSON
  /// string.
  ///
  /// The string is expected to follow the format described in
  /// [FirebaseServiceAccountCredentials.fromJson].
  factory FirebaseServiceAccountCredentials.fromJsonString(
    final String jsonString,
  ) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return FirebaseServiceAccountCredentials.fromJson(data);
  }

  /// Creates a new instance of [FirebaseServiceAccountCredentials] from a JSON
  /// file.
  ///
  /// The file is expected to follow the format described in
  /// [FirebaseServiceAccountCredentials.fromJson].
  factory FirebaseServiceAccountCredentials.fromJsonFile(final File file) {
    final jsonString = file.readAsStringSync();
    return FirebaseServiceAccountCredentials.fromJsonString(jsonString);
  }
}
