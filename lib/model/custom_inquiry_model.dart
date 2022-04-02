class CustomInquiryModel {
  int? id;
  String? name;
  String? key;
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

  CustomInquiryModel(
      {this.id,
      this.description,
      this.inquiry_price,
      this.key,
      this.rating,
      this.isFavourite = false,
      this.name,
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

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'address': this.address,
      'contactNum': this.contactNum,
      'contactPerson': this.contactPerson,
      'openingHours': this.openingHours,
      'menuOptions': this.menuOptions,
      'dressCode': this.dressCode,
      'adults': this.adults,
      'price': this.price,
      'amenities': this.amenities,
      'imageUrl': this.imageUrl,
      'recommended': this.recommended,
      'popular': this.popular,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'checkins': this.checkins,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'deletedAt': this.deletedAt,
      'description': this.description,
      'rating': this.rating,
      'inquiry_price': this.inquiry_price,
    };
  }

  factory CustomInquiryModel.fromMap(Map<String, dynamic> map) {
    return CustomInquiryModel(
      id: map['id'],
      address: map['address'],
      contactNum: map['contactNum'],
      contactPerson: map['contactPerson'],
      openingHours: map['openingHours'],
      menuOptions: map['menuOptions'],
      dressCode: map['dressCode'],
      adults: map['adults'],
      price: map['price'],
      amenities: map['amenities'],
      imageUrl: map['imageUrl'],
      recommended: map['recommended'],
      popular: map['popular'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      checkins: map['checkins'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      description: map['description'],
      rating: map['rating'],
      inquiry_price: map['inquiry_price'],
    );
  }
}
