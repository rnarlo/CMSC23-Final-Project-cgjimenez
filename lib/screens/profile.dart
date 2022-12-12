import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';
import 'package:cmsc23_project_cgjimenez/screens/signup.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileIcon = SizedBox(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Image(image: AssetImage('icons/profile.png')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10))
      ]),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            profileIcon,
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              "Name",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Text("Hello World!"),
          ],
        ),
      ),
    );
  }
}
