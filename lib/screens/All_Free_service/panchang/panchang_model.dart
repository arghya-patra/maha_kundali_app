class Panchang {
  final String dayName;
  final Tithi tithi;
  final Nakshatra nakshatra;
  final Karana karana;
  final Yoga yoga;
  final AdvancedDetails advancedDetails;

  Panchang({
    required this.dayName,
    required this.tithi,
    required this.nakshatra,
    required this.karana,
    required this.yoga,
    required this.advancedDetails,
  });

  factory Panchang.fromJson(Map<String, dynamic> json) {
    return Panchang(
      dayName: json['day']['name'],
      tithi: Tithi.fromJson(json['tithi']),
      nakshatra: Nakshatra.fromJson(json['nakshatra']),
      karana: Karana.fromJson(json['karana']),
      yoga: Yoga.fromJson(json['yoga']),
      advancedDetails: AdvancedDetails.fromJson(json['advanced_details']),
    );
  }
}

class Tithi {
  final String name;
  final int number;
  final String nextTithi;
  final String type;
  final String diety;
  final String start;
  final String end;
  final String meaning;
  final String special;

  Tithi({
    required this.name,
    required this.number,
    required this.nextTithi,
    required this.type,
    required this.diety,
    required this.start,
    required this.end,
    required this.meaning,
    required this.special,
  });

  factory Tithi.fromJson(Map<String, dynamic> json) {
    return Tithi(
      name: json['name'],
      number: json['number'],
      nextTithi: json['next_tithi'],
      type: json['type'],
      diety: json['diety'],
      start: json['start'],
      end: json['end'],
      meaning: json['meaning'],
      special: json['special'],
    );
  }
}

class Nakshatra {
  final String name;
  final int number;
  final String lord;
  final String diety;
  final String start;
  final String end;
  final String meaning;
  final String special;
  final String summary;

  Nakshatra({
    required this.name,
    required this.number,
    required this.lord,
    required this.diety,
    required this.start,
    required this.end,
    required this.meaning,
    required this.special,
    required this.summary,
  });

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    return Nakshatra(
      name: json['name'],
      number: json['number'],
      lord: json['lord'],
      diety: json['diety'],
      start: json['start'],
      end: json['end'],
      meaning: json['meaning'],
      special: json['special'],
      summary: json['summary'] ?? '',
    );
  }
}

class Karana {
  final String name;
  final int number;
  final String type;
  final String lord;
  final String diety;
  final String start;
  final String end;
  final String special;
  final String nextKarana;

  Karana({
    required this.name,
    required this.number,
    required this.type,
    required this.lord,
    required this.diety,
    required this.start,
    required this.end,
    required this.special,
    required this.nextKarana,
  });

  factory Karana.fromJson(Map<String, dynamic> json) {
    return Karana(
      name: json['name'],
      number: json['number'],
      type: json['type'],
      lord: json['lord'],
      diety: json['diety'],
      start: json['start'],
      end: json['end'],
      special: json['special'],
      nextKarana: json['next_karana'],
    );
  }
}

class Yoga {
  final String name;
  final int number;
  final String start;
  final String end;
  final String meaning;
  final String special;
  final String nextYoga;

  Yoga({
    required this.name,
    required this.number,
    required this.start,
    required this.end,
    required this.meaning,
    required this.special,
    required this.nextYoga,
  });

  factory Yoga.fromJson(Map<String, dynamic> json) {
    return Yoga(
      name: json['name'],
      number: json['number'],
      start: json['start'],
      end: json['end'],
      meaning: json['meaning'],
      special: json['special'],
      nextYoga: json['next_yoga'],
    );
  }
}

class AdvancedDetails {
  final String sunRise;
  final String sunSet;
  final String moonRise;
  final String moonSet;

  AdvancedDetails({
    required this.sunRise,
    required this.sunSet,
    required this.moonRise,
    required this.moonSet,
  });

  factory AdvancedDetails.fromJson(Map<String, dynamic> json) {
    return AdvancedDetails(
      sunRise: json['sun_rise'],
      sunSet: json['sun_set'],
      moonRise: json['moon_rise'],
      moonSet: json['moon_set'],
    );
  }
}
