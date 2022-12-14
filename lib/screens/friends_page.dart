import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23_project_cgjimenez/providers/user_provider.dart';
import 'package:cmsc23_project_cgjimenez/screens/other_profile.dart';
import 'package:cmsc23_project_cgjimenez/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:cmsc23_project_cgjimenez/models/user_model.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});
  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<User> usersSearch = [];
  List<User> friends = [];
  List<User> friendReqs = [];
  late User currentUser;
  TextEditingController searchController = TextEditingController();
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().users;

    final profileIcon = SizedBox(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Image(image: AssetImage('icons/profile.png')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10))
      ]),
    );

    final backButton = Center(
        child: SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 67, 134, 221),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 13),
                    textStyle: const TextStyle(fontSize: 12)),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child:
                    const Text('Back', style: TextStyle(color: Colors.white)),
              ),
            )));

    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                User temp = User.fromJson(
                    snapshot.data?.docs[i].data() as Map<String, dynamic>);
                if (temp.id == auth.currentUser?.uid) {
                  currentUser = temp;
                  break;
                }
              }

              if (searchController.text.isEmpty) {
                friends.clear();
                friendReqs.clear();
                usersSearch.clear();
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  User temp = User.fromJson(
                      snapshot.data?.docs[i].data() as Map<String, dynamic>);
                  if (currentUser.sentFriendRequests.contains(temp.id) ||
                      currentUser.friends.contains(temp.id)) {
                    friends.add(temp);
                  }
                  if (currentUser.receivedFriendRequests.contains(temp.id)) {
                    friendReqs.add(temp);
                  }
                }
              }

              final currentFriends = Center(
                child: Container(
                  width: 460,
                  height: 225,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        offset: Offset(0, -5.0),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: ((context, index) {
                      User? user = friends[index];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            context
                                .read<UserListProvider>()
                                .changeSelectedUser(user);
                            Navigator.pushNamed(context, '/friend_profile',
                                arguments: UserArgumentFriend(user.id));
                          });
                        },
                        leading: Icon(Icons.person),
                        title: Text(
                            "${friends[index].firstName} ${friends[index].lastName}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Color.fromRGBO(212, 57, 65, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 13),
                              textStyle: const TextStyle(fontSize: 12)),
                          onPressed: () {
                            setState(() {
                              friends.remove(user);
                              context
                                  .read<UserListProvider>()
                                  .changeSelectedUser(user);

                              if (currentUser.friends.contains(user.id)) {
                                context
                                    .read<UserListProvider>()
                                    .removeFriend(currentUser.id, user.id);
                              } else {
                                context
                                    .read<UserListProvider>()
                                    .cancelRequest(currentUser.id, user.id);
                              }
                            });
                          },
                          child: currentUser.friends.contains(user.id)
                              ? Text('Unfriend',
                                  style: TextStyle(color: Colors.white))
                              : Text('Cancel',
                                  style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }),
                  ),
                ),
              );

              final friendRequests = Center(
                child: Container(
                  width: 460,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListView.builder(
                    itemCount: friendReqs.length,
                    itemBuilder: ((context, index) {
                      User? user = friendReqs[index];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            context
                                .read<UserListProvider>()
                                .changeSelectedUser(user);
                            Navigator.pushNamed(context, '/friend_profile',
                                arguments: UserArgumentFriend(user.id));
                          });
                        },
                        leading: Icon(Icons.person),
                        title: Text(
                            "${friendReqs[index].firstName} ${friendReqs[index].lastName}"),
                        trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:
                                    Color.fromARGB(255, 72, 139, 83),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 13),
                                textStyle: const TextStyle(fontSize: 12)),
                            onPressed: () {
                              setState(() {
                                context
                                    .read<UserListProvider>()
                                    .changeSelectedUser(user);

                                context
                                    .read<UserListProvider>()
                                    .acceptRequest(currentUser.id, user.id);

                                friendReqs.remove(user);
                              });
                            },
                            child: Text('Accept',
                                style: TextStyle(color: Colors.white))),
                      );
                    }),
                  ),
                ),
              );

              final searchResults = Center(
                child: Container(
                  width: 460,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListView.builder(
                    itemCount: usersSearch.length,
                    itemBuilder: ((context, index) {
                      User? user = usersSearch[index];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            context
                                .read<UserListProvider>()
                                .changeSelectedUser(user);
                            Navigator.pushNamed(context, '/friend_profile',
                                arguments: UserArgumentFriend(user.id));
                          });
                        },
                        leading: Icon(Icons.person),
                        title: Text(
                            "${usersSearch[index].firstName} ${usersSearch[index].lastName}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 67, 134, 221),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 13),
                              textStyle: const TextStyle(fontSize: 12)),
                          onPressed: () {
                            setState(() {
                              context
                                  .read<UserListProvider>()
                                  .changeSelectedUser(user);

                              context
                                  .read<UserListProvider>()
                                  .addFriend(currentUser.id, user.id);

                              friends.add(user);
                              usersSearch.remove(user);
                            });
                          },
                          child: const Text('Add',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }),
                  ),
                ),
              );

              final searchBar = Center(
                  child: SizedBox(
                      width: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              friendReqs.clear();
                              usersSearch.clear();
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                User temp = User.fromJson(snapshot.data?.docs[i]
                                    .data() as Map<String, dynamic>);
                                String fullName =
                                    "${temp.firstName} ${temp.lastName}";

                                // Make sure self is not shown
                                if (temp.id == auth.currentUser?.uid) {
                                  continue;
                                }

                                if (fullName
                                        .toUpperCase()
                                        .contains(value.toUpperCase()) &
                                    value.isNotEmpty &
                                    !currentUser.sentFriendRequests
                                        .contains(temp.id) &
                                    !currentUser.friends.contains(temp.id) &
                                    !currentUser.receivedFriendRequests
                                        .contains(temp.id)) {
                                  usersSearch.add(temp);
                                }
                              }
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Search for other people!',
                              prefixIcon: Icon(Icons.search_outlined)),
                        ),
                      )));

              return SingleChildScrollView(
                  child: Center(
                      child: Column(
                children: [
                  searchBar,
                  SizedBox(
                    height: 500,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 490,
                          top: 0,
                          child: searchController.text.isEmpty
                              ? friendRequests
                              : searchResults,
                        ),
                        Positioned(
                          left: 490,
                          bottom: 25,
                          child: currentFriends,
                        ),
                      ],
                    ),
                  ),
                  backButton
                ],
              )));
            }));
  }
}
