import 'package:flutter/foundation.dart';

/// Controller for managing record dialog state without setState.
class RecordDialogStateController extends ChangeNotifier {
  bool _isSubmitting = false;
  String? _submitError;

  bool get isSubmitting => _isSubmitting;
  String? get submitError => _submitError;

  void setSubmitting(bool value) {
    if (_isSubmitting != value) {
      _isSubmitting = value;
      notifyListeners();
    }
  }

  void setError(String? error) {
    if (_submitError != error) {
      _submitError = error;
      notifyListeners();
    }
  }

  void startSubmission() {
    _isSubmitting = true;
    _submitError = null;
    notifyListeners();
  }

  void stopSubmission({String? error}) {
    _isSubmitting = false;
    _submitError = error;
    notifyListeners();
  }

  void clearError() {
    if (_submitError != null) {
      _submitError = null;
      notifyListeners();
    }
  }
}
