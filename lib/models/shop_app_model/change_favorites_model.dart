class ChangFavoritesModel {
  bool status;
  String message;

  ChangFavoritesModel({this.status, this.message});

  ChangFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
