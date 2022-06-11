import 'package:shop_app/models/shop_app_model/categories_model.dart';

class OrdersModel {
  bool status;
  String message;
  OrdersDataModel data;

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] != null ? OrdersDataModel.fromJson(json["data"]) : null;
  }
}

class OrdersDataModel {
  int currentPage;
  List<DataModel> data=[];
  String firstPageUrl;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  String prevPageUrl;
  int from;
  int lastPage;
  int perPage;
  int to;
  int total;

  OrdersDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    firstPageUrl = json["first_page_url"];
    lastPageUrl = json["last_page_url"];
    nextPageUrl = json["next_page_url"];
    path = json["path"];
    prevPageUrl = json["prev_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    perPage = json["per_page"];
    to = json["to"];
    total = json["total"];

    if (json["data"] != null) {
      json["data"].forEach((element) => data.add(DataModel.fromJson(element)));
    }
  }
}

class DataModel {
  int id;
  int total;
  String date;
  String status;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    total = json["total"];
    date = json["date"];
    status = json["status"];
  }
}

// class OrdersModel {
//   bool status;
//   Null message;
//   OrdersDataModel data;
//
//   OrdersModel({this.status, this.message, this.data});
//
//   OrdersModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new OrdersDataModel.fromJson(json['data']) : null;
//   }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   data['message'] = this.message;
  //   if (this.data != null) {
  //     data['data'] = this.data.toJson();
  //   }
  //   return data;
  // }
// }
//
// class OrdersDataModel {
//   int currentPage;
//   List<DataModel> data;
//   String firstPageUrl;
//   int from;
//   int lastPage;
//   String lastPageUrl;
//   Null nextPageUrl;
//   String path;
//   int perPage;
//   Null prevPageUrl;
//   int to;
//   int total;
//
//   OrdersDataModel(
//       {this.currentPage,
//         this.data,
//         this.firstPageUrl,
//         this.from,
//         this.lastPage,
//         this.lastPageUrl,
//         this.nextPageUrl,
//         this.path,
//         this.perPage,
//         this.prevPageUrl,
//         this.to,
//         this.total});
//
//   OrdersDataModel.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = <DataModel>[];
//       json['data'].forEach((v) {
//         data.add(new DataModel.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }
//
// }
//
// class DataModel {
//   int id;
//   int total;
//   String date;
//   String status;
//
//   DataModel({this.id, this.total, this.date, this.status});
//
//   DataModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     total = json['total'];
//     date = json['date'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['total'] = this.total;
//     data['date'] = this.date;
//     data['status'] = this.status;
//     return data;
//   }
// }
//


class ChangOrdersModel {
  bool status;
  String message;

  ChangOrdersModel({this.status, this.message});

  ChangOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
