import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/orders_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/cubit/states.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = "OrdersScreen";

  @override
  Widget build(BuildContext context) {
    ShopAppCubit.get(context).changeFromAccountIcon(false);
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          log("Model in Orders Screen is : ${ShopAppCubit.get(context).ordersModel}");
          return ConditionalBuilder(
              condition: ShopAppCubit.get(context).ordersModel!=null,
              builder: (context) => buildListOrdersItem(
                  ShopAppCubit.get(context).ordersModel, context),
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  buildListOrdersItem(OrdersModel model, BuildContext context, {bool hasOldPrice = true}) {
    // int id = model.id;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: Column(children: [
                Text("id is : ${model.data.data[index].id}"),
                Text("total is : ${model.data.data[index].total}"),
                Text("date is : ${model.data.data[index].date}"),
                Text("status is : ${model.data.data[index].status}"),
              ]),),
            );
          },
          itemCount: model.data.data.length,
          separatorBuilder: (context, index) {
            return Divider(height: 10,color: Colors.grey,thickness: 1,);
          },
        ),
      ),
    );
  }
}
