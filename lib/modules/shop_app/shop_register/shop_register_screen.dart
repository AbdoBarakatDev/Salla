import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_cubit/shop_register_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_cubit/shop_register_cubit_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopRegisterScreen extends StatelessWidget {
  static final String id = "ShopRegisterScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
      listener: (context, state) {
        if (state is ShopRegisterSuccessStates) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextHeading(context),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "register now to browse our hot offers",
                        style: GoogleFonts.acme(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1)
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 300,
                        child: Column(
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                labelText: "User Name",
                                textHintStyle: hintTextStyle,
                                textLabelStyle: labelTextStyle,
                                textErrorStyle: errorTextStyle,
                                context: context,
                                hintText: "Type Your Name",
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.person,
                                  color: prefixIconsColor,
                                ),
                                controller: userNameController,
                                validatorFunction: (String value) {
                                  if (value.isEmpty) {
                                    return "Name must not be empty";
                                  } else if (value.length < 3) {
                                    return "Name must not be less than 3 letters";
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
                                hintText: "Type Email Address",
                                textHintStyle: hintTextStyle,
                                textLabelStyle: labelTextStyle,
                                textErrorStyle: errorTextStyle,
                                context: context,
                                labelText: "Email",
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.email_outlined,
                                  color: prefixIconsColor,
                                ),
                                controller: emailController,
                                validatorFunction: (String value) {
                                  if (value.isEmpty) {
                                    return "Email Address must not be empty";
                                  } else if (!value.contains("@")) {
                                    return "Email must be Contains @";
                                  } else if (!((value.contains("gmail.com")) ||
                                      (value.contains("yahoo.com")))) {
                                    return "Email typed in a wrong format";
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
                                hintText: "Type Your Password",
                                labelText: "Password",
                                context: context,
                                textHintStyle: hintTextStyle,
                                textLabelStyle: labelTextStyle,
                                textErrorStyle: errorTextStyle,
                                textInputAction: TextInputAction.none,
                                prefix: Icon(
                                  Icons.lock_outlined,
                                  color: prefixIconsColor,
                                ),
                                hidden: ShopRegisterCubit.get(context).isHidden,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ShopRegisterCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  child: Icon(
                                    ShopRegisterCubit.get(context).icon,
                                    color: prefixIconsColor,
                                  ),
                                ),
                                controller: passwordController,
                                validatorFunction: (String value) {
                                  RegExp rex = RegExp(
                                      r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
                                  if (value.isEmpty) {
                                    return "Password must not be empty";
                                  } else if (value.length < 8 ||
                                      !rex.hasMatch(value)) {
                                    return "Password must not be less than 8 digits, 1 capital letter, 1 small letter";
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
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                height: 80,
                                textHintStyle: hintTextStyle,
                                textLabelStyle: labelTextStyle,
                                textErrorStyle: errorTextStyle,
                                hintText: "Type Your Phone Number",
                                labelText: "Phone",
                                maxLength:
                                    ShopRegisterCubit.get(context).maxLength,
                                textInputAction: TextInputAction.done,
                                prefix: Container(
                                  height: 20,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  child: buildCountryKeys(context),
                                ),
                                controller: phoneController,
                                validatorFunction: (String value) {
                                  if (value.isEmpty) {
                                    return "Phone Number must not be empty";
                                  } else if (value.length <
                                      ShopRegisterCubit.get(context)
                                          .maxLength) {
                                    return "wrong number must be at least ${ShopRegisterCubit.get(context).maxLength} digits";
                                  } else {
                                    return null;
                                  }
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.phone,
                                context: context,
                              ),
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
                          textStyle: buttonTextStyle,
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
                              style: authCaptionRegisterLoginTextStyle,
                            ),
                            onPressed: () {
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
      style: GoogleFonts.aclonica(
          textStyle: Theme.of(context).textTheme.headline3),
    );
  }

  buildCountryKeys(BuildContext context) {
    return Center(
      child: CountryCodePicker(
        padding: EdgeInsets.zero,
        onChanged: (countryCode) {
          ShopRegisterCubit.get(context).onCountryChange(countryCode, context);
        },
        initialSelection: 'EG',
        favorite: const ['+20', 'EG'],
        showCountryOnly: false,
        flagWidth: 25,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }
}
