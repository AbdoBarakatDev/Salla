import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/categories_model.dart';
import 'package:shop_app/modules/shop_app/category_details/category_details.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class ShopAppCategoriesScreen extends StatelessWidget {
  static String id = "ShopAppCategoriesScreen";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CategoriesModel model = ShopAppCubit.get(context).categoriesModel;
        return ConditionalBuilder(
          condition: model != null,
          builder: (context) => Scaffold(
            body: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      doWidgetNavigation(
                          context,
                          ShopCategoryDetailsScreen(
                            modelCategory: model.data.data[index].name,
                            modelCategoryImage: model.data.data[index].image,
                          ));
                      ShopSearchCubit.get(context)
                          .search(text: model.data.data[index].name.toString());
                    },
                    child: Card(
                      child: Row(
                        children: [
                          customShimmerNetworkImage(
                            imagePath: model.data.data[index].image,
                            imgHeight: mainCategoryItemHeight,
                            imgWidth: mainCategoryItemWidth,
                            backgroundWidth: mainCategoryItemWidth,
                            imgFit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(model.data.data[index].name),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios_outlined),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: model.data.data.length),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
