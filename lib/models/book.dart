class Book {
  final int id;
  final String title;
  final String? englishTitle;
  final String? frontCover;

  Book({
    required this.id,
    required this.title,
    this.englishTitle,
    this.frontCover,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] is int ? json['id'] as int : 0,
        title: json['title'] as String? ?? 'No Title',
        englishTitle: json['english_title'] as String?,
        frontCover: json['front_cover'] as String?,
      );
}