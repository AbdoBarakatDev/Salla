import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/cubit/app_states.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  int indexOfPage = 0;
  bool isDark = true;
  Database database;
  IconData iconData = Icons.edit;
  bool bottomSheetOpened = false;

  changeScreenIndex(int index) {
    indexOfPage = index;
    print("Index of page : $indexOfPage");
    emit(AppChangeBottomNavIndexStates());
  }

  changeIconBottomSheet({
    @required bool bottomSheetOpened,
    @required IconData iconData,
  }) {
    this.bottomSheetOpened = bottomSheetOpened;
    this.iconData = iconData;
    emit(ChangeIconBottomSheetStates());
  }

  changeThemeMode({bool isDarkFromShared}) {
    if (isDarkFromShared != null) {
      isDark = isDarkFromShared;
    } else {
      isDark = !isDark;
      CashHelper.putBoolean(key: 'isDark', value: isDark)
          .then((value) => emit(AppChangeModeStates()));
    }
  }
}
