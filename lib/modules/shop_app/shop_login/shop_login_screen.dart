import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_cubit/shop_login_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_cubit/shop_login_cubit_states.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/app_cubit.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopLoginScreen extends StatelessWidget {
  static final String id = 'shopLogin Screen';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextStyle titleTextStyle;

  TextStyle subTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    titleTextStyle =
        GoogleFonts.aclonica(textStyle: Theme
            .of(context)
            .textTheme
            .headline2);
    subTitleTextStyle =
        GoogleFonts.aclonica(textStyle: Theme
            .of(context)
            .textTheme
            .bodyText1)
            .copyWith(color: Colors.grey);
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessStates) {
          if (state.model.status) {
            CashHelper.putData(key: "token", value: state.model.data.token)
                .then((value) {
              token = state.model.data.token;
              doWidgetNavigationAndRemoveUntil(context, ShopLayout());
            });

            showSnackBar(
              context: context,
              message: state.model.message,
              states: SnackBarStates.SUCCESS,
            );
          } else {
            showSnackBar(
              context: context,
              seconds: 3,
              message: state.model.message,
              states: SnackBarStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      buildTextHeading(context),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "login now to browse our hot offers",
                    style: subTitleTextStyle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        Expanded(
                          child: defaultTextFormField(
                            context: context,
                            textHintStyle: hintTextStyle,
                            labelText: "Email",
                            hintText: "Email Address",
                            textErrorStyle: errorTextStyle,
                            textLabelStyle: labelTextStyle,
                            textInputAction: TextInputAction.next,
                            prefix: Icon(Icons.email_outlined,color: prefixIconsColor,),
                            controller: emailController,
                            isDense: true,
                            validatorFunction: (String value) {
                              if (value.isEmpty) {
                                return "Email Address must not be empty";
                              } else {
                                return null;
                              }
                            },
                            borderRadius: 10,
                            textInputType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: defaultTextFormField(
                            context: context,
                            labelText: "Password",
                            textHintStyle: hintTextStyle,
                            textLabelStyle: labelTextStyle,
                            textErrorStyle: errorTextStyle,
                            hintText: "Password",
                            textInputAction: TextInputAction.done,
                            prefix: Icon(Icons.lock_outlined,color: prefixIconsColor,),
                            hidden: ShopLoginCubit
                                .get(context)
                                .isHidden,
                            isDense: true,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                ShopLoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              child: Icon(
                                ShopLoginCubit
                                    .get(context)
                                    .icon,
                                color: AppCubit
                                    .get(context)
                                    .isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey,
                              ),
                            ),
                            controller: passwordController,
                            validatorFunction: (String value) {
                              if (value.isEmpty) {
                                return "Password must not be empty";
                              } else {
                                return null;
                              }
                            },
                            onSubmited: (value) {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                ShopLoginCubit.get(context).login(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            borderRadius: 10,
                            textInputType: TextInputType.visiblePassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ConditionalBuilder(
                    condition: state is! ShopLoginLoadingStates,
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                    builder: (context) =>
                        defaultButton(
                            text: "LOGIN",
                            textStyle: buttonTextStyle,
                            function: ()
                    {
                    if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    ShopLoginCubit.get(context).login(
                    email: emailController.text,
                    password: passwordController.text);
                    }
                    },
                    height: 50,
                    buttonColor: defaultAppColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do not have an account",
                      style: Theme
                          .of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.grey),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        "REGISTER",
                        style: authCaptionRegisterLoginTextStyle,
                      ),
                      onPressed: () {
                        doWidgetNavigation(context, ShopRegisterScreen());
                      },
                    ),
                  ],
                )
                ],
              ),
            ),
          ),
        ),)
        ,
        );
      },
    );
  }

  buildTextHeading(BuildContext context) {
    return Text(
      "LOGIN",
      style: titleTextStyle,
    );
  }
}
