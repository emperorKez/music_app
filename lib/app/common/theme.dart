import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: const Color(0xffC624B4),
  scaffoldBackgroundColor: const Color(0xff3B1164),
  primaryTextTheme: const TextTheme(),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(color: Color(0xff3B1164)),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Color(0xffC624B4)))),
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
  primarySwatch: Colors.blue,
);

ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
);
