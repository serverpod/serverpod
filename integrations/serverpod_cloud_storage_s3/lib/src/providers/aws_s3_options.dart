import 'package:serverpod_cloud_storage_s3/serverpod_cloud_storage_s3.dart';

class AwsS3Options implements S3Options {
  final String region;

  AwsS3Options(this.region);

  @override
  String buildClientHost(String region) => 's3.$region.amazonaws.com';

  @override
  String buildPublicHost(String bucket, String region, {String? publicHost}) =>
      publicHost ?? '$bucket.s3.$region.amazonaws.com';

  @override
  String buildUploadEndpoint(String bucket, String region) =>
      'https://$bucket.s3-$region.amazonaws.com';

  @override
  bool useHttps() => true;
}
