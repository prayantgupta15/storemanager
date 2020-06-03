// To parse this JSON data, do
//
//     final orderDetails = orderDetailsFromJson(jsonString);

import 'dart:convert';

class OrderDetails {
  String saleItemId;
  String saleId;
  String productId;
  String productName;
  String qty;
  String unit;
  String unitValue;
  String price;
  String qtyInKg;
  String rewards;
  String productArbName;
  String productDescription;
  String productArbDescription;
  String productImage;
  String categoryId;
  String inStock;
  String mrp;
  String arbUnit;
  String increament;
  String tax;

  OrderDetails({
    this.saleItemId,
    this.saleId,
    this.productId,
    this.productName,
    this.qty,
    this.unit,
    this.unitValue,
    this.price,
    this.qtyInKg,
    this.rewards,
    this.productArbName,
    this.productDescription,
    this.productArbDescription,
    this.productImage,
    this.categoryId,
    this.inStock,
    this.mrp,
    this.arbUnit,
    this.increament,
    this.tax,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        saleItemId: json["sale_item_id"],
        saleId: json["sale_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        qty: json["qty"],
        unit: json["unit"],
        unitValue: json["unit_value"],
        price: json["price"],
        qtyInKg: json["qty_in_kg"],
        rewards: json["rewards"],
        productArbName: json["product_arb_name"],
        productDescription: json["product_description"],
        productArbDescription: json["product_arb_description"],
        productImage: json["product_image"],
        categoryId: json["category_id"],
        inStock: json["in_stock"],
        mrp: json["mrp"],
        arbUnit: json["arb_unit"],
        increament: json["increament"],
        tax: json["tax"],
      );

  Map<String, dynamic> toJson() => {
        "sale_item_id": saleItemId,
        "sale_id": saleId,
        "product_id": productId,
        "product_name": productName,
        "qty": qty,
        "unit": unit,
        "unit_value": unitValue,
        "price": price,
        "qty_in_kg": qtyInKg,
        "rewards": rewards,
        "product_arb_name": productArbName,
        "product_description": productDescription,
        "product_arb_description": productArbDescription,
        "product_image": productImage,
        "category_id": categoryId,
        "in_stock": inStock,
        "mrp": mrp,
        "arb_unit": arbUnit,
        "increament": increament,
        "tax": tax,
      };
}
