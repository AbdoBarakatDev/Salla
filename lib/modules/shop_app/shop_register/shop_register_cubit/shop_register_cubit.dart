import 'dart:developer';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/shop_app_model.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_register_cubit/shop_register_cubit_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialStates());

  static ShopRegisterCubit get(BuildContext context) =>
      BlocProvider.of(context);
  ShopAppLoginModel modelData;

  void register(
      {@required String email,
      @required String password,
      @required String name,
      @required String phone}) async {
    emit(ShopRegisterLoadingStates());
    await ShopAppDioHelper.post(url: REGISTER, data: {
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
    }).then((value) {
      log("register DATA is" + value.data.toString());
      modelData = ShopAppLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessStates(modelData));
    }).catchError((error) {
      log("Error is: ${error.toString()}");
      emit(ShopRegisterErrorStates(error.toString()));
    });
  }

  bool isHidden = false;
  IconData icon = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isHidden = !isHidden;
    isHidden
        ? icon = Icons.visibility_outlined
        : icon = Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityStates());
  }

  void onCountryChange(CountryCode countryCode, BuildContext context) {
    detectMaxLines(countryCode: countryCode.code.toString().trim());
    log("New Country selected: ${countryCode.code}");
  }

  int maxLength = 11;

  detectMaxLines({String countryCode = "EG"}) {
    log("$countryCode =>condition is egypt: ${countryCode == 'EG'}");
    if (countryCode == "EG") {
      maxLength = 11;
    } else {
      maxLength = 13;
    }
    emit(ChangePhoneLengthStates());
  }
}
