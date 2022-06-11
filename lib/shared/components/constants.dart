import 'package:flutter/material.dart';


final Color baseIconsColor = Colors.white;
final Color mainBackgroundColor = Colors.teal.shade900;
final Color mainIconsColor = Colors.deepOrange.shade300;

final Color cardItemColor = Colors.teal.shade600.withOpacity(0.9);
final Color baseTextItemColor = Colors.grey.shade200;
final Color floatingBtnColor = Colors.grey.shade400;
final Color calcBtnColor = Colors.red.shade300;

final double mainCategoryItemWidth=120;
final double mainCategoryItemHeight=120;

final double mainCartItemWidth=150;
final double mainCartItemHeight=150;

const String language = "en";
String token = "";

// void logout(BuildContext context) {
//   CashHelper.clearData(key: "token").then((value) {
//     print("when Logout : ${value.toString()}");
//     print("Logout Token : ${CashHelper.getData(key: "token")}");
//     doReplacementWidgetNavigation(context, ShopLoginScreen());
//   });
// }




// Api Ex..
// baseURL= "https://newsapi.org/";
// method="v2/top-headlines";
// queries={
// "country":"eg",
// "category":"business",
// "apiKey":"9e94d2799d4a48fe872d43f70f48a274",
// }
// "country=us&category=business&apiKey=9e94d2799d4a48fe872d43f70f48a274";
String allURL1 =
    "https://newsapi.org/ v2/top-headlines? country=eg & apiKey=9e94d2799d4a48fe872d43f70f48a274";
String allURL2 =
    "https://newsapi.org/ v2/top-headlines? country=eg & category=business &apiKey=9e94d2799d4a48fe872d43f70f48a274";
String allURL3 =
    "https://newsapi.org/ v2/top-headlines? country=eg & category=science &apiKey=9e94d2799d4a48fe872d43f70f48a274";
String allURL4 =
    "https://newsapi.org/ v2/top-headlines? country=eg & category=sports &apiKey=9e94d2799d4a48fe872d43f70f48a274";
String mainURL =
    "https://newsapi.org/v2/everything?q=tesla&from=2022-03-01&sortBy=publishedAt&apiKey=9e94d2799d4a48fe872d43f70f48a274";


// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5