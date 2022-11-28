import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/todo_provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';
import 'package:cmsc23_project_cgjimenez/screens/todo_page.dart';
import 'package:cmsc23_project_cgjimenez/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {'/': (context) => const AuthWrapper()},
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const TodoPage();
    } else {
      return const LoginPage();
    }
  }
}
