import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';

class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Sqldb sqldb = Sqldb();
  Future<List<Map>> readData() async {
    List<Map> data = await sqldb.readData("SELECT * FROM tasks");
    return data;
  }

  void deleteTask(int id) async {
    await sqldb.deleteData("DELETE FROM tasks WHERE id = $id");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    sqldb.insertData("INSERT INTO 'tasks' ('task') VALUES ('task one')");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink[300],
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.pink[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: FutureBuilder(
            future: readData(),
            builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No tasks available",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      bool isChecked = snapshot.data![i]['completed'] == 1;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            "${snapshot.data![i]['task']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: isChecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isChecked ? Colors.grey : Colors.black,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.pink[200],
                            child: Icon(
                              Icons.task,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    snapshot.data![i]['completed'] =
                                        value! ? 1 : 0;
                                    // Update the database
                                    sqldb.updateData(
                                        "UPDATE tasks SET completed = ${value ? 1 : 0} WHERE id = ${snapshot.data![i]['id']}");
                                  });
                                },
                                activeColor: Colors.pink[300],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.pink.shade200),
                                onPressed: () {
                                  deleteTask(snapshot.data![i]['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: Text(
                    "Error loading tasks",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.pink[300],
        child: Icon(Icons.add),
      ),
    );
  }
}
