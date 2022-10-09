import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/search_cubit/cubit.dart';
import 'package:shop_app/modules/search/search_cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/functional_cubit.dart';


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
          appBar: AppBar(
            title: Text("Search"),
          ),
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
                    prefix: Icon(Icons.search),
                      hintText: "Search here..",
                      textHintStyle: Theme.of(context).textTheme.button,
                      prefixIcon: Icons.search,
                      controller: searchController,
                      borderRadius: 10,
                      maxLines: 1,
                      height: 90,
                      textInputAction: TextInputAction.search,
                      // onChange: (value) {
                      // todo: add search edit
                      // ShopSearchCubit.get(context).search(text: value);

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
