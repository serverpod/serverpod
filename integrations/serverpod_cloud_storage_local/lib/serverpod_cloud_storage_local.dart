/// Local filesystem cloud storage integration for Serverpod.
///
/// This package provides [LocalCloudStorage] for storing files directly on
/// the server's filesystem, without external cloud providers or database
/// tables. This is useful for development, testing, and self-hosted
/// deployments.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:serverpod_cloud_storage_local/serverpod_cloud_storage_local.dart';
///
/// pod.addCloudStorage(LocalCloudStorage(
///   'public',
///   storagePath: '/var/serverpod/storage',
/// ));
/// ```
///
/// When registered with the storage id 'public', stored files are served
/// through the server's built-in `/serverpod_cloud_storage` endpoint.
///
/// ## Expiration
///
/// Files stored with an expiration time are hidden from retrieval once they
/// expire, but stay on disk until removed. Call
/// [LocalCloudStorage.startCleanupScheduler] to periodically delete expired
/// files, or trigger [LocalCloudStorage.cleanupExpiredFiles] manually. When
/// shutting the server down, call [LocalCloudStorage.stopCleanupScheduler].
///
/// ## Limitations
///
/// Direct file uploads from clients are not supported, since they require
/// database backed upload tracking. Store uploaded data through an endpoint
/// with `session.storage.storeFile` instead.
library;

export 'src/cloud_storage/local_cloud_storage.dart';
