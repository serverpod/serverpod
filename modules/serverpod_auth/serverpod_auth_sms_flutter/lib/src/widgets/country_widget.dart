import 'package:flutter/material.dart';
import '../res/country_data.dart';
import '../res/country_model.dart';
import '../res/country_name.dart';
import '../res/get_country.dart';

class CountryWidget extends StatefulWidget {
  final CountryName defaultCountry;
  final void Function(CountryModel country)? onCountryChanged;

  const CountryWidget(
      {Key? key, required this.defaultCountry, this.onCountryChanged})
      : super(key: key);

  @override
  State<CountryWidget> createState() => _CountryWidgetState();
}

class _CountryWidgetState extends State<CountryWidget> {
  List<CountryModel> countryCodesList = countryData;
  late CountryModel selectedCountry;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    // Initialize 'selectedCountry' with the default country code (India) in the initState method.
    selectedCountry = getCountryDisplayName(widget.defaultCountry);
    // widget.onCountryChanged?.call(selectedCountry);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPicker();
      },
      child: Text(
        '+${selectedCountry.e164Cc}',
      ),
    );
  }

  /// Show country picker dialog
  showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search bar
              TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search for a country',
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      countryCodesList = countryData;
                    });
                  } else {
                    setState(() {
                      countryCodesList = filterSearchResults(value);
                    });
                  }
                  // Call setState to rebuild the AnimatedList
                  _listKey.currentState!.setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  initialItemCount: countryCodesList.length,
                  itemBuilder: (context, index, animation) {
                    return buildCountryListItem(
                      context,
                      index,
                      animation,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCountryListItem(
      BuildContext context, int index, Animation<double> animation) {
    // Check if the index is within the bounds of the list
    if (index >= 0 && index < countryCodesList.length) {
      return SizeTransition(
        sizeFactor: animation,
        child: ListTile(
          onTap: () {
            setState(() {
              selectedCountry = countryCodesList[index];
              widget.onCountryChanged?.call(selectedCountry);
            });
            Navigator.pop(context);
          },
          title: Text(countryCodesList[index].name),
          leading: Text('+${countryCodesList[index].e164Cc}'),
          titleAlignment: ListTileTitleAlignment.center,
        ),
      );
    } else {
      // Handle the case where the index is out of bounds
      return Container(); // Placeholder or empty widget
    }
  }

  List<CountryModel> filterSearchResults(String value) {
    return countryData.where((country) {
      return country.name.toLowerCase().contains(value.toLowerCase()) ||
          country.e164Cc.contains(value);
    }).toList();
  }
}
