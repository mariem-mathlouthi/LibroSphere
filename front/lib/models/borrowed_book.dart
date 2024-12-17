class BorrowedBook {
  final String id;
  final String bookId, bookTitle;
  final String userId, username;
  final bool returned;
  final DateTime? returnDate, borrowDate;

  BorrowedBook({
    
    required this.id, required this.bookId, required this.userId, required this.returned, this.returnDate, this.borrowDate,
      required this.bookTitle, required this.username
    });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      id: json['_id'],
      bookId: json['bookId'],
      userId: json['userId'],
      bookTitle: json['bookTitle'],
      username: json['userName'],
      returned: json['returned'],
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      borrowDate: json['borrowDate'] != null ? DateTime.parse(json['borrowDate']) : null,
    );
  }
}
