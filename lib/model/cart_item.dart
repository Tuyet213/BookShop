import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem{
  String id;
  DocumentReference customerRef;
  DocumentReference bookRef;
  int quantity;

  CartItem({
    required this.id,
    required this.customerRef,
    required this.bookRef,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'customerRef': this.customerRef,
      'bookRef': this.bookRef,
      'quantity': this.quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      customerRef: map['customerRef'] as DocumentReference,
      bookRef: map['bookRef'] as DocumentReference,
      quantity: map['quantity'] as int,
    );
  }
}
class CartItemSnapshot{
  CartItem cartItem;
  DocumentReference ref;

  CartItemSnapshot({
    required this.cartItem,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'cartItem': this.cartItem,
      'ref': this.ref,
    };
  }

  factory CartItemSnapshot.fromJson(DocumentSnapshot docSnap) {
    return CartItemSnapshot(
      cartItem: CartItem.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
  static Future<DocumentReference> add(CartItem cartItem) async {
    return FirebaseFirestore.instance.collection("CartItems").add(cartItem.toJson());
  }

  Future<void> update(CartItem cartItem) async{
    return ref.update(cartItem.toJson());
  }

  Future<void> delete() async{
    return ref.delete();
  }

  static Stream<List<CartItemSnapshot>> getAll(){
    Stream<QuerySnapshot> sqs = FirebaseFirestore.instance.collection("CartItems").snapshots();
    return sqs.map(
            (qs) => qs.docs.map(
                (docSnap) => CartItemSnapshot.fromJson(docSnap)
        ).toList());
  }
}