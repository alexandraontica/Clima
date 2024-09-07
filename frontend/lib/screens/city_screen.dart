import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key, required this.onCityChange});

  final Function(String) onCityChange;

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  late String cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 60.0,
              ),
              const Text(
                "Choose a city or region",
                style: kTitleTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Text(
                  'Find a city or region you want to know the detailed weather information about.',
                  style: kParagraphTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  style: const TextStyle(
                    color: Color(0xf0ffffff),
                  ),
                  decoration: kTextFieldInputDecoration,
                  onChanged: (value) {
                    cityName = value;
                  },
                ),
              ),
              FilledButton(
                style: kTextButtonStyle,
                onPressed: () {
                  widget.onCityChange(cityName);
                },
                child: const Text(
                  'Search',
                  style: kButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
