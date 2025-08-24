class Travel {
  final String id;
  final String title;
  final String country;
  final String region;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final String description;
  bool isFavorite; // only for ui, not for json

  Travel({
    required this.id,
    required this.title,
    required this.country,
    required this.region,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.description,
    this.isFavorite = false, // default runtime 
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      region: json['region'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      category: json['category'],
      description: json['description'],
      // isFavorite do not read from json
    );
  }

  Travel copyWith({
    String? id,
    String? title,
    String? country,
    String? region,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? description,
    bool? isFavorite,
  }) {
    return Travel(
      id: id ?? this.id,
      title: title ?? this.title,
      country: country ?? this.country,
      region: region ?? this.region,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'country': country,
      'region': region,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'category': category,
      'description': description,
      // isFavorite will come from firestore
    };
  }
}
