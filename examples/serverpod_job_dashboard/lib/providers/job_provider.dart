import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:serverpod_job_dashboard/models/job.dart';

class JobProvider extends ChangeNotifier {
  List<Job> _jobs = [];
  bool _isLoading = false;
  String _searchQuery = '';
  JobStatus? _statusFilter;
  JobPriority? _priorityFilter;
  String _sortBy = 'createdAt';
  bool _sortAscending = false;
  Timer? _simulationTimer;
  bool _isAutoRefresh = true;

  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  JobStatus? get statusFilter => _statusFilter;
  JobPriority? get priorityFilter => _priorityFilter;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  bool get isAutoRefresh => _isAutoRefresh;

  List<Job> get filteredJobs {
    List<Job> filtered = _jobs;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    job.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    job.tags.any(
                      (tag) => tag.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    ) ||
                    (job.assignedTo?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
    }

    // Apply status filter
    if (_statusFilter != null) {
      filtered = filtered.where((job) => job.status == _statusFilter).toList();
    }

    // Apply priority filter
    if (_priorityFilter != null) {
      filtered =
          filtered.where((job) => job.priority == _priorityFilter).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'status':
          comparison = a.status.index.compareTo(b.status.index);
          break;
        case 'priority':
          comparison = a.priority.level.compareTo(b.priority.level);
          break;
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'progress':
          comparison = a.progress.compareTo(b.progress);
          break;
        case 'duration':
          comparison = a.duration.compareTo(b.duration);
          break;
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  Map<JobStatus, int> get statusCounts {
    Map<JobStatus, int> counts = {};
    for (JobStatus status in JobStatus.values) {
      counts[status] = _jobs.where((job) => job.status == status).length;
    }
    return counts;
  }

  Map<JobPriority, int> get priorityCounts {
    Map<JobPriority, int> counts = {};
    for (JobPriority priority in JobPriority.values) {
      counts[priority] = _jobs.where((job) => job.priority == priority).length;
    }
    return counts;
  }

  int get totalJobs => _jobs.length;
  int get activeJobs => _jobs.where((job) => job.isActive).length;
  int get completedJobs => _jobs.where((job) => job.isCompleted).length;
  int get failedJobs => _jobs.where((job) => job.hasError).length;
  int get pendingJobs => _jobs.where((job) => job.isWaiting).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(JobStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(JobPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void setSortBy(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    notifyListeners();
  }

  void toggleAutoRefresh() {
    _isAutoRefresh = !_isAutoRefresh;
    if (_isAutoRefresh) {
      _startSimulation();
    } else {
      _stopSimulation();
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    _jobs = _generateSampleJobs();
    _isLoading = false;
    notifyListeners();

    if (_isAutoRefresh) {
      _startSimulation();
    }
  }

  Future<void> retryJob(String jobId) async {
    final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final job = _jobs[jobIndex];
      if (job.canRetry) {
        _jobs[jobIndex] = job.copyWith(
          status: JobStatus.retrying,
          retryCount: job.retryCount + 1,
          errorMessage: null,
        );
        notifyListeners();

        // Simulate retry process
        await Future.delayed(const Duration(seconds: 2));

        // Randomly succeed or fail
        final success = DateTime.now().millisecondsSinceEpoch % 3 != 0;
        _jobs[jobIndex] = _jobs[jobIndex].copyWith(
          status: success ? JobStatus.running : JobStatus.failed,
          errorMessage: success ? null : 'Retry attempt failed',
          startedAt: success ? DateTime.now() : null,
        );
        notifyListeners();
      }
    }
  }

  Future<void> pauseJob(String jobId) async {
    final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final job = _jobs[jobIndex];
      if (job.canPause) {
        _jobs[jobIndex] = job.copyWith(status: JobStatus.paused);
        notifyListeners();
      }
    }
  }

  Future<void> resumeJob(String jobId) async {
    final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final job = _jobs[jobIndex];
      if (job.canResume) {
        _jobs[jobIndex] = job.copyWith(status: JobStatus.running);
        notifyListeners();
      }
    }
  }

  Future<void> cancelJob(String jobId) async {
    final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final job = _jobs[jobIndex];
      if (job.canCancel) {
        _jobs[jobIndex] = job.copyWith(status: JobStatus.cancelled);
        notifyListeners();
      }
    }
  }

  Future<void> rescheduleJob(String jobId, DateTime newTime) async {
    final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final job = _jobs[jobIndex];
      if (job.canReschedule) {
        _jobs[jobIndex] = job.copyWith(
          status: JobStatus.pending,
          nextRunAt: newTime,
          errorMessage: null,
        );
        notifyListeners();
      }
    }
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_jobs.isEmpty || !_isAutoRefresh) return;

      // Update running jobs progress
      for (int i = 0; i < _jobs.length; i++) {
        final job = _jobs[i];
        if (job.status == JobStatus.running) {
          double newProgress =
              job.progress + (DateTime.now().millisecondsSinceEpoch % 15) / 100;
          if (newProgress >= 1.0) {
            _jobs[i] = job.copyWith(
              status: JobStatus.completed,
              progress: 1.0,
              completedAt: DateTime.now(),
            );
          } else {
            _jobs[i] = job.copyWith(progress: newProgress);
          }
        } else if (job.status == JobStatus.retrying) {
          // Simulate retry completion
          final success = DateTime.now().millisecondsSinceEpoch % 3 != 0;
          _jobs[i] = job.copyWith(
            status: success ? JobStatus.running : JobStatus.failed,
            errorMessage: success ? null : 'Retry failed',
            startedAt: success ? DateTime.now() : null,
          );
        }
      }
      notifyListeners();
    });
  }

  void _stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  @override
  void dispose() {
    _stopSimulation();
    super.dispose();
  }

  List<Job> _generateSampleJobs() {
    final now = DateTime.now();
    final jobs = <Job>[];

    // Generate various types of jobs
    for (int i = 1; i <= 25; i++) {
      final status =
          JobStatus.values[DateTime.now().millisecondsSinceEpoch %
              JobStatus.values.length];
      final priority =
          JobPriority.values[DateTime.now().millisecondsSinceEpoch %
              JobPriority.values.length];
      final createdAt = now.subtract(Duration(hours: i * 2));
      final estimatedDuration = Duration(
        minutes: 30 + (DateTime.now().millisecondsSinceEpoch % 90),
      );

      Job job = Job(
        id: 'job_$i',
        name: _getJobName(i),
        description: _getJobDescription(i),
        status: status,
        priority: priority,
        createdAt: createdAt,
        startedAt:
            status != JobStatus.pending
                ? createdAt.add(const Duration(minutes: 5))
                : null,
        completedAt:
            status == JobStatus.completed
                ? createdAt.add(const Duration(hours: 1))
                : null,
        retryCount:
            status == JobStatus.failed
                ? (DateTime.now().millisecondsSinceEpoch % 3)
                : 0,
        progress:
            status == JobStatus.running
                ? (DateTime.now().millisecondsSinceEpoch % 100) / 100
                : status == JobStatus.completed
                ? 1.0
                : 0.0,
        errorMessage: status == JobStatus.failed ? _getErrorMessage(i) : null,
        tags: _getJobTags(i),
        assignedTo: _getAssignedTo(i),
        estimatedDuration: estimatedDuration,
        metadata: _getJobMetadata(i),
      );

      jobs.add(job);
    }

    return jobs;
  }

  String _getJobName(int index) {
    final names = [
      'Data Processing Pipeline',
      'Email Campaign',
      'Backup Operation',
      'Report Generation',
      'Image Processing',
      'Database Migration',
      'API Integration',
      'File Synchronization',
      'Log Analysis',
      'Cache Refresh',
      'User Import',
      'Payment Processing',
      'Notification Service',
      'Data Export',
      'System Maintenance',
      'Security Scan',
      'Performance Test',
      'Content Update',
      'Analytics Calculation',
      'Cleanup Task',
      'Index Rebuild',
      'Configuration Sync',
      'Health Check',
      'Resource Optimization',
      'Audit Trail',
    ];
    return names[index % names.length];
  }

  String _getJobDescription(int index) {
    final descriptions = [
      'Process large datasets for analytics and reporting',
      'Send marketing emails to customer segments',
      'Create backup of critical system data',
      'Generate monthly performance reports',
      'Resize and optimize product images',
      'Migrate data to new database schema',
      'Integrate with third-party API services',
      'Synchronize files across multiple servers',
      'Analyze system logs for errors and patterns',
      'Refresh application cache for better performance',
      'Import user data from external sources',
      'Process payment transactions securely',
      'Send notifications to users',
      'Export data for external systems',
      'Perform routine system maintenance tasks',
      'Scan system for security vulnerabilities',
      'Run performance tests on critical components',
      'Update content across the platform',
      'Calculate analytics metrics and KPIs',
      'Clean up temporary files and old data',
      'Rebuild database indexes for optimization',
      'Synchronize configuration across services',
      'Perform system health checks',
      'Optimize resource usage and allocation',
      'Generate audit trail for compliance',
    ];
    return descriptions[index % descriptions.length];
  }

  String _getErrorMessage(int index) {
    final errors = [
      'Network timeout occurred during operation',
      'Database connection failed',
      'Insufficient disk space for operation',
      'Authentication token expired',
      'External service unavailable',
      'Memory limit exceeded',
      'File permission denied',
      'Invalid data format received',
      'Rate limit exceeded by external API',
      'Configuration file not found',
    ];
    return errors[index % errors.length];
  }

  List<String> _getJobTags(int index) {
    final allTags = [
      'data',
      'email',
      'backup',
      'report',
      'image',
      'database',
      'api',
      'sync',
      'log',
      'cache',
      'import',
      'payment',
      'notification',
      'export',
      'maintenance',
      'security',
      'performance',
      'content',
      'analytics',
      'cleanup',
    ];
    final numTags = 2 + (index % 4);
    final tags = <String>[];
    for (int i = 0; i < numTags; i++) {
      tags.add(allTags[(index + i) % allTags.length]);
    }
    return tags;
  }

  String? _getAssignedTo(int index) {
    final users = [
      'john.doe',
      'jane.smith',
      'mike.johnson',
      'sarah.wilson',
      'alex.brown',
      null,
    ];
    return users[index % users.length];
  }

  Map<String, dynamic> _getJobMetadata(int index) {
    return {
      'type': 'automated',
      'category': 'background',
      'estimatedDuration': '30-60 minutes',
      'retryPolicy': 'exponential_backoff',
      'timeout': '3600',
      'priority': 'normal',
      'environment': 'production',
    };
  }
}
