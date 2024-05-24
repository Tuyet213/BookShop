import 'package:cloud_firestore/cloud_firestore.dart';

class Staff{
  String id, name, email, phone, password;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'password': this.password,
    };
  }

  factory Staff.fromJson(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
    );
  }
}
class StaffSnapshot{
  Staff staff;
  DocumentReference ref;

  StaffSnapshot({
    required this.staff,
    required this.ref,
  });

  Map<String, dynamic> toJSon() {
    return {
      'staff': this.staff,
      'ref': this.ref,
    };
  }

  factory StaffSnapshot.fromJson(DocumentSnapshot docSnap) {
    return StaffSnapshot(
      staff: Staff.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
  static Future<DocumentReference> add(Staff staff) async {
    return FirebaseFirestore.instance.collection("Staffs").add(staff.toJson());
  }

  Future<void> update(Staff staff) async{
    return ref.update(staff.toJson());
  }

  static Stream<List<StaffSnapshot>> getAll(){
    Stream<QuerySnapshot> sqs = FirebaseFirestore.instance.collection("Staffs").snapshots();
    return sqs.map(
            (qs) => qs.docs.map(
                (docSnap) => StaffSnapshot.fromJson(docSnap)
        ).toList());
  }
}