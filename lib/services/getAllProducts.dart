import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bazarmanager/models/allProducts.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

List<ProductData> productList = List<ProductData>();
Future<List<ProductData>> getStoreDataProducts() async {
  final response =
      await http.post(UtilsImporter().stringUtils.GET_PRODUCTS_URL);

  var jsondata = jsonDecode(response.body)["data"];
  print(jsondata.toString());
  productList = List<ProductData>();

  for (var i in jsondata) {
    productList.add(ProductData.fromJson(i));
    print("adding");
    print("LENGTH: " + productList.length.toString());
  }
  return productList;
}

//String storeDataToJson(StoreData data) => json.encode(data.toJson());
