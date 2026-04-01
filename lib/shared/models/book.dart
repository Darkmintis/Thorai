class Book {
  final String slug;
  final String title;
  final String? englishTitle;
  final String? frontCover;
  final String? price;

  Book({
    required this.slug,
    required this.title,
    this.englishTitle,
    this.frontCover,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        slug: json['slug'] as String? ?? json['title'] as String? ?? 'unknown',
        title: json['title'] as String? ?? 'No Title',
        englishTitle: json['english_title'] as String?,
        frontCover: json['front_cover'] as String?,
        price: json['price'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'title': title,
        'english_title': englishTitle,
        'front_cover': frontCover,
        'price': price,
      };
}