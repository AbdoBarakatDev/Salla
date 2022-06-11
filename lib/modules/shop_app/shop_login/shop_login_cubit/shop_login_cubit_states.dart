import 'package:shop_app/models/shop_app_model/shop_app_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialStates extends ShopLoginStates {}

class ShopLoginLoadingStates extends ShopLoginStates {}

class ShopLoginSuccessStates extends ShopLoginStates {
  ShopAppLoginModel model;

  ShopLoginSuccessStates(this.model);
}

class ShopLoginChangePasswordVisibilityStates extends ShopLoginStates {}

class ShopLoginErrorStates extends ShopLoginStates {
  final String error;

  ShopLoginErrorStates(this.error);
}

class ShopLogOutSuccessStates extends ShopLoginStates {}

class ShopLogOutFailStates extends ShopLoginStates {}

class ShopLogOutLoadingStates extends ShopLoginStates {}
