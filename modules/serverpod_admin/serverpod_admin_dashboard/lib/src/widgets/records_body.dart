import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/controller/pagination.dart';
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
  State<RecordsBody> createState() => _RecordsBodyState();
}

class _RecordsBodyState extends State<RecordsBody> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  late final PaginationController _paginationController = PaginationController(
    rowsPerPage: 10,
    rowsPerPageOptions: const [5, 10, 25, 50],
  );

  @override
  void initState() {
    super.initState();
    _paginationController.setTotalRecords(widget.records.length);
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _paginationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RecordsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.records.length != oldWidget.records.length) {
      _paginationController.setTotalRecords(widget.records.length);
    }
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
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _paginationController,
      builder: (context, _) {
        final pagedRecords = _paginationController.getPageItems(widget.records);

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
                          (states) =>
                              theme.colorScheme.secondary.withOpacity(0.08),
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
                                          constraints: const BoxConstraints(
                                              minWidth: 160),
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
                                            icon:
                                                const Icon(Icons.edit_outlined),
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
                                                : () =>
                                                    widget.onDelete!(record),
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
              currentPage: _paginationController.currentPage,
              totalPages: _paginationController.totalPages,
              startRecord: _paginationController.startRecord,
              endRecord: _paginationController.endRecord,
              totalRecords: _paginationController.totalRecords,
              rowsPerPage: _paginationController.rowsPerPage,
              rowsPerPageOptions: _paginationController.rowsPerPageOptions,
              onRowsPerPageChanged: (value) {
                _paginationController.setRowsPerPage(value ?? 10);
              },
              onPrevious: _paginationController.goToPreviousPage,
              onNext: _paginationController.goToNextPage,
            ),
          ],
        );
      },
    );
  }
}
