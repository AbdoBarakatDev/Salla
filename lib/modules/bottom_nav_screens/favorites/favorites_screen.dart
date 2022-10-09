import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/functional_cubit.dart';
import 'package:shop_app/shared/cubit/functional_states.dart';

class ShopAppFavoritesScreen extends StatelessWidget {
  static String id = "ShopAppFavoritesScreen";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return (ShopAppCubit.get(context).favoritesModelData.data.data.length)>0?ListView.builder(
          itemBuilder: (context, index) {
            return ConditionalBuilder(
                condition: state is! ShopAppFavoritesLoadingStates,
                builder: (context) {
                  return buildListItem(
                      ShopAppCubit.get(context)
                          .favoritesModelData
                          .data
                          .data[index]
                          .product,
                      context);
                },
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()));
          },
          itemCount:
              ShopAppCubit.get(context).favoritesModelData.data.data.length,
        ):Center(
        child: Text(
        "No Favorites",
        style: Theme.of(context).textTheme.caption,
        ),
        );
      },
    );
  }
}
