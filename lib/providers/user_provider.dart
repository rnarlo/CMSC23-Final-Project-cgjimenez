import 'package:flutter/material.dart';
import 'package:cmsc23_project_cgjimenez/api/firebase_user_api.dart';
import 'package:cmsc23_project_cgjimenez/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  late DocumentReference<Map<String, dynamic>> _fetchedUser;
  User? _selectedUser;

  UserListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _userStream;
  User get selected => _selectedUser!;

  changeSelectedUser(User user) {
    _selectedUser = user;
  }

  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  void fetchUser(String id) {
    _fetchedUser = firebaseService.getUser(id);
    notifyListeners();
  }

  void addFriend(String id, String id2) async {
    String message = await firebaseService.sendRequest(id, id2);
    print(message);
    notifyListeners();
  }

  void cancelRequest(String id, String id2) async {
    String message = await firebaseService.cancelRequest(id, id2);
    print(message);
    notifyListeners();
  }

  void acceptRequest(String id, String id2) async {
    String message = await firebaseService.acceptRequest(id, id2);
    print(message);
    notifyListeners();
  }

  void removeFriend(String id, String id2) async {
    String message = await firebaseService.removeFriend(id, id2);
    print(message);
    notifyListeners();
  }
}

class FriendListProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  late DocumentReference<Map<String, dynamic>> _fetchedUser;
  User? _selectedUser;

  FriendListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _userStream;
  User get selected => _selectedUser!;

  changeSelectedUser(User user) {
    _selectedUser = user;
  }

  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  void fetchUser(String id) {
    _fetchedUser = firebaseService.getUser(id);
    notifyListeners();
  }
}
