import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/cart_model.dart';
import 'package:shop_app/models/shop_app_model/categories_model.dart';
import 'package:shop_app/models/shop_app_model/change_favorites_model.dart';
import 'package:shop_app/models/shop_app_model/favorites_model.dart';
import 'package:shop_app/models/shop_app_model/shop_app_home_model.dart';
import 'package:shop_app/models/shop_app_model/shop_app_model.dart';
import 'package:shop_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shop_app/modules/shop_app/home/home_screen.dart';
import 'package:shop_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';

import '../../../models/shop_app_model/orders_model.dart';

class ShopAppCubit extends Cubit<ShopAppStates> {
  ShopAppCubit() : super(ShopAppInitialStates());

  static ShopAppCubit get(BuildContext context) => BlocProvider.of(context);
  bool editEnabled = false;
  File pickedImage;
  List<Widget> shopScreens = [
    ShopAppHomeScreen(),
    ShopAppCategoriesScreen(),
    ShopAppFavoritesScreen(),
    ShopAppSettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: "Categories",
      icon: Icon(Icons.apps),
    ),
    BottomNavigationBarItem(
      label: "Favorites",
      icon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: "Settings",
      icon: Icon(Icons.settings),
    ),
  ];

  void changEditEnabled() {
    editEnabled = !editEnabled;
    emit(ShopAppProfileEditStates());
  }

  int currentIndex = 0;

  void changeBottomNavCurrentIndex(int value) {
    currentIndex = value;
    emit(ShopAppBottomNavChangStates());
  }

  bool isFromAccountIcon = false;

  void changeFromAccountIcon(bool value) {
    isFromAccountIcon = value;
    emit(ShopAppChangeFromAccountIconStates());
  }

  HomeModel model;

  Map<int, bool> favorites = {};

  void getData() {
    emit(ShopAppDataLoadingStates());
    ShopAppDioHelper.get(
      url: HOME,
      token: token,
    ).then((value) {
      model = HomeModel.fromJson(value.data);
      // print(model.data.products[0].image);
      model.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      // print(favorites.toString());
      emit(ShopAppDataSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      emit(ShopAppDataFailStates());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    ShopAppDioHelper.get(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      // print("Value Data is : ${value.data}");
      categoriesModel = CategoriesModel.fromJson(value.data);
      // print("Categories are : ${categoriesModel.data.data[0].image}");
      emit(ShopAppCategoriesSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      emit(ShopAppCategoriesFailStates());
    });
  }

  ChangFavoritesModel favoritesModel;

  void changeFavorites(int id) {
    favorites[id] = !favorites[id];
    emit(ShopAppChangeFavoritesStates());

    ShopAppDioHelper.post(
      url: FAVORITES,
      data: {"product_id": id},
      token: token,
    ).then((value) {
      favoritesModel = ChangFavoritesModel.fromJson(value.data);
      // print("DATA FAV : ${value.data}");
      // print("FAV MODEL : ${favoritesModel.status}");
      if (!favoritesModel.status) {
        favorites[id] = !favorites[id];
      } else {
        getFavorites();
      }
      emit(ShopAppChangeFavoritesSuccessStates(favoritesModel));
    }).catchError((error) {
      favorites[id] = !favorites[id];
      emit(ShopAppChangeFavoritesFailStates());
      print(error.toString());
    });
  }

  FavoritesModel favoritesModelData;

  void getFavorites() {
    emit(ShopAppFavoritesLoadingStates());
    ShopAppDioHelper.get(
      url: FAVORITES,
      token: token,
    ).then((value) {
      // print("Value Data is : ${value.data}");
      favoritesModelData = FavoritesModel.fromJson(value.data);
      // print("Favorites are : ${favoritesModelData.data.data[0].product}");
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      emit(ShopAppFavoritesFailStates());
    });
  }

  ShopAppLoginModel profileModel;

  void getProfileData() {
    emit(ShopAppFavoritesLoadingStates());
    ShopAppDioHelper.get(
      url: PROFILE,
      token: token,
    ).then((value) {
      // print("Value Data is : ${value.data}");
      // print("Token in cubit is : $token");
      profileModel = ShopAppLoginModel.fromJson(value.data);
      print("Token When Get Profile Data: $token");
      print("Email  When Get Profile Data: ${profileModel.data.email}");
      // print("Email are : ${profileModel.data.email}");
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      emit(ShopAppFavoritesFailStates());
    });
  }

  void getImage(File image) {
    pickedImage = image;
    emit(ShopAppGetImageStates());
  }

  void updateProfileData({
    @required String name,
    @required String email,
    @required String phone,
    @required String image,
    // @required String password,
  }) {
    emit(ShopAppFavoritesLoadingStates());
    ShopAppDioHelper.put(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        // "password":password,
      },
    ).then((value) {
      // print("Value Data is : ${value.data}");
      profileModel = ShopAppLoginModel.fromJson(value.data);
      // print("Name become : ${profileModel.data.name}");
      // print("Email become : ${profileModel.data.email}");
      // print("Phone become : ${profileModel.data.phone}");
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      emit(ShopAppFavoritesFailStates());
    });
  }

  int productQuantity = 1;
  double quantityPrice = 0;
  double productPrice = 0;

  void setInitialQuantity() {
    productQuantity=1;
    emit(ShopAppInitialQuantityState());
  }

  void increaseQuantity(double price) {
    productQuantity++;
    productPrice = price;
    calculateQuantityPrice(productQuantity, productPrice);
    emit(ShopAppIncreaseQuantityState());
  }

  void decreaseQuantity(double price) {
    if (productQuantity < 1) {
      return;
    } else {
      productQuantity--;
      productPrice = price;
      calculateQuantityPrice(productQuantity, productPrice);
      emit(ShopAppDecreaseQuantityState());
    }
  }

  calculateQuantityPrice(int quantity, double price) {
    return quantity * price;
  }

  IconData icon = Icons.expand_less_outlined;
  bool isExpanded = true;
  int maxLines = 1;

  expandCollapseDescription() {
    isExpanded = !isExpanded;
    icon = isExpanded ? Icons.expand_more_outlined : Icons.expand_less_outlined;
    maxLines = isExpanded ? 50 : 1;
    emit(ShopAppChangeExpandCollapseStates());
  }

  //================================================
  ChangOrdersModel changOrdersModel;

  void addOrder({
    @required int addressId,
    @required int paymentMethod,
    @required bool usePoints,
    BuildContext context
  }) {
    emit(ShopAppAddOrderLoadingStates());

    ShopAppDioHelper.post(
      url: ORDERS,
      data: {
        "address_id": addressId,
        "payment_method": paymentMethod,
        "use_points": usePoints,
      },
      token: token,
    ).then((value) {
      changOrdersModel = ChangOrdersModel.fromJson(value.data);
      print("Change Order on Add: " + changOrdersModel.toString());
      print("Change Order on Add: " + changOrdersModel.status.toString());
      print("Change Order on Add: " + changOrdersModel.message.toString());
      showSnackBar(context: context, message: changOrdersModel.message, states: SnackBarStates.SUCCESS);
      // if (!changOrdersModel.status) {
      // } else {
        getOrders(context: context);

      // }
      emit(ShopAppAddOrderSuccessStates());
    }).catchError((error) {
      showSnackBar(context: context, message: error.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppAddOrderFailStates());
      print(error.toString());
    });
  }

  void cancelOrder(int id) {
    favorites[id] = !favorites[id];
    emit(ShopAppCancelOrderLoadingStates());

    ShopAppDioHelper.post(
      url: ORDERS,
      data: {"product_id": id},
      token: token,
    ).then((value) {
      changOrdersModel = ChangOrdersModel.fromJson(value.data);
      print("Change Order on Cancel: " + changOrdersModel.toString());
      if (!changOrdersModel.status) {
      } else {
        // getOrders();
      }
      emit(ShopAppCancelOrderSuccessStates());
    }).catchError((error) {
      emit(ShopAppCancelOrderFailStates());
      print(error.toString());
    });
  }

  OrdersModel ordersModel;

  void getOrders({BuildContext context}) {
    emit(ShopAppGetOrderLoadingStates());
    ShopAppDioHelper.get(
      url: ORDERS,
      token: token,
    ).then((value) {
      // print("Value in add is : "+value.data.toString());
      ordersModel = OrdersModel.fromJson(value.data);
      print("ordersModel get Orders: " + ordersModel.data.data.toString());
      // showSnackBar(context: context, message: ordersModel.data.data.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppGetOrderSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      // showSnackBar(context: context, message: error.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppGetOrderFailStates());
    });
  }
//================================================
  CartModel cartModel;
  void getCarts({BuildContext context}) {
    emit(ShopAppGetCartsLoadingStates());
    ShopAppDioHelper.get(
      url: CARTS,
      token: token,
    ).then((value) {
      print("Value in add is : "+value.data.toString());
      cartModel = CartModel.fromJson(value.data);
      // print("cartsModel get Carts is: " + cartModel.data.cartItems.toString());
      // print("Length cartsModel get Carts is: " + cartModel.data.cartItems.length.toString());

      // showSnackBar(context: context, message: ordersModel.data.data.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppGetCartsSuccessStates());
    }).catchError((error) {
      print("Error is $error");
      // showSnackBar(context: context, message: error.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppGetCartsFailStates());
    });
  }

  ChangCartsModel changCartsModel;

  void addCart({
    @required int prodId,
    BuildContext context
  }) {
    emit(ShopAppAddCartsLoadingStates());

    ShopAppDioHelper.post(
      url: CARTS,
      data: {
        "product_id": prodId,
      },
      token: token,
    ).then((value) {

      changCartsModel = ChangCartsModel.fromJson(value.data);
      print("Change Carts on Add: " + changCartsModel.toString());
      // print("Change Carts on Add: " + changCartsModel.status.toString());
      // print("Change Carts on Add: " + changCartsModel.message.toString());
      showSnackBar(context: context, message: changCartsModel.message, states: SnackBarStates.SUCCESS);
      // if (!changOrdersModel.status) {
      // } else {
      getOrders(context: context);

      // }
      emit(ShopAppAddCartsSuccessStates());
    }).catchError((error) {
      showSnackBar(context: context, message: error.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppAddCartsFailStates());
      print(error.toString());
    });
  }

  void deleteCart({
    @required int prodId,
    BuildContext context
  }) {
    emit(ShopAppRemoveCartsLoadingStates());

    ShopAppDioHelper.post(
      url: CARTS,
      data: {
        "product_id": prodId,
      },
      token: token,
    ).then((value) {
      changCartsModel = ChangCartsModel.fromJson(value.data);
      print("Delete Cart is : " + changCartsModel.toString());
      // print("Change Carts on Add: " + changCartsModel.status.toString());
      // print("Change Carts on Add: " + changCartsModel.message.toString());
      showSnackBar(context: context, message: "Deleted Successfully", states: SnackBarStates.SUCCESS);
      // if (!changOrdersModel.status) {
      // } else {
      getOrders(context: context);

      // }
      emit(ShopAppRemoveCartsSuccessStates());
    }).catchError((error) {
      showSnackBar(context: context, message: error.toString(), states: SnackBarStates.ERROR);
      emit(ShopAppRemoveCartsFailStates());
      print(error.toString());
    });
  }
}
