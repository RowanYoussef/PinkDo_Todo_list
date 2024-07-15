import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinkdo/Themes/theme.dart';
import 'package:pinkdo/Themes/themeNotifier.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        ThemeData currentTheme = themeNotifier.currentTheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Tasks',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: currentTheme.primaryColor,
            elevation: 0,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text('Delete All Tasks',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          onTap: () {
                            deleteAllTasks();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.star,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text('Your Wishes',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
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
                        ListTile(
                          leading: Icon(Icons.color_lens,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text(themeNotifier.isBlue() ? "Pink mode" : "Blue mode",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          onTap: () {
                            themeNotifier.toggleTheme();
                             Navigator.pop(context);
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
                colors: [
                  ThemeData().colorScheme.surface,
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                        calculateCompletionPercentage(
                            pendingTasks, completedTasks);

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
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
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
                                      task = completedTasks[
                                          i - pendingTasks.length];
                                    } else {
                                      task = pendingTasks[i];
                                    }
                                    bool isChecked = task['completed'] == 1;
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8),
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
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                          ],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme.primary,
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
                                              activeColor:
                                                  Theme.of(context).primaryColor,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18),
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
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

