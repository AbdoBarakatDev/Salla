import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
    bodyText1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
    bodyText2: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
    overline: TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45),
    headline1: TextStyle(
        fontSize: 96, fontWeight: FontWeight.bold, color: Colors.black45),
    headline2: TextStyle(
        fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black45),
    headline3: TextStyle(
        fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black45),
    headline4: TextStyle(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black45),
    headline5: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45),
    headline6: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45),
    caption: TextStyle(fontSize: 12, color: Colors.black45),
    button: TextStyle(fontSize: 14, color: Colors.black45),
  ),
  cardColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white),
);
ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    bodyText1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    bodyText2: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    overline: TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
    headline1: TextStyle(
        fontSize: 96, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(
        fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
    headline3: TextStyle(
        fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
    headline4: TextStyle(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
    headline5: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    headline6: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    caption: TextStyle(fontSize: 12, color: Colors.white),
    button: TextStyle(fontSize: 14, color: Colors.white),
  ),
  cardColor: HexColor("333739"),
  scaffoldBackgroundColor: HexColor("333739"),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor("333739"),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
  ),
  primarySwatch: Colors.deepOrange,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor("333739"),
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: HexColor("333739"),
  ),
);
