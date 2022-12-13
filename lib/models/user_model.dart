import 'dart:convert';

class User {
  String id;
  String firstName;
  String lastName;
  String address;
  String birthday;
  String bio;
  List<String>? friends;
  List<String>? receivedFriendRequests;
  List<String>? sentFriendRequests;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        friends: json['friends'],
        address: json['address'],
        birthday: json['birthday'],
        bio: json['bio'],
        receivedFriendRequests: json['receivedFriendRequests'],
        sentFriendRequests: json['sentFriendRequests']);
  }

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.birthday,
      required this.bio,
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
      'firstname': user.firstName,
      'lastname': user.lastName,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests
    };
  }
}
