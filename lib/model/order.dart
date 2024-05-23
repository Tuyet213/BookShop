import 'package:bookshop/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String id, customerId, staffId, statusId;

  Order({
    required this.id,
    required this.customerId,
    required this.staffId,
    required this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'customerId': this.customerId,
      'staffId': this.staffId,
      'statusId': this.statusId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      staffId: map['staffId'] as String,
      statusId: map['statusId'] as String,
    );
  }
}
class OrderSnapshot{
  Order order;
  DocumentReference ref;

  OrderSnapshot({
    required this.order,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'order': this.order,
      'ref': this.ref,
    };
  }

  factory OrderSnapshot.fromJson(DocumentSnapshot docSnap) {
    return OrderSnapshot(
      order: Order.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
}