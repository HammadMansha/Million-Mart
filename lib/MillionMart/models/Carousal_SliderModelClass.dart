class Carousal_Slider {
  int? id;
  String? photo;

  Carousal_Slider({required this.id, required this.photo});

  Carousal_Slider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    return data;
  }
}