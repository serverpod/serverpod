/*
 * This file is cloned from the original cron library and licensed under the BSD
 * 3-Clause License. Source: https://github.com/agilord/cron
 *
 * The scope of the below license ("Software") is limited to this file
 * which is a derivative work of the original library. The license does
 * not apply to any other part of the codebase.
 * 
 * Copyright (c) 2016, Agilord.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'package:collection/collection.dart';

/// Represents a cron schedule.
class Cron {
  /// The seconds of this cron schedule.
  final List<int>? seconds;

  /// The minutes of this cron schedule.
  final List<int>? minutes;

  /// The hours of this cron schedule.
  final List<int>? hours;

  /// The days of this cron schedule.
  final List<int>? days;

  /// The months of this cron schedule.
  final List<int>? months;

  /// The weekdays of this cron schedule.
  final List<int>? weekdays;

  Cron._(
    this.seconds,
    this.minutes,
    this.hours,
    this.days,
    this.months,
    this.weekdays,
  );

  static String _currentCronExpression = '';

  /// Parses the [cronExpression].
  factory Cron.parse(String cronExpression) {
    _currentCronExpression = cronExpression.trim();

    List<String?> fields = cronExpression
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (fields.length < 5 || fields.length > 6) {
      throw CronFormatException(
        'Invalid cron expression: $cronExpression. Only 5-field and 6-field formats are supported.',
        _currentCronExpression,
      );
    }

    fields = [
      if (fields.length == 5) null,
      ...fields,
    ];

    final seconds = fields[0];
    final minutes = fields[1];
    final hours = fields[2];
    final days = fields[3];
    final months = fields[4];
    final weekdays = fields[5];

    List<int> offsets = List.generate(fields.length, (i) {
      if (i == 0) return seconds == null ? 0 : 1;
      final sublist = fields.sublist(0, i).whereType<String>();
      return sublist.length * 2 + 1;
    });

    final parsedSeconds = _parseFieldWithConstraint(seconds, offsets[0], 0, 59);
    final parsedMinutes = _parseFieldWithConstraint(minutes, offsets[1], 0, 59);
    final parsedHours = _parseFieldWithConstraint(hours, offsets[2], 0, 23);
    final parsedDays = _parseFieldWithConstraint(days, offsets[3], 1, 31);
    final parsedMonths = _parseFieldWithConstraint(months, offsets[4], 1, 12);
    final parsedWeekdays = _parseWeekdayField(weekdays, offsets[5]);

    return Cron._(
      parsedSeconds,
      parsedMinutes,
      parsedHours,
      parsedDays,
      parsedMonths,
      parsedWeekdays,
    );
  }

  static List<int>? _parseWeekdayField(String? field, int offset) {
    final parsed = _parseFieldWithConstraint(field, offset, 0, 7);
    return parsed?.map((x) => x == 0 ? 7 : x).toSet().toList();
  }

  static List<int>? _parseFieldWithConstraint(
    String? field,
    int offset,
    int min,
    int max,
  ) {
    return _parseField(
      field,
      offset,
    )?.where((x) => x >= min && x <= max).toList();
  }

  static List<int>? _parseField(dynamic constraint, [int offset = 0]) {
    if (constraint == null) return null;
    if (constraint is int) return [constraint];
    if (constraint is List<int>) return constraint;
    if (constraint is String) {
      if (constraint == '*') return List.generate(60, (i) => i);
      if (constraint == '') return null;
      final parts = constraint.split(',');
      if (parts.length > 1) {
        return _parseFieldValues(parts, offset);
      }

      final singleValue = int.tryParse(constraint);
      if (singleValue != null) return [singleValue];

      return _parseIntervalField(constraint, offset);
    }

    throw CronFormatException(
      'Unable to parse field',
      _currentCronExpression,
      offset,
    );
  }

  static List<int> _parseFieldValues(List<String> parts, [int offset = 0]) {
    final items = parts
        .mapIndexed((i, p) => _parseField(p, offset + i + 1))
        .expand((list) => list!)
        .toSet()
        .toList();
    items.sort();
    return items;
  }

  static List<int>? _parseIntervalField(String field, [int offset = 0]) {
    var intervalPart = '';
    if (field.contains('/')) {
      final parts = field.split('/');
      if (parts.length > 2) {
        throw CronFormatException(
          'More than one `/` for an interval',
          _currentCronExpression,
          offset + parts.length - 1,
        );
      }

      field = parts[0].trim();
      intervalPart = parts[1].trim();
    }

    final interval = intervalPart.isEmpty ? 1 : int.tryParse(intervalPart);
    if (interval == null) {
      throw CronFormatException(
        'Invalid interval value: $intervalPart',
        _currentCronExpression,
        offset + 1,
      );
    }
    if (interval < 1) {
      throw CronFormatException(
        'Invalid interval value: $intervalPart',
        _currentCronExpression,
        offset + 1,
      );
    }

    if (field == '*') {
      return List.generate(120 ~/ interval, (i) => i * interval);
    } else if (field.contains('-')) {
      return _parseIntervalRange(field, interval, offset);
    }

    throw CronFormatException(
      'Invalid field value: $field',
      _currentCronExpression,
      offset,
    );
  }

  static List<int>? _parseIntervalRange(
    String field,
    int interval, [
    int offset = 0,
  ]) {
    final ranges = field.split('-');
    if (ranges.length == 2) {
      final lower = int.tryParse(ranges.first) ?? -1;
      final higher = int.tryParse(ranges.last) ?? -1;
      if (lower <= higher) {
        return List.generate(
          (higher - lower + 1) ~/ interval,
          (i) => i * interval + lower,
        );
      }
    }
    throw CronFormatException(
      'Invalid range: $field',
      _currentCronExpression,
      offset + ranges.length - 1,
    );
  }

  bool get _hasSeconds =>
      seconds != null &&
      seconds!.isNotEmpty &&
      (seconds!.length != 1 || !seconds!.contains(0));

  /// Returns the next run time.
  DateTime nextTime() {
    var currentDate = DateTime.now().toUtc();

    currentDate = _hasSeconds
        ? currentDate.add(const Duration(seconds: 1))
        : currentDate.add(const Duration(minutes: 1));

    while (true) {
      if (months?.contains(currentDate.month) == false) {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
          1,
        );
        continue;
      }
      if (weekdays?.contains(currentDate.weekday) == false) {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 1,
        );
        continue;
      }
      if (days?.contains(currentDate.day) == false) {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 1,
        );
        continue;
      }
      if (hours?.contains(currentDate.hour) == false) {
        currentDate = currentDate.add(const Duration(hours: 1));
        currentDate = currentDate.subtract(
          Duration(minutes: currentDate.minute),
        );
        continue;
      }
      if (minutes?.contains(currentDate.minute) == false) {
        currentDate = currentDate.add(const Duration(minutes: 1));
        continue;
      }
      if (_hasSeconds && seconds?.contains(currentDate.second) == false) {
        currentDate = currentDate.add(const Duration(seconds: 1));
        continue;
      }
      return currentDate;
    }
  }
}

/// Exception thrown when a cron data does not have an expected
/// format and cannot be parsed or processed.
class CronFormatException extends FormatException {
  /// Creates a new `CronFormatException` with an optional error [message].
  CronFormatException([
    super.message,
    super.source,
    super.offset,
  ]);
}
