class CartModel {
  bool status;
  dynamic message;
  CartModelData data;

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? CartModelData.fromJson(json["data"]) : null;
  }
}

class CartModelData {
  dynamic subTotal;
  dynamic total;
  List<CartItems> cartItems = [];

  CartModelData.fromJson(Map<String, dynamic> json) {
    subTotal = json["sub_total"];
    total = json["total"];
    if (json["cart_items"] != null) {
      json["cart_items"]
          .forEach((element) => cartItems.add(CartItems.fromJson(element)));
    }
  }
}

class CartItems {
  int id;
  int quantity;
  ProductData product;

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    quantity = json["quantity"];
    product =
        json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }
}

class ProductData {
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  List<dynamic> images = [];
  bool inFavorites;
  bool inCart;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    name = json['name'];
    description = json['description'];
    images = json['images'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}

class ChangCartsModel {
  bool status;
  String message;

  ChangCartsModel({this.status, this.message});

  ChangCartsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
