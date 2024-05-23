import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  String id, name, email, phone, address, password;



  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'address': this.address,
      'password': this.password,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      password: map['password'] as String,
    );
  }

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
  });
}
class CustomerSnapshot{
  Customer customer;
  DocumentReference ref;

  CustomerSnapshot({
    required this.customer,
    required this.ref,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer': this.customer,
      'ref': this.ref,
    };
  }

  factory CustomerSnapshot.fromJson(DocumentSnapshot docSnap) {
    return CustomerSnapshot(
      customer: Customer.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }


}