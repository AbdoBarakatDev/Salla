import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app_model/search_model.dart';
import 'package:shop_app/modules/shop_app/search/cubit/states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/shopapp_dio_helper.dart';

class ShopSearchCubit extends Cubit<ShopSearchStates> {
  ShopSearchCubit() : super(ShopSearchInitialStates());

  static ShopSearchCubit get(BuildContext context) => BlocProvider.of(context);
  SearchModel model;

  void search({String text}) {
    emit(ShopSearchLoadingStates());
    ShopAppDioHelper.post(
      url: PRODUCT_SEARCH,
      token: token,
      data: {
        "text":text,
      }
    ).then((value) {
      log("Value Data is : ${value.data}");
      model = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      emit(ShopSearchErrorStates());
    });
  }

  viewCategoryDetails({String text}) {
    ShopAppDioHelper.post(
        url: PRODUCT_SEARCH,
        token: token,
        data: {
          "text":text,
        }
    ).then((value) {
      log("Value Data is : ${value.data}");
      model = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessStates());
    }).catchError((error) {
      log("Error is $error");
      emit(ShopSearchErrorStates());
    });
  }
}
