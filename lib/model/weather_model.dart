class WeathterModel {
  List<Data>? list;

  WeathterModel(this.list);

  WeathterModel.fromJson(Map<String, dynamic> json) {
    if (json["list"] != null) {
      list = <Data>[];
      json["list"].forEach((v) {
        list!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  dynamic temp;
  dynamic pressure;
  dynamic humidity;
  List<Weather>? weather;
  Wind? wind;
  String? dt_txt;

  Data.fromJson(Map<String, dynamic> json) {
    temp = json['main']["temp"];
    pressure = json['main']['pressure'];
    humidity = json['main']['humidity'];
    if (json["weather"] != null) {
      weather = <Weather>[];
      json["weather"].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    wind = json["wind"] != null ? Wind.fromJson(json["wind"]) : null;
    dt_txt = json["dt_txt"];
  }
}

class Weather {
  String? main;

  Weather.fromJson(Map<String, dynamic> json) {
    main = json["main"];
  }
}

class Wind {
  dynamic speed;

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json["speed"];
  }
}
