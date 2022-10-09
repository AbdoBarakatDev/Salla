import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/authentication_screens/shop_login/shop_login_cubit/shop_login_cubit_states.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/functional_cubit.dart';
import 'package:shop_app/shared/cubit/functional_states.dart';
import '../carts_screen/carts_screen.dart';

class ShopLayout extends StatelessWidget {
  static String id = "Shop Layout";
  ShopAppCubit shopAppCubit;

  @override
  Widget build(BuildContext context) {
    shopAppCubit = ShopAppCubit.get(context);

    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopLogOutLoadingStates) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Store"),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  doWidgetNavigation(context, ShopAppSearchScreen());
                },
              ),
              IconButton(
                icon: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Icon(Icons.shopping_cart),
                  if (ShopAppCubit.get(context).cartModel != null &&
                      ShopAppCubit.get(context)
                              .cartModel
                              .data
                              .cartItems
                              .length >
                          0)
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 7,
                      child: Text(
                        "${ShopAppCubit.get(context).cartModel.data.cartItems.length}",
                        style: TextStyle(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ]),
                onPressed: () {
                  doWidgetNavigation(context, CartsScreen());
                },
              ),
              ShopAppCubit.get(context).profileModel != null
                  ? GestureDetector(
                      onTap: () {
                        ShopAppCubit.get(context).changeFromAccountIcon(true);
                        ShopAppCubit.get(context)
                            .changeBottomNavCurrentIndex(3);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            radius: 14,
                            child: Text(
                              ShopAppCubit.get(context)
                                  .profileModel
                                  .data
                                  .name
                                  .toString()
                                  .toUpperCase()
                                  .substring(0, 1),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            backgroundColor: Colors.cyan,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: shopAppCubit.bottomNavItems,
            currentIndex: shopAppCubit.currentIndex,
            onTap: (value) {
              ShopAppCubit.get(context).changeFromAccountIcon(false);
              shopAppCubit.changeBottomNavCurrentIndex(value);
            },
          ),
          body: shopAppCubit.shopScreens[shopAppCubit.currentIndex],
        );
      },
    );
  }
}
