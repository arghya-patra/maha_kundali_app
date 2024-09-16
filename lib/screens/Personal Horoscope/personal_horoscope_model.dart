import 'dart:convert';

class HoroscopeResponse {
  Horoscope horoscope;
  Dosha dosha;
  PlanetDetails planetDetails;
  Dasha dasha;
  Chart chart;

  HoroscopeResponse({
    required this.horoscope,
    required this.dosha,
    required this.planetDetails,
    required this.dasha,
    required this.chart,
  });

  factory HoroscopeResponse.fromJson(Map<String, dynamic> json) {
    return HoroscopeResponse(
      horoscope: Horoscope.fromJson(json['horoscope']),
      dosha: Dosha.fromJson(json['dosha']),
      planetDetails: PlanetDetails.fromJson(json['planet_details']),
      dasha: Dasha.fromJson(json['dasha']),
      chart: Chart.fromJson(json['chart']),
    );
  }
}

class Horoscope {
  BasicDetails basicDetails;
  AscendantReport ascendantReport;
  MoonSign moonSign;
  SunSign sunSign;
  PersonalCharacteristics personalCharacteristics;

  Horoscope({
    required this.basicDetails,
    required this.ascendantReport,
    required this.moonSign,
    required this.sunSign,
    required this.personalCharacteristics,
  });

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      basicDetails: BasicDetails.fromJson(json['basic_details']),
      ascendantReport: AscendantReport.fromJson(json['ascendant_report']),
      moonSign: MoonSign.fromJson(json['moonsign']),
      sunSign: SunSign.fromJson(json['sunsign']),
      personalCharacteristics:
          PersonalCharacteristics.fromJson(json['personal_characteristics']),
    );
  }
}

class BasicDetails {
  String name;
  String? sunSign;
  String? city;
  String dob;
  String time;
  String lat;
  String lon;

  BasicDetails({
    required this.name,
    this.sunSign,
    this.city,
    required this.dob,
    required this.time,
    required this.lat,
    required this.lon,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      name: json['name'],
      sunSign: json['sun_sign'],
      city: json['city'],
      dob: json['dob'],
      time: json['time'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class AscendantReport {
  int status;
  List<AscendantResponse> response;

  AscendantReport({
    required this.status,
    required this.response,
  });

  factory AscendantReport.fromJson(Map<String, dynamic> json) {
    return AscendantReport(
      status: json['status'],
      response: List<AscendantResponse>.from(
          json['response'].map((x) => AscendantResponse.fromJson(x))),
    );
  }
}

class AscendantResponse {
  String ascendant;
  String ascendantLord;
  String ascendantLordLocation;
  int ascendantLordHouseLocation;
  String generalPrediction;
  String personalisedPrediction;
  String verbalLocation;
  String ascendantLordStrength;
  String symbol;
  String zodiacCharacteristics;
  String luckyGem;
  String dayForFasting;
  String gayatriMantra;
  String flagshipQualities;
  String spiritualityAdvice;
  String goodQualities;
  String badQualities;

  AscendantResponse({
    required this.ascendant,
    required this.ascendantLord,
    required this.ascendantLordLocation,
    required this.ascendantLordHouseLocation,
    required this.generalPrediction,
    required this.personalisedPrediction,
    required this.verbalLocation,
    required this.ascendantLordStrength,
    required this.symbol,
    required this.zodiacCharacteristics,
    required this.luckyGem,
    required this.dayForFasting,
    required this.gayatriMantra,
    required this.flagshipQualities,
    required this.spiritualityAdvice,
    required this.goodQualities,
    required this.badQualities,
  });

  factory AscendantResponse.fromJson(Map<String, dynamic> json) {
    return AscendantResponse(
      ascendant: json['ascendant'],
      ascendantLord: json['ascendant_lord'],
      ascendantLordLocation: json['ascendant_lord_location'],
      ascendantLordHouseLocation: json['ascendant_lord_house_location'],
      generalPrediction: json['general_prediction'],
      personalisedPrediction: json['personalised_prediction'],
      verbalLocation: json['verbal_location'],
      ascendantLordStrength: json['ascendant_lord_strength'],
      symbol: json['symbol'],
      zodiacCharacteristics: json['zodiac_characteristics'],
      luckyGem: json['lucky_gem'],
      dayForFasting: json['day_for_fasting'],
      gayatriMantra: json['gayatri_mantra'],
      flagshipQualities: json['flagship_qualities'],
      spiritualityAdvice: json['spirituality_advice'],
      goodQualities: json['good_qualities'],
      badQualities: json['bad_qualities'],
    );
  }
}

class MoonSign {
  int status;
  MoonSignResponse response;

  MoonSign({required this.status, required this.response});

  factory MoonSign.fromJson(Map<String, dynamic> json) {
    return MoonSign(
      status: json['status'],
      response: MoonSignResponse.fromJson(json['response']),
    );
  }
}

class MoonSignResponse {
  String moonSign;
  String botResponse;
  String prediction;

  MoonSignResponse({
    required this.moonSign,
    required this.botResponse,
    required this.prediction,
  });

  factory MoonSignResponse.fromJson(Map<String, dynamic> json) {
    return MoonSignResponse(
      moonSign: json['moon_sign'],
      botResponse: json['bot_response'],
      prediction: json['prediction'],
    );
  }
}

class SunSign {
  int status;
  SunSignResponse response;

  SunSign({required this.status, required this.response});

  factory SunSign.fromJson(Map<String, dynamic> json) {
    return SunSign(
      status: json['status'],
      response: SunSignResponse.fromJson(json['response']),
    );
  }
}

class SunSignResponse {
  String sunSign;
  String prediction;

  SunSignResponse({required this.sunSign, required this.prediction});

  factory SunSignResponse.fromJson(Map<String, dynamic> json) {
    return SunSignResponse(
      sunSign: json['sun_sign'],
      prediction: json['prediction'],
    );
  }
}

class PersonalCharacteristics {
  int status;
  List<AscendantResponse> response;

  PersonalCharacteristics({required this.status, required this.response});

  factory PersonalCharacteristics.fromJson(Map<String, dynamic> json) {
    return PersonalCharacteristics(
      status: json['status'],
      response: List<AscendantResponse>.from(
          json['response'].map((x) => AscendantResponse.fromJson(x))),
    );
  }
}

class Dosha {
  Kaalsarpdosh kaalsarpdosh;
  Mangaldosh mangaldosh;
  Pitradosh pitradosh;
  ManglikDosh manglikDosh;

  Dosha({
    required this.kaalsarpdosh,
    required this.mangaldosh,
    required this.pitradosh,
    required this.manglikDosh,
  });

  factory Dosha.fromJson(Map<String, dynamic> json) {
    return Dosha(
      kaalsarpdosh: Kaalsarpdosh.fromJson(json['kaalsarpdosh']),
      mangaldosh: Mangaldosh.fromJson(json['mangaldosh']),
      pitradosh: Pitradosh.fromJson(json['pitradosh']),
      manglikDosh: ManglikDosh.fromJson(json['manglik_dosh']),
    );
  }
}

class Kaalsarpdosh {
  bool isDoshaPresent;
  String botResponse;
  List<String> remedies;

  Kaalsarpdosh({
    required this.isDoshaPresent,
    required this.botResponse,
    required this.remedies,
  });

  factory Kaalsarpdosh.fromJson(Map<String, dynamic> json) {
    return Kaalsarpdosh(
      isDoshaPresent: json['response']['is_dosha_present'],
      botResponse: json['response']['bot_response'],
      remedies: List<String>.from(json['response']['remedies']),
    );
  }
}

class Mangaldosh {
  bool isDoshaPresent;
  String botResponse;
  List<String> remedies;

  Mangaldosh({
    required this.isDoshaPresent,
    required this.botResponse,
    required this.remedies,
  });

  factory Mangaldosh.fromJson(Map<String, dynamic> json) {
    return Mangaldosh(
      isDoshaPresent: json['response']['is_dosha_present'],
      botResponse: json['response']['bot_response'],
      remedies: List<String>.from(json['response']['remedies']),
    );
  }
}

class Pitradosh {
  bool isDoshaPresent;
  String botResponse;
  List<String> remedies;

  Pitradosh({
    required this.isDoshaPresent,
    required this.botResponse,
    required this.remedies,
  });

  factory Pitradosh.fromJson(Map<String, dynamic> json) {
    return Pitradosh(
      isDoshaPresent: json['response']['is_dosha_present'],
      botResponse: json['response']['bot_response'],
      remedies: List<String>.from(json['response']['remedies']),
    );
  }
}

class ManglikDosh {
  bool isManglik;
  String botResponse;
  List<String> remedies;

  ManglikDosh({
    required this.isManglik,
    required this.botResponse,
    required this.remedies,
  });

  factory ManglikDosh.fromJson(Map<String, dynamic> json) {
    return ManglikDosh(
      isManglik: json['is_manglik'],
      botResponse: json['bot_response'],
      remedies: List<String>.from(json['remedies']),
    );
  }
}

class PlanetDetails {
  List<Planet> planets;

  PlanetDetails({required this.planets});

  factory PlanetDetails.fromJson(Map<String, dynamic> json) {
    return PlanetDetails(
      planets:
          List<Planet>.from(json['response'].map((x) => Planet.fromJson(x))),
    );
  }
}

class Planet {
  String name;
  String zodiac;
  String nakshatra;
  String house;
  String longitude;
  String degrees;

  Planet({
    required this.name,
    required this.zodiac,
    required this.nakshatra,
    required this.house,
    required this.longitude,
    required this.degrees,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'],
      zodiac: json['zodiac'],
      nakshatra: json['nakshatra'],
      house: json['house'],
      longitude: json['longitude'],
      degrees: json['degrees'],
    );
  }
}

class Dasha {
  int currentDasha;
  List<DashaDetail> details;

  Dasha({
    required this.currentDasha,
    required this.details,
  });

  factory Dasha.fromJson(Map<String, dynamic> json) {
    return Dasha(
      currentDasha: json['current_dasha'],
      details: List<DashaDetail>.from(
          json['details'].map((x) => DashaDetail.fromJson(x))),
    );
  }
}

class DashaDetail {
  String planet;
  String startDate;
  String endDate;
  String prediction;

  DashaDetail({
    required this.planet,
    required this.startDate,
    required this.endDate,
    required this.prediction,
  });

  factory DashaDetail.fromJson(Map<String, dynamic> json) {
    return DashaDetail(
      planet: json['planet'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      prediction: json['prediction'],
    );
  }
}

class Chart {
  String chartType;
  List<ChartDetail> chartDetails;

  Chart({
    required this.chartType,
    required this.chartDetails,
  });

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      chartType: json['chart_type'],
      chartDetails: List<ChartDetail>.from(
          json['chart_details'].map((x) => ChartDetail.fromJson(x))),
    );
  }
}

class ChartDetail {
  String planet;
  String house;
  String rashi;

  ChartDetail({
    required this.planet,
    required this.house,
    required this.rashi,
  });

  factory ChartDetail.fromJson(Map<String, dynamic> json) {
    return ChartDetail(
      planet: json['planet'],
      house: json['house'],
      rashi: json['rashi'],
    );
  }
}
