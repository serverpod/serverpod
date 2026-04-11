const bool isWeb = bool.fromEnvironment('dart.library.js_interop');
void main() {
  print(isWeb);
}
