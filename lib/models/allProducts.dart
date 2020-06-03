// To parse this JSON data, do
//
//     final storeData = storeDataFromJson(jsonString);

class ProductData {
  String productId;
  String productName;
  String productNameArb;
  String productDescriptionArb;
  String categoryId;
  String productDescription;
  String dealPrice;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String price;
  String mrp;
  String productImage;
  String status;
  String inStock;
  String unitValue;
  String unit;
  String increament;
  String rewards;
  String stock;
  String title;

  ProductData({
    this.productId,
    this.productName,
    this.productNameArb,
    this.productDescriptionArb,
    this.categoryId,
    this.productDescription,
    this.dealPrice,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.price,
    this.mrp,
    this.productImage,
    this.status,
    this.inStock,
    this.unitValue,
    this.unit,
    this.increament,
    this.rewards,
    this.stock,
    this.title,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        productId: json["product_id"],
        productName: json["product_name"],
        productNameArb: json["product_name_arb"],
        productDescriptionArb: json["product_description_arb"],
        categoryId: json["category_id"],
        productDescription: json["product_description"],
        dealPrice: json["deal_price"],
        startDate: json["start_date"],
        startTime: json["start_time"],
        endDate: json["end_date"],
        endTime: json["end_time"],
        price: json["price"],
        mrp: json["mrp"],
        productImage: json["product_image"],
        status: json["status"],
        inStock: json["in_stock"],
        unitValue: json["unit_value"],
        unit: json["unit"],
        increament: json["increament"],
        rewards: json["rewards"],
        stock: json["stock"],
        title: json["title"],
      );
  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_name_arb": productNameArb,
        "product_description_arb": productDescriptionArb,
        "category_id": categoryId,
        "product_description": productDescription,
        "deal_price": dealPrice,
        "start_date": startDate,
        "start_time": startTime,
        "end_date": endDate,
        "end_time": endTime,
        "price": price,
        "mrp": mrp,
        "product_image": productImage,
        "status": status,
        "in_stock": inStock,
        "unit_value": unitValue,
        "unit": unit,
        "increament": increament,
        "rewards": rewards,
        "stock": stock,
        "title": title,
      };
}
