## 3.4.3

- feat: Adds Tencent Cloud Object Storage (COS) integration.
  - Server-side CRUD: `storeFile`, `retrieveFile`, `fileExists`, `deleteFile`,
    `getPublicUrl`.
  - Direct client upload via presigned PUT: `createDirectFileUploadDescription`,
    `createDirectFileUploadDescriptionWithOptions`.
  - Verification via `verifyDirectFileUpload` (delegates to `fileExists`).
  - `CloudStorageWithOptions` support: `storeFileWithOptions` and
    `createDirectFileUploadDescriptionWithOptions` with `preventOverwrite`
    (`x-cos-forbid-overwrite`) and `contentLength` validation.
  - COS-native HMAC-SHA1 signatures (no S3-compatible layer dependency).
  - Custom domain (`publicHost`) support for public read URLs.
