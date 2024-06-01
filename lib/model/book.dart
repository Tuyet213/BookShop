import 'package:cloud_firestore/cloud_firestore.dart';

import 'booktype.dart';

class Book {
  String id, name, description, image, author;
  double price;
  int quantity, publicationYear;
  DocumentReference bookTypeRef;

  Book({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.author,
    required this.price,
    required this.quantity,
    required this.publicationYear,
    required this.bookTypeRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'image': this.image,
      'author': this.author,
      'price': this.price,
      'quantity': this.quantity,
      'publicationYear': this.publicationYear,
      'bookTypeRef': this.bookTypeRef,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      author: map['author'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      publicationYear: map['publicationYear'] as int,
      bookTypeRef: map['bookTypeRef'] as DocumentReference,
    );
  }
}

class BookSnapshot {
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
  static Future<DocumentReference> add(Book book) async {
    return FirebaseFirestore.instance.collection("Books").add(book.toJson());
  }

  Future<void> update(Book book) async {
    return ref.update(book.toJson());
  }

  static Stream<List<BookSnapshot>> getAll() {
    Stream<QuerySnapshot> sqs =
        FirebaseFirestore.instance.collection("Books").snapshots();
    return sqs.map((qs) =>
        qs.docs.map((docSnap) => BookSnapshot.fromJson(docSnap)).toList());
  }

  static Future<String> getBookTypeName(DocumentReference bookTypeRef) async {
    DocumentSnapshot docSnap = await bookTypeRef.get();
    BookType bookType =
        BookType.fromJson(docSnap.data() as Map<String, dynamic>);
    return bookType.name.toString();
  }
}
