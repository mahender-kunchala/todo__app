import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/model/todo.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection("Todos");
  Future createNewTodo(String title) async {
    await todosCollection.add({
      "title": title,
      "iscomplete": false,
    });
  }

  Future completeTask(uid) async {
    await todosCollection.doc(uid).update({"iscomplete": true});
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo>? todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(e.id, (e.data() as dynamic)["title"],
            (e.data() as dynamic)["iscomplete"]);
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>?> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
