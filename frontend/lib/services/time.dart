import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeModel {
  DateTime convertTimestamptoUTCDateTime(int timestamp) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000, // the timestamp is in seconds
      isUtc: true,
    );

    return dt;
  }

  String convertDateTimeToHHmm(DateTime dt) {
    String time = TimeOfDay.fromDateTime(dt).toString();
    time = time.substring('TimeOfDay('.length, time.length - 1);

    return time;
  }

  DateTime convertTimestampToLocalDateTime(int timestamp, int secondsFromUTC) {
    DateTime dt = convertTimestamptoUTCDateTime(timestamp);
    DateTime localdt = dt.add(Duration(seconds: secondsFromUTC));
    return localdt;
  }

  String convertTimestampToLocalFormattedDateTime(
      int timestamp, int secondFromUTC) {
    DateTime dt = convertTimestampToLocalDateTime(timestamp, secondFromUTC);
    return DateFormat('EEEE, HH:mm').format(dt); // e.g. Monday, 13:15
  }

  String convertTimestampToLocalTime(int timestamp, int secondFromUTC) {
    DateTime dt = convertTimestampToLocalDateTime(timestamp, secondFromUTC);
    return convertDateTimeToHHmm(dt);
  }

  String convertTimestampToLocalDayOfWeek(int timestamp, int secondFromUTC) {
    DateTime dt = convertTimestampToLocalDateTime(timestamp, secondFromUTC);
    return DateFormat('EEEE').format(dt);
  }
}
