class TransportersModel {
  int? id;
  String? company;
  String? description;
  String? rating;
  String? address;
  String? contactNum;
  String? contactPerson;
  String? operatingHours;
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

  TransportersModel(
      {this.id,
      this.company,
      this.description,
      this.rating,
      this.address,
      this.contactNum,
      this.contactPerson,
      this.operatingHours,
      this.price,
      this.inquiryPrice,
      this.imageUrl,
      this.recommended,
      this.popular,
      this.latitude,
      this.longitude,
      this.checkins,
      this.createdAt,
      this.updatedAt});

  TransportersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    description = json['description'];
    rating = json['rating'];
    address = json['address'];
    contactNum = json['contact_num'];
    contactPerson = json['contact_person'];
    operatingHours = json['operating_hours'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company'] = this.company;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['contact_num'] = this.contactNum;
    data['contact_person'] = this.contactPerson;
    data['operating_hours'] = this.operatingHours;
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
    return data;
  }
}
