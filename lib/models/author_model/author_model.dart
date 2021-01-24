class AuthorModel {
  List<Data> data;

  AuthorModel({this.data});

  AuthorModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String bio;
  String image;
  String birthDate;
  String diedDate;

  Data(
      {this.id,
      this.name,
      this.bio,
      this.image,
      this.birthDate,
      this.diedDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bio = json['bio'];
    image = json['image'];
    birthDate = json['birth_date'];
    diedDate = json['died_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['birth_date'] = this.birthDate;
    data['died_date'] = this.diedDate;
    return data;
  }
}