import 'package:flutter/material.dart';
import 'package:serverpod_job_dashboard/models/job.dart';
import 'package:serverpod_job_dashboard/providers/job_provider.dart';

class JobFilters extends StatefulWidget {
  final JobProvider jobProvider;

  const JobFilters({super.key, required this.jobProvider});

  @override
  State<JobFilters> createState() => _JobFiltersState();
}

class _JobFiltersState extends State<JobFilters> {
  final TextEditingController _searchController = TextEditingController();
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.jobProvider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.jobProvider,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildSearchBar(),
              if (_showAdvancedFilters) ...[
                const SizedBox(height: 16),
                _buildAdvancedFilters(),
              ],
              const SizedBox(height: 8),
              _buildResultsInfo(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs by name, description, tags...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          widget.jobProvider.setSearchQuery('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                      : null,
            ),
            onChanged: widget.jobProvider.setSearchQuery,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            setState(() {
              _showAdvancedFilters = !_showAdvancedFilters;
            });
          },
          icon: Icon(
            _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
          ),
          tooltip: _showAdvancedFilters ? 'Hide filters' : 'Show filters',
        ),
        IconButton(
          onPressed: () {
            widget.jobProvider.clearFilters();
            _searchController.clear();
          },
          icon: const Icon(Icons.clear_all),
          tooltip: 'Clear all filters',
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop/Tablet layout
          return Row(
            children: [
              Expanded(child: _buildStatusFilter()),
              const SizedBox(width: 16),
              Expanded(child: _buildPriorityFilter()),
              const SizedBox(width: 16),
              Expanded(child: _buildSortFilter()),
            ],
          );
        } else {
          // Mobile layout
          return Column(
            children: [
              _buildStatusFilter(),
              const SizedBox(height: 12),
              _buildPriorityFilter(),
              const SizedBox(height: 12),
              _buildSortFilter(),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatusFilter() {
    return DropdownButtonFormField<JobStatus?>(
      decoration: const InputDecoration(
        labelText: 'Status',
        prefixIcon: Icon(Icons.filter_list),
      ),
      value: widget.jobProvider.statusFilter,
      items: [
        const DropdownMenuItem<JobStatus?>(
          value: null,
          child: Text('All Statuses'),
        ),
        ...JobStatus.values.map(
          (status) => DropdownMenuItem<JobStatus?>(
            value: status,
            child: Row(
              children: [
                Icon(status.icon, color: status.color, size: 16),
                const SizedBox(width: 8),
                Text(status.display),
              ],
            ),
          ),
        ),
      ],
      onChanged: widget.jobProvider.setStatusFilter,
    );
  }

  Widget _buildPriorityFilter() {
    return DropdownButtonFormField<JobPriority?>(
      decoration: const InputDecoration(
        labelText: 'Priority',
        prefixIcon: Icon(Icons.priority_high),
      ),
      value: widget.jobProvider.priorityFilter,
      items: [
        const DropdownMenuItem<JobPriority?>(
          value: null,
          child: Text('All Priorities'),
        ),
        ...JobPriority.values.map(
          (priority) => DropdownMenuItem<JobPriority?>(
            value: priority,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(priority.display),
              ],
            ),
          ),
        ),
      ],
      onChanged: widget.jobProvider.setPriorityFilter,
    );
  }

  Widget _buildSortFilter() {
    final sortOptions = [
      {'value': 'createdAt', 'label': 'Created Date', 'icon': Icons.schedule},
      {'value': 'name', 'label': 'Name', 'icon': Icons.sort_by_alpha},
      {'value': 'status', 'label': 'Status', 'icon': Icons.filter_list},
      {'value': 'priority', 'label': 'Priority', 'icon': Icons.priority_high},
      {'value': 'progress', 'label': 'Progress', 'icon': Icons.trending_up},
      {'value': 'duration', 'label': 'Duration', 'icon': Icons.timer},
    ];

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Sort by',
              prefixIcon: Icon(Icons.sort),
            ),
            value: widget.jobProvider.sortBy,
            items:
                sortOptions
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option['value'] as String,
                        child: Row(
                          children: [
                            Icon(option['icon'] as IconData, size: 16),
                            const SizedBox(width: 8),
                            Text(option['label'] as String),
                          ],
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                widget.jobProvider.setSortBy(
                  value,
                  widget.jobProvider.sortAscending,
                );
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            widget.jobProvider.setSortBy(
              widget.jobProvider.sortBy,
              !widget.jobProvider.sortAscending,
            );
          },
          icon: Icon(
            widget.jobProvider.sortAscending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          tooltip:
              widget.jobProvider.sortAscending
                  ? 'Sort descending'
                  : 'Sort ascending',
        ),
      ],
    );
  }

  Widget _buildResultsInfo() {
    final filteredCount = widget.jobProvider.filteredJobs.length;
    final totalCount = widget.jobProvider.totalJobs;
    final hasFilters =
        widget.jobProvider.searchQuery.isNotEmpty ||
        widget.jobProvider.statusFilter != null ||
        widget.jobProvider.priorityFilter != null;

    return Row(
      children: [
        Text(
          '$filteredCount of $totalCount jobs',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (hasFilters) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Filtered',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (hasFilters)
          TextButton.icon(
            onPressed: () {
              widget.jobProvider.clearFilters();
              _searchController.clear();
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
      ],
    );
  }
}
