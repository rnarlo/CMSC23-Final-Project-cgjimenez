import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23_project_cgjimenez/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc23_project_cgjimenez/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';

class UserArgument {
  final String id;
  UserArgument(this.id);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().users;
    final args = ModalRoute.of(context)!.settings.arguments as UserArgument;

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
              padding: const EdgeInsets.symmetric(vertical: 50.0),
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

              int index = 0;
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                User temp = User.fromJson(
                    snapshot.data?.docs[i].data() as Map<String, dynamic>);
                index = i;
                if (temp.id.toString() == args.id) break;
              }

              User user = User.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                children: <Widget>[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  profileIcon,
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Account ID: ${user.id}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  Text(
                    "\"${user.bio}\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  const Text(
                    "Current Location:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  const Text(
                    "Date of Birth:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.birthday,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  backButton
                ],
              );
            }));
  }
}
