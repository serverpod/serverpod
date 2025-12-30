/// Local filesystem cloud storage adapter for Serverpod.
///
/// This package provides a [LocalCloudStorage] implementation that stores
/// files on the local filesystem instead of using cloud storage providers
/// like Amazon S3 or Google Cloud Storage.
///
/// This is useful for:
/// - Development and testing
/// - Self-hosted deployments
/// - Scenarios where you don't want external dependencies
///
/// Example usage:
/// ```dart
/// import 'package:serverpod_cloud_storage_local/serverpod_cloud_storage_local.dart';
///
/// // In your server.dart
/// pod.addCloudStorage(
///   LocalCloudStorage(
///     serverpod: pod,
///     storageId: 'public',
///     storagePath: '/var/serverpod/uploads/public',
///     public: true,
///   ),
/// );
///
/// pod.addCloudStorage(
///   LocalCloudStorage(
///     serverpod: pod,
///     storageId: 'private',
///     storagePath: '/var/serverpod/uploads/private',
///     public: false,
///   ),
/// );
/// ```
library;

export 'src/cloud_storage/local_cloud_storage.dart';
