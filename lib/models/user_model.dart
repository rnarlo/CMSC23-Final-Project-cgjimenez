import 'dart:convert';

class User {
  String? id;
  String username;
  String displayName;
  List<String>? friends;
  List<String>? receivedFriendRequests;
  List<String>? sentFriendRequests;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        displayName: json['displayName'],
        friends: json['friends'],
        receivedFriendRequests: json['receivedFriendRequests'],
        sentFriendRequests: json['sentFriendRequests']);
  }

  User(
      {this.id,
      required this.username,
      required this.displayName,
      this.friends,
      this.receivedFriendRequests,
      this.sentFriendRequests});

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'username': user.username,
      'displayName': user.displayName,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests
    };
  }
}
