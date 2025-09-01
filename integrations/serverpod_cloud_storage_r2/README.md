# Serverpod Cloud Storage R2

This package provides Cloudflare R2 cloud storage integration for Serverpod applications.

## Features

- **File Operations**: Upload, download, delete files in Cloudflare R2
- **Direct Upload Support**: PUT (presigned URL) method optimized for R2
- **Public/Private Files**: Support for both public and private file access
- **S3 Compatibility**: Uses S3-compatible API for seamless integration

## Setup

### 1. Add dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  serverpod_cloud_storage_r2: ^3.0.0-alpha.1
```

### 2. Configure R2 credentials

Set your Cloudflare R2 credentials as environment variables:

```bash
SERVERPOD_R2_ACCESS_KEY_ID=your_r2_access_key
SERVERPOD_R2_SECRET_KEY=your_r2_secret_key
```

### 3. Initialize storage

```dart
import 'package:serverpod_cloud_storage_r2/serverpod_cloud_storage_r2.dart';

// In your server configuration
final r2Storage = R2CloudStorage(
  serverpod: serverpod,
  storageId: 'public',
  public: true,
  region: 'auto', // R2 uses 'auto' region
  bucket: 'my-r2-bucket',
  accountId: 'your-cloudflare-account-id',
);

// Register the storage
serverpod.storage.register(r2Storage);
```

## Usage

### Basic file operations

```dart
// Store a file
await serverpod.storage.storeFile(
  session: session,
  storageId: 'public',
  path: 'uploads/image.jpg',
  byteData: imageData,
);

// Retrieve a file
final fileData = await serverpod.storage.retrieveFile(
  session: session,
  storageId: 'public', 
  path: 'uploads/image.jpg',
);

// Get public URL
final url = await serverpod.storage.getPublicUrl(
  session: session,
  storageId: 'public',
  path: 'uploads/image.jpg',
);

// Delete a file
await serverpod.storage.deleteFile(
  session: session,
  storageId: 'public',
  path: 'uploads/image.jpg',
);
```

### Direct upload (client-side)

R2 uses PUT presigned URLs for direct uploads:

#### Standard Direct Upload

```dart
// Get upload description (returns PUT presigned URL)
final uploadDescription = await serverpod.storage.createDirectFileUploadDescription(
  session: session,
  storageId: 'public',
  path: 'uploads/client-file.jpg',
);
// This returns a JSON with url, method: "PUT", etc.
```

#### Direct Presigned URL (Alternative)

```dart
// Cast to R2CloudStorage to access R2-specific methods
final r2Storage = serverpod.storage.get('public') as R2CloudStorage;

// Get presigned PUT URL directly
final uploadUrl = await r2Storage.createDirectFileUploadUrl(
  session: session,
  path: 'uploads/client-file.jpg',
  contentType: 'image/jpeg',
);
```

## Configuration Options

- `accountId`: Your Cloudflare account ID (required)
- `bucket`: R2 bucket name (required)
- `region`: Region (defaults to 'auto' for R2)
- `public`: Whether files should be publicly accessible
- `publicHost`: Custom public hostname (defaults to `bucket.account-id.r2.dev`)

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SERVERPOD_R2_ACCESS_KEY_ID` | R2 access key ID | Yes |
| `SERVERPOD_R2_SECRET_KEY` | R2 secret access key | Yes |

## Differences from S3

- **Endpoint**: Uses Cloudflare R2 endpoints (`account-id.r2.cloudflarestorage.com`)
- **Region**: Uses 'auto' instead of specific AWS regions
- **Upload Method**: Uses PUT requests instead of POST multipart (R2 doesn't support POST multipart)
- **PUT Upload**: Includes additional `createDirectFileUploadUrl()` method for presigned PUT URLs
- **Public URLs**: Uses R2 public hostname format (`bucket.account-id.r2.dev`)

## Development

This package is built on top of the S3-compatible API and reuses much of the AWS SDK functionality for signing requests.