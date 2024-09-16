import 'package:flutter/material.dart';

// Basic Details Model
class BasicDetails {
  final String name;
  final String? sunSign;
  final String? city;
  final String dob;
  final String time;
  final String lat;
  final String lon;

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

// Ascendant Report Model
class AscendantReport {
  final String ascendant;
  final String ascendantLord;
  final String ascendantLordLocation;
  final int ascendantLordHouseLocation;
  final String generalPrediction;
  final String personalisedPrediction;
  final String verbalLocation;
  final String ascendantLordStrength;
  final String symbol;
  final String zodiacCharacteristics;
  final String luckyGem;
  final String dayForFasting;
  final String gayatriMantra;
  final String flagshipQualities;
  final String spiritualityAdvice;
  final String goodQualities;
  final String badQualities;

  AscendantReport({
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

  factory AscendantReport.fromJson(Map<String, dynamic> json) {
    return AscendantReport(
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

// Moon Sign Model
class MoonSign {
  final String moonSign;
  final String botResponse;
  final String prediction;

  MoonSign({
    required this.moonSign,
    required this.botResponse,
    required this.prediction,
  });

  factory MoonSign.fromJson(Map<String, dynamic> json) {
    return MoonSign(
      moonSign: json['moon_sign'],
      botResponse: json['bot_response'],
      prediction: json['prediction'],
    );
  }
}

// Sun Sign Model
class SunSign {
  final String sunSign;
  final String prediction;

  SunSign({
    required this.sunSign,
    required this.prediction,
  });

  factory SunSign.fromJson(Map<String, dynamic> json) {
    return SunSign(
      sunSign: json['sun_sign'],
      prediction: json['prediction'],
    );
  }
}

// Planet Details Model
class PlanetDetails {
  final String name;
  final String fullName;
  final double localDegree;
  final double globalDegree;
  final double progressInPercentage;
  final int rasiNo;
  final String zodiac;
  final int house;
  final String nakshatra;
  final String nakshatraLord;
  final int nakshatraPada;
  final int nakshatraNo;
  final String zodiacLord;
  final bool isPlanetSet;
  final String lordStatus;
  final String basicAvastha;
  final bool isCombust;

  PlanetDetails({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.globalDegree,
    required this.progressInPercentage,
    required this.rasiNo,
    required this.zodiac,
    required this.house,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.nakshatraPada,
    required this.nakshatraNo,
    required this.zodiacLord,
    required this.isPlanetSet,
    required this.lordStatus,
    required this.basicAvastha,
    required this.isCombust,
  });

  factory PlanetDetails.fromJson(Map<String, dynamic> json) {
    return PlanetDetails(
      name: json['name'],
      fullName: json['full_name'],
      localDegree: json['local_degree'],
      globalDegree: json['global_degree'],
      progressInPercentage: json['progress_in_percentage'],
      rasiNo: json['rasi_no'],
      zodiac: json['zodiac'],
      house: json['house'],
      nakshatra: json['nakshatra'],
      nakshatraLord: json['nakshatra_lord'],
      nakshatraPada: json['nakshatra_pada'],
      nakshatraNo: json['nakshatra_no'],
      zodiacLord: json['zodiac_lord'],
      isPlanetSet: json['is_planet_set'],
      lordStatus: json['lord_status'],
      basicAvastha: json['basic_avastha'],
      isCombust: json['is_combust'],
    );
  }
}
