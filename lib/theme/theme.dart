import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    onBackground: Colors.black,
    primary: Color.fromRGBO(206, 147, 216, 1), // сиреневый
    onPrimary: Colors.black,
    secondary: Color.fromRGBO(244, 143, 177, 1), // розовый
    onSecondary: Colors.white,
    tertiary: Color.fromRGBO(255, 204, 128, 1), // оранжевый
    error: Colors.red,
    outline: Color(0xFF424242),
  ),
);
