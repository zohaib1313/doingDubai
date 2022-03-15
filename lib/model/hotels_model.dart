class HotelsModel {
  int? id;
  String? hotel;
  String? address;
  String? contactNum;
  String? contactPerson;
  String? openingHours;
  String? menuOptions;
  String? dressCode;
  bool? adults;
  String? price;
  String? amenities;
  String? imageUrl;
  String? createdAt;
  bool isFavourite = false;

  HotelsModel(
      {this.id,
      this.hotel,
      this.address,
      this.contactNum,
      this.contactPerson,
      this.openingHours,
      this.menuOptions,
      this.dressCode,
      this.adults = true,
      this.price,
      this.amenities,
      this.imageUrl,
      this.createdAt});

  HotelsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotel = json['hotel'];
    address = json['address'];
    contactNum = json['contact_num'];
    contactPerson = json['contact_person'];
    openingHours = json['opening_hours'];
    menuOptions = json['menu_options'];
    dressCode = json['dress_code'];
    adults = json['adults'] == '1';
    price = json['price'];
    amenities = json['amenities'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
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
    data['created_at'] = this.createdAt;
    return data;
  }
}
