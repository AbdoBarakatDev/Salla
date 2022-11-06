import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/cart_model.dart';
import 'package:shop_app/models/shop_app_model/categories_model.dart';
import 'package:shop_app/models/shop_app_model/change_favorites_model.dart';
import 'package:shop_app/models/shop_app_model/favorites_model.dart';
import 'package:shop_app/models/shop_app_model/shop_app_home_model.dart';
import 'package:shop_app/models/shop_app_model/shop_app_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';

import '../../../models/shop_app_model/orders_model.dart';
import '../../modules/bottom_nav_screens/categories/categories_screen.dart';
import '../../modules/bottom_nav_screens/favorites/favorites_screen.dart';
import '../../modules/bottom_nav_screens/home/home_screen.dart';
import '../../modules/bottom_nav_screens/settings/settings_screen.dart';
import 'functional_states.dart';

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
      log(model.data.products[0].image);
      model.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      log(favorites.toString());
      emit(ShopAppDataSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      emit(ShopAppDataFailStates());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    ShopAppDioHelper.get(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      log("Value Data is : ${value.data}");
      categoriesModel = CategoriesModel.fromJson(value.data);
      log("Categories are : ${categoriesModel.data.data[0].image}");
      emit(ShopAppCategoriesSuccessStates());
    }).catchError((error) {
      log("Error is $error");
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
      log("DATA FAV : ${value.data}");
      log("FAV MODEL : ${favoritesModel.status}");
      if (!favoritesModel.status) {
        favorites[id] = !favorites[id];
      } else {
        getFavorites();
      }
      emit(ShopAppChangeFavoritesSuccessStates(favoritesModel));
    }).catchError((error) {
      favorites[id] = !favorites[id];
      emit(ShopAppChangeFavoritesFailStates());
      log(error.toString());
    });
  }

  FavoritesModel favoritesModelData;

  void getFavorites() {
    emit(ShopAppFavoritesLoadingStates());
    ShopAppDioHelper.get(
      url: FAVORITES,
      token: token,
    ).then((value) {
      log("Value Data is : ${value.data}");
      favoritesModelData = FavoritesModel.fromJson(value.data);
      log("Favorites are : ${favoritesModelData.data.data[0].product}");
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      log("Error is $error");
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
      log("Value Data is : ${value.data}");
      log("Token in cubit is : $token");
      profileModel = ShopAppLoginModel.fromJson(value.data);
      log("Token When Get Profile Data: $token");
      log("Email  When Get Profile Data: ${profileModel.data.email}");
      log("Email are : ${profileModel.data.email}");
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      log("Error is $error");
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
    @required String password,
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
        "password": password,
      },
    ).then((value) {
      if (ShopAppLoginModel.fromJson(value.data).status == false) {
        showToast(
            message: ShopAppLoginModel.fromJson(value.data).message +
                " try another one",
            color: errorColor);
      } else {
        log("value after update : ${ShopAppLoginModel.fromJson(value.data).message}");
        log("Value Data is : ${value.data}");
        profileModel = ShopAppLoginModel.fromJson(value.data);
        log("Name become : ${profileModel.data.name}");
        log("Email become : ${profileModel.data.email}");
        log("Phone become : ${profileModel.data.phone}");
      }
      emit(ShopAppFavoritesSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      emit(ShopAppFavoritesFailStates());
    });
  }

  int productQuantity = 1;
  double quantityPrice = 0;
  double productPrice = 0;

  void setInitialQuantity() {
    productQuantity = 1;
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

  ChangOrdersModel changOrdersModel;

  void addOrder(
      {@required int addressId,
      @required int paymentMethod,
      @required bool usePoints,
      BuildContext context}) {
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
      log("Change Order on Add: " + changOrdersModel.toString());
      log("Change Order on Add: " + changOrdersModel.status.toString());
      log("Change Order on Add: " + changOrdersModel.message.toString());
      showToast(
        message: changOrdersModel.message,
        color: successColor,
      );
      if (!changOrdersModel.status) {
      } else {
        getOrders(context: context);
      }
      emit(ShopAppAddOrderSuccessStates());
    }).catchError((error) {
      showToast(
        message: error.toString(),
        color: errorColor,
      );
      emit(ShopAppAddOrderFailStates());
      log(error.toString());
    });
  }

  void cancelOrder(int id, BuildContext context) {
    favorites[id] = !favorites[id];
    emit(ShopAppCancelOrderLoadingStates());

    ShopAppDioHelper.post(
      url: ORDERS,
      data: {"product_id": id},
      token: token,
    ).then((value) {
      changOrdersModel = ChangOrdersModel.fromJson(value.data);
      log("Change Order on Cancel: " + changOrdersModel.toString());
      if (!changOrdersModel.status) {
      } else {
        getOrders(context: context);
      }
      emit(ShopAppCancelOrderSuccessStates());
    }).catchError((error) {
      emit(ShopAppCancelOrderFailStates());
      log(error.toString());
    });
  }

  OrdersModel ordersModel;

  void getOrders({BuildContext context}) {
    emit(ShopAppGetOrderLoadingStates());
    ShopAppDioHelper.get(
      url: ORDERS,
      token: token,
    ).then((value) {
      log("Value in add is : " + value.data.toString());
      ordersModel = OrdersModel.fromJson(value.data);
      log("ordersModel get Orders: " + ordersModel.data.data.toString());
      // showToast(message: ordersModel.data.data.toString());
      emit(ShopAppGetOrderSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      // showToast(message: error.toString());
      emit(ShopAppGetOrderFailStates());
    });
  }

  CartModel cartModel;

  void getCarts({BuildContext context}) {
    emit(ShopAppGetCartsLoadingStates());
    ShopAppDioHelper.get(
      url: CARTS,
      token: token,
    ).then((value) {
      log("Value in add is : " + value.data.toString());
      cartModel = CartModel.fromJson(value.data);
      log("cartsModel get Carts is: " + cartModel.data.cartItems.toString());
      log("Length cartsModel get Carts is: " +
          cartModel.data.cartItems.length.toString());
      // showToast(message: ordersModel.data.data.toString());
      emit(ShopAppGetCartsSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      // showToast(message: error.toString());
      emit(ShopAppGetCartsFailStates());
    });
  }

  ChangCartsModel changeCartsModel;

  void addToCart(
      {@required int prodId, @required int quantity, BuildContext context}) {
    emit(ShopAppAddCartsLoadingStates());

    ShopAppDioHelper.post(
      url: CARTS,
      data: {
        "product_id": prodId,
        "quantity": quantity,
        "product": {
          "id": prodId,
          "price": 44500,
          "old_price": 44500,
          "discount": 0,
          "image":
              "https://student.valuxapps.com/storage/uploads/products/1615442168bVx52.item_XXL_36581132_143760083.jpeg",
          "name": "لاب توب ابل ماك بوك برو",
          "description":
              "يمكنك التمتع بتجربة الحوسبة بطريقة لم يسبق لها مثيل عندما تقوم باقتناء لاب توب ابل ماك بوك برو. يتميز هذا اللاب توب بمعالج انتل كور i5 من الجيل الثامن بتردد 2.3 جيجاهرتز والذي يضمن لك استمرار أداء النظام بكفاءة عالية. استمتع بتجربة تعدد المهام على نحو سلس وسريع باستخدام ذاكرة الوصول العشوائي بسعة 8 جيجا. يقدم لك معالج الرسومات الجرافيكية انتل ايريس بلس Intel Iris Plus Graphics صور بجودة عالية ويجعل تجربة اللعب الخاصة بك سلسة وممتعة بشكل لم يسبق له مثيل. يوفر نظام التشغيل ماك او اس macOS العديد من الميزات سهلة الاستخدام. قم بتخزين الأفلام المفضلة لديك، والتسجيلات الصوتية، والملفات الهامة الأخرى الخاصة بك بشكل مريح على الذاكرة اس اس دي SSD سعة 512 جيجا. تسمح لك شاشة العرض الرائعة حجم 13.3 انش بعرض الافلام المفضلة لديك والمحتويات الاخرى بجودة عالية. تتميز شاشة ريتينا Retina بإضاءة خلفية ال اي دي زاهية ونسبة تباين عالية تعزز تجربة المشاهدة الخاصة بك. توفر تقنية ترو تون True Tone تجربة مشاهدة طبيعية عن طريق ضبط توازن اللون الأبيض للشاشة حسب درجة حرارة لون الضوء من حولك. يتميز هذا اللاب توب بمخرجات صوتية متوازنة، وعالية الدقة، ونابضة بالحياة، ويوفر لك تجربة صوتية غامرة. تسمح لك شريحة ابل تي Apple T2 بتخزين البيانات الخاصة بك بتنسيق مشفر بمساعدة المعالج الثانوي سيكيور انكليف Secure Enclave. وعلاوة على ذلك، تعمل هذه الشريحة المتطورة على تعزيز وتشديد الحماية والامان لبياناتك بمساعدة من مستشعر التعرف على الهوية عن طريق اللمس Touch ID. يسمح لك هذا المستشعر المتقدم بإلغاء قفل الكمبيوتر المحمول باستخدام بصمات أصابعك فقط. تعمل عناصر التحكم بالشريط اللمسي Touchbar على تبسيط الأنشطة المختلفة مثل إرسال بريد إلكتروني أو تنسيق مستند معين. يمكن حمل لاب توب ابل ماك بوك برو خفيف الوزن بسهولة في حقيبة الظهر الخاصة بك. يتميز هذا اللاب توب باللون الرمادي والذي يضفي عليه مظهراً مميزاً وجميلاً."
        }
      },
      token: token,
    ).then((value) {
      changeCartsModel = ChangCartsModel.fromJson(value.data);
      log("Change Carts on Add: " + changeCartsModel.toString());
      showToast(
        message: changeCartsModel.message,
        color: successColor,
      );
      if (!changOrdersModel.status) {
      } else {
        getCarts(context: context);
      }
      emit(ShopAppAddCartsSuccessStates());
    }).catchError((error) {
      showToast(
        message: error.toString(),
        color: errorColor,
      );
      emit(ShopAppAddCartsFailStates());
      log(error.toString());
    });
  }

  void deleteCart({@required int prodId, BuildContext context}) {
    emit(ShopAppRemoveCartsLoadingStates());

    ShopAppDioHelper.post(
      url: CARTS,
      data: {
        "product_id": prodId,
      },
      token: token,
    ).then((value) {
      changeCartsModel = ChangCartsModel.fromJson(value.data);
      log("Delete Cart is : " + changeCartsModel.toString());
      showToast(
        message: "Deleted Successfully",
        color: successColor,
      );
      if (!changOrdersModel.status) {
      } else {
        getCarts(context: context);
      }
      emit(ShopAppRemoveCartsSuccessStates());
    }).catchError((error) {
      showToast(
        message: error.toString(),
        color: errorColor,
      );
      emit(ShopAppRemoveCartsFailStates());
      log(error.toString());
    });
  }
}
