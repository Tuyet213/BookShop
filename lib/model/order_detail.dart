import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail{
  String id;
  DocumentReference orderRef;
  DocumentReference bookRef;
  double price;
  int quantity;

  OrderDetail({
    required this.id,
    required this.orderRef,
    required this.bookRef,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'orderRef': this.orderRef,
      'bookRef': this.bookRef,
      'price': this.price,
      'quantity': this.quantity,
    };
  }

  factory OrderDetail.fromJson(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'] as String,
      orderRef: map['orderRef'] as DocumentReference,
      bookRef: map['bookRef'] as DocumentReference,
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
  static Future<DocumentReference> add(OrderDetail orderDetail) async {
    return FirebaseFirestore.instance.collection("OrderDetails").add(orderDetail.toJson());
  }

  Future<void> update(OrderDetail orderDetail) async{
    return ref.update(orderDetail.toJson());
  }

  Future<void> delete() async{
    return ref.delete();
  }

  static Stream<List<OrderDetailSnapshot>> getAll(){
    Stream<QuerySnapshot> sqs = FirebaseFirestore.instance.collection("OrderDetails").snapshots();
    return sqs.map(
            (qs) => qs.docs.map(
                (docSnap) => OrderDetailSnapshot.fromJson(docSnap)
        ).toList());
  }
  static Stream<List<OrderDetailSnapshot>> getByOrderRef(DocumentReference orderRef) {
    Stream<QuerySnapshot> sqs = FirebaseFirestore.instance
        .collection("OrderDetails")
        .where('orderRef', isEqualTo: orderRef)
        .snapshots();
    return sqs.map((qs) => qs.docs.map((docSnap) => OrderDetailSnapshot.fromJson(docSnap)).toList());
  }
}
