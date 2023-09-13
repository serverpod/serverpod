import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'country_widget.dart';
import '../res/country_model.dart';
import '../res/country_name.dart';

//ignore: must_be_immutable
class PhoneNumberWidget extends StatefulWidget {
  final void Function(CountryModel country)? onCountryChanged;
  CountryName defaultCountry;

  TextEditingController phoneNumberController;
  String? phoneNumberIssue;
  PhoneNumberWidget({
    required this.onCountryChanged,
    required this.defaultCountry,
    required this.phoneNumberController,
    this.phoneNumberIssue,
    Key? key,
  }) : super(key: key);

  @override
  _PhoneNumberWidgetState createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      keyboardType: TextInputType.phone,
      controller: widget.phoneNumberController,
      decoration: InputDecoration(
        prefix: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CountryWidget(
            defaultCountry: widget.defaultCountry,
            onCountryChanged: (country) {
              setState(() {
                widget.onCountryChanged?.call(country);
              });
            },
          ),
        ),
        labelText: 'Phone number',
        errorText: widget.phoneNumberIssue,
      ),
      onChanged: (_) {
        setState(() {
          widget.phoneNumberIssue = null;
        });
      },
    );
  }
}
