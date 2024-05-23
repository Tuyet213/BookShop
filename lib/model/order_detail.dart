import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail{
  String id, orderId, bookId;
  double price;
  int quantity;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.bookId,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'orderId': this.orderId,
      'bookId': this.bookId,
      'price': this.price,
      'quantity': this.quantity,
    };
  }

  factory OrderDetail.fromJson(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      bookId: map['bookId'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
    );
  }
}
class OrderDetailSnapshot{
  OrderDetail orderDetail;
  DocumentReference ref;

  OrderDetailSnapshot({
    required this.orderDetail,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderDetail': this.orderDetail,
      'ref': this.ref,
    };
  }

  factory OrderDetailSnapshot.fromJson(DocumentSnapshot docSnap) {
    return OrderDetailSnapshot(
      orderDetail: OrderDetail.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
}