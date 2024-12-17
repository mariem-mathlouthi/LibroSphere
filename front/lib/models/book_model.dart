class Book {
  final String id;
  final String title;
  final String author;
  final bool isAvailable;

  Book({required this.id, required this.title, required this.author, required this.isAvailable});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      isAvailable: json['isAvailable'],
    );
  }
}
