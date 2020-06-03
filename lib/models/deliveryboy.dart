import 'package:flutter/cupertino.dart';

class DeliveryBoy {
  String id;
  String name;

  DeliveryBoy({@required this.name, @required this.id});

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) =>
      DeliveryBoy(name: json["user_name"], id: json["id"]);
}
