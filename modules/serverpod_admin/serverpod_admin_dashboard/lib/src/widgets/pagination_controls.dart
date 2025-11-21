import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.startRecord,
    required this.endRecord,
    required this.totalRecords,
    required this.rowsPerPage,
    required this.rowsPerPageOptions,
    required this.onRowsPerPageChanged,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final int startRecord;
  final int endRecord;
  final int totalRecords;
  final int rowsPerPage;
  final List<int> rowsPerPageOptions;
  final ValueChanged<int?> onRowsPerPageChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface.withOpacity(0.6),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Rows per page',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: rowsPerPage,
            items: rowsPerPageOptions
                .map(
                  (value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  ),
                )
                .toList(),
            onChanged: onRowsPerPageChanged,
          ),
          const Spacer(),
          Text(
            'Showing $startRecord-$endRecord of $totalRecords',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Previous page',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: currentPage == 0 ? null : onPrevious,
          ),
          Text(
            'Page ${currentPage + 1} of $totalPages',
            style: theme.textTheme.bodyMedium,
          ),
          IconButton(
            tooltip: 'Next page',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: currentPage >= totalPages - 1 ? null : onNext,
          ),
        ],
      ),
    );
  }
}
