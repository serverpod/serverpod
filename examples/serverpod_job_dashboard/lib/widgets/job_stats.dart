import 'package:flutter/material.dart';
import 'package:serverpod_job_dashboard/models/job.dart';
import 'package:serverpod_job_dashboard/providers/job_provider.dart';

class JobStats extends StatelessWidget {
  final JobProvider jobProvider;

  const JobStats({super.key, required this.jobProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: jobProvider,
      builder: (context, child) {
        final statusCounts = jobProvider.statusCounts;
        final priorityCounts = jobProvider.priorityCounts;
        final totalJobs = jobProvider.totalJobs;

        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStatusCards(context, statusCounts, totalJobs),
              const SizedBox(height: 20),
              _buildPriorityChart(context, priorityCounts, totalJobs),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.analytics,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Job Statistics',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${jobProvider.totalJobs} Total',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCards(
    BuildContext context,
    Map<JobStatus, int> statusCounts,
    int totalJobs,
  ) {
    final cards = [
      _buildStatCard(
        context,
        'Active',
        jobProvider.activeJobs.toString(),
        Icons.play_circle,
        Colors.blue,
        'Running & Retrying',
      ),
      _buildStatCard(
        context,
        'Completed',
        jobProvider.completedJobs.toString(),
        Icons.check_circle,
        Colors.green,
        'Successfully finished',
      ),
      _buildStatCard(
        context,
        'Failed',
        jobProvider.failedJobs.toString(),
        Icons.error,
        Colors.red,
        'Encountered errors',
      ),
      _buildStatCard(
        context,
        'Pending',
        jobProvider.pendingJobs.toString(),
        Icons.schedule,
        Colors.orange,
        'Waiting to start',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Desktop layout - 4 cards in a row
          return Row(
            children:
                cards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index > 0 ? 8 : 0,
                        right: index < cards.length - 1 ? 8 : 0,
                      ),
                      child: card,
                    ),
                  );
                }).toList(),
          );
        } else if (constraints.maxWidth > 600) {
          // Tablet layout - 2x2 grid
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: cards[0],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: cards[1],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: cards[2],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: cards[3],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Mobile layout - stacked
          return Column(
            children:
                cards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < cards.length - 1 ? 16 : 0,
                    ),
                    child: card,
                  );
                }).toList(),
          );
        }
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChart(
    BuildContext context,
    Map<JobPriority, int> priorityCounts,
    int totalJobs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Distribution',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children:
                JobPriority.values.map((priority) {
                  final count = priorityCounts[priority] ?? 0;
                  final percentage = totalJobs > 0 ? count / totalJobs : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    priority.display,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '$count jobs',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: priority.color.withValues(
                                  alpha: 0.1,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  priority.color,
                                ),
                                minHeight: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
