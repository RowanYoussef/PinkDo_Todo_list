import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';

class TodoListLogic {
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
    await sqldb.deleteData("DELETE FROM tasks WHERE id = $id");
  }

  void deleteAllTasks() async {
    await sqldb.deleteAllTasks();
  }

  void openTask(Map task,context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task['task'],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 20),
              Text(
                'Deadline: ${task['DeadLine'] ?? 'No deadline'}',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: 20),
              Text(
                'Description: ${task['Description'] ?? 'No description'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double calculateCompletionPercentage(
      List<Map> pendingTasks, List<Map> completedTasks) {
    int totalTasks = pendingTasks.length + completedTasks.length;
    if (totalTasks == 0) return 0.0;
    return completedTasks.length / totalTasks;
  }
}
