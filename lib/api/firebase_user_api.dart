import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("user").snapshots();
  }

  Future<String> sendRequest(String? id, String? id2, List<String>? newList,
      List<String>? newList2) async {
    try {
      await db
          .collection("user")
          .doc(id2)
          .update({'receivedFriendRequests': newList2});

      await db
          .collection("user")
          .doc(id)
          .update({'sentFriendRequests': newList});

      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
