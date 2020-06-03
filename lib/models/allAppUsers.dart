class AllAppUsers {
  String userId;
  String userPhone;
  String userFullname;
  String userEmail;
  String userPassword;
  String userImage;
  String pincode;
  String socityId;
  String houseNo;
  String mobileVerified;
  String userGcmCode;
  String userIosToken;
  String varifiedToken;
  String status;
  String regCode;
  String wallet;
  String rewards;
  String totalAmount;
  dynamic totalOrders;
  String totalRewards;

  AllAppUsers({
    this.userId,
    this.userPhone,
    this.userFullname,
    this.userEmail,
    this.userPassword,
    this.userImage,
    this.pincode,
    this.socityId,
    this.houseNo,
    this.mobileVerified,
    this.userGcmCode,
    this.userIosToken,
    this.varifiedToken,
    this.status,
    this.regCode,
    this.wallet,
    this.rewards,
    this.totalAmount,
    this.totalOrders,
    this.totalRewards,
  });

  factory AllAppUsers.fromJson(Map<String, dynamic> json) => AllAppUsers(
        userId: json["user_id"],
        userPhone: json["user_phone"],
        userFullname: json["user_fullname"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
        userImage: json["user_image"],
        pincode: json["pincode"],
        socityId: json["socity_id"],
        houseNo: json["house_no"],
        mobileVerified: json["mobile_verified"],
        userGcmCode: json["user_gcm_code"],
        userIosToken: json["user_ios_token"],
        varifiedToken: json["varified_token"],
        status: json["status"],
        regCode: json["reg_code"],
        wallet: json["wallet"],
        rewards: json["rewards"],
        totalAmount: json["total_amount"],
        totalOrders: json["total_orders"],
        totalRewards: json["total_rewards"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_phone": userPhone,
        "user_fullname": userFullname,
        "user_email": userEmail,
        "user_password": userPassword,
        "user_image": userImage,
        "pincode": pincode,
        "socity_id": socityId,
        "house_no": houseNo,
        "mobile_verified": mobileVerified,
        "user_gcm_code": userGcmCode,
        "user_ios_token": userIosToken,
        "varified_token": varifiedToken,
        "status": status,
        "reg_code": regCode,
        "wallet": wallet,
        "rewards": rewards,
        "total_amount": totalAmount,
        "total_orders": totalOrders,
        "total_rewards": totalRewards,
      };
}
