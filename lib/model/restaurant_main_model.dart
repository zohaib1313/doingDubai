class RestaurantMainModel {
  int? id;
  String? restaurant;
  String? description;
  String? rating;
  String? address;
  String? contactNum;
  String? contactPerson;
  String? openingHours;
  String? menuOptions;
  String? menuOptionPrices;
  String? dressCode;
  bool? familyFriendly;
  bool? offerDelivery;
  String? amenities;
  String? price;
  String? inquiryPrice;
  String? imageUrl;
  bool? recommended;
  bool? popular;
  String? latitude;
  String? longitude;
  String? checkins;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  RestaurantMainModel(
      {this.id,
      this.restaurant,
      this.description,
      this.rating,
      this.address,
      this.contactNum,
      this.contactPerson,
      this.openingHours,
      this.menuOptions,
      this.menuOptionPrices,
      this.dressCode,
      this.familyFriendly,
      this.offerDelivery,
      this.amenities,
      this.price,
      this.inquiryPrice,
      this.imageUrl,
      this.recommended,
      this.popular,
      this.latitude,
      this.longitude,
      this.checkins,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  RestaurantMainModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'];
    description = json['description'];
    rating = json['rating'];
    address = json['address'];
    contactNum = json['contact_num'];
    contactPerson = json['contact_person'];
    openingHours = json['opening_hours'];
    menuOptions = json['menu_options'];
    menuOptionPrices = json['menu_option_prices'];
    dressCode = json['dress_code'];
    familyFriendly = json['family_friendly'];
    offerDelivery = json['offer_delivery'];
    amenities = json['amenities'];
    price = json['price'];
    inquiryPrice = json['inquiry_price'];
    imageUrl = json['image_url'];
    recommended = json['recommended'];
    popular = json['popular'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    checkins = json['checkins'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant'] = this.restaurant;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['contact_num'] = this.contactNum;
    data['contact_person'] = this.contactPerson;
    data['opening_hours'] = this.openingHours;
    data['menu_options'] = this.menuOptions;
    data['menu_option_prices'] = this.menuOptionPrices;
    data['dress_code'] = this.dressCode;
    data['family_friendly'] = this.familyFriendly;
    data['offer_delivery'] = this.offerDelivery;
    data['amenities'] = this.amenities;
    data['price'] = this.price;
    data['inquiry_price'] = this.inquiryPrice;
    data['image_url'] = this.imageUrl;
    data['recommended'] = this.recommended;
    data['popular'] = this.popular;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['checkins'] = this.checkins;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
