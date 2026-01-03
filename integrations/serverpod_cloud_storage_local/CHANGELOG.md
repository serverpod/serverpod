## 3.1.1

- Initial release of the local filesystem cloud storage adapter.
- Supports storing files on the local filesystem.
- Supports public and private storage configurations.
- Upload files through endpoints using storeFile() (direct uploads not supported).
- Includes path sanitization to prevent directory traversal attacks.
- Streaming support for memory-efficient large file handling.
- Automatic expiration cleanup scheduler.
