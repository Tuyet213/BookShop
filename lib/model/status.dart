import 'package:cloud_firestore/cloud_firestore.dart';

class Status{
  String id, name;

  Status({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
    };
  }

  factory Status.fromJson(Map<String, dynamic> map) {
    return Status(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
class StatusSnapshot{
  Status status;
  DocumentReference ref;

  StatusSnapshot({
    required this.status,
    required this.ref,
  });

  Map<String, dynamic> toJon() {
    return {
      'status': this.status,
      'ref': this.ref,
    };
  }

  factory StatusSnapshot.fromJson(DocumentSnapshot docSnap) {
    return StatusSnapshot(
      status: Status.fromJson(docSnap.data() as Map<String, dynamic>),
      ref: docSnap.reference,
    );
  }
}