import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class ShopLoginScreen extends StatelessWidget {
  static final String id = 'shopLogin Screen';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessStates) {
          if (state.model.status) {
            CashHelper.putData(key: "token", value: state.model.data.token)
                .then((value) {
              token = state.model.data.token;
              doReplacementWidgetNavigation(context, ShopLayout());
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextHeading(context),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "login now to browse our hot offers",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 120,
                        child: Column(
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Email",
                                  hintText: "Email Address",
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: Icons.email_outlined,
                                  controller: emailController,
                                  validatorFunction: (String value) {
                                    if (value.isEmpty) {
                                      return "Email Address must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  borderRadius: 10,
                                  textInputType: TextInputType.emailAddress,
                                  height: 80),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                height: 50,
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: "Password",
                                hintText: "Password",
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icons.lock_outlined,
                                hidden: ShopLoginCubit.get(context).isHidden,
                                suffixIcon: IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      ShopLoginCubit.get(context).icon,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey,
                                    ),
                                  ),
                                  onPressed: () {
                                    ShopLoginCubit.get(context)
                                        .changePasswordVisibility();
                                  },
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
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //         content: Text(
                                  //             ShopLoginCubit.get(context)
                                  //                 .loginMessage
                                  //                 .toString())));
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.visiblePassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingStates,
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                        builder: (context) => defaultButton(
                          text: "LOGIN",
                          function: () {
                            if (formKey.currentState.validate()) {
                              // formKey.currentState.save();
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
                            style: Theme.of(context)
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
                              style: TextStyle(color: defaultAppColor),
                            ),
                            onPressed: () {
                              // doNamedNavigation(context, ShopRegisterScreen.id);
                              doWidgetNavigation(context, ShopRegisterScreen());
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  buildTextHeading(BuildContext context) {
    return Text(
      "LOGIN",
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
