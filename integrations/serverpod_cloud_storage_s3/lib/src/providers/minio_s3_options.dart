import 'package:serverpod_cloud_storage_s3/serverpod_cloud_storage_s3.dart';

class MinioS3Options implements S3Options {
  final String endpointUrl;
  final String hostOverride;
  final bool https;

  MinioS3Options({
    required this.endpointUrl,
    required this.hostOverride,
    this.https = false,
  });

  @override
  String buildClientHost(String region) => hostOverride;

  @override
  String buildPublicHost(String bucket, String region, {String? publicHost}) =>
      publicHost ?? hostOverride;

  @override
  String buildUploadEndpoint(String bucket, String region) =>
      '${endpointUrl.endsWith('/') ? endpointUrl : '$endpointUrl/'}$bucket';

  @override
  bool useHttps() => https;
}
