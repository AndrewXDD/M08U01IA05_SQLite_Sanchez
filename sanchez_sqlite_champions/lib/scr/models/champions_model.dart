import 'dart:convert';

List<Champions> championsFromJson(String str) =>
    List<Champions>.from(json.decode(str).map((x) => Champions.fromJson(x)));

String championsToJson(List<Champions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Champions {
  int? id;
  String? nom;
  String? description;
  String? icon;
  String? lane;

  Champions({
    this.id,
    this.nom,
    this.description,
    this.icon,
    this.lane,
  });

  factory Champions.fromJson(Map<String, dynamic> json) => Champions(
        id: json["id"],
        nom: json["nom"],
        description: json["description"],
        icon: json["icon"],
        lane: json["lane"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "description": description,
        "icon": icon,
        "lane": lane,
      };
}
