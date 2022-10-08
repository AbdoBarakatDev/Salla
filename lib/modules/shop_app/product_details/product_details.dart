import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/models/shop_app_model/shop_app_home_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopProductDetailsScreen extends StatelessWidget {
  final ProductsModel product;

  ShopProductDetailsScreen({
    this.product,
  });

  static const String id = "ProductDetails";

  @override
  Widget build(BuildContext context) {
    ShopAppCubit.get(context).setInitialQuantity();
    if (ShopAppCubit
        .get(context)
        .isExpanded)
      ShopAppCubit.get(context).expandCollapseDescription();
    ShopAppCubit.get(context).changeFromAccountIcon(false);
    final double height = MediaQuery
        .of(context)
        .size
        .height;
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: defaultButton(
                text: "Add To Cart",
                function: () {
                  ShopAppCubit.get(context).addToCart(
                    prodId: product.id,
                    quantity: ShopAppCubit.get(context).productQuantity,
                    context: context,
                  );
                  ShopAppCubit.get(context).getData();
                },
                radius: 20,
                height: 50,
                buttonColor: defaultAppColor,
                width: width),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: CircleAvatar(
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey.withOpacity(0.5)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: CircleAvatar(
                      child: Icon(
                        Icons.upload_outlined,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: AlignmentDirectional.centerStart, children: [
                  Container(
                    width: width,
                    height: height * 0.50,
                    decoration: BoxDecoration(),
                    child: CarouselSlider(
                      items: product.images
                          .map(
                            (e) =>
                                customShimmerNetworkImage(
                                  imagePath: e,
                                  borderRadius: 70,
                                  imgHeight: height * 0.50,
                                  imgWidth: double.infinity,
                                  backgroundWidth: double.infinity,
                                  imgFit: BoxFit.cover,

                                ),
                      )
                          .toList(),
                      options: CarouselOptions(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.50,
                        autoPlay: true,
                        scrollPhysics: BouncingScrollPhysics(),
                        autoPlayAnimationDuration: Duration(seconds: 1),
                        autoPlayInterval: Duration(seconds: 10),
                        enableInfiniteScroll: true,
                        initialPage: 0,
                        reverse: false,
                        viewportFraction: 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product.discount != 0
                          ? Container(
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Discount",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red.withOpacity(0.7),
                      )
                          : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.grey.shade300.withOpacity(0.7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "\$${product.price}",
                              style: TextStyle(color: calcBtnColor),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            product.discount != 0
                                ? Text(
                              "\$${product.oldPrice}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                decorationColor:
                                Colors.black.withOpacity(0.5),
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ("${product.name}"),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.w800),
                              maxLines: 3,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              ShopAppCubit
                                  .get(context)
                                  .favorites[product.id]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 30,
                              color: ShopAppCubit
                                  .get(context)
                                  .favorites[product.id]
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              log(product.id.toString());
                              ShopAppCubit.get(context)
                                  .changeFavorites(product.id);
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  ShopAppCubit.get(context).decreaseQuantity(
                                      double.parse(product.price.toString()));
                                },
                                icon: Icon(Icons.remove, color: Colors.grey),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    "${ShopAppCubit
                                        .get(context)
                                        .productQuantity}"),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                              ),
                              IconButton(
                                onPressed: () {
                                  ShopAppCubit.get(context).increaseQuantity(
                                      double.parse(product.price.toString()));
                                },
                                icon: Icon(Icons.add, color: mainIconsColor),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "\$${ShopAppCubit.get(context)
                                .calculateQuantityPrice(ShopAppCubit
                                .get(context)
                                .productQuantity,
                                double.parse(product.price.toString()))
                                .toString()}",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 5, right: 5),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      Row(children: [
                        Expanded(
                          child: Text(
                            "Product Description",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              ShopAppCubit.get(context)
                                  .expandCollapseDescription();
                            },
                            icon: Icon(
                              ShopAppCubit
                                  .get(context)
                                  .icon,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ]),
                      Text(
                        "${product.description}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        maxLines: ShopAppCubit
                            .get(context)
                            .maxLines,
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 5, right: 5),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Reviews",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                          Spacer(),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) {
                              log(rating.toString());
                            },
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  
  //todo: add save action
  // onImageSaveBtnPressed(String imgSrc) async {
  //   File image;
  //   var response = await http.get(Uri(path: imgSrc));
  //   var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  //   String BASE64_IMAGE=filePath;
  //   final ByteData bytes=await rootBundle.load(BASE64_IMAGE);
  //   // await Share.file("My Image Test", name, bytes, mimeType)
  //
  // }
}
