import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class AdditionalInfoCard extends StatelessWidget {
  const AdditionalInfoCard({
    super.key,
    required this.label,
    required this.info,
    required this.icon,
    required this.margins,
  });

  final String label;
  final String info;
  final IconData icon;
  final EdgeInsets margins;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: margins,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: kLabelAdditionlInfoTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                info,
                style: kAdditionalWeatherInfoTextStyle,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Icon(
                icon,
                size: 30.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
