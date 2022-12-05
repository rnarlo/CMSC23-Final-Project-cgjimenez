import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController birthdayController = TextEditingController();
  DateTime dateSelected = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        birthdayController.text = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> firstnameKey = GlobalKey<FormState>();
    final GlobalKey<FormState> lastnameKey = GlobalKey<FormState>();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    final firstname = TextFormField(
      key: firstnameKey,
      controller: firstnameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'First Name',
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Last Name',
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
        border: OutlineInputBorder(),
        labelText: 'E-mail Address',
      ),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
    );

    final signupIcon = SizedBox(
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Image(image: AssetImage('icons/add-user.png')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10))
      ]),
    );

    final address = TextField(
      controller: addressController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Address',
      ),
    );

    final birthday = AbsorbPointer(
        child: GestureDetector(
            onTap: () => _selectDate(context),
            child: TextFormField(
              controller: birthdayController,
              decoration: const InputDecoration(
                labelText: "Birthday",
                icon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value!.isEmpty) return "Please enter a date for your task";
                return null;
              },
            )));

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: const Color.fromARGB(255, 67, 134, 221),
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 22),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () {
          // if (firstnameKey.currentState!.validate() &
          //     lastnameKey.currentState!.validate()) {
          context.read<AuthProvider>().signUp(
              firstnameController.text,
              lastnameController.text,
              emailController.text,
              passwordController.text,
              addressController.text);
          Navigator.pop(context);
          // }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: const Color.fromARGB(255, 67, 134, 221),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
            textStyle: const TextStyle(fontSize: 12)),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    final signupFields = SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          firstname,
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          lastname,
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          email,
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          password,
          const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
          address,
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          birthday,
          const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
          SignupButton,
          backButton
        ],
      ),
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            signupIcon,
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              "Get Started.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            signupFields,
          ],
        ),
      ),
    );
  }
}
