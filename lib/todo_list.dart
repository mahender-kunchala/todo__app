import "package:flutter/material.dart";
import 'package:todo_list/loading.dart';
import 'package:todo_list/services/database_service.dart';

import 'model/todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool iscomplete = false;
  TextEditingController todoTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>?>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              List<Todo>? todos = snapshot.data;

              return Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("All Todos",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey[200],
                            fontWeight: FontWeight.bold)),
                    Divider(color: Colors.grey[600]),
                    SizedBox(height: 10),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                      ),
                      shrinkWrap: true,
                      itemCount: (todos as dynamic).length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key((todos as dynamic)[index].title.toString()),
                          background: Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          onDismissed: (direction) async {
                            await DatabaseService()
                                .removeTodo((todos as dynamic)[index].uid);

                            //
                          },
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  DatabaseService().completeTask(
                                      (todos as dynamic)[index].uid);
                                });
                              },
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle),
                                child: (todos as dynamic)[index].iscomplete
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.grey[300],
                                      )
                                    : Container(),
                              ),
                              title: Text(
                                  (todos as dynamic)[index].title.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.w600))),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Row(
                      children: [
                        Text(
                          "Add Todo",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel),
                          color: Colors.grey,
                          iconSize: 30,
                        )
                      ],
                    ),
                    children: [
                      Divider(),
                      TextFormField(
                        controller: todoTextController,
                        autofocus: true,
                        style: TextStyle(
                            fontSize: 18, height: 1.5, color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "ex: workout",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (todoTextController.text.isNotEmpty) {
                                  await DatabaseService().createNewTodo(
                                      todoTextController.text.trim());
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Add"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )))))
                    ],
                  ));
        },
      ),
    );
  }
}
