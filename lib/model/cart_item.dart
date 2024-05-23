import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem{
  String id, customerId, bookId;
  int quantity;

  CartItem({
    required this.id,
    required this.customerId,
    required this.bookId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'customerId': this.customerId,
      'bookId': this.bookId,
      'quantity': this.quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      bookId: map['bookId'] as String,
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
}