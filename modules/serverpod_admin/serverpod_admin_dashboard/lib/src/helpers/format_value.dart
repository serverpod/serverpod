import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';

String formatRecordValue(AdminColumn column, String? value) {
  if (value == null || value.isEmpty) return '';
  final dataType = column.dataType.toLowerCase();
  if (dataType.contains('date') || dataType.contains('time')) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toLocal().toString();
    }
  }
  return value;
}
