class Matchmaking {
  BoyGirlDetails boyGirlDetails;
  Ashtakoot ashtakoot;

  Matchmaking({required this.boyGirlDetails, required this.ashtakoot});

  factory Matchmaking.fromJson(Map<String, dynamic> json) {
    return Matchmaking(
      boyGirlDetails: BoyGirlDetails.fromJson(json['boy_girl_details']),
      ashtakoot: Ashtakoot.fromJson(json['ashtakoot']['response']),
    );
  }
}

class BoyGirlDetails {
  String boyName;
  String boyDob;
  String boyLat;
  String boyLon;
  String boyTz;
  String girlName;
  String girlDob;
  String girlLat;
  String girlLon;
  String girlTz;

  BoyGirlDetails({
    required this.boyName,
    required this.boyDob,
    required this.boyLat,
    required this.boyLon,
    required this.boyTz,
    required this.girlName,
    required this.girlDob,
    required this.girlLat,
    required this.girlLon,
    required this.girlTz,
  });

  factory BoyGirlDetails.fromJson(Map<String, dynamic> json) {
    return BoyGirlDetails(
      boyName: json['boy_name'],
      boyDob: json['boy_dob'],
      boyLat: json['boy_lat'],
      boyLon: json['boy_lon'],
      boyTz: json['boy_tz'],
      girlName: json['girl_name'],
      girlDob: json['girl_dob'],
      girlLat: json['girl_lat'],
      girlLon: json['girl_lon'],
      girlTz: json['girl_tz'],
    );
  }
}

class Ashtakoot {
  String score;
  String botResponse;
  Map<String, AshtakootDetails> details;

  Ashtakoot({
    required this.score,
    required this.botResponse,
    required this.details,
  });

  factory Ashtakoot.fromJson(Map<String, dynamic> json) {
    return Ashtakoot(
      score: json['score'].toString(),
      botResponse: json['bot_response'],
      details: {
        "tara": AshtakootDetails.fromJson(json['tara']),
        "gana": AshtakootDetails.fromJson(json['gana']),
        "yoni": AshtakootDetails.fromJson(json['yoni']),
        "bhakoot": AshtakootDetails.fromJson(json['bhakoot']),
        "grahamaitri": AshtakootDetails.fromJson(json['grahamaitri']),
        "vasya": AshtakootDetails.fromJson(json['vasya']),
        "nadi": AshtakootDetails.fromJson(json['nadi']),
        "varna": AshtakootDetails.fromJson(json['varna']),
      },
    );
  }
}

class AshtakootDetails {
  String boyValue;
  String girlValue;
  String score;
  String description;
  String name;
  int fullScore;

  AshtakootDetails({
    required this.boyValue,
    required this.girlValue,
    required this.score,
    required this.description,
    required this.name,
    required this.fullScore,
  });

  factory AshtakootDetails.fromJson(Map<String, dynamic> json) {
    return AshtakootDetails(
      boyValue: json['boy_tara'] ?? json['boy_gana'] ?? json['boy_yoni'] ?? '',
      girlValue:
          json['girl_tara'] ?? json['girl_gana'] ?? json['girl_yoni'] ?? '',
      score: json['tara'].toString() ??
          json['gana'].toString() ??
          json['yoni'].toString() ??
          '',
      description: json['description'],
      name: json['name'],
      fullScore: json['full_score'],
    );
  }
}
