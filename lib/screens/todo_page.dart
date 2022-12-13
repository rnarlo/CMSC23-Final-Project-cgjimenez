import 'package:cmsc23_project_cgjimenez/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/models/todo_model.dart';
import 'package:cmsc23_project_cgjimenez/providers/todo_provider.dart';
import 'package:cmsc23_project_cgjimenez/providers/auth_provider.dart';
import 'package:cmsc23_project_cgjimenez/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    final FirebaseAuth auth = FirebaseAuth.instance;
    List<Todo?> _userTodos = [];

    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        ListTile(
          title: const Text('View Profile'),
          trailing: const Icon(Icons.person),
          onTap: () {
            Navigator.pushNamed(context, '/profile',
                arguments: UserArgument(auth.currentUser!.uid));
          },
        ),
        ListTile(
          title: const Text('Manage Friends'),
          trailing: const Icon(Icons.person_search_sharp),
          onTap: () {
            Navigator.pushNamed(context, '/friends',
                arguments: UserArgument(auth.currentUser!.uid));
          },
        ),
        ListTile(
          title: const Text('Shared Todos'),
          trailing: const Icon(Icons.note_sharp),
          onTap: () {
            Navigator.pushNamed(context, '/shared_todos',
                arguments: UserArgument(auth.currentUser!.uid));
          },
        ),
        ListTile(
          title: const Text('Logout'),
          trailing: const Icon(Icons.logout),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ])),
      appBar: AppBar(
        title: const Text("Personal Todo List"),
        backgroundColor: const Color.fromARGB(255, 67, 134, 221),
      ),
      body: StreamBuilder(
        stream: todosStream,
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

          if (snapshot.hasData) {
            _userTodos.clear();
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[i].data() as Map<String, dynamic>);
              if (todo.userId == auth.currentUser!.uid) {
                _userTodos.add(todo);
              }
            }
          }

          if (_userTodos.isEmpty) {
            return const Center(
              child: Text("Add your first Todo!"),
            );
          }

          return ListView.builder(
            itemCount: _userTodos.length,
            itemBuilder: ((context, index) {
              Todo? todo = _userTodos[index];
              return Dismissible(
                key: Key(todo!.id.toString()),
                onDismissed: (direction) {
                  context.read<TodoListProvider>().changeSelectedTodo(todo);
                  context.read<TodoListProvider>().deleteTodo();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} dismissed')));
                },
                background: Container(
                  color: Color.fromARGB(255, 184, 59, 50),
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      context.read<TodoListProvider>().changeSelectedTodo(todo);
                      context.read<TodoListProvider>().toggleStatus(value!);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Edit',
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Delete',
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
