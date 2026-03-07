---
name: serverpod-file-uploads
description: File uploads in Serverpod — upload descriptions, verification, storage backends (database, S3, GCP). Use when implementing file uploads or cloud storage.
---

# Serverpod File Uploads

Flow: server issues upload description → client uploads → server verifies. Default storage is the database; use S3 or GCP for production.

## Server: create upload description

```dart
Future<String?> getUploadDescription(Session session, String path) async {
  return await session.storage.createDirectFileUploadDescription(
    storageId: 'public',
    path: path,
  );
}
```

Restrict paths in production (derive from user/session).

## Server: verify upload

```dart
Future<bool> verifyUpload(Session session, String path) async {
  return await session.storage.verifyDirectFileUpload(
    storageId: 'public', path: path);
}
```

Always verify after client upload when using S3 or GCP.

## Client: upload

```dart
var desc = await client.myEndpoint.getUploadDescription('profile/$userId/avatar.png');
if (desc != null) {
  var uploader = FileUploader(desc);
  await uploader.upload(byteDataOrStream);
  await client.myEndpoint.verifyUpload('profile/$userId/avatar.png');
}
```

Use `Stream` for large files. Paths: no leading slash, S3/GCP compatible.

## Accessing stored files

- `session.storage.fileExists(storageId: 'public', path: path)`
- `session.storage.getPublicUrl(storageId: 'public', path: path)` (public storage only)
- `session.storage.retrieveFile(storageId: 'public', path: path)`

## Storage backends

- **Database (default):** `public` and `private` storages. Fine for dev.
- **Google Cloud Storage:** Add `serverpod_cloud_storage_gcp`, set HMAC keys in `passwords.yaml` or env. Register: `pod.addCloudStorage(GoogleCloudStorage(...))`.
- **AWS S3:** Add `serverpod_cloud_storage_s3`, set AWS keys. Register: `pod.addCloudStorage(S3CloudStorage(...))`.

Use `storageId: 'public'` or `'private'` when replacing defaults.
