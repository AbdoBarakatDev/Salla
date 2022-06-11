import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/search_model.dart';
import 'package:shop_app/modules/shop_app/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopAppSearchScreen extends StatelessWidget {
  static String id = "ShopAppSearchScreen";
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ShopAppCubit.get(context).changeFromAccountIcon(false);
    return BlocConsumer<ShopSearchCubit, ShopSearchStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopSearchLoadingStates)
                    Column(
                      children: [
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  defaultTextFormField(
                      hintText: "Search here..",
                      hintStyle: Theme.of(context).textTheme.button,
                      prefixIcon: Icons.search,
                      borderRadius: 10,
                      maxLines: 1,
                      height: 90,
                      textInputAction: TextInputAction.search,
                      // onChange: (value) {
                      //   ShopSearchCubit.get(context).search(value);
                      // },
                      onSubmited: (value) {
                        ShopSearchCubit.get(context).search(text: value);
                      }),
                  if (state is ShopSearchSuccessStates)
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => buildListItem(
                          ShopSearchCubit.get(context).model.data.data[index],
                          context,
                          hasOldPrice: false,
                        ),
                        itemCount:
                            ShopSearchCubit.get(context).model.data.data.length,
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
