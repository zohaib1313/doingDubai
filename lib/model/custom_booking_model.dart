class CustomBookingModel {
  int? id;
  int? userId;
  String? bookDate;
  String? bookTime;
  int? kids;
  int? adults;
  int? confirmed;
  int? paid;
  String? imageUrl;
  String? entityType;
  int? entityId;
  String? restaurant;
  String? key;
  String? name;
  CustomBookingModel(
      {this.id,
      this.userId,
      this.bookDate,
      this.bookTime,
      this.kids,
      this.adults,
      this.confirmed,
      this.paid,
      this.imageUrl,
      this.entityType,
      this.entityId,
      this.restaurant});

  CustomBookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookDate = json['book_date'];
    bookTime = json['book_time'];
    kids = json['kids'];
    adults = json['adults'];
    confirmed = json['confirmed'];
    paid = json['paid'];
    imageUrl = json['image_url'];
    entityType = json['entity_type'];
    entityId = json['entity_id'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['book_date'] = this.bookDate;
    data['book_time'] = this.bookTime;
    data['kids'] = this.kids;
    data['adults'] = this.adults;
    data['confirmed'] = this.confirmed;
    data['paid'] = this.paid;
    data['image_url'] = this.imageUrl;
    data['entity_type'] = this.entityType;
    data['entity_id'] = this.entityId;
    data['restaurant'] = this.restaurant;
    return data;
  }
}
