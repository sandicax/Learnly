import 'dart:convert';

List<CourseList> courseListFromJson(String str) =>
    List<CourseList>.from(json.decode(str).map((x) => CourseList.fromJson(x)));

String courseListToJson(List<CourseList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseList {
  CourseList({
    this.id,
    this.usermail,
    this.title,
    this.description,
    this.date,
    this.time,
    this.category,
    this.available,
    this.basicprice,
    this.basicdescription,
    this.basichours,
    this.standardprice,
    this.standarddesc,
    this.standardhours,
    this.premiumprice,
    this.premiumdesc,
    this.premiumhours,
    this.rating,
    this.imagepath,
    this.fullname,
    this.v,
  });

  String id;
  String usermail;
  String title;
  String description;
  String date;
  String time;
  String category;
  String available;
  String basicprice;
  String basicdescription;
  String basichours;
  String rating;
  String standardprice;
  String standarddesc;
  String standardhours;
  String premiumprice;
  String premiumdesc;
  String premiumhours;
  String imagepath;
  String fullname;
  int v;

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
        id: json["_id"],
        usermail: json["usermail"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        time: json["time"],
        category: json["category"],
        available: json["available"],
        basicprice: json["basicprice"],
        basicdescription: json["basicdescription"],
        basichours: json["basichours"],
        standardprice: json["standardprice"],
        standarddesc: json["standarddesc"],
        rating: json["rating"],
        standardhours: json["standardhours"],
        premiumprice: json["premiumprice"],
        premiumdesc: json["premiumdesc"],
        premiumhours: json["premiumhours"],
        imagepath: json["imagepath"],
        fullname: json["fullname"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "usermail": usermail,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        "category": category,
        "available": available,
        "basicprice": basicprice,
        "basicdescription": basicdescription,
        "basichours": basichours,
        "standardprice": standardprice,
        "standarddesc": standarddesc,
        "standardhours": standardhours,
        "premiumprice": premiumprice,
        "premiumdesc": premiumdesc,
        "premiumhours": premiumhours,
        "imagepath": imagepath,
        "rating": rating,
        "fullname": fullname,
        "__v": v,
      };
}
