import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopCategoryDetailsScreen extends StatelessWidget {
  static String id = "ShopCategoryDetailsScreen";
  final String modelCategory;
  final String modelCategoryImage;

  ShopCategoryDetailsScreen({this.modelCategory, this.modelCategoryImage});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<ShopSearchCubit, ShopSearchStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text("Category Details"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: height * 0.25,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      FadeInImage(
                        width: width,
                        image: NetworkImage(modelCategoryImage.toString()),
                        placeholder: AssetImage(
                          "assets/images/loading.jpg",
                        ),
                        placeholderFit: BoxFit.scaleDown,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/images/error_handle.png",
                              fit: BoxFit.fitWidth);
                        },
                        fit: BoxFit.fitWidth,
                      ),
                      Container(
                          width: width,
                          color: Colors.black.withOpacity(0.4),
                          child: Wrap(
                            children: [Text(modelCategory.toString().toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(color: Colors.white)),],
                          )),
                    ],
                  ),
                ),
                (state is ShopSearchSuccessStates)
                    ? Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            // onTap: () {
                            //   doWidgetNavigation(
                            //       context,
                            //       ShopProductDetailsScreen(
                            //         product: ShopAppCubit.get(context)
                            //             .model
                            //             .data
                            //             .products[index],
                            //       ));
                            // },
                            child: buildListItem(
                              ShopSearchCubit.get(context)
                                  .model
                                  .data
                                  .data[index],
                              context,
                              hasOldPrice: false,
                            ),
                          ),
                          itemCount: ShopSearchCubit.get(context)
                              .model
                              .data
                              .data
                              .length,
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: CircularProgressIndicator(),
                      )),
              ],
            ),
          )),
    );
  }
}
