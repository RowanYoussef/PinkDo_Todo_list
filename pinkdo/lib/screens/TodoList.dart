import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinkdo/database/sql.dart';

class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Sqldb sqldb = Sqldb();

  Future<List<Map>> readData() async {
    List<Map> data =
        await sqldb.readData("SELECT * FROM tasks WHERE completed = 0");
    return data;
  }

  Future<List<Map>> readCompleted() async {
    List<Map> data =
        await sqldb.readData("SELECT * FROM tasks WHERE completed = 1");
    return data;
  }

  void deleteTask(int id) async {
    try {
      await sqldb.deleteData("DELETE FROM tasks WHERE id = $id");
      setState(() {});
    } catch (e) {
      print("Error deleting task with id $id: $e");
    }
  }

  void deleteAllTasks() async {
    try {
      await sqldb.deleteAllTasks();
      setState(() {});
    } catch (e) {
      print("Error deleting all tasks: $e");
    }
  }

  double calculateCompletionPercentage(
      List<Map> pendingTasks, List<Map> completedTasks) {
    int totalTasks = pendingTasks.length + completedTasks.length;
    if (totalTasks == 0) return 0.0;
    return completedTasks.length / totalTasks;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.pink[200]),
                      title: Text('Delete All Tasks',
                          style: TextStyle(color: Colors.pink[200])),
                      onTap: () {
                        deleteAllTasks();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.pink[200]),
                      title: Text('Your Wishes',
                          style: TextStyle(color: Colors.pink[200])),
                      onTap: () async {
                        final result =
                            await Navigator.pushNamed(context, '/WishList');
                        if (result != null && result == true) {
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
          child: FutureBuilder<List<List<Map>>>(
            future: Future.wait([readData(), readCompleted()]),
            builder: (BuildContext context,
                AsyncSnapshot<List<List<Map>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                List<Map> pendingTasks = snapshot.data![0];
                List<Map> completedTasks = snapshot.data![1];
                double completionPercentage =
                    calculateCompletionPercentage(pendingTasks, completedTasks);

                return Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 10.0,
                      percent: completionPercentage,
                      center: Text(
                        "${(completionPercentage * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      progressColor: Colors.pink[300],
                      backgroundColor: Colors.pink[100]!,
                    ),
                    SizedBox(height: 20),
                    pendingTasks.isEmpty && completedTasks.isEmpty
                        ? Center(
                            child: Text(
                              "No tasks available",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  pendingTasks.length + completedTasks.length,
                              itemBuilder: (context, i) {
                                Map task = {};
                                if (i >= pendingTasks.length) {
                                  task = completedTasks[i - pendingTasks.length];
                                }else{
                                  task = pendingTasks[i];
                                }
                                bool isChecked = task['completed'] == 1;
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    title: Text(
                                      "${task['task']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isChecked
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (task['DeadLine'] != null &&
                                            task['DeadLine'].isNotEmpty)
                                          Text(
                                            "DeadLine: ${task['DeadLine']}",
                                            style: TextStyle(
                                                color: Colors.pink[300]),
                                          ),
                                      ],
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
                                          onChanged: (bool? value) async {
                                            bool newValue = value ?? false;
                                            setState(() {
                                              isChecked = newValue;
                                            });
                                            try {
                                              await sqldb.updateData(
                                                  "UPDATE tasks SET completed = ${newValue ? 1 : 0} WHERE id = ${task['id']}");
                                            } catch (e) {
                                              print(
                                                  "Error updating task with id ${task['id']}: $e");
                                            }
                                          },
                                          activeColor: Colors.pink[300],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.pink.shade200),
                                          onPressed: () {
                                            deleteTask(task['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "Error loading tasks",
                    style: TextStyle(color: Colors.pink[200], fontSize: 18),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/Task');
          if (result != null) {
            setState(() {});
          }
        },
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
