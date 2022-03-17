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
  bool isFavourite = false;

  HotelsModel(
      {this.id,
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel'] = this.hotel;
    data['address'] = this.address;
    data['contact_num'] = this.contactNum;
    data['contact_person'] = this.contactPerson;
    data['opening_hours'] = this.openingHours;
    data['menu_options'] = this.menuOptions;
    data['dress_code'] = this.dressCode;
    data['adults'] = this.adults;
    data['price'] = this.price;
    data['amenities'] = this.amenities;
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
