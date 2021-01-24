import 'package:equatable/equatable.dart';

class BookModel {
  List<Data> data;

  BookModel({this.data});

  BookModel.fromJson(Map<String, dynamic> json) {
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

// ignore: must_be_immutable
class Data extends Equatable{
  int id;
  String name;
  String desc;
  int authorId;
  String image;

  Data({this.id, this.name, this.desc, this.authorId, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    authorId = json['author_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['author_id'] = this.authorId;
    data['image'] = this.image;
    return data;
  }
  Data.toString(){
    print("id: $id name: $name desc: $desc author_id: $authorId image: $image");
  }

  @override
  List<Object> get props => [id,name,desc,authorId,image];
}