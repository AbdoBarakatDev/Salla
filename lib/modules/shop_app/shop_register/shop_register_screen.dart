import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_cubit/shop_register_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_cubit/shop_register_cubit_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/app_cubit.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopRegisterScreen extends StatelessWidget {
  static final String id = "ShopRegisterScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
      listener: (context, state) {
        if (state is ShopRegisterSuccessStates) {
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
                        height: 250,
                        child: Column(
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "User Name",
                                  hintText: "Type Your Name",
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: Icons.person,
                                  controller: userNameController,
                                  validatorFunction: (String value) {
                                    if (value.isEmpty) {
                                      return "User Name must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  borderRadius: 10,
                                  textInputType: TextInputType.emailAddress,
                                  height: 80),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Type Email Address",
                                  labelText: "Email",
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
                              height: 10,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                height: 80,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: "Type Your Password",
                                labelText: "Password",
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.lock_outlined,
                                hidden: ShopRegisterCubit.get(context).isHidden,
                                suffixIcon: IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      ShopRegisterCubit.get(context).icon,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey,
                                    ),
                                  ),
                                  onPressed: () {
                                    ShopRegisterCubit.get(context)
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
                                borderRadius: 10,
                                textInputType: TextInputType.visiblePassword,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Type Your Phone Number",
                                  labelText: "Phone",
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Icons.phone,
                                  controller: phoneController,
                                  validatorFunction: (String value) {
                                    if (value.isEmpty) {
                                      return "Phone Number must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  borderRadius: 10,
                                  textInputType: TextInputType.phone,
                                  height: 80),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopRegisterLoadingStates,
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                        builder: (context) => defaultButton(
                          text: "REGISTER",
                          function: () {
                            if (formKey.currentState.validate()) {
                              // formKey.currentState.save();
                              ShopRegisterCubit.get(context).register(
                                  name: userNameController.text,
                                  phone: phoneController.text,
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
                            "Already have an account",
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
                              "LOGIN",
                              style: TextStyle(color: defaultAppColor),
                            ),
                            onPressed: () {
                              // doNamedNavigation(context, ShopRegisterScreen.id);

                              doReplacementWidgetNavigation(
                                  context, ShopLoginScreen());
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
      "REGISTER",
      style: Theme.of(context).textTheme.headline3,
    );
  }
}
