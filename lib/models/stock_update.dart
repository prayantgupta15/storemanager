import 'package:flutter/cupertino.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';

class StockUpdateItem {
  String productId;
  String price;
  String unit;
  String quantity;
  String storeId;
  StockUpdateItem({
    @required this.productId,
    @required this.price,
    @required this.unit,
    @required this.quantity,
    @required this.storeId
  });

  Map<String, String> toJson() {
    return {
      'product_id': productId,
      'qty': quantity,
      'unit': unit,
      'price': price,
      'store_id_login': storeId

    };
  }
}
