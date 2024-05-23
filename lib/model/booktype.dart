import 'package:cloud_firestore/cloud_firestore.dart';

class BookType{
  String id, name;

  BookType({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
    };
  }

  factory BookType.fromJson(Map<String, dynamic> map) {
    return BookType(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
class BookTypeSnapshot{
  BookType bookType;
  DocumentReference ref;

  BookTypeSnapshot({
    required this.bookType,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookType': this.bookType,
      'ref': this.ref,
    };
  }

  factory BookTypeSnapshot.fromJson(DocumentSnapshot docSnap) {
    return BookTypeSnapshot(
      bookType: BookType.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
}