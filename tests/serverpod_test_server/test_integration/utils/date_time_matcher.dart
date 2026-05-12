import 'package:test/test.dart';

Matcher matchesDate(
  Object? year, [
  Object? month = anyMonth,
  Object? day = anyDay,
  Object? hour = anyHour,
  Object? minute = anyMinute,
  Object? second = anySecond,
]) {
  return _DateTimeMatcher(
    year: wrapMatcher(year),
    month: wrapMatcher(month),
    day: wrapMatcher(day),
    hour: wrapMatcher(hour),
    minute: wrapMatcher(minute),
    second: wrapMatcher(second),
  );
}

class _DateTimeMatcher extends Matcher {
  _DateTimeMatcher({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  final Matcher year;
  final Matcher month;
  final Matcher day;
  final Matcher hour;
  final Matcher minute;
  final Matcher second;

  @override
  bool matches(Object? item, Map matchState) {
    if (item is! DateTime) return false;

    return year.matches(item.year, {}) &&
        month.matches(item.month, {}) &&
        day.matches(item.day, {}) &&
        hour.matches(item.hour, {}) &&
        minute.matches(item.minute, {}) &&
        second.matches(item.second, {});
  }

  @override
  Description describe(Description description) {
    description.add('DateTime matching ');

    _addField(description, 'year', year);
    _addField(description, 'month', month);
    _addField(description, 'day', day);
    _addField(description, 'hour', hour);
    _addField(description, 'minutes', minute);
    _addField(description, 'seconds', second);

    return description;
  }

  void _addField(
    Description description,
    String label,
    Matcher matcher,
  ) {
    if (description.toString() != 'DateTime matching ') {
      description.add(', ');
    }

    description.add('$label: ');
    matcher.describe(description);
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! DateTime) {
      return mismatchDescription.add('is not a DateTime');
    }

    return mismatchDescription.add(
      'was ${item.toIso8601String()}',
    );
  }
}

const Matcher anyMonth = _RangeMatcher(1, 12, 'any month');
const Matcher anyDay = _RangeMatcher(1, 31, 'any day');
const Matcher anyHour = _RangeMatcher(0, 23, 'any hour');
const Matcher anyMinute = _RangeMatcher(0, 59, 'any minute');
const Matcher anySecond = _RangeMatcher(0, 59, 'any second');

class _RangeMatcher extends Matcher {
  const _RangeMatcher(this.min, this.max, this.description);

  final int min;
  final int max;
  final String description;

  @override
  bool matches(Object? item, Map matchState) =>
      item is int && item >= min && item <= max;

  @override
  Description describe(Description description) =>
      description.add(this.description);
}
