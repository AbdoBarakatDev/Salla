import 'package:shop_app/models/shop_app_model/change_favorites_model.dart';

abstract class ShopAppStates {}

class ShopAppInitialStates extends ShopAppStates {}

class ShopAppBottomNavChangStates extends ShopAppStates {}

class ShopAppChangeFromAccountIconStates extends ShopAppStates {}


class ShopAppDataLoadingStates extends ShopAppStates {}

class ShopAppDataSuccessStates extends ShopAppStates {}

class ShopAppDataFailStates extends ShopAppStates {}

class ShopAppCategoriesSuccessStates extends ShopAppStates {}

class ShopAppCategoriesFailStates extends ShopAppStates {}

class ShopAppChangeFavoritesStates extends ShopAppStates {}
class ShopAppChangeExpandCollapseStates extends ShopAppStates {}

class ShopAppChangeFavoritesSuccessStates extends ShopAppStates {
  ChangFavoritesModel model;

  ShopAppChangeFavoritesSuccessStates(this.model);
}

class ShopAppChangeFavoritesFailStates extends ShopAppStates {}

class ShopAppFavoritesSuccessStates extends ShopAppStates {}

class ShopAppFavoritesFailStates extends ShopAppStates {}

class ShopAppFavoritesLoadingStates extends ShopAppStates {}

class ShopAppProfileSuccessStates extends ShopAppStates {}

class ShopAppProfileFailStates extends ShopAppStates {}

class ShopAppProfileLoadingStates extends ShopAppStates {}

class ShopAppProfileEditStates extends ShopAppStates {}

class ShopAppInitialQuantityState extends ShopAppStates {}
class ShopAppIncreaseQuantityState extends ShopAppStates {}
class ShopAppDecreaseQuantityState extends ShopAppStates {}


class ShopAppGetImageStates extends ShopAppStates {}


class ShopAppAddOrderStates extends ShopAppStates {}
class ShopAppAddOrderLoadingStates extends ShopAppStates {}
class ShopAppAddOrderSuccessStates extends ShopAppStates {}
class ShopAppAddOrderFailStates extends ShopAppStates {}

class ShopAppCancelOrderStates extends ShopAppStates {}
class ShopAppCancelOrderLoadingStates extends ShopAppStates {}
class ShopAppCancelOrderSuccessStates extends ShopAppStates {}
class ShopAppCancelOrderFailStates extends ShopAppStates {}

class ShopAppGetOrderLoadingStates extends ShopAppStates {}
class ShopAppGetOrderSuccessStates extends ShopAppStates {}
class ShopAppGetOrderFailStates extends ShopAppStates {}

class ShopAppGetCartsLoadingStates extends ShopAppStates {}
class ShopAppGetCartsSuccessStates extends ShopAppStates {}
class ShopAppGetCartsFailStates extends ShopAppStates {}

class ShopAppAddCartsStates extends ShopAppStates {}
class ShopAppAddCartsLoadingStates extends ShopAppStates {}
class ShopAppAddCartsSuccessStates extends ShopAppStates {}
class ShopAppAddCartsFailStates extends ShopAppStates {}

class ShopAppRemoveCartsStates extends ShopAppStates {}
class ShopAppRemoveCartsLoadingStates extends ShopAppStates {}
class ShopAppRemoveCartsSuccessStates extends ShopAppStates {}
class ShopAppRemoveCartsFailStates extends ShopAppStates {}