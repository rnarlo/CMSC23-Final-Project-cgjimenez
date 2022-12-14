import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  DocumentReference<Map<String, dynamic>> getUser(String id) {
    return db.collection("users").doc(id);
  }

  Future<String> sendRequest(String? id, String? id2) async {
    try {
      await db.collection("users").doc(id2).update({
        'receivedFriendRequests': FieldValue.arrayUnion([id])
      });

      await db.collection("users").doc(id).update({
        'sentFriendRequests': FieldValue.arrayUnion([id2])
      });

      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> acceptRequest(String? id, String? id2) async {
    try {
      await db.collection("users").doc(id2).update({
        'friends': FieldValue.arrayUnion([id])
      });
      await db.collection("users").doc(id).update({
        'friends': FieldValue.arrayUnion([id2])
      });

      var allTodos = db.collection('todos');
      var querySnapshots = await allTodos.get();
      for (var todo in querySnapshots.docs) {
        if (todo.id == id) {
          await todo.reference.update({
            'sharedWith': FieldValue.arrayUnion([id2]),
          });
        }
      }

      for (var todo in querySnapshots.docs) {
        if (todo.id == id2) {
          await todo.reference.update({
            'sharedWith': FieldValue.arrayUnion([id]),
          });
        }
      }

      await db.collection("users").doc(id2).update({
        'sentFriendRequests': FieldValue.arrayRemove([id])
      });
      await db.collection("users").doc(id).update({
        'receivedFriendRequests': FieldValue.arrayRemove([id2])
      });

      return "Successfully added friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> cancelRequest(String? id, String? id2) async {
    try {
      await db.collection("users").doc(id2).update({
        'receivedFriendRequests': FieldValue.arrayRemove([id])
      });

      await db.collection("users").doc(id).update({
        'sentFriendRequests': FieldValue.arrayRemove([id2])
      });

      return "Cancelled friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> removeFriend(String? id, String? id2) async {
    try {
      await db.collection("users").doc(id2).update({
        'friends': FieldValue.arrayRemove([id])
      });
      await db.collection("users").doc(id).update({
        'friends': FieldValue.arrayRemove([id2])
      });

      return "Successfully removed friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
