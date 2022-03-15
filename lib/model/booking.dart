class Bookings {
  int? id;
  String? entityType;
  String? entityTypeId;
  String? userId;
  bool? sent;
  bool? seen;
  bool? actioned;
  String? bookDate;
  String? bookTime;
  int? adults;
  int? kids;
  String? notes;
  String? secured;
  bool? confirmed;
  bool? paid;
  String? payMethod;
  String? amountPaid;
  String? payReference;
  String? createdAt;
  String? updatedAt;

  Bookings(
      {this.id,
        this.entityType,
        this.entityTypeId,
        this.userId,
        this.sent,
        this.seen,
        this.actioned,
        this.bookDate,
        this.bookTime,
        this.adults,
        this.kids,
        this.notes,
        this.secured,
        this.confirmed,
        this.paid,
        this.payMethod,
        this.amountPaid,
        this.payReference,
        this.createdAt,
        this.updatedAt});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityType = json['entity_type'];
    entityTypeId = json['entity_type_id'];
    userId = json['user_id'];
    sent = json['sent'];
    seen = json['seen'];
    actioned = json['actioned'];
    bookDate = json['book_date'];
    bookTime = json['book_time'];
    adults = json['adults'];
    kids = json['kids'];
    notes = json['notes'];
    secured = json['secured'];
    confirmed = json['confirmed'];
    paid = json['paid'];
    payMethod = json['pay_method'];
    amountPaid = json['amount_paid'];
    payReference = json['pay_reference'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity_type'] = this.entityType;
    data['entity_type_id'] = this.entityTypeId;
    data['user_id'] = this.userId;
    data['sent'] = this.sent;
    data['seen'] = this.seen;
    data['actioned'] = this.actioned;
    data['book_date'] = this.bookDate;
    data['book_time'] = this.bookTime;
    data['adults'] = this.adults;
    data['kids'] = this.kids;
    data['notes'] = this.notes;
    data['secured'] = this.secured;
    data['confirmed'] = this.confirmed;
    data['paid'] = this.paid;
    data['pay_method'] = this.payMethod;
    data['amount_paid'] = this.amountPaid;
    data['pay_reference'] = this.payReference;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}