abstract class S3Options {
  String buildClientHost(String region);
  String buildPublicHost(String bucket, String region, {String? publicHost});
  String buildUploadEndpoint(String bucket, String region);
  bool useHttps();
}
