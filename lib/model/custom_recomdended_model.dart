class CustomRecomededModel {
  int? id;
  int? userId;
  String? name;
  String? key;
  String? description;
  String? rating;
  String? address;
  String? contactNum;
  String? imageUrl;

  CustomRecomededModel(
      {this.id,
      this.userId,
      this.key,
      this.name,
      this.description,
      this.rating,
      this.address,
      this.contactNum,
      this.imageUrl});

  CustomRecomededModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    description = json['description'];
    rating = json['rating'];
    address = json['address'];
    contactNum = json['contact_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['contact_num'] = this.contactNum;

    return data;
  }
}
