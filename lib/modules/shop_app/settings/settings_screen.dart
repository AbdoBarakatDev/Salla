import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/shop_app_model/shop_app_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_cubit/shop_login_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_cubit/shop_login_cubit_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/app_cubit.dart';

class ShopAppSettingsScreen extends StatelessWidget {

  static String id = "ShopAppSettingsScreen";
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopLogOutLoadingStates) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      builder: (context, state) {
        buildContext = context;
        ShopAppLoginModel model = ShopAppCubit.get(context).profileModel;
        // print("Token in setting is : $token");
        // print("Model in setting is : ${model.data.email}");
        return ConditionalBuilder(
          condition: model != null,
          builder: (context) {
            return buildSettings(model, context,
            );
          },
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildSettings(ShopAppLoginModel model, BuildContext context,
     ) {
    print("From Account ${ShopAppCubit.get(context).isFromAccountIcon}");
    var formKey = GlobalKey<FormState>();
    nameController.text = model.data.name.toString();
    emailController.text = model.data.email.toString();
    phoneController.text = model.data.phone.toString();
    passwordController.text = model.data.phone.toString();
    String imagePath = model.data.image;
    print("Name is : ${nameController.text}");
    print("Email is : ${emailController.text}");
    print("Phone is : ${phoneController.text}");
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             ShopAppCubit.get(context).isFromAccountIcon==false? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "App Settings",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Dark Mode"),
                            Switch(
                                value: AppCubit.get(context).isDark,
                                onChanged: (value) {
                                  AppCubit.get(context).changeThemeMode();
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Logout"),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .iconTheme
                                    .color,
                              ),
                              onPressed: () {
                                ShopLoginCubit.get(context)
                                    .logout(token: token, context: context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 20,
                      color: Colors.grey.shade400,
                      indent: 10,
                      endIndent: 10),
                ],
              ):Container(),
              Text(
                "Personal Settings",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      defaultTextFormField(
                          context: buildContext,
                          borderRadius: 10,
                          hintText: "Profile Name",
                          prefixIcon: Icons.person,
                          // validatorFunction: () {},
                          labelText: "Name",
                          enabled: ShopAppCubit.get(buildContext).editEnabled,
                          controller: nameController),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                          context: buildContext,
                          borderRadius: 10,
                          hintText: "Email Address",
                          prefixIcon: Icons.email,
                          // validatorFunction: () {},
                          labelText: "Email Address",
                          enabled: ShopAppCubit.get(buildContext).editEnabled,
                          controller: emailController),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                          context: buildContext,
                          borderRadius: 10,
                          hintText: "Phone Number",
                          prefixIcon: Icons.phone,
                          // validatorFunction: () {},
                          labelText: "phone",
                          enabled: ShopAppCubit.get(buildContext).editEnabled,
                          controller: phoneController),
                      SizedBox(height: 30),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: mainIconsColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                ShopAppCubit.get(buildContext)
                                    .changEditEnabled();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    ShopAppCubit.get(buildContext).editEnabled
                                        ? "CANCEL"
                                        : "EDIT",
                                    style: Theme.of(buildContext)
                                        .textTheme
                                        .bodyText1,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    ShopAppCubit.get(buildContext).editEnabled
                                        ? Icons.cancel_outlined
                                        : Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: mainIconsColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (ShopAppCubit.get(buildContext)
                                    .editEnabled) {
                                  if (formKey.currentState.validate()) {
                                    ShopAppCubit.get(buildContext)
                                        .updateProfileData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      image: imagePath,
                                    );
                                    ShopAppCubit.get(buildContext)
                                        .changEditEnabled();
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "SAVE",
                                    style: Theme.of(buildContext)
                                        .textTheme
                                        .bodyText1,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildEditData() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {},
    );
  }

// Future getImageFromGallery() async {
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//   if (pickedImage != null) {
//     _image = File(pickedImage.path);
//     ShopAppCubit.get(buildContext).getImage(_image);
//   } else {
//     print("No items selected");
//   }
// }
}
