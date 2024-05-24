import 'package:bookshop/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String id;
  DocumentReference customerRef;
  DocumentReference staffRef;
  DocumentReference statusRef;

  Order({
    required this.id,
    required this.customerRef,
    required this.staffRef,
    required this.statusRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'customerRef': this.customerRef,
      'staffRef': this.staffRef,
      'statusRef': this.statusRef,
    };
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      customerRef: map['customerRef'] as DocumentReference,
      staffRef: map['staffRef'] as DocumentReference,
      statusRef: map['statusRef'] as DocumentReference,
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
  static Future<DocumentReference> add(Order order) async {
    return FirebaseFirestore.instance.collection("Orders").add(order.toJson());
  }

  Future<void> update(Order order) async{
    return ref.update(order.toJson());
  }

  static Stream<List<OrderSnapshot>> getAll(){
    Stream<QuerySnapshot> sqs = FirebaseFirestore.instance.collection("Orders").snapshots();
    return sqs.map(
            (qs) => qs.docs.map(
                (docSnap) => OrderSnapshot.fromJson(docSnap)
        ).toList());
  }
}