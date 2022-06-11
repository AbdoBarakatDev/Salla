import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/shop_app_model/favorites_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/app_cubit.dart';

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
  @required IconData prefixIcon,
  Widget suffixIcon,
  Color textColor,
  Color hintColor,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  TextStyle hintStyle,
  TextStyle textStyle,
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
        decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 0.01),
          // contentPadding: EdgeInsets.symmetric(vertical: 10),
          labelText: labelText,
          labelStyle: context != null
              ? Theme.of(context).textTheme.bodyText2
              : TextStyle(color: Colors.grey),
          isDense: isDense,
          hintText: hintText,
          hintStyle: hintStyle,
          prefixIcon: Icon(
            prefixIcon,
            color: prefixIconColor,
          ),
          suffix: suffixIcon,

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
              color:Colors.white,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  FadeInImage(
                    height: mainCategoryItemHeight,
                    width: mainCategoryItemWidth,
                    image: NetworkImage(model.image.toString(),),
                    placeholder: AssetImage("assets/images/loading.jpg",),
                    placeholderFit: BoxFit.scaleDown,
                    imageErrorBuilder:
                        (context, error, stackTrace) {
                      return Image.asset(
                          "assets/images/error_handle.png",
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.contain,
                  ),
                  model.discount != 0 &&hasOldPrice
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
                          print(model.id);
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
