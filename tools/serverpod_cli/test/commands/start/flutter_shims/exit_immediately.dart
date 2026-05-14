// Test shim for [FlutterProcess]: exits immediately with code 0, never
// publishing an `app.debugPort` event. Used to exercise the "Flutter
// exits before VM service URI is published" path.
void main() {}
