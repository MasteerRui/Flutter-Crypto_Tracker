import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme
          ? const Color(0xFF121212)
          : Color.fromARGB(255, 236, 236, 236),
      backgroundColor:
          isDarkTheme ? const Color(0xFF242323) : const Color(0xFCffffff),
      textTheme: TextTheme(
          headline1: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 21.5,
              fontFamily: 'Kangmas'),
          headline2: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 18.5,
              fontWeight: FontWeight.w700),
          headline3: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          )),
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
