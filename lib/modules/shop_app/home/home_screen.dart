import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/categories_model.dart';
import 'package:shop_app/models/shop_app_model/shop_app_home_model.dart';
import 'package:shop_app/modules/shop_app/category_details/category_details.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/modules/shop_app/product_details/product_details.dart';
import 'package:shop_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class ShopAppHomeScreen extends StatelessWidget {
  static String id = "ShopAppHomeScreen";

  @override
  Widget build(BuildContext context) {
    ShopAppCubit.get(context).getProfileData();
    return Scaffold(
        body: BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopAppChangeFavoritesSuccessStates) {
          if (!state.model.status) {
            showSnackBar(
                context: context,
                message: state.model.message.toString(),
                states: SnackBarStates.ERROR);
          }
          showSnackBar(
              context: context,
              message: state.model.message.toString(),
              states: SnackBarStates.SUCCESS);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopAppCubit.get(context).model != null,
          builder: (context) {
            return buildHomeScreen(
                context,
                ShopAppCubit.get(context).model.data,
                ShopAppCubit.get(context).categoriesModel);
          },
          fallback: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    ));
  }

  Widget buildHomeScreen(
      BuildContext context, HomeDataModel data, CategoriesModel model) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: data.banners
                .map(
                  (e) =>
                      // FadeInImage(
                      //   width: double.infinity,
                      //   image: NetworkImage(e.image),
                      //   // placeholder: AssetImage(AppCubit.get(context).isDark?loadingIconDark:loadingIconLite,),
                      //   placeholderFit: BoxFit.scaleDown,
                      //   imageErrorBuilder: (context, error, stackTrace) {
                      //     return Image.asset("assets/images/error_handle.png",
                      //         fit: BoxFit.fitWidth);
                      //   },
                      //   fit: BoxFit.cover,
                      // ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   child: CachedNetworkImage(
                      //     width: double.infinity,
                      //     height: 150,
                      //     fit: BoxFit.cover,
                      //     imageUrl: e.image,
                      //     placeholder: (context, url) => Shimmer.fromColors(
                      //       baseColor: Colors.grey[850],
                      //       highlightColor: Colors.grey[800],
                      //       child: Container(
                      //         height: 150.0,
                      //         width: 120.0,
                      //         decoration: BoxDecoration(
                      //           color: Colors.black,
                      //           borderRadius: BorderRadius.circular(10.0),
                      //         ),
                      //       ),
                      //     ),
                      //     errorWidget: (context, url, error) => const Icon(Icons.error),
                      //   ),
                      // ),

                  customShimmerNetworkImage(
                    imagePath: e.image,
                    imgHeight: 150,
                        backgroundWidth: double.infinity,
                    imgWidth: double.infinity,
                    imgFit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.25,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayInterval: Duration(seconds: 3),
              enableInfiniteScroll: true,
              initialPage: 0,
              reverse: false,
              viewportFraction: 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Categories",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                buildCategoriesItems(model),
                SizedBox(
                  height: 20,
                ),
                Text("Explore",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            child: GridView.count(
              childAspectRatio: 1 / 1.33,
              crossAxisCount: 2,
              children: List.generate(
                  ShopAppCubit.get(context).model.data.products.length,
                  (index) => GestureDetector(
                        onTap: () {
                          log(
                              "ID IS : ${ShopAppCubit.get(context).model.data.products[index].id}");
                          doWidgetNavigation(
                              context,
                              ShopProductDetailsScreen(
                                  product: ShopAppCubit.get(context)
                                      .model
                                      .data
                                      .products[index]));
                        },
                        child: buildGridItems(
                            context,
                            ShopAppCubit.get(context)
                                .model
                                .data
                                .products[index]),
                      )),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }

  buildGridItems(BuildContext context, ProductsModel model) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              customShimmerNetworkImage(
                imagePath: model.image,
                imgHeight: 150,
                backgroundWidth: double.infinity,
                imgWidth: double.infinity,
                imgFit: BoxFit.scaleDown,
              ),
              model.discount != 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "Discount",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    )
                  : Container()
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  model.name.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      "${model.price}",
                      style: TextStyle(color: calcBtnColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    model.discount != 0
                        ? Text(
                            "${model.oldPrice}",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                decoration: TextDecoration.lineThrough),
                          )
                        : Container(),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        ShopAppCubit.get(context).favorites[model.id]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: ShopAppCubit.get(context).favorites[model.id]
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        log(model.id.toString());
                        ShopAppCubit.get(context).changeFavorites(model.id);
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  buildCategoriesItems(CategoriesModel model) {
    return Container(
      height: mainCategoryItemHeight,
      child: ListView.builder(
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
            child: Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  customShimmerNetworkImage(
                    imagePath: model.data.data[index].image,
                    imgHeight: mainCategoryItemHeight,
                    imgWidth: mainCategoryItemWidth,
                    backgroundWidth: mainCategoryItemWidth,
                  ),
                  Container(
                      width: mainCategoryItemWidth,
                      color: Colors.black.withOpacity(0.8),
                      child: Text(
                        model.data.data[index].name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
              height: mainCategoryItemHeight,
              width: mainCategoryItemWidth,
              padding: EdgeInsets.symmetric(horizontal: 5),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.data.data.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
