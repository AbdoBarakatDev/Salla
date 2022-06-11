class HomeModel {
  bool status;
  HomeDataModel data;

  HomeModel({this.status, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null ? HomeDataModel.fromJson(json["data"]) : null;
  }
}

class HomeDataModel {
  List<BannersModel> banners = [];
  List<ProductsModel> products = [];

  HomeDataModel({this.banners, this.products});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json["banners"] != null) {
      json["banners"].forEach((element) => banners.add(BannersModel.fromJson(element)));
    }
    if (json["products"] != null) {
      json["products"].forEach((element) => products.add(ProductsModel.fromJson(element)));
    }
    // print("Banners is : $banners");
  }
}

class BannersModel {
  int id;
  String image;
  dynamic category;
  dynamic product;

  BannersModel({this.id, this.image, this.category, this.product});

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['category'] = this.category;
    data['product'] = this.product;
    return data;
  }
}

class ProductsModel {
  int id;
  dynamic price;
  dynamic oldPrice;
  int discount;
  String image;
  String name;
  String description;
  List<String> images;
  bool inFavorites;
  bool inCart;

  ProductsModel(
      {this.id,
      this.price,
      this.oldPrice,
      this.discount,
      this.image,
      this.name,
      this.description,
      this.images,
      this.inFavorites,
      this.inCart});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}