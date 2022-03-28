class HotelsModel {
  int? id;
  String? hotel;
  String? address;
  String? contactNum;
  String? contactPerson;
  String? openingHours;
  String? menuOptions;
  String? dressCode;
  dynamic adults;
  String? price;
  String? amenities;
  String? imageUrl;
  dynamic recommended;
  dynamic popular;
  String? latitude;
  String? longitude;
  String? checkins;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? description;
  String? rating;
  String? inquiry_price;
  bool isFavourite = false;

  HotelsModel(
      {this.id,
      this.description,
      this.inquiry_price,
      this.rating,
      this.isFavourite = false,
      this.hotel,
      this.address,
      this.contactNum,
      this.contactPerson,
      this.openingHours,
      this.menuOptions,
      this.dressCode,
      this.adults,
      this.price,
      this.amenities,
      this.imageUrl,
      this.recommended,
      this.popular,
      this.latitude,
      this.longitude,
      this.checkins,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  HotelsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotel = json['hotel'];
    address = json['address'];
    contactNum = json['contact_num'];
    contactPerson = json['contact_person'];
    openingHours = json['opening_hours'];
    menuOptions = json['menu_options'];
    dressCode = json['dress_code'];
    adults = json['adults'];
    price = json['price'];
    amenities = json['amenities'];
    imageUrl = json['image_url'];
    recommended = json['recommended'];
    popular = json['popular'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    checkins = json['checkins'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    description = json['description'];
    inquiry_price = json['inquiry_price'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hotel'] = hotel;
    data['address'] = address;
    data['contact_num'] = contactNum;
    data['contact_person'] = contactPerson;
    data['opening_hours'] = openingHours;
    data['menu_options'] = menuOptions;
    data['dress_code'] = dressCode;
    data['adults'] = adults;
    data['price'] = price;
    data['amenities'] = amenities;
    data['image_url'] = imageUrl;
    data['recommended'] = recommended;
    data['popular'] = popular;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['checkins'] = checkins;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['description'] = description;
    data['rating'] = rating;
    data['inquiry_price'] = inquiry_price;

    return data;
  }
}
