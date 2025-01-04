class NumerologyResponse {
  Numerology numerology;

  NumerologyResponse({required this.numerology});

  factory NumerologyResponse.fromJson(Map<String, dynamic> json) {
    return NumerologyResponse(
      numerology: Numerology.fromJson(json['numerology']),
    );
  }
}

class Numerology {
  int status;
  NumerologyDetails response;

  Numerology({required this.status, required this.response});

  factory Numerology.fromJson(Map<String, dynamic> json) {
    return Numerology(
      status: json['status'],
      response: NumerologyDetails.fromJson(json['response']),
    );
  }
}

class NumerologyDetails {
  final NumerologyItem destiny;
  final NumerologyItem personality;
  final NumerologyItem attitude;
  final NumerologyItem character;
  final NumerologyItem soul;
  final NumerologyItem agenda;
  final NumerologyItem purpose;

  NumerologyDetails({
    required this.destiny,
    required this.personality,
    required this.attitude,
    required this.character,
    required this.soul,
    required this.agenda,
    required this.purpose,
  });

  factory NumerologyDetails.fromJson(Map<String, dynamic> json) {
    return NumerologyDetails(
      destiny: NumerologyItem.fromJson(json['destiny']),
      personality: NumerologyItem.fromJson(json['personality']),
      attitude: NumerologyItem.fromJson(json['attitude']),
      character: NumerologyItem.fromJson(json['character']),
      soul: NumerologyItem.fromJson(json['soul']),
      agenda: NumerologyItem.fromJson(json['agenda']),
      purpose: NumerologyItem.fromJson(json['purpose']),
    );
  }
}

class NumerologyItem {
  final String title;
  final String category;
  final String number;
  final bool master;
  final String meaning;
  final String description;

  NumerologyItem({
    required this.title,
    required this.category,
    required this.number,
    required this.master,
    required this.meaning,
    required this.description,
  });

  factory NumerologyItem.fromJson(Map<String, dynamic> json) {
    return NumerologyItem(
      title: json['title'],
      category: json['category'],
      number: json['number'],
      master: json['master'],
      meaning: json['meaning'],
      description: json['description'],
    );
  }
}
