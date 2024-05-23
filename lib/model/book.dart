import 'package:cloud_firestore/cloud_firestore.dart';

class Book{
  String id, name, bookTypeId, description, image;
  double price;
  int quantity, publicationYear;

  Book({
    required this.id,
    required this.name,
    required this.bookTypeId,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.publicationYear,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'bookTypeId': this.bookTypeId,
      'description': this.description,
      'image': this.image,
      'price': this.price,
      'quantity': this.quantity,
      'publicationYear': this.publicationYear,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      name: map['name'] as String,
      bookTypeId: map['bookTypeId'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      publicationYear: map['publicationYear'] as int,
    );
  }
}
class BookSnapshot{
  Book book;
  DocumentReference ref;

  BookSnapshot({
    required this.book,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'book': this.book,
      'ref': this.ref,
    };
  }

  factory BookSnapshot.fromJson(DocumentSnapshot docSnap) {
    return BookSnapshot(
      book: Book.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
}