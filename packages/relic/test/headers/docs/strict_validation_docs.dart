/// ## Strict Header Validation
///
/// This code will throw an exception when the header is empty and the strict flag is set to true.
/// In many servers, an empty header is considered as null, which can lead to unexpected behavior.
/// By enforcing strict validation, we ensure that any empty headers are caught and handled appropriately,
/// preventing potential issues in the server's request handling process.
class StrictValidationDocs {
  const StrictValidationDocs();
}
