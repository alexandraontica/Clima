import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';
import 'utilities/constants.dart';

void main() => runApp(const ClimaApp());

class ClimaApp extends StatelessWidget {
  const ClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: kBackgroundColor,
          height: 55,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Color(0xff5384ed),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
              size: 30.0,
            ),
          ),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}
