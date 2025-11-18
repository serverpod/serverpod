import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_admin_client/serverpod_admin_client.dart';
import 'package:serverpod_admin_dashboard/src/helpers/validate_value.dart';

class Field extends StatelessWidget {
  const Field({
    required this.column,
    required this.controller,
    required this.readOnly,
  });

  final AdminColumn column;
  final TextEditingController controller;
  final bool readOnly;

  Future<String?> _pickDateTime(
    BuildContext context,
    String currentValue,
  ) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(currentValue)?.toLocal() ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    final dateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime?.hour ?? initial.hour,
      pickedTime?.minute ?? initial.minute,
    );
    return dateTime.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataType = column.dataType;
    final normalizedType = dataType.toLowerCase().replaceAll('?', '');
    final typeToken = normalizedType.split('.').last;
    final isDateType = typeToken.contains('date') || typeToken.contains('time');
    final requiresValue = !column.hasDefault;

    TextInputType? keyboardType;
    List<TextInputFormatter>? inputFormatters;
    VoidCallback? onTap;
    Widget? suffixIcon;

    switch (typeToken) {
      case 'int':
      case 'integer':
      case 'bigint':
      case 'smallint':
        keyboardType = TextInputType.number;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 'double':
      case 'decimal':
      case 'float':
      case 'numeric':
        keyboardType =
            const TextInputType.numberWithOptions(signed: true, decimal: true);
        break;
      case 'bool':
      case 'boolean':
        keyboardType = TextInputType.text;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    if (isDateType) {
      onTap = () async {
        final picked = await _pickDateTime(context, controller.text);
        if (picked != null) {
          controller.text = picked;
        }
      };
      suffixIcon = const Icon(Icons.calendar_today_outlined);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly || isDateType,
          onTap: readOnly ? null : onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: '${readOnly ? 'Locked' : 'Enter'} ${column.name}',
            helperText: 'Type: ${column.dataType}',
            suffixIcon: suffixIcon,
          ),
          validator: readOnly
              ? null
              : (raw) =>
                  validateValue(raw, requiresValue, typeToken, isDateType),
        ),
      ],
    );
  }
}
