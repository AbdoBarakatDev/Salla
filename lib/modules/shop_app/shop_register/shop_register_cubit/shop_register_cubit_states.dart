import 'package:shop_app/models/shop_app_model/shop_app_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialStates extends ShopRegisterStates {}

class ShopRegisterLoadingStates extends ShopRegisterStates {}

class ShopRegisterSuccessStates extends ShopRegisterStates {
  ShopAppLoginModel model;

  ShopRegisterSuccessStates(this.model);
}

class ShopRegisterChangePasswordVisibilityStates extends ShopRegisterStates {}

class ShopRegisterErrorStates extends ShopRegisterStates {
  final String error;

  ShopRegisterErrorStates(this.error);
}
