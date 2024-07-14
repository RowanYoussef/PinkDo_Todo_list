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
    List<Map> data = await sqldb.readData("SELECT * FROM tasks");
    return data;
  }

  void deleteTask(int id) async {
    await sqldb.deleteData("DELETE FROM tasks WHERE id = $id");
    setState(() {});
  }

  void deleteAllTasks() async {
    await sqldb.deleteAllTasks();
    setState(() {});
  }

  double calculateCompletionPercentage(List<Map> tasks) {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task['completed'] == 1).length;
    return completedTasks / tasks.length;
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
                          setState(() {Navigator.pop(context);});
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
          child: FutureBuilder(
            future: readData(),
            builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                double completionPercentage =
                    calculateCompletionPercentage(snapshot.data!);
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
                    snapshot.data!.isEmpty
                        ? Center(
                            child: Text(
                              "No tasks available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                bool isChecked =
                                    snapshot.data![i]['completed'] == 1;
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
                                        color: isChecked
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (snapshot.data![i]['DeadLine'] !=
                                                null &&
                                            snapshot.data![i]['DeadLine']
                                                .isNotEmpty)
                                          Text(
                                            "DeadLine: ${snapshot.data![i]['DeadLine']}",
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
                                            await sqldb.updateData(
                                                "UPDATE tasks SET completed = ${newValue ? 1 : 0} WHERE id = ${snapshot.data![i]['id']}");
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
                            ),
                          ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "Error loading tasks",
                    style: TextStyle(
                      color: Colors.pink[200],
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
