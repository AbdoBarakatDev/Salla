import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/functional_cubit.dart';
import 'package:shop_app/shared/helper_cubit/app_cubit.dart';

Widget defaultButton({
  Color buttonColor = Colors.cyanAccent,
  double height = 30,
  double width = double.infinity,
  @required String text,
  @required Function function,
  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  double radius = 0,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: buttonColor,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );

Widget defaultTextFormField({
  bool enabled = true,
  Function onTab,
  BuildContext context,
  Function onChange,
  Function onSubmited,
  @required String hintText,
  String labelText,
  IconData prefixIcon,
  Widget prefix,
  Widget suffixIcon,
  Color textColor,
  Color hintColor,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  TextStyle textHintStyle,
  TextStyle textLabelStyle,
  TextStyle textStyle,
  TextStyle textErrorStyle,
  TextEditingController controller,
  Function validatorFunction,
  double borderRadius = 0,
  Color borderColor = Colors.grey,
  double borderSize = 1,
  bool hidden = false,
  TextInputAction textInputAction,
  TextInputType textInputType,
  bool autoCorrect = false,
  int maxLines = 1,
  TextDirection textDirection,
  Key textFieldKey,
  Color cursorColor,
  int maxLength,
  double height = 60,
  bool isDense = false,
  contentPadding = const EdgeInsets.symmetric(vertical: 10),
}) =>
    Container(
      height: height,
      child: TextFormField(
        autocorrect: autoCorrect,
        maxLines: maxLines,
        key: textFieldKey,
        cursorColor: cursorColor,
        maxLength: maxLength,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        enabled: enabled,
        obscureText: hidden,
        style: textStyle,
        controller: controller,
        validator: validatorFunction,
        onTap: onTab,
        onChanged: onChange,
        onFieldSubmitted: onSubmited,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced),
        ],
        decoration: InputDecoration(
          hintMaxLines: 1,
          contentPadding: (prefix != null && prefix is Widget)
              ? const EdgeInsets.symmetric(vertical: 2)
              : contentPadding,
          labelText: labelText,
          labelStyle: (context != null && textLabelStyle != null)
              ? textLabelStyle
              : TextStyle(color: Colors.grey),
          isDense: isDense,
          hintText: hintText,
          hintStyle: textHintStyle != null
              ? textHintStyle
              : TextStyle(color: Colors.grey),
          errorStyle: textErrorStyle != null
              ? textErrorStyle
              : TextStyle(color: Colors.red),
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 5, right: 8), child: prefix),
          prefixIconConstraints: prefix is Widget
              ? const BoxConstraints(
                  maxWidth: 100, minHeight: 50, maxHeight: 100)
              : const BoxConstraints(minWidth: 90),
          suffix:
              Padding(padding: EdgeInsets.only(right: 10), child: suffixIcon),

          border: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );

doNamedNavigation(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

doWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

doReplacementWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));

doWidgetNavigationAndRemoveUntil(BuildContext context, Widget screen) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      ModalRoute.withName('$screen'),
    );

enum SnackBarStates { SUCCESS, ERROR, WARNING }

Color chooseSnackBarColor(SnackBarStates states) {
  Color color;
  switch (states) {
    case SnackBarStates.ERROR:
      color = Colors.red;
      break;
    case SnackBarStates.WARNING:
      color = Colors.amber;
      break;
    case SnackBarStates.SUCCESS:
      color = Colors.green;
      break;
  }
  return color;
}

showSnackBar({
  @required BuildContext context,
  @required String message,
  @required SnackBarStates states,
  int seconds = 2,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: seconds),
    backgroundColor: chooseSnackBarColor(states),
  ));
}

buildListItem(model, BuildContext context, {bool hasOldPrice = true}) {
  int id = model.id;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: mainCategoryItemHeight,
      child: Card(
        child: Row(
          children: [
            Container(
              color: Colors.white,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  customShimmerNetworkImage(
                    imagePath: model.image.toString(),
                    imgHeight: mainCategoryItemHeight,
                    imgWidth: mainCategoryItemWidth,
                    backgroundWidth: mainCategoryItemWidth,
                    imgFit: BoxFit.contain,
                  ),
                  model.discount != 0 && hasOldPrice
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "Discount",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        )
                      : Container()
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: TextStyle(color: calcBtnColor),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      model.discount != 0 && hasOldPrice
                          ? Text(
                              model.oldPrice.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Container(),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          ShopAppCubit.get(context).favorites[id] != null &&
                                  ShopAppCubit.get(context).favorites[id]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 30,
                          color: ShopAppCubit.get(context).favorites[model.id]
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          log(model.id.toString());
                          ShopAppCubit.get(context).changeFavorites(model.id);
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

showToast({
  BuildContext context,
  @required String message,
  Toast time = Toast.LENGTH_SHORT,
  MaterialColor color = Colors.green,
  Color textColor = Colors.white,
  double fontSize = 16.0,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: time,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: textColor,
      fontSize: fontSize);
}

Widget customShimmerNetworkImage(
    {@required String imagePath,
    @required double imgHeight,
    @required double imgWidth,
    @required double backgroundWidth,
    BoxFit imgFit = BoxFit.cover,
    double borderRadius = 10.0,
    Color shimmerBackgroundBaseColor,
    Color shimmerBackgroundHighlightColor}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Container(
      height: imgHeight,
      width: backgroundWidth,
      color: Colors.white,
      child: CachedNetworkImage(
        width: imgWidth,
        height: imgHeight,
        fit: imgFit,
        imageUrl: imagePath,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: shimmerBackgroundBaseColor ??
              (AppCubit.get(context).isDark
                  ? Colors.grey[850]
                  : Colors.grey[100]),
          highlightColor: shimmerBackgroundHighlightColor ?? Colors.grey[800],
          child: Container(
            height: imgHeight,
            width: imgWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}
