import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bazarmanager/models/deliveryboy.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

List<DeliveryBoy> list = List<DeliveryBoy>();
void getBoysList() async {
  print('getting delivery boy list');
  final response =
      await http.get(UtilsImporter().stringUtils.DELIVERY_BOY_LIST_URL);
  print('response.body' + response.body);

  var jsondata = jsonDecode(response.body)["delivery_boy"];
  print(jsondata);
  list = List<DeliveryBoy>();

  for (var i in jsondata) {
    list.add(DeliveryBoy.fromJson(i));
  }
  print(list);
  print("list.length.toString()" + list.length.toString());
}

String getBoyName(String id) {
  String name = "NA";
  print("getting name for $id");
  for (int i = 0; i < list.length; i++) {
    print(list[i].name);
    if (list[i].id == id) return list[i].name;
  }
  return name;
}
