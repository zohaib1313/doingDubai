class EventsModel {
  int? id;
  String? event;
  String? description;
  String? rating;
  String? address;
  String? contactNum;
  String? contactPerson;
  String? openingHours;
  String? eventTypes;
  String? dressCode;
  bool? adults;
  String? price;
  String? inquiryPrice;
  String? amenities;
  String? imageUrl;
  bool? recommended;
  bool? popular;
  String? latitude;
  String? longitude;
  String? checkins;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  EventsModel(
      {this.id,
      this.event,
      this.description,
      this.rating,
      this.address,
      this.contactNum,
      this.contactPerson,
      this.openingHours,
      this.eventTypes,
      this.dressCode,
      this.adults,
      this.price,
      this.inquiryPrice,
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

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    description = json['description'];
    rating = json['rating'];
    address = json['address'];
    contactNum = json['contact_num'];
    contactPerson = json['contact_person'];
    openingHours = json['opening_hours'];
    eventTypes = json['event_types'];
    dressCode = json['dress_code'];
    adults = json['adults'];
    price = json['price'];
    inquiryPrice = json['inquiry_price'];
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
    data['event'] = this.event;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['contact_num'] = this.contactNum;
    data['contact_person'] = this.contactPerson;
    data['opening_hours'] = this.openingHours;
    data['event_types'] = this.eventTypes;
    data['dress_code'] = this.dressCode;
    data['adults'] = this.adults;
    data['price'] = this.price;
    data['inquiry_price'] = this.inquiryPrice;
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
