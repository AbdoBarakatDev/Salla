import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/modules/search/search_cubit/cubit.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/functional_cubit.dart';
import 'package:shop_app/shared/helper_cubit/app_cubit.dart';
import 'package:shop_app/shared/helper_cubit/app_states.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'modules/authentication_screens/shop_login/shop_login_cubit/shop_login_cubit.dart';
import 'modules/authentication_screens/shop_login/shop_login_screen.dart';
import 'modules/authentication_screens/shop_register/shop_register_cubit/shop_register_cubit.dart';
import 'modules/authentication_screens/shop_register/shop_register_screen.dart';
import 'modules/bottom_nav_screens/categories/categories_screen.dart';
import 'modules/bottom_nav_screens/categories/category_details/category_details.dart';
import 'modules/bottom_nav_screens/favorites/favorites_screen.dart';
import 'modules/bottom_nav_screens/home/home_screen.dart';
import 'modules/bottom_nav_screens/settings/settings_screen.dart';
import 'modules/carts_screen/carts_screen.dart';
import 'modules/on_boarding/onboarding_screen.dart';
import 'modules/orders_screen/orders_screen.dart';
import 'modules/product_details/product_details.dart';
import 'modules/search/search_screen.dart';
import 'modules/shop_layout/shop_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ShopAppDioHelper.init();
  await CashHelper.init();
  bool openedBoardingBefore = CashHelper.getData(key: "onBoarding");
  bool isDarkFromShared = CashHelper.getBoolean(key: "isDark");
  token = CashHelper.getData(key: "token");
  log("Token is : $token");
  Widget start;
  String startupId;
  if (openedBoardingBefore != null) {
    if (token != null) {
      start = ShopLayout();
      startupId = ShopLayout.id;
    } else {
      start = ShopLoginScreen();
      startupId = ShopLoginScreen.id;
    }
  } else {
    start = OnBoardingScreen();
    startupId = OnBoardingScreen.id;
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        isDark: isDarkFromShared,
        startUpWidget: start,
        startUpWidgetID: startupId,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startUpWidget;
  final String startUpWidgetID;

  MyApp({this.isDark, this.startUpWidget, this.startUpWidgetID});

  @override
  Widget build(BuildContext context) {
    // checkInternetConnection(context);
    return MultiProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) =>
              AppCubit()..changeThemeMode(isDarkFromShared: isDark),
        ),
        BlocProvider<ShopLoginCubit>(create: (context) => ShopLoginCubit()),
        BlocProvider<ShopRegisterCubit>(
            create: (context) => ShopRegisterCubit()),
        BlocProvider<ShopSearchCubit>(create: (context) => ShopSearchCubit()),
        BlocProvider<ShopAppCubit>(
          create: (context) => ShopAppCubit()
            ..getData()
            ..getCategories()
            ..getFavorites()
            ..getProfileData()
            ..getOrders()
            ..getCarts(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Revision',
            home: startUpWidget,
            initialRoute: startUpWidgetID,
            routes: {
              OnBoardingScreen.id: (context) => OnBoardingScreen(),
              ShopLoginScreen.id: (context) => ShopLoginScreen(),
              ShopRegisterScreen.id: (context) => ShopRegisterScreen(),
              ShopLayout.id: (context) => ShopLayout(),
              ShopAppHomeScreen.id: (context) => ShopAppHomeScreen(),
              ShopAppCategoriesScreen.id: (context) =>
                  ShopAppCategoriesScreen(),
              ShopAppFavoritesScreen.id: (context) => ShopAppFavoritesScreen(),
              ShopAppSettingsScreen.id: (context) => ShopAppSettingsScreen(),
              ShopAppSearchScreen.id: (context) => ShopAppSearchScreen(),
              ShopProductDetailsScreen.id: (context) =>
                  ShopProductDetailsScreen(),
              ShopCategoryDetailsScreen.id: (context) =>
                  ShopCategoryDetailsScreen(),
              OrdersScreen.id: (context) => OrdersScreen(),
              CartsScreen.id: (context) => CartsScreen(),
            },
          );
        },
      ),
    );
  }
}

checkInternetConnection(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('connected');
      showSnackBar(
          context: context,
          message: "Connected To Internet",
          states: SnackBarStates.SUCCESS);
    }
  } on SocketException catch (_) {
    log('not connected');
    showSnackBar(
        context: context,
        message: "No Internet Connected",
        states: SnackBarStates.SUCCESS);
  }
}
