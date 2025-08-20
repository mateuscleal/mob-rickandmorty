
class Episode {
  final String id;
  final String date;
  final String title;
  final String imagePath;
  final String episodeName;
  final List<dynamic> characters;
  final bool isWatched;
  final bool isFavorite;

  Episode({
    required this.id,
    required this.date,
    required this.title,
    required this.imagePath,
    required this.episodeName,
    required this.characters,
    this.isWatched = false,
    this.isFavorite = false,
  });

  Episode copyWith({String? imagePath, bool? isWatched, bool? isFavorite}) {
    return Episode(
      id: id,
      date: date,
      title: title,
      imagePath: imagePath ?? this.imagePath,
      episodeName: episodeName,
      characters: characters,
      isWatched: isWatched ?? this.isWatched,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Episode.fromMap(Map<String, dynamic> map, dynamic hiveData) {
    return Episode(
      id: map['id'],
      title: map['name'],
      date: map['air_date'],
      characters: map['characters'],
      episodeName: map['episode'],
      imagePath: hiveData[2] ?? map['characters'][0]['image'],
      isWatched: hiveData[0] ?? false,
      isFavorite: hiveData[1] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'imagePath': imagePath,
      'episodeName': episodeName,
      'characters': characters,
      'isWatched': isWatched,
      'isFavorite': isFavorite,
    };
  }
}
