class Astrologer {
  final String id;
  final String name;
  final String establish;
  final String experience;
  final String price;
  final String callRate;
  final String chatRate;
  final String pujaId;
  final String pujaName;
  final String logo;
  final List<String> skills;
  final List<String> languages;

  Astrologer({
    required this.id,
    required this.name,
    required this.establish,
    required this.experience,
    required this.price,
    required this.callRate,
    required this.chatRate,
    required this.pujaId,
    required this.pujaName,
    required this.logo,
    required this.skills,
    required this.languages,
  });

  factory Astrologer.fromJson(
      Map<String, dynamic> json, List<String> skills, List<String> languages) {
    return Astrologer(
      id: json['astrologer_id'],
      name: json['astrologer_name'],
      establish: json['establish'],
      experience: json['experience'],
      price: json['price'],
      callRate: json['call_rate'],
      chatRate: json['chat_rate'],
      pujaId: json['puja_id'],
      pujaName: json['puja_name'],
      logo: json['logo'],
      skills: skills,
      languages: languages,
    );
  }
}
