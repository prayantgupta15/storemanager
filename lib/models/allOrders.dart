class AllOrders {
  String saleId;
  String userId;
  DateTime onDate;
  String deliveryTimeFrom;
  String deliveryTimeTo;
  String status;
  String note;
  String isPaid;
  String totalAmount;
  String totalRewards;
  String totalKg;
  String totalItems;
  String socityId;
  String deliveryAddress;
  String locationId;
  String deliveryCharge;
  String newStoreId;
  String assignTo;
  String paymentMethod;
  String userFullname;
  String userPhone;
  String pincode;
  String houseNo;
  String socityName;
  String receiverName;
  String receiverMobile;

  AllOrders({
    this.saleId,
    this.userId,
    this.onDate,
    this.deliveryTimeFrom,
    this.deliveryTimeTo,
    this.status,
    this.note,
    this.isPaid,
    this.totalAmount,
    this.totalRewards,
    this.totalKg,
    this.totalItems,
    this.socityId,
    this.deliveryAddress,
    this.locationId,
    this.deliveryCharge,
    this.newStoreId,
    this.assignTo,
    this.paymentMethod,
    this.userFullname,
    this.userPhone,
    this.pincode,
    this.houseNo,
    this.socityName,
    this.receiverName,
    this.receiverMobile,
  });

  factory AllOrders.fromJson(Map<String, dynamic> json) => AllOrders(
        saleId: json["sale_id"],
        userId: json["user_id"],
        onDate: DateTime.parse(json["on_date"]),
        deliveryTimeFrom: json["delivery_time_from"],
        deliveryTimeTo: json["delivery_time_to"],
        status: json["status"],
        note: json["note"],
        isPaid: json["is_paid"],
        totalAmount: json["total_amount"],
        totalRewards: json["total_rewards"],
        totalKg: json["total_kg"],
        totalItems: json["total_items"],
        socityId: json["socity_id"],
        deliveryAddress: json["delivery_address"],
        locationId: json["location_id"],
        deliveryCharge: json["delivery_charge"],
        newStoreId: json["new_store_id"],
        assignTo: json["assign_to"],
        paymentMethod: json["payment_method"],
        userFullname: json["user_fullname"],
        userPhone: json["user_phone"],
        pincode: json["pincode"],
        houseNo: json["house_no"],
        socityName: json["socity_name"],
        receiverName: json["receiver_name"],
        receiverMobile: json["receiver_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "sale_id": saleId,
        "user_id": userId,
        "on_date":
            "${onDate.year.toString().padLeft(4, '0')}-${onDate.month.toString().padLeft(2, '0')}-${onDate.day.toString().padLeft(2, '0')}",
        "delivery_time_from": deliveryTimeFrom,
        "delivery_time_to": deliveryTimeTo,
        "status": status,
        "note": note,
        "is_paid": isPaid,
        "total_amount": totalAmount,
        "total_rewards": totalRewards,
        "total_kg": totalKg,
        "total_items": totalItems,
        "socity_id": socityId,
        "delivery_address": deliveryAddress,
        "location_id": locationId,
        "delivery_charge": deliveryCharge,
        "new_store_id": newStoreId,
        "assign_to": assignTo,
        "payment_method": paymentMethod,
        "user_fullname": userFullname,
        "user_phone": userPhone,
        "pincode": pincode,
        "house_no": houseNo,
        "socity_name": socityName,
        "receiver_name": receiverName,
        "receiver_mobile": receiverMobile,
      };
}
