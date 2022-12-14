import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/models/todo_model.dart';
import 'package:cmsc23_project_cgjimenez/models/user_model.dart';
import 'package:cmsc23_project_cgjimenez/providers/todo_provider.dart';
import 'package:cmsc23_project_cgjimenez/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../providers/user_provider.dart';

class SharedTodoPage extends StatefulWidget {
  const SharedTodoPage({super.key});

  @override
  State<SharedTodoPage> createState() => _SharedTodoPageState();
}

class _SharedTodoPageState extends State<SharedTodoPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().users;
    Stream<QuerySnapshot> sharedTodosStream =
        context.watch<SharedTodoListProvider>().todos;
    late User currentUser;

    final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
    List<Todo?> _userTodos = [];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: const Text("Shared Todo List"),
        backgroundColor: const Color.fromARGB(255, 67, 134, 221),
      ),
      body: StreamBuilder(
          stream: userStream,
          builder: (context, snapshot1) {
            String getFullName(String id) {
              String fullName = "";
              for (int i = 0; i < snapshot1.data!.docs.length; i++) {
                User user = User.fromJson(
                    snapshot1.data?.docs[i].data() as Map<String, dynamic>);
                if (user.id == id) {
                  fullName = "${user.firstName} ${user.lastName}";
                }
              }
              return fullName;
            }

            if (snapshot1.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot1.error}"),
              );
            } else if (snapshot1.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: sharedTodosStream,
              builder: (context, snapshot2) {
                if (snapshot2.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot2.error}"),
                  );
                } else if (snapshot2.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot1.hasData) {
                  for (int i = 0; i < snapshot1.data!.docs.length; i++) {
                    User temp = User.fromJson(
                        snapshot1.data?.docs[i].data() as Map<String, dynamic>);
                    if (temp.id == auth.currentUser?.uid) {
                      currentUser = temp;
                      break;
                    }
                  }

                  _userTodos.clear();
                  for (int j = 0; j < snapshot2.data!.docs.length; j++) {
                    Todo todo = Todo.fromJson(
                        snapshot2.data?.docs[j].data() as Map<String, dynamic>);
                    if (todo.userId == auth.currentUser!.uid ||
                        currentUser.friends.contains(todo.userId)) {
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
                    return ListTile(
                      title: Text(todo!.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "(${getFullName(todo.userId)})",
                            style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.italic,
                              fontSize: 10,
                            ),
                          ),
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
                        ],
                      ),
                    );
                  }),
                );
              },
            );
          }),
      /////
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
