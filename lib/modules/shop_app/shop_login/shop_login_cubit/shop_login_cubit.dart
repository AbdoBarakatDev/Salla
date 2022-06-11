import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/shop_app_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_cubit/shop_login_cubit_states.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialStates());

  static ShopLoginCubit get(BuildContext context) => BlocProvider.of(context);
  ShopAppLoginModel modelData;
  bool isHidden = false;
  IconData icon = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isHidden = !isHidden;
    isHidden
        ? icon = Icons.visibility_outlined
        : icon = Icons.visibility_off_outlined;
    emit(ShopLoginChangePasswordVisibilityStates());
  }

  void login({@required String email, @required String password}) async {
    emit(ShopLoginLoadingStates());
    await ShopAppDioHelper.post(
      url: LOGIN,
      data: {
        "email": email,
        "password": password,
      },
      token: token,
    ).then((value) {
      print("Login DATA is" + value.data.toString());
      modelData = ShopAppLoginModel.fromJson(value.data);
      // print(modelData.status);
      // print(modelData.message);
      // print(modelData.data.token);
      emit(ShopLoginSuccessStates(modelData));
    }).catchError((error) {
      print("Error is: ${error.toString()}");
      emit(ShopLoginErrorStates(error.toString()));
    });
  }

  void logout({
    @required String token,
    @required BuildContext context,
  }) async {
    emit(ShopLogOutLoadingStates());
    await ShopAppDioHelper.post(
      url: LOGOUT,
      data: {
        "lang": language,
        "Content-Type": "application/json",
        "Authorization": token,
      },
      token: token,
    ).then((value) {
      // print("DATA is" + value.data.toString());
      CashHelper.clearData(key: "token").then((value) {
        print("logout DATA is" + value.toString());
        print("when Logout : ${value.toString()}");
        print("Logout Token : ${CashHelper.getData(key: "token")}");
        ShopAppCubit.get(context).currentIndex = 0;
        doReplacementWidgetNavigation(context, ShopLoginScreen());
        emit(ShopLogOutSuccessStates());
      }).catchError((error) {
        print("Error is: ${error.toString()}");
        emit(ShopLogOutFailStates());
      });
    }).catchError((error) {
      print(error.toString());
    });
  }
}
