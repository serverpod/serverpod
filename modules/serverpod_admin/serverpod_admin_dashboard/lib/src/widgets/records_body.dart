import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/helpers/format_value.dart';
import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/widgets/pagination_controls.dart';

class RecordsBody extends StatefulWidget {
  const RecordsBody({
    required this.resource,
    required this.records,
    required this.isLoading,
    required this.errorMessage,
    required this.onEdit,
    required this.onDelete,
  });

  final AdminResource resource;
  final List<Map<String, String>> records;
  final bool isLoading;
  final String? errorMessage;
  final void Function(Map<String, String> record)? onEdit;
  final void Function(Map<String, String> record)? onDelete;

  @override
  State<RecordsBody> createState() => RecordsBodyState();
}

class RecordsBodyState extends State<RecordsBody> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  static const List<int> _rowsPerPageOptions = [5, 10, 25, 50];
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RecordsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.records.length != oldWidget.records.length) {
      final clamped = _clampPageIndex(_currentPage);
      if (clamped != _currentPage) {
        setState(() {
          _currentPage = clamped;
        });
      }
    }
  }

  int _clampPageIndex(int page) {
    final maxPage = math.max(0, _totalPages - 1);
    return page.clamp(0, maxPage);
  }

  int get _totalPages =>
      math.max(1, (widget.records.length / _rowsPerPage).ceil());

  List<Map<String, String>> _pageRecords() {
    final start = _currentPage * _rowsPerPage;
    if (start >= widget.records.length) return const [];
    final endExclusive = math.min(
      start + _rowsPerPage,
      widget.records.length,
    );
    return widget.records.sublist(start, endExclusive);
  }

  void _goToPreviousPage() {
    if (_currentPage == 0) return;
    setState(() {
      _currentPage = _currentPage - 1;
    });
  }

  void _goToNextPage() {
    if (_currentPage >= _totalPages - 1) return;
    setState(() {
      _currentPage = _currentPage + 1;
    });
  }

  void _updateRowsPerPage(int? value) {
    if (value == null || value == _rowsPerPage) return;
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.errorMessage != null) {
      return Center(
        child: Text(
          widget.errorMessage!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (widget.records.isEmpty) {
      return Center(
        child: Text(
          'No records found for ${widget.resource.tableName}.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final columns = widget.resource.columns;
    final pagedRecords = _pageRecords();
    final theme = Theme.of(context);
    final startRecord =
        widget.records.isEmpty ? 0 : _currentPage * _rowsPerPage + 1;
    final endRecord = widget.records.isEmpty
        ? 0
        : math.min(
            _currentPage * _rowsPerPage + pagedRecords.length,
            widget.records.length,
          );
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _verticalController,
            thumbVisibility: true,
            radius: const Radius.circular(12),
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              primary: false,
              child: SingleChildScrollView(
                controller: _verticalController,
                primary: false,
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingTextStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => theme.colorScheme.secondary.withOpacity(0.08),
                    ),
                    dataTextStyle: theme.textTheme.bodyMedium,
                    dividerThickness: 0.6,
                  ),
                  child: DataTable(
                    columnSpacing: 36,
                    horizontalMargin: 20,
                    columns: columns
                        .map(
                          (column) => DataColumn(
                            label: Row(
                              children: [
                                const Icon(Icons.view_column_outlined,
                                    size: 16),
                                const SizedBox(width: 8),
                                Text(column.name),
                              ],
                            ),
                          ),
                        )
                        .toList()
                      ..add(
                        const DataColumn(
                          label: Text('Actions'),
                        ),
                      ),
                    rows: pagedRecords
                        .map(
                          (record) => DataRow(
                            cells: columns
                                .map(
                                  (column) => DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(minWidth: 160),
                                      child: Text(
                                        formatRecordValue(
                                          column,
                                          record[column.name],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                              ..add(
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit record',
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: widget.onEdit == null
                                            ? null
                                            : () => widget.onEdit!(record),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete record',
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: theme.colorScheme.error,
                                        ),
                                        onPressed: widget.onDelete == null
                                            ? null
                                            : () => widget.onDelete!(record),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        PaginationControls(
          currentPage: _currentPage,
          totalPages: _totalPages,
          startRecord: startRecord,
          endRecord: endRecord,
          totalRecords: widget.records.length,
          rowsPerPage: _rowsPerPage,
          rowsPerPageOptions: _rowsPerPageOptions,
          onRowsPerPageChanged: _updateRowsPerPage,
          onPrevious: _goToPreviousPage,
          onNext: _goToNextPage,
        ),
      ],
    );
  }
}
