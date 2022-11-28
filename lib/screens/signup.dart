import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> firstnameKey = GlobalKey<FormState>();
    final GlobalKey<FormState> lastnameKey = GlobalKey<FormState>();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final firstname = TextFormField(
      key: firstnameKey,
      controller: firstnameController,
      decoration: InputDecoration(
        hintText: "First Name",
      ),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'This field cannot be empty!';
      //   }
      //   return null;
      // },
    );

    final lastname = TextFormField(
      key: lastnameKey,
      controller: lastnameController,
      decoration: InputDecoration(
        hintText: "Last Name",
      ),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'This field cannot be empty!';
      //   }
      //   return null;
      // },
    );

    final email = TextField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // if (firstnameKey.currentState!.validate() &
          //     lastnameKey.currentState!.validate()) {
          context.read<AuthProvider>().signUp(
              firstnameController.text,
              lastnameController.text,
              emailController.text,
              passwordController.text);
          Navigator.pop(context);
          // }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            firstname,
            lastname,
            email,
            password,
            SignupButton,
            backButton
          ],
        ),
      ),
    );
  }
}
