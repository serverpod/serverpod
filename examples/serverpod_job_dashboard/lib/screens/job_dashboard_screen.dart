import 'package:flutter/material.dart';
import 'package:serverpod_job_dashboard/models/job.dart';
import 'package:serverpod_job_dashboard/providers/job_provider.dart';
import 'package:serverpod_job_dashboard/widgets/job_card.dart';
import 'package:serverpod_job_dashboard/widgets/job_filters.dart';
import 'package:serverpod_job_dashboard/widgets/job_stats.dart';
import 'package:serverpod_job_dashboard/widgets/job_details_dialog.dart';

class JobDashboardScreen extends StatefulWidget {
  const JobDashboardScreen({super.key});

  @override
  State<JobDashboardScreen> createState() => _JobDashboardScreenState();
}

class _JobDashboardScreenState extends State<JobDashboardScreen> {
  late JobProvider _jobProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _jobProvider = JobProvider();
    _jobProvider.loadJobs();
  }

  @override
  void dispose() {
    _jobProvider.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListenableBuilder(
        listenable: _jobProvider,
        builder: (context, child) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(),
              if (_jobProvider.isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(child: JobStats(jobProvider: _jobProvider)),
                SliverToBoxAdapter(
                  child: JobFilters(jobProvider: _jobProvider),
                ),
                _buildJobsList(),
              ],
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Job Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _jobProvider.loadJobs(),
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
        IconButton(
          onPressed: () => _jobProvider.toggleAutoRefresh(),
          icon: Icon(
            _jobProvider.isAutoRefresh ? Icons.pause : Icons.play_arrow,
          ),
          tooltip:
              _jobProvider.isAutoRefresh
                  ? 'Pause Auto-refresh'
                  : 'Start Auto-refresh',
        ),
        IconButton(
          onPressed: () => _showSettingsDialog(),
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildJobsList() {
    if (_jobProvider.filteredJobs.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final job = _jobProvider.filteredJobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: JobCard(
              job: job,
              onTap: () => _showJobDetails(job),
              onRetry: () => _jobProvider.retryJob(job.id),
              onPause: () => _jobProvider.pauseJob(job.id),
              onResume: () => _jobProvider.resumeJob(job.id),
              onCancel: () => _jobProvider.cancelJob(job.id),
              onReschedule: () => _showRescheduleDialog(job),
            ),
          );
        }, childCount: _jobProvider.filteredJobs.length),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No jobs found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or add a new job',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddJobDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add New Job'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddJobDialog(),
      icon: const Icon(Icons.add),
      label: const Text('New Job'),
      elevation: 4,
    );
  }

  void _showJobDetails(Job job) {
    showDialog(
      context: context,
      builder: (context) => JobDetailsDialog(job: job),
    );
  }

  void _showAddJobDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Job'),
            content: const Text(
              'Job creation functionality will be implemented in the next version.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showRescheduleDialog(Job job) {
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reschedule Job'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Reschedule "${job.name}" to:'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      if (time != null && context.mounted) {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      }
                    }
                  },
                  child: Text(_formatDateTime(selectedDate)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _jobProvider.rescheduleJob(job.id, selectedDate);
                  Navigator.of(context).pop();
                  _showSnackBar(
                    'Job "${job.name}" rescheduled to ${_formatDateTime(selectedDate)}',
                  );
                },
                child: const Text('Reschedule'),
              ),
            ],
          ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Auto-refresh'),
                  subtitle: const Text('Automatically update job status'),
                  value: _jobProvider.isAutoRefresh,
                  onChanged: (value) {
                    _jobProvider.toggleAutoRefresh();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Clear All Filters'),
                  leading: const Icon(Icons.clear_all),
                  onTap: () {
                    _jobProvider.clearFilters();
                    Navigator.of(context).pop();
                    _showSnackBar('All filters cleared');
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month $day, ${dateTime.year} $hour:$minute';
  }
}
