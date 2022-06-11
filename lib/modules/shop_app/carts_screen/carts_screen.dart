import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/cart_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/constants.dart';

class CartsScreen extends StatelessWidget {
  static const String id = "CartsScreen";

  @override
  Widget build(BuildContext context) {
    ShopAppCubit.get(context).changeFromAccountIcon(false);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // ShopAppCubit.get(context).addOrder(
            //     addressId: 36,
            //     paymentMethod: 1,
            //     usePoints: false,
            //     context: context);
          },
          label: Text("Make Order"),
          icon: Icon(Icons.add)),
      appBar: AppBar(title: Text("My Cart")),
      body: BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (ShopAppCubit.get(context).cartModel != null) {
            print(
                "Model in Carts Screen is : ${ShopAppCubit.get(context).cartModel.data.cartItems}");
          }
          return ConditionalBuilder(
              condition: ShopAppCubit.get(context).cartModel != null,
              builder: (context) => buildListCartsItem(
                  ShopAppCubit.get(context).cartModel, context),
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  buildListCartsItem(CartModel model, BuildContext context,
      {bool hasOldPrice = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return buildCartListItem(index, model, context);
          },
          itemCount: model.data.cartItems.length,
        ),
      ),
    );
  }

  buildCartListItem(int index, CartModel model, BuildContext context,
      {bool hasOldPrice = true}) {
    print("Product $index id is :${model.data.cartItems[index].product.id}");
    print(
        "Product $index in Cart is :${model.data.cartItems[index].product.inCart}");
    int id = model.data.cartItems[index].product.id;
    ProductData product = model.data.cartItems[index].product;
    return GestureDetector(
      onLongPress: () {
        product.inCart = !product.inCart;
        ShopAppCubit.get(context).deleteCart(prodId: id, context: context);
      },
      child:
      // product.inCart
      //     ?
        Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: mainCartItemHeight,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              height: mainCartItemHeight,
                              width: mainCartItemWidth,
                              color: Colors.white,
                              child: Stack(
                                alignment: AlignmentDirectional.bottomStart,
                                children: [
                                  FadeInImage(
                                    height: mainCartItemHeight,
                                    width: mainCartItemWidth,
                                    image: NetworkImage(
                                      product.images.length>0?product.images[0].toString():product.image.toString(),
                                    ),
                                    placeholder: AssetImage(
                                      "assets/images/loading.jpg",
                                    ),
                                    placeholderFit: BoxFit.scaleDown,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          "assets/images/error_handle.png",
                                          fit: BoxFit.fitWidth);
                                    },
                                    fit: BoxFit.contain,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      product.discount != 0
                                          ? Container(
                                              height: 20,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                "Discount",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color:
                                                  Colors.red.withOpacity(0.7),
                                            )
                                          : Container(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        color: Colors.grey.shade300
                                            .withOpacity(0.7),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "\$${product.price}",
                                              style: TextStyle(
                                                  color: calcBtnColor),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            product.discount != 0
                                                ? Text(
                                                    "\$${product.oldPrice}",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      decorationColor: Colors
                                                          .black
                                                          .withOpacity(0.5),
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Divider(
                                    height: 5,
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Quantity:  ${model.data.cartItems[index].quantity.toString()}",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            Divider(
                                              height: 5,
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "TOTAL: ${model.data.total}",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print(id);
                                          ShopAppCubit.get(context)
                                              .changeFavorites(id);
                                        },
                                        child: Icon(
                                          ShopAppCubit.get(context)
                                                          .cartModel.data.cartItems[index].product.inFavorites !=
                                                      null &&
                                              ShopAppCubit.get(context)
                                                  .cartModel.data.cartItems[index].product.inFavorites
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 30,
                                          color: ShopAppCubit.get(context)
                                                          .favorites[id] !=
                                                      null &&
                                                  ShopAppCubit.get(context)
                                                      .favorites[id]
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     CircleAvatar(child: Text(model.data.cartItems[index].quantity.toString()),),
                  //     Text("TOTAL: ${model.data.total}"),
                  //   ],
                  // )
                ],
              ),
            )
          // : Container(),
    );
  }
}
