![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod Local Cloud Storage

A local filesystem storage adapter for Serverpod that allows you to store files directly on your server without requiring external cloud storage services like Amazon S3 or Google Cloud Storage.

## Features

- Store files on the local filesystem
- No external dependencies or cloud provider accounts required
- Support for public and private storage
- Ideal for development, testing, and self-hosted deployments

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  serverpod_cloud_storage_local: ^3.1.1
```

## Usage

In your `server.dart`, register the local cloud storage:

```dart
import 'package:serverpod_cloud_storage_local/serverpod_cloud_storage_local.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Add public storage
  pod.addCloudStorage(
    LocalCloudStorage(
      serverpod: pod,
      storageId: 'public',
      storagePath: '/var/serverpod/uploads/public',
      public: true,
    ),
  );

  // Add private storage
  pod.addCloudStorage(
    LocalCloudStorage(
      serverpod: pod,
      storageId: 'private',
      storagePath: '/var/serverpod/uploads/private',
      public: false,
    ),
  );

  await pod.start();
}
```

## Configuration Options

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `serverpod` | `Serverpod` | Yes | The Serverpod instance |
| `storageId` | `String` | Yes | Identifier for this storage (e.g., 'public', 'private') |
| `storagePath` | `String` | Yes | Base directory path for file storage |
| `public` | `bool` | Yes | Whether files are publicly accessible |
| `publicHost` | `String?` | No | Custom host for public URLs |
| `publicPort` | `int?` | No | Custom port for public URLs |
| `publicScheme` | `String?` | No | Custom scheme for public URLs (http/https) |

## Limitations

**Direct file uploads are not supported.** The `createDirectFileUploadDescription` method returns `null`. This means clients cannot POST files directly to a URL.

Instead, use `storeFile()` to upload files through your endpoints:

```dart
// In your endpoint
Future<void> uploadFile(Session session, String fileName, ByteData data) async {
  await session.storage.storeFile(
    storageId: 'public',
    path: 'uploads/$fileName',
    byteData: data,
  );
}
```

If you need direct upload support (where clients POST files directly to a URL), use the built-in `DatabaseCloudStorage` instead.

## Security Considerations

- Ensure the storage directory has appropriate permissions
- The adapter sanitizes file paths to prevent directory traversal attacks
- For production deployments, consider placing the storage directory outside the web root
- Use private storage for sensitive files that should not be publicly accessible

## What is Serverpod?

Serverpod is an open-source, scalable app server, written in Dart for the Flutter community. Check it out!

[Serverpod.dev](https://serverpod.dev)
