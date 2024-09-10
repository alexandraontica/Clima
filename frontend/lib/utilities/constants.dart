import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xff04041e);
const kBlueColor = Color(0xff5384ed);
const kCardColor = Color(0xff11112b);

const kCityTextStyle = TextStyle(
  fontSize: 23.0,
  fontWeight: FontWeight.bold,
);

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kNightMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kDayMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
  color: Color(0xff5470b7),
);

const kNightTempDetailsTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 15.0,
);

const kDayTempDetailsTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 15.0,
  color: Color(0xff5470b7),
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  color: Color(0xe0ffffff),
  fontFamily: 'Spartan MB',
);

const kTitleTextStyle = TextStyle(
  fontSize: 35.0,
  color: Color(0xe0ffffff),
  fontFamily: 'Spartan MB',
  backgroundColor: kBackgroundColor,
);

const kParagraphTextStyle = TextStyle(
  fontSize: 16.0,
  color: Color(0xc0ffffff),
);

const kConditionTextStyle = TextStyle(
  fontSize: 110.0,
);

const kAdditionalWeatherInfoTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kLabelAdditionlInfoTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  color: Color(0xb0ffffff),
  fontSize: 17.0,
);

const kAIGeneratedTextStyle = TextStyle(
  color: Color(0xb0ffffff),
);

const kHourTextStyle = TextStyle(
  color: Color(0xb0ffffff),
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kHourlyTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 35.0,
);

const kHourlyAppTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 18.0,
);

const kForecastTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 25.0,
);

const kIconButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(
    Colors.transparent,
  ),
  foregroundColor: WidgetStatePropertyAll(
    Color(0xffffffff),
  ),
);

const kTextButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(
    kBlueColor,
  ),
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0x1affffff),
  icon: Icon(
    Icons.location_city,
    color: Color(0xffffffff),
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Color(0x2affffff),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
);
