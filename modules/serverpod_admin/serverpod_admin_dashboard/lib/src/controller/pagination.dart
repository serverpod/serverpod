import 'package:flutter/foundation.dart';

/// Controller for managing pagination state without setState.
class PaginationController extends ChangeNotifier {
  PaginationController({
    int rowsPerPage = 10,
    this.rowsPerPageOptions = const [5, 10, 25, 50],
  }) : _rowsPerPage = rowsPerPage;

  int _currentPage = 0;
  int _rowsPerPage;
  final List<int> rowsPerPageOptions;
  int _totalRecords = 0;

  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  int get totalRecords => _totalRecords;

  int get totalPages =>
      _totalRecords == 0 ? 1 : (_totalRecords / _rowsPerPage).ceil();

  int get startRecord =>
      _totalRecords == 0 ? 0 : _currentPage * _rowsPerPage + 1;

  int get endRecord {
    if (_totalRecords == 0) return 0;
    final end = _currentPage * _rowsPerPage + _rowsPerPage;
    return end > _totalRecords ? _totalRecords : end;
  }

  void setTotalRecords(int total) {
    if (_totalRecords != total) {
      _totalRecords = total;
      _clampCurrentPage();
      notifyListeners();
    }
  }

  void setRowsPerPage(int value) {
    if (value != _rowsPerPage && rowsPerPageOptions.contains(value)) {
      _rowsPerPage = value;
      _currentPage = 0;
      notifyListeners();
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToNextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    final clamped = page.clamp(0, totalPages - 1);
    if (clamped != _currentPage) {
      _currentPage = clamped;
      notifyListeners();
    }
  }

  void reset() {
    _currentPage = 0;
    notifyListeners();
  }

  void _clampCurrentPage() {
    final maxPage = totalPages > 0 ? totalPages - 1 : 0;
    if (_currentPage > maxPage) {
      _currentPage = maxPage;
    }
  }

  List<T> getPageItems<T>(List<T> items) {
    if (items.isEmpty) return items;
    final start = _currentPage * _rowsPerPage;
    if (start >= items.length) return [];
    final end = (start + _rowsPerPage).clamp(0, items.length);
    return items.sublist(start, end);
  }
}
