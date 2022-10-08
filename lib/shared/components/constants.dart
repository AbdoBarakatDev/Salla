import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/shared/styles/colors.dart';

final Color baseIconsColor = Colors.white;
final Color mainBackgroundColor = Colors.teal.shade900;
final Color mainIconsColor = Colors.deepOrange.shade300;

final Color cardItemColor = Colors.teal.shade600.withOpacity(0.9);
final Color baseTextItemColor = Colors.grey.shade200;
final Color floatingBtnColor = Colors.grey.shade400;
final Color calcBtnColor = Colors.red.shade300;
final Color prefixIconsColor = Colors.grey;

// for fonts
TextStyle hintTextStyle =
    GoogleFonts.andika(textStyle: TextStyle(color: Colors.grey));
TextStyle buttonTextStyle = GoogleFonts.anaheim(
    textStyle: TextStyle(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold));
TextStyle errorTextStyle =
    GoogleFonts.alegreya(textStyle: TextStyle(color: Colors.red));
TextStyle labelTextStyle =
    GoogleFonts.alice(textStyle: TextStyle(color: Colors.grey));
TextStyle authCaptionRegisterLoginTextStyle =
    GoogleFonts.alice(textStyle: TextStyle(color: defaultAppColor));

final double mainCategoryItemWidth = 120;
final double mainCategoryItemHeight = 120;

final double mainCartItemWidth = 150;
final double mainCartItemHeight = 150;

String loadingIconLite = "assets/images/loading_icon_lite.gif";
String loadingIconDark = "assets/images/loading_icon_dark.gif";
String loadingErrorImage = "assets/images/error_handle.png";

const String language = "en";
String token = "";
